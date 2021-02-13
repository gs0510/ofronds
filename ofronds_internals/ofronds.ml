open! Import

let exercise_metadata =
  lazy
    (let cwd = Sys.getcwd () in
     let ( / ) = Filename.concat in
     Exercise.list_of_file (cwd / "exercises" / "metadata.sexp") |> function
     | Ok ex -> ex
     | Error `File_not_found ->
         failwith "You must run the thing from the thing.")

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
    |> List.map (fun { Exercise.name; _ } -> name)
    |> Fmt.pr "@[<v>%a@]@." (Fmt.list Fmt.string)
  in
  (Term.(const fn), Term.info ~doc "list")

let verify =
  let doc = "Verifies all exercises in the recommended order." in
  let fn () = failwith "TODO: implement" in
  (Term.(const fn $ const ()), Term.info ~doc "verify")

let watch =
  let doc = "Run a file-system watched for the `ofronds' exercises" in
  let fn () = failwith "TODO: implement" in
  (Term.(const fn $ const ()), Term.info ~doc "watch")

let () =
  let default =
    let default_info =
      let doc =
        "Ofronds is a collection of small exercises to get you used to writing \
         and reading OCaml code"
      in
      Term.info ~doc "ofronds"
    in
    Term.
      ( app (const @@ fun () -> print_endline introductory_text) (const ())
      , default_info )
  in
  Term.(exit @@ eval_choice default [ list; watch ])
