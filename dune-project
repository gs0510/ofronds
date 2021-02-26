(lang dune 2.8)
(name ofronds)

(implicit_transitive_deps false)
(cram enable)
(generate_opam_files true)

(source (github gs0510/ofronds))
(documentation https://gs0510.github.io/ofronds/)
(maintainers "Gargi Sharma <gs051095@gmail.com>")
(authors "Gargi Sharma <gs051095@gmail.com>")
(license MIT)

(package
 (name ofronds)
 (synopsis "Small exercises to get you used to reading and writing OCaml code.")
 (description "\
Small exercises to get you used to reading and writing OCaml code.
")
 (depends
  (ocaml (>= 4.08.0))
  astring
  bos
  cmdliner
  dune-build-info
  fmt
  logs
  ppx_sexp_conv
  result
  rresult
  sexplib
  sexplib0))
