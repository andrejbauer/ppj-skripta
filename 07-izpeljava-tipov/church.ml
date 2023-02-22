let zero  = (fun f x -> x) ;;
let one   = (fun f x -> f x) ;;
let two   = (fun f x -> f (f x)) ;;
let three = (fun f x -> f (f (f x))) ;;

let zero'  = (fun f x -> x) ;;
let one'   = (fun f x -> f zero' x) ;;
let two'   = (fun f x -> f one' (f zero' x)) ;;
let three' = (fun f x -> f two' (f one' (f zero' x))) ;;
let four'  = (fun f x -> f three' (f two' (f one' (f zero' x)))) ;;
let five'  = (fun f x -> f four' (f three' (f two' (f one' (f zero' x))))) ;;
