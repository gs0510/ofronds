let cylinder_density ~radius ~height ~mass =
  let volume = Float.pi *. radius *. radius *. height in
  mass /. volume

let radius = 3.
let height = 2.
let mass = 5.

let density = cylinder_density ~height radius mass
let () = assert (density = 0.0884194128288307429)
