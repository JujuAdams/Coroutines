CO_BEGIN
    a = 0;
    REPEAT 10 THEN
        a++;
    END
    show_debug_message("a = " + string(a));
    
    b = 0;
    REPEAT 10 THEN
        BREAK
        b++;
    END
    show_debug_message("b = " + string(b));
    
    c = 0;
    REPEAT 10 THEN
        IF c == 5 THEN
            BREAK
        END_IF
        c++;
    END
    show_debug_message("c = " + string(c));
    
    d = 0;
    WHILE d < 10 THEN
        IF d == 7 THEN
            BREAK
        END_IF
        d++;
    END
    show_debug_message("d = " + string(d));
    
    e = 0;
    FOREACH value IN [4, 3, 2, 1, 0] THEN
        IF value == 3 THEN
            BREAK
        END_IF
        e++;
    END
    show_debug_message("e = " + string(e));
CO_END