type t [@@deriving sexp_of]

val of_file :
  string -> name:string -> (t, [ `File_not_found | `Name_absent ]) result

val name : t -> string
val pp_path : t Fmt.t
val compile : t -> (unit, [ `Output of string list ]) result

module Set : sig
  type t
  type exercise

  val of_file : string -> (t, [ `File_not_found ]) result
  val to_list : t -> exercise list
  val run_sequentially : t -> unit
end
with type exercise := t
