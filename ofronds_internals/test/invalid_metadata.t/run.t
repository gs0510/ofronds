  $ mkdir exercises

The metadata must not contain two tests with the same name:

  $ cat > exercises/metadata.sexp << EOF
  > (exercise (name duplicated) (path foo.ml) (hint ""))
  > (exercise (name duplicated) (path bar.ml) (hint ""))
  > EOF

  $ ofronds verify
  ofronds: internal error, uncaught exception:
           Invalid_metadata("Duplicate test name: duplicated")
           
  [125]

The metadata must not contain two tests with the same path:
 
  $ cat > exercises/metadata.sexp << EOF
  > (exercise (name foo) (path duplicated.ml) (hint ""))
  > (exercise (name bar) (path duplicated.ml) (hint ""))
  > EOF

  $ ofronds verify
  ofronds: internal error, uncaught exception:
           Invalid_metadata("Duplicate test path: duplicated.ml")
           
  [125]
