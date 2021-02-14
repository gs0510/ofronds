  $ mkdir exercises

The metadata must not contain two tests with the same name:

  $ cat > exercises/info.sexp << EOF
  > (exercise (name duplicated) (path foo.ml))
  > (exercise (name duplicated) (path bar.ml))
  > EOF

  $ ofronds verify
  ofronds: internal error, uncaught exception:
           Invalid_metadata("Duplicate test name: duplicated")
           
  [125]

The metadata must not contain two tests with the same path:
 
  $ cat > exercises/info.sexp << EOF
  > (exercise (name foo) (path duplicated.ml))
  > (exercise (name bar) (path duplicated.ml))
  > EOF

  $ ofronds verify
  ofronds: internal error, uncaught exception:
           Invalid_metadata("Duplicate test path: duplicated.ml")
           
  [125]
