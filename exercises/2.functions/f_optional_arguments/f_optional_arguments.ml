(* Here, the argument `start` is optional. If it's not given, it defaults to `0`. *)
let substring ?(start=0) ~length s =
  String.sub s start length

let greeting = "hi here"

let greeting_beginning = substring ~length:2 greeting
let () = assert ( greeting_beginning = "hi")

let greeting_end = substring ~length:4 greeting
let () = assert ( greeting_end = "here")
