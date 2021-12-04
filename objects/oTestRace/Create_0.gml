CO_BEGIN
    show_debug_message("testing AWAIT...");
    
    a = CO_BEGIN
        DELAY 200 THEN
        show_debug_message("1 finished first");
    CO_END
    
    b = CO_BEGIN
        DELAY 100 THEN
        show_debug_message("2 finished first");
    CO_END
    
    c = CO_BEGIN
        DELAY 300 THEN
        show_debug_message("3 finished first");
    CO_END
    
    AWAIT a.GetComplete() || b.GetComplete() || c.GetComplete() THEN
    a.Cancel();
    b.Cancel();
    c.Cancel();
    
    show_debug_message("...AWAIT finished");
CO_END

CO_BEGIN
    show_debug_message("testing RACE...");
    
    RACE
        CO_BEGIN
            DELAY 200 THEN
            show_debug_message("1 finished first");
        CO_END
        
        CO_BEGIN
            DELAY 100 THEN
            show_debug_message("2 finished first");
        CO_END
        
        CO_BEGIN
            DELAY 300 THEN
            show_debug_message("3 finished first");
        CO_END
    END
    
    show_debug_message("...RACE finished");
CO_END