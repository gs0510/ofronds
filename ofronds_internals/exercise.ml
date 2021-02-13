open! Import
open Result.Syntax

let invalid_metadata fmt =
  let exception Invalid_metadata of string in
  Fmt.kstr (fun s -> raise (Invalid_metadata s)) fmt

module T : sig
  type t [@@deriving sexp]

  val of_file :
    string -> name:string -> (t, [ `File_not_found | `Name_absent ]) result

  val name : t -> string
  val pp_path : t Fmt.t
  val compile : t -> (unit, [ `Output of string list ]) result

  module Set : sig
    type t
    type exercise

    val of_file : string -> (t, [ `File_not_found ]) result
    val to_list : t -> exercise list
  end
  with type exercise := t
end = struct
  type t =
    { name : string
    ; path : string (* Relative to the metadata file *)
    ; hint : string
    }
  [@@deriving sexp]

  let name t = t.name
  let pp_path = Fmt.using (fun { path; _ } -> path) Fmt.string

  let of_stanza : Sexp.t -> t = function
    | List (Atom "exercise" :: fields) -> t_of_sexp (List fields)
    | sexp -> invalid_metadata "unsupported exercise format: %a" Sexp.pp sexp

  let with_open_in p f =
    let+ input_channel = try Ok (open_in p) with _ -> Error `File_not_found in
    let res = f input_channel in
    close_in input_channel;
    res

  let compile ex =
    let ( / ) = Filename.concat in
    let*! cmd =
      let exe =
        Filename.current_dir_name
        / "exercises"
        / (Filename.chop_extension ex.path ^ ".exe")
      in
      OS.Cmd.must_exist
        Cmd.(v "dune" % "exec" % "--force" % "--no-buffer" % exe)
    in
    let*! output, (_, status) =
      OS.Cmd.(run_out ~err:err_run_out cmd |> out_lines)
    in
    match status with
    | `Exited 0 -> Ok ()
    | `Exited _ ->
        (* NOTE: the last two lines of unbuffered Dune output are from Dune
           itself, so we discard them here. TODO: find a better way to get just
           the compiler output. *)
        let output =
          match List.rev output with
          | _ :: _ :: xs -> List.rev xs
          | _ -> failwith "Invalid output format"
        in
        Error (`Output output)
    | `Signaled _ -> failwith "TODO: error message"

  module Set = struct
    type nonrec t = { ordered : t list; by_name : (string, t) Hashtbl.t }

    let to_list t = t.ordered

    let list_to_hashtbl (type a b) ~(key_fn : a -> b) (l : a list) :
        ((b, a) Hashtbl.t, [ `Dup of b ]) result =
      let h = Hashtbl.create 0 in
      let rec aux = function
        | [] -> Ok h
        | a :: l -> (
            let b = key_fn a in
            match Hashtbl.mem h b with
            | true -> Error (`Dup b)
            | false ->
                Hashtbl.add h b a;
                aux l)
      in
      aux l

    let of_file path =
      let+ ordered =
        with_open_in path Sexp.input_sexps >>| List.map of_stanza
      in
      let by_name = list_to_hashtbl ordered ~key_fn:(fun t -> t.name)
      and by_path = list_to_hashtbl ordered ~key_fn:(fun t -> t.path) in
      match (by_name, by_path) with
      | Ok by_name, Ok _ -> { ordered; by_name }
      | Error (`Dup name), _ -> invalid_metadata "Duplicate test name: %s" name
      | _, Error (`Dup path) -> invalid_metadata "Duplicate test path: %s" path
  end

  let of_file path ~name =
    let* { by_name; _ } = Set.of_file path in
    match Hashtbl.find_opt by_name name with
    | Some x -> Ok x
    | None -> Error `Name_absent
end

include T
