type t [@@deriving sexp_of]
(** The type of individual user exercises. *)

val name : t -> string
(** The name of an exercise. *)

val pp_path : t Fmt.t
(** Pretty-prints the file path associated with the exercise. *)

val of_file :
  string -> name:string -> (t, [ `File_not_found | `Name_absent ]) result
(** [of_file path ~name] loads the exercise named [name] from the given metadata
    file [path]. *)

val compile : t -> (unit, [ `Output of string list ]) result
(** [compile ex] attempts to build exercise [ex] with Dune. If the build fails,
    the compiler output is returned. *)

(** Functions for dealing with {i set}s of exercises, such as might be loaded
    from a metadata file. *)
module Set : sig
  type t
  type exercise

  val of_file : string -> (t, [ `File_not_found ]) result
  (** Load all exercises specified in the given metadata file path. *)

  val to_list : t -> exercise list
  (** View the exercise set as a list in the intended completion order. *)

  val run_sequentially : t -> unit
  (** Run each exercise in the given set in intended order, stopping at the
      first failure with an appropriate error message. *)
end
with type exercise := t
