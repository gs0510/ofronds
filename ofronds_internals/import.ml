(* Standard additions to the default namespace in this project *)

include Sexplib.Std
include Sexplib

module Result = struct
  include Result

  module Syntax = struct
    let ( let+ ) x f = Result.map f x
    let ( let* ) x f = Result.bind x f
    let ( >>| ) x f = Result.map f x
    let ( >>= ) x f = Result.bind x f
  end
end
