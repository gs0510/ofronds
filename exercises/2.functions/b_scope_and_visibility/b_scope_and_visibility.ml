let in_the_jungle sound =
  (* Define a local variable `repeated_sound` here. You can use the function `triple_sound`,
     since it's defined globally. But you'll have to move it up in order to make it visible inside
     this function. *)
  "Mogli hears: " ^ repeated_sound

let lion_sound = "roar"

let triple_sound sound = sound ^ ", " ^ sound ^ ", " ^ sound ^ "!"
let () = assert (in_the_jungle lion_sound = "Mogli hears: roar, roar, roar!")
