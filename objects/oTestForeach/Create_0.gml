repeat(5) instance_create_layer(0, 0, layer, oTestForEachTestInstance);

CO_PARAMS.creator = self;
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
    
    FOREACH value IN oTestForEachTestInstance THEN
        show_debug_message(value.id);
    END
    
    FOREACH value IN creator.id THEN
        show_debug_message(value);
    END
    
    FOREACH value IN creator THEN
        show_debug_message(value.id);
    END
CO_END