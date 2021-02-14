open! Import

let exercise_metadata =
  lazy
    (let cwd = Sys.getcwd () in
     let ( / ) = Filename.concat in
     let () =
       try Unix.access (cwd / "exercises") [ R_OK ]
       with Unix.Unix_error _ ->
         User_message.failf
           "No `exercises/' directory found. Are you in the top-level \
            directory of the `ofronds' project?"
     in
     Exercise.Set.of_file (cwd / "exercises" / "info.sexp") |> function
     | Ok ex -> ex
     | Error `File_not_found ->
         User_message.failf
           "The `exercises/' directory doesn't contain a valid `info.sexp' \
            file.")

let introductory_text =
  {|                                          _  _
                                        -| || | _
    ___  _____                    _      | || || |-
   / _ \|  ___| __ ___  _ __   __| |___   \_  || |
  | | | | |_ | '__/ _ \| '_ \ / _` / __|    |  _/
  | |_| |  _|| | | (_) | | | | (_| \__ \   -| |
   \___/|_|  |_|  \___/|_| |_|\__,_|___/    | |-
┌───────────────────────────────────────────┴─┴───────┐
│           Get ready to learn some OCaml!            │
└─────────────────────────────────────────────────────┘

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

Ready? Run `ofronds watch' to get started.

┌───< useful commands >───────────────────────────────┐
│                                                     │
│ • ofronds watch   # Auto-rebuild changed exercises  │
│ • ofronds verify  # Run all in recommended order    │
│ • ofronds list    # See available exercises         │
│                                                     │
└─────────────────────────────────────────────────────┘
|}

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

let verify =
  let doc = "Verifies all exercises in the recommended order." in
  let fn () = Lazy.force exercise_metadata |> Exercise.Set.run_sequentially in
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

let version =
  let open Build_info.V1 in
  match version () with Some v -> Version.to_string v | None -> "dev"

let () =
  let default =
    let default_info =
      let doc =
        "OFronds is a collection of small exercises to get you used to writing \
         and reading OCaml code"
      in
      Term.info ~version ~doc "ofronds"
    in
    Term.
      ( app (const @@ fun () -> print_endline introductory_text) (const ())
      , default_info )
  in
  Term.(exit @@ eval_choice default [ list; verify; describe; watch ])
