let hypotenuse =
  let one_side = 3. in (* right syntax *)
  let other_side = 4. (* wrong syntax *)
  Float.sqrt (one_side ** 2. +. other_side ** 2.)
