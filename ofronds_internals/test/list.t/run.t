The `list` subcommand displays all available exercises:

  $ mkdir exercises
  $ cat > exercises/info.se << EOF
  > (exercise (name foo) (path foo.ml))
  > (exercise (name bar) (path bar.ml))
  > EOF
  $ ofronds list
  foo
  bar

Running `list' from a directory with no exercise data displays an appropriate
error:

  $ mkdir empty && cd empty && ofronds list
  error: No `exercises/' directory found. Are you in the top-level directory of the `ofronds' project?
  [1]
