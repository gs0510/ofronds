open! Import

let () =
  Fmt.set_style_renderer Fmt.stdout `Ansi_tty;
  Fmt.set_style_renderer Fmt.stderr `Ansi_tty

let failf fmt =
  let k ppf =
    ppf Fmt.stderr;
    exit 1
  in
  Format.kdprintf k
    ("@[%a: @[<v>" ^^ fmt ^^ "@]@.")
    Fmt.(styled `Red string)
    "error"

let successf fmt =
  Format.printf
    ("@[%a: @[<v>" ^^ fmt ^^ "@]@.")
    Fmt.(styled `Green string)
    "success"

(* TODO: get terminal width dynamically in a Windows-compatible manner. c.f.
    Alcotest. *)
let terminal_width () = 80

(* Given a string, return the number of columns it occupies in a terminal (by
   discounting ANSI escape codes in the string). *)
let printed_length : string -> int =
  let is_final_byte c =
    let c = Char.to_int c in
    c >= 0x40 && c <= 0x7e
  in
  let rec count_escape_characters s ~off ~acc =
    match String.find ~start:off (function '\x1b' -> true | _ -> false) s with
    | None -> acc
    | Some escape_start -> (
        match String.find ~start:(escape_start + 2) is_final_byte s with
        | None -> Fmt.failwith "Invalid escape sequence in string: `%s'" s
        | Some escape_end ->
            count_escape_characters s ~off:(escape_end + 1)
              ~acc:(acc + escape_end - escape_start + 1))
  in
  fun s -> String.length s - count_escape_characters s ~off:0 ~acc:0

let with_surrounding_box ppf lines =
  (* Peek at the lines being pretty-printed to determine the length of the box
     we're going to need. Fortunately, this will not include ANSII colour
     escapes. *)
  let lines_with_lengths =
    ListLabels.map lines ~f:(fun l -> (l, printed_length l))
  in
  let width =
    ListLabels.fold_left lines_with_lengths ~init:(terminal_width ())
      ~f:(fun acc (_, length) -> max acc (length + 4))
  in
  let bars = List.init (width - 2) (fun _ -> "─") |> String.concat in
  let pp_faint x = Fmt.(styled `Faint string) ppf x in

  pp_faint ("┌" ^ bars ^ "┐");
  Fmt.cut ppf ();

  ListLabels.iter lines_with_lengths ~f:(fun (line, length) ->
      pp_faint "│ ";
      Fmt.string ppf line;
      for _ = length + 4 to width - 1 do
        Fmt.char ppf ' '
      done;
      pp_faint " │";
      Fmt.cut ppf ());

  pp_faint ("└" ^ bars ^ "┘")
