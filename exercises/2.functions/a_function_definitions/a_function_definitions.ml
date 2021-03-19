(* There is no `return` keyword in OCaml, the value that the last expression (in this function `a+b`)
   is evaluated to gets returned.*)
let add a b = a + b

(* Write a function `multiply` that multiplies two integers. *)


let () = assert (multiply 3 4 = 12)
