(* Here, the argument `start` is optional. If it's not given, it defaults to `0`. *)
let subsing ?(start = 0) ~length s = String.sub s start length

let animals_singing = "quack roar"

let duck = subsing ~length:5 animals_singing
let () = assert (duck = "quack")

let lion = subsing ~length:4 animals_singing
let () = assert (lion = "roar")
