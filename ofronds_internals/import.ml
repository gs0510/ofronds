(* Standard additions to the default namespace in this project. *)

include Astring
include Bos
include Sexplib.Std
include Sexplib0

module Result = struct
  include Result

  module Syntax = struct
    let ( let+ ) x f = Result.map f x
    let ( let* ) x f = Result.bind x f

    let ( let*! ) : 'a 'b 'e. ('a, 'e) t -> ('a -> 'b) -> 'b =
     fun x f -> f (Result.get_ok x)

    let ( >>| ) x f = Result.map f x
    let ( >>= ) x f = Result.bind x f
  end
end

module Hashtbl = struct
  include Hashtbl

  let of_list :
        'a 'b.
           index_by:('a -> 'b)
        -> 'a list
        -> (('b, 'a) Hashtbl.t, [ `Dup of 'b ]) result =
   fun ~index_by l ->
    let h = Hashtbl.create 0 in
    let rec aux = function
      | [] -> Ok h
      | a :: l -> (
          let b = index_by a in
          match Hashtbl.mem h b with
          | true -> Error (`Dup b)
          | false ->
              Hashtbl.add h b a;
              aux l)
    in
    aux l
end
