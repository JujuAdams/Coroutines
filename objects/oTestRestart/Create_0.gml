CO_BEGIN
    show_debug_message("1");
    DELAY 200 THEN
    show_debug_message("2");
    RESTART
    show_debug_message("This should never appear");
CO_END;