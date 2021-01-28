(lang dune 2.7.1)
(name ofronds)
(implicit_transitive_deps false)

(generate_opam_files true)
(source (github gs0510/ofronds))
(maintainers "Gargi Sharma <gs051095@gmail.com>")
(authors "Gargi Sharma <gs051095@gmail.com>")

(package
 (name ofronds)
 (synopsis "Small exercises to get you used to reading and writing OCaml code.")
 (description "\
Small exercises to get you used to reading and writing OCaml code.
")
 (documentation https://gs0510.github.io/ofronds/)
 (depends alcotest fmt logs))
