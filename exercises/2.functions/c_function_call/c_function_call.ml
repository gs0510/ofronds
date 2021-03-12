let area a b = a * b

let a = area 3 4

let () = assert (a = 12)

let volume a b c = (area a b) * c

let v = volume (3, 4, 5)

let () = assert (v = 60)
