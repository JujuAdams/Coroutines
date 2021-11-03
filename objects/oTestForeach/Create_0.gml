CO_BEGIN
    FOREACH value IN [3, 1, 4, 1, 2] THEN
        show_debug_message(value);
    END
    
    FOREACH value IN {a : "z", b : "y", c : "x"} THEN
        show_debug_message(value);
    END
    
    FOREACH value IN TestPowersOfTwo(10) THEN
        show_debug_message(value);
    END
CO_END