(* This defines an operator `$` *)
let ($) dollars cents = (string_of_int dollars) ^ " dollars and " ^ (string_of_int cents) ^ " cents"

let () = assert (2 $ 50 = "2 dollars and 50 cents")

(* Define an operator `%` that operates on two floats `p` and `a`: `p % a` returns `p` percent of `a`*)

let let () = assert(20. % 50. = 10.)
