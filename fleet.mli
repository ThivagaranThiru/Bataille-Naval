type fleet
val empty : fleet
val is_empty : fleet -> bool
val add_ship : fleet -> int -> fleet
val remove_ship : fleet -> int -> fleet
val get_quantity :  fleet -> int -> int
val max_size : fleet -> int