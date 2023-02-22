let main =
    print_string "Ime: " ;
    let ime = read_line () in
    print_string "Primek: " ;
    let priimek = read_line () in
    let s = ime ^ " " ^ priimek ^ " je bimbo." in
    print_string s
