# ofronds :dromedary_camel: :palm_tree:

[![OCaml-CI Build Status](https://img.shields.io/endpoint?url=https%3A%2F%2Fci.ocamllabs.io%2Fbadge%2Focurrent%2Focaml-ci%2Fmaster&logo=ocaml)](https://ci.ocamllabs.io/github/gs0510/ofronds)

                                          _  _
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

┌───< useful commands >─────────────────────────────────────┐
│                                                           │
│ • ofronds watch   # Auto-rebuild changed exercises        │
│ • ofronds verify  # Run all in recommended order          │
│ • ofronds list    # See available exercises               │
│ • ofronds hint  <name>  # Display hint for the exercises  │
│                                                           │
└───────────────────────────────────────────────────────────┘


## Installation

If you have a linux based operating system or a Mac you can run `./install.sh` and the script will install all dependencies for you! Run `ofronds` to see the set of commands you need to run ofronds exercises. :)

# Plan for ofronds

The idea:
Have a [rustlings](https://github.com/rust-lang/rustlings) style tutorial for OCaml. The tutorial walks the user through a list of OCaml exercises, the command prompt directs them to the exercise they are supposed to solve and then as they work on the exercise a functionality like `ofronds watch` can recompile the exercise and let the user move on to the next exercise.

Non exhaustive list of things to cover:

- [ ] Variables
- [ ] Functions
    - [ ] Make clear that they are curried; introduce '|>'
    - [ ] precedence and associativity; introduce '@@'
    - [ ] introduce ';' as a binary operator for expression that return ()
- [ ] Recursive functions
- [ ] Conditionals
- [ ] Pattern Matching
- [ ] Lists
    - [ ] Pattern Matching with lists
    - [ ] List.fold 
- [ ] Modules
    - [ ] Basics
    - [ ] Functors | First-class modules
- [ ] Records
- [ ] Variants
- [ ] Map and bind
- [ ] Error handling
- [ ] Tests
   - [ ] Alcotest
   - [ ] Cram tests
- [ ] Signatures and type errors
- [ ] Polymorphic variants; objects and classes
- [ ] Dune files
- [ ] ppx
    - [ ] Using ppxs
        - [ ] extension points
        - [ ] different attributes
    - [ ] writing simple ppxs

Questions:
- What does watch (`dune build --watch`) functionality look like in ocaml?
- Release `ofronds` as an opam package.
- Add an install script that installs ocaml, opam, dune etc. and installs ofronds as an opam package.
- Introducing how `;` works in OCaml.
- Structure into something that's common to functional programming vs OCaml specific features.
    - Functions in Rust are very different than OCaml, so it would still be a functional feature, but the boundaries might be blurry.
- Rust compiler is very friendly, and makes it a pleasant experience when things go wrong.
    - Add hints in the exercises for possible errors the user might be making. Add hints related to the exercise as well.

Milestone 1:
- Have a framework in place that can have a `watch` functionality and give hints and allow the user to move on to the next exercise.
- Will likely use `inotifywait`, look into how it will be implemented. 
- Add install script.

Milestone 2:
- Add exercises for the first few topics, recruit alpha testers to take a look at the exercises/experience.

Milestone 3:
- Add rest of the exercises.
