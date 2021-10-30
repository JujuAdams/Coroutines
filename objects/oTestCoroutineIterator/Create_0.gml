CO_BEGIN
    show_debug_message("start");
    FOREACH i IN TestPowersOfTwo(10) THEN
        show_debug_message(i);
    POP
    show_debug_message("end");
CO_END