The `hint <exercise_name>` subcommand displays the hint for the given exercise.

  $ mkdir exercises
  $ cat > exercises/info.se << EOF
  > (exercise (name foo) (path foo.ml) (hint "hint"))
  > (exercise (name bar) (path bar.ml))
  > EOF
  $ ofronds hint foo
  hint
Hint for the exercise doesn't exist
  $ ofronds hint bar
  There's no hint for this exercise. If you think it'd be useful, please open an issue: https://github.com/gs0510/ofronds/issues.
Name of exercise doesn't exist
  $ ofronds hint baz 
  error: This exercise doesn't exist, perphaps you entered the name wrong?
  [1]
