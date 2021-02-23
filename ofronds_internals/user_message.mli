(** Utilities for consistently-styled terminal interactions. *)

val failf : ('a, Format.formatter, unit, _) format4 -> 'a
(** Print an error message and fail with a non-zero exit code. *)

val successf : ('a, Format.formatter, unit, unit) format4 -> 'a
(** Print a success message and return unit. *)

val with_surrounding_box : string list Fmt.t
(** Wrap a list of lines with a UTF-8 box, using box-drawing characters from
    code page 437. *)
