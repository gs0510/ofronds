open! Import
open Result.Syntax

let invalid_metadata fmt =
  let exception Invalid_metadata of string in
  Fmt.kstr (fun s -> raise (Invalid_metadata s)) fmt

type t = { name : string; path : string (* Relative to the metadata file *) }
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
    OS.Cmd.must_exist Cmd.(v "dune" % "exec" % "--force" % "--no-buffer" % exe)
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
        | _ -> failwith "Unexpected Dune output format"
      in
      Error (`Output output)
  | `Signaled n -> Fmt.failwith "`dune exec' subcommand received signal %d" n

module Set = struct
  type nonrec t = { ordered : t list; by_name : (string, t) Hashtbl.t }

  let to_list t = t.ordered

  let of_file path =
    let+ ordered =
      with_open_in path Sexplib.Sexp.input_sexps >>| List.map of_stanza
    in
    let by_name = Hashtbl.of_list ordered ~index_by:(fun t -> t.name)
    and by_path = Hashtbl.of_list ordered ~index_by:(fun t -> t.path) in
    match (by_name, by_path) with
    | Ok by_name, Ok _ -> { ordered; by_name }
    | Error (`Dup name), _ -> invalid_metadata "Duplicate test name: %s" name
    | _, Error (`Dup path) -> invalid_metadata "Duplicate test path: %s" path

  let run_sequentially t =
    ListLabels.fold_left t.ordered ~init:(Ok 0) ~f:(fun acc ex ->
        let* exercises_passed = acc in
        match compile ex with
        | Error (`Output lines) -> Error (ex, lines)
        | Ok () ->
            Fmt.pr "%a@,"
              Fmt.(styled `Green string)
              (Fmt.str "✓ Successfully ran `%a'" pp_path ex);

            Ok (succ exercises_passed))
    |> function
    | Ok n -> User_message.successf "ran %d exercises" n
    | Error (ex, lines) ->
        Fmt.pr "@[<v>%a@,@,%a@]@."
          Fmt.(styled `Red string)
          (Fmt.str "! Failed to compile `%a'. Here's the output:" pp_path ex)
          User_message.with_surrounding_box lines
end

let of_file path ~name =
  let* { by_name; _ } = Set.of_file path in
  match Hashtbl.find_opt by_name name with
  | Some x -> Ok x
  | None -> Error `Name_absent
