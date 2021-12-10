a = 0;

CO_SCOPE = self;
CO_BEGIN
    WHILE a < 10 THEN
        show_debug_message(a);
        a++;
        DELAY 500 THEN
    END
CO_END