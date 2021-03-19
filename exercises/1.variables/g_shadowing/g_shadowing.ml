(* -------- global shadowing ----------- *)

(* max_float is a variable in the standard library. We can shadow that variable *)
let () = assert (max_float = 1.79769313486231571e+308)
let max_float = 10.0
let () = assert (max_float = 10.0)

(* Shadowing doesn't need to preserve types. Shadow max_float with the integer 0. *)

let () = assert (max_float = 0)

(* 
(* -------- local shadowing ----------- *)

(* min_float is another variable in the standard library.*)
let () = assert (min_float = 2.22507385850720138e-308)
let () = let min_float = "hi" in
  assert (min_float = "hi")

(* We've only shadowed it locally. *)
let () = assert (min_float = 2.22507385850720138e-308)


TODO: come back to this exercise ;D *)
