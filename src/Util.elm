module Util exposing (..)

import Array

-- HTML.text escapes all characters, so here's a non-breaking space helper.
nbsp : String
nbsp = " "

-- Utility function to retrieve the first instance of an element from a List that satisfies
-- the given function.
pluck : (t -> Bool) -> List t -> Maybe t
pluck f items =
    let
        filteredItems = List.filter f items
    in
        if List.length filteredItems > 0 then
            Array.get 0 <| Array.fromList filteredItems
        else
            Nothing

