(* Fix both type errors *)

let x = 5 + 7.0

let y = "hello " ^ 'O'

let () = assert (x = 12)
let () = assert (y = "hello O")
