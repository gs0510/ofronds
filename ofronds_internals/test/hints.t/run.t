The `hint <exercise_name>` subcommand displays the hint for the given exercise.

  $ mkdir exercises
  $ cat > exercises/info.se << EOF
  > (exercise (name foo) (extended_name a_foo_bar) (shorthand 1.f) (path foo.ml) (hint "hint"))
  > (exercise (name bar) (extended_name b_bar_foo) (shorthand 1.b) (path bar.ml))
  > EOF
  $ ofronds hint foo
  hint
  $ ofronds hint a_foo_bar
  hint
  $ ofronds hint 1.f
  hint
Hint for the exercise doesn't exist
  $ ofronds hint bar
  There's no hint for this exercise. If you think it'd be useful, please open an issue: https://github.com/gs0510/ofronds/issues.
  $ ofronds hint b_bar_foo
  There's no hint for this exercise. If you think it'd be useful, please open an issue: https://github.com/gs0510/ofronds/issues.
  $ ofronds hint 1.b
  There's no hint for this exercise. If you think it'd be useful, please open an issue: https://github.com/gs0510/ofronds/issues.
Name of exercise doesn't exist
  $ ofronds hint baz
  error: This exercise doesn't exist, perphaps you entered the name wrong? The name can be of the form: 1.a or a_let_bindings or let_bindings.
  [1]
