# ofronds :dromedary_camel: :palm_tree:

Small exercises to get you used to reading and writing OCaml code.

## Installation

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
