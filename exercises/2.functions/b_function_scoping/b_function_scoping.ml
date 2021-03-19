let triple_sound sound =
  sound ^ ", " ^ sound ^ ", " ^ sound ^ "!"

let in_the_jungle sound =
  (* Define `tripled_sound`. You can use the function `triple_sound` here since it's defined globally. *)

  "Mogli hears: " ^ tripled_sound

let lion_sound = "roar"

let () = assert (in_the_jungle lion_sound = "Mogli hears: roar, roar, roar!")
