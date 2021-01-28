let x = "a,b";;
let y = 
  let l = String.split_on_char ','  x in
  String.concat " " l
;;

let () = Printf.printf "The value of y is %s. \n" y