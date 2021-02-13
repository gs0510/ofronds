open! Import

module User_message = struct
  let () =
    Fmt.set_style_renderer Fmt.stdout `Ansi_tty;
    Fmt.set_style_renderer Fmt.stderr `Ansi_tty

  let failf fmt =
    let k ppf =
      ppf Fmt.stderr;
      exit 1
    in
    Format.kdprintf k
      ("@[%a: @[<v>" ^^ fmt ^^ "@]@.")
      Fmt.(styled `Red string)
      "error"

  let successf fmt =
    Format.printf
      ("@[%a: @[<v>" ^^ fmt ^^ "@]@.")
      Fmt.(styled `Green string)
      "success"
end

let exercise_metadata =
  lazy
    (let cwd = Sys.getcwd () in
     let ( / ) = Filename.concat in
     Exercise.Set.of_file (cwd / "exercises" / "metadata.sexp") |> function
     | Ok ex -> ex
     | Error `File_not_found ->
         User_message.failf
           "No `exercises/' directory found. Are you in the top-level \
            directory of the `ofronds' project?")

let introductory_text =
  {|                                          _  _
                                        -| || | _
    ___  _____                    _      | || || |-
   / _ \|  ___| __ ___  _ __   __| |___   \_  || |
  | | | | |_ | '__/ _ \| '_ \ / _` / __|    |  _/
  | |_| |  _|| | | (_) | | | | (_| \__ \   -| |
   \___/|_|  |_|  \___/|_| |_|\__,_|___/    | |-
────────────────────────────────────────────┴─┴────────
            Get ready to learn some OCaml!
───────────────────────────────────────────────────────

New here? Here's a breakdown:

- OFronds is a set of exercises for getting used to
  writing and reading OCaml code. The exercises are all
  OCaml programs containing errors; your job is to read
  the code, fix the errors, and move onto the next one!

- The exercises can be run in two ways. The recommended
  method is to run `ofronds watch', which automatically
  interactively runs through all exercises from start
  to finish. You can also run exercises individually
  with `ofronds run <exercise>' (see `ofronds list' for
  a list of available commands).

- If you're not sure how to finish an exercise, you can
  ask for a hint by typing `hint' (when running in
  `watch' mode) or via `ofronds hint <exercise>'.

Ready? Run `ofronds watch' to get started.|}

open Cmdliner

let list =
  let doc = "List the available exercises" in
  let fn () =
    Lazy.force exercise_metadata
    |> Exercise.Set.to_list
    |> List.map Exercise.name
    |> Fmt.pr "@[<v>%a@]@." (Fmt.list Fmt.string)
  in
  (Term.(const fn $ const ()), Term.info ~doc "list")

(* TODO: get terminal width dynamically in a Windows-compatible manner. c.f. Alcotest. *)
let terminal_width () = 80

let apparent_length : string -> int =
  let is_final_byte c =
    let c = Char.to_int c in
    c >= 0x40 && c <= 0x7e
  in
  let rec count_escape_characters s ~off ~acc =
    match String.find ~start:off (function '\x1b' -> true | _ -> false) s with
    | None -> acc
    | Some escape_start -> (
        match String.find ~start:(escape_start + 2) is_final_byte s with
        | None -> Fmt.failwith "Invalid escape sequence in string: `%s'" s
        | Some escape_end ->
            count_escape_characters s ~off:(escape_end + 1)
              ~acc:(acc + escape_end - escape_start + 1))
  in
  fun s -> String.length s - count_escape_characters s ~off:0 ~acc:0

let with_surrounding_box ppf lines =
  (* Peek at the lines being pretty-printed to determine the length of the box
     we're going to need. Fortunately, this will not include ANSII colour
     escapes. *)
  let lines_with_lengths =
    ListLabels.map lines ~f:(fun l -> (l, apparent_length l))
  in
  let width =
    ListLabels.fold_left lines_with_lengths ~init:(terminal_width ())
      ~f:(fun acc (_, apparent_length) -> max acc (apparent_length + 4))
  in
  let bars = List.init (width - 2) (fun _ -> "─") |> String.concat in
  let pp_faint x = Fmt.(styled `Faint string) ppf x in

  pp_faint ("┌" ^ bars ^ "┐");
  Fmt.cut ppf ();

  ListLabels.iter lines_with_lengths ~f:(fun (line, apparent_length) ->
      pp_faint "│ ";
      Fmt.string ppf line;
      for _ = apparent_length + 4 to width - 1 do
        Fmt.char ppf ' '
      done;
      pp_faint " │";
      Fmt.cut ppf ());

  pp_faint ("└" ^ bars ^ "┘")

let verify =
  let doc = "Verifies all exercises in the recommended order." in
  let fn () =
    Lazy.force exercise_metadata
    |> Exercise.Set.to_list
    |> ListLabels.fold_left ~init:(Ok 0) ~f:(fun acc ex ->
           match acc with
           | Error _ as e -> e
           | Ok exercises_passed -> (
               match Exercise.compile ex with
               | Error (`Output lines) -> Error (ex, lines)
               | Ok () ->
                   Fmt.pr "%a@,"
                     Fmt.(styled `Green string)
                     (Fmt.str "✓ Successfully ran `%a'" Exercise.pp_path ex);

                   Ok (succ exercises_passed)))
    |> function
    | Ok n -> User_message.successf "ran %d exercises" n
    | Error (ex, lines) ->
        Fmt.pr "@[<v>%a@,@,%a@]@."
          Fmt.(styled `Red string)
          (Fmt.str "! Failed to compile `%a'. Here's the output:"
             Exercise.pp_path ex)
          with_surrounding_box lines
  in
  (Term.(const fn $ const ()), Term.info ~doc "verify")

let describe =
  let doc = "Print an s-expression description of the exercise metadata" in
  let fn () =
    Lazy.force exercise_metadata
    |> Exercise.Set.to_list
    |> List.map Exercise.sexp_of_t
    |> (fun x -> Sexp.List x)
    |> Fmt.pr "%a\n%!" Sexp.pp_hum
  in
  (Term.(const fn $ const ()), Term.info ~doc "describe")

let watch =
  let doc = "Run a file-system watched for the `ofronds' exercises" in
  let fn () = failwith "TODO: implement" in
  (Term.(const fn $ const ()), Term.info ~doc "watch")

let () =
  let default =
    let default_info =
      let doc =
        "OFronds is a collection of small exercises to get you used to writing \
         and reading OCaml code"
      in
      Term.info ~doc "ofronds"
    in
    Term.
      ( app (const @@ fun () -> print_endline introductory_text) (const ())
      , default_info )
  in
  Term.(exit @@ eval_choice default [ list; verify; describe; watch ])
