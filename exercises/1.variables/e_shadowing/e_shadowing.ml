(* max_float is a variable in the standard library *)
let () = assert (max_float = 1.79769313486231571e+308)

(* We can shadow that variable *)
let max_float = 10.0
let () = assert (max_float = 10.0)

(* min_float is another variable in the standard library *)
let () = assert (min_float = 2.22507385850720138e-308)

(* Shadowing doesn't need to preserve types. Shadow min_float with the integer 0. *)

let () = assert (min_float = 0)
