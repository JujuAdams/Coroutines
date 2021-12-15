test = CO_BEGIN
    show_debug_message("!");
    PAUSE THEN
CO_ON_COMPLETE
    show_debug_message("on_complete");
CO_END;