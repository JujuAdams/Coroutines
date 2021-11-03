coroutine = CO_BEGIN
    variable = 0;
    WHILE variable < 10 THEN
        show_debug_message("variable = " + string(variable));
        
        IF variable == 1 THEN
            show_debug_message("    variable == 1");
        END_IF
        
        IF variable == 2 THEN
            show_debug_message("    variable == 2");
        ELSE
            show_debug_message("    variable != 2");
        END_IF
        
        IF variable == 3 THEN
            show_debug_message("    variable == 3");
        ELSE_IF variable == 4 THEN
            show_debug_message("    variable == 4");
        END_IF
        
        IF variable == 5 THEN
            show_debug_message("    variable == 5");
        ELSE_IF variable == 6 THEN
            show_debug_message("    variable == 6");
        ELSE
            show_debug_message("    variable != 6, variable != 7");
        END_IF
        
        variable++;
    END
CO_END