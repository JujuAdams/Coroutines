CO_SCOPE = self;
CO_BEGIN
    show_debug_message("1");
    DELAY 200 THEN
    show_debug_message("2");
    CO_LOCAL.Restart();
    show_debug_message("This should never appear");
CO_END;