let say_greeting greeting name = greeting ^ " " ^ name ^ "!"
let () = assert (say_greeting "hello" "world" = "hello world!")

let say_hi = say_greeting "hi"
let () = assert (say_hi "everyone" = "hi everyone!")

(* Using `say_greeting` function, define a function called `say_hey`*)

let () = assert (say_hey "there" = "hey there!")
