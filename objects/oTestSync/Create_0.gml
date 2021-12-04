CO_BEGIN
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
    show_debug_message("race finished");
CO_END