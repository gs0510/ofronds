(* ----------- global shadowing ----------- *)

(* max_float is a variable in the standard library. We can shadow that variable *)
let () = assert (max_float = 1.79769313486231571e+308)
let max_float = 10.0
let () = assert (max_float = 10.0)

(* Shadowing doesn't need to preserve types. Shadow min_float with the integer 0. *)

let () = assert (min_float = 0)
