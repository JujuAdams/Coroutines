CO_BEGIN
    show_debug_message("testing AWAIT...");
    
    a = CO_BEGIN
        DELAY 200 THEN
        show_debug_message("1 finished");
    CO_END
    
    b = CO_BEGIN
        DELAY 100 THEN
        show_debug_message("2 finished");
    CO_END
    
    c = CO_BEGIN
        DELAY 300 THEN
        show_debug_message("3 finished");
    CO_END
    
    AWAIT a.GetComplete() && b.GetComplete() && c.GetComplete() THEN
    
    show_debug_message("...AWAIT finished");
CO_END

CO_BEGIN
    show_debug_message("testing SYNC...");
    
    SYNC
        CO_BEGIN
            DELAY 200 THEN
            show_debug_message("1 finished");
        CO_END
        
        CO_BEGIN
            DELAY 100 THEN
            show_debug_message("2 finished");
        CO_END
        
        CO_BEGIN
            DELAY 300 THEN
            show_debug_message("3 finished");
        CO_END
    END
    
    show_debug_message("...SYNC finished");
CO_END