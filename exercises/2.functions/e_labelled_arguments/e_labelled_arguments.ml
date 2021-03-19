let cylinder_volume ~radius ~height =
  let pi = Float.pi in
  pi *. radius *. radius *. height

let radius = 3.
let height = 2.

let volume = cylinder_volume ~height radius
let () = assert (volume = 56.548668)
