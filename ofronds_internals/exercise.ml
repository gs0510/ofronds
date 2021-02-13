open! Import
open Result.Syntax

type t =
  { name : string
  ; path : string (* Relative to the metadata file *)
  ; hint : string
  }
[@@deriving sexp]

let of_stanza : Sexp.t -> t = function
  | List (Atom "exercise" :: fields) -> t_of_sexp (List fields)
  | sexp -> Fmt.failwith "Unsupported exercise format: %a" Sexp.pp sexp

let with_open_in p f =
  let+ input_channel = try Ok (open_in p) with _ -> Error `File_not_found in
  let res = f input_channel in
  close_in input_channel;
  res

let list_of_file path =
  with_open_in path Sexp.input_sexps >>| List.map of_stanza
