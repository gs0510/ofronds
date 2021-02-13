The `list` subcommand displays all available exercises:

  $ ofronds list
  foo

Running `list' from a directory with no exercise data displays an appropriate
error:

  $ mkdir empty && cd empty && ofronds list
  error: No `exercises/' directory found. Are you in the top-level directory of the `ofronds' project?
  [1]
