  $ mkdir exercises

The metadata must not contain two tests with the same name:

  $ cat > exercises/info.se << EOF
  > (exercise (name duplicated) (extended_name foo) (shorthand 1.f) (path foo.ml))
  > (exercise (name duplicated) (extended_name foo_bar) (shorthand 1.b) (path bar.ml))
  > EOF

  $ ofronds verify
  ofronds: internal error, uncaught exception:
           Invalid_metadata("Duplicate name: duplicated")
           
  [125]

The metadata must not contain two tests with the same path:

  $ cat > exercises/info.se << EOF
  > (exercise (name foo) (extended_name foo_bar) (shorthand 1.f) (path duplicated.ml))
  > (exercise (name bar) (extended_name foo_baz) (shorthand 1.b) (path duplicated.ml))
  > EOF

  $ ofronds verify
  ofronds: internal error, uncaught exception:
           Invalid_metadata("Duplicate path: duplicated.ml")

  [125]

The metadata must not contain two tests with the same shorthand:

  $ cat > exercises/info.se << EOF
  > (exercise (name foo) (extended_name foo_bar) (shorthand 1.f) (path foo.ml))
  > (exercise (name bar) (extended_name foo_rab) (shorthand 1.f) (path bar.ml))
  > EOF

  $ ofronds verify
  ofronds: internal error, uncaught exception:
           Invalid_metadata("Duplicate shorthand: 1.f")

  [125]

The metadata must not contain two tests with the same extended_name:

  $ cat > exercises/info.se << EOF
  > (exercise (name foo) (extended_name foo_bar) (shorthand 1.g) (path foo.ml))
  > (exercise (name bar) (extended_name foo_bar) (shorthand 1.f) (path bar.ml))
  > EOF

  $ ofronds verify
  ofronds: internal error, uncaught exception:
           Invalid_metadata("Duplicate extended name: foo_bar")

  [125]
