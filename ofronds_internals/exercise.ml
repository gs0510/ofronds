open! Import
open Result.Syntax

let invalid_metadata fmt =
  let exception Invalid_metadata of string in
  Fmt.kstr (fun s -> raise (Invalid_metadata s)) fmt

type t =
  { name : string
  ; extended_name : string
  ; shorthand : string
  ; path : string (* Relative to the metadata file *)
  ; hint : string option [@sexp.option]
  }
[@@deriving sexp]

type user_input =
  | Name of string
  | Extended_name of string
  | Shorthand of string

let user_input_error =
  "This exercise doesn't exist, perphaps you entered the name wrong? The name \
   can be of the form: 1.a or a_let_bindings or let_bindings."

let name t = t.name
let pp_path = Fmt.using (fun { path; _ } -> path) Fmt.string
let hint t = t.hint

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

let user_input_heuristics input =
  let shorthand_regex = Str.regexp "[1-9]+\.[a-z]" in
  if Str.string_match shorthand_regex input 0 then Shorthand input
  else
    let extended_name_regex = Str.regexp "[a-z]_[A-Za-z]+" in
    if Str.string_match extended_name_regex input 0 then Extended_name input
    else Name input

module Set = struct
  type nonrec t =
    { ordered : t list; by_user_input : (user_input, t) Hashtbl.t }

  let to_list t = t.ordered
  let to_hashtable t = t.by_user_input

  let of_file path =
    let+ ordered =
      with_open_in path Sexplib.Sexp.input_sexps >>| List.map of_stanza
    in
    let by_name = Hashtbl.of_list ordered ~index_by:(fun t -> t.name) in
    let by_extended_name =
      Hashtbl.of_list ordered ~index_by:(fun t -> t.extended_name)
    in
    let by_shorthand =
      Hashtbl.of_list ordered ~index_by:(fun t -> t.shorthand)
    in
    let by_path = Hashtbl.of_list ordered ~index_by:(fun t -> t.path) in
    match (by_name, by_extended_name, by_shorthand, by_path) with
    | Ok by_name, Ok by_extended_name, Ok by_shorthand, Ok _ ->
        let by_user_input = Hashtbl.create 1024 in
        Hashtbl.iter
          (fun name info -> Hashtbl.add by_user_input (Name name) info)
          by_name;
        Hashtbl.iter
          (fun extended_name info ->
            Hashtbl.add by_user_input (Extended_name extended_name) info)
          by_extended_name;
        Hashtbl.iter
          (fun shorthand info ->
            Hashtbl.add by_user_input (Shorthand shorthand) info)
          by_shorthand;
        { ordered; by_user_input }
    | Error (`Dup by_name), _, _, _ ->
        invalid_metadata "Duplicate name: %s" by_name
    | _, Error (`Dup by_extended_name), _, _ ->
        invalid_metadata "Duplicate extended name: %s" by_extended_name
    | _, _, Error (`Dup by_shorthand), _ ->
        invalid_metadata "Duplicate shorthand: %s" by_shorthand
    | _, _, _, Error (`Dup path) -> invalid_metadata "Duplicate path: %s" path

  let rec chop_list start_at = function
    | { name; extended_name; shorthand; _ } :: tail as current -> (
        match start_at with
        | Name sname ->
            if String.equal name sname then current else chop_list start_at tail
        | Extended_name sextended_name ->
            if String.equal extended_name sextended_name then current
            else chop_list start_at tail
        | Shorthand sshorthand ->
            if String.equal shorthand sshorthand then current
            else chop_list start_at tail)
    | [] -> User_message.failf "%s\n" user_input_error

  let run_sequentially t ~start_at =
    let ordered =
      match start_at with
      | None -> t.ordered
      | Some start_at -> chop_list (user_input_heuristics start_at) t.ordered
    in
    ListLabels.fold_left ordered ~init:(Ok 0) ~f:(fun acc ex ->
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
        Fmt.pr "@[<v>%a@,@,%a@]@.%s"
          Fmt.(styled `Red string)
          (Fmt.str "! Failed to compile `%a'. Here's the output:" pp_path ex)
          User_message.with_surrounding_box lines
          "To get to know what this exercise is about, run ofronds hint.\n"

  let get_hint t ~user_input =
    let output =
      let hastable = to_hashtable t in
      match Hashtbl.find_opt hastable (user_input_heuristics user_input) with
      | Some exercise -> (
          match hint exercise with Some hint -> `Hint hint | None -> `No_hint)
      | None -> `Erroneous_name
    in
    match output with
    | `Hint hint -> Fmt.pr "%s\n" hint
    | `No_hint ->
        Fmt.pr "%s\n"
          "There's no hint for this exercise. If you think it'd be useful, \
           please open an issue: https://github.com/gs0510/ofronds/issues."
    | `Erroneous_name -> User_message.failf "%s\n" user_input_error
end
