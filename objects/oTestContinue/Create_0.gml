CO_BEGIN
    a0 = 0;
    a1 = 0;
    REPEAT 10 THEN
        a0++;
        a1++;
    END
    show_debug_message("a0 = " + string(a0) + ", a1 = " + string(a1));
    
    b0 = 0;
    b1 = 0;
    REPEAT 10 THEN
        b0++;
        CONTINUE
        b1++;
    END
    show_debug_message("b0 = " + string(b0) + ", b1 = " + string(b1));
    
    c0 = 0;
    c1 = 0;
    REPEAT 10 THEN
        c0++;
        IF c0 == 5 THEN
            CONTINUE;
        END_IF
        c1++;
    END
    show_debug_message("c0 = " + string(c0) + ", c1 = " + string(c1));
    
    d0 = 0;
    d1 = 0;
    WHILE d0 < 10 THEN
        d0++;
        IF d0 == 7 THEN
            CONTINUE
        END_IF
        d1++;
    END
    show_debug_message("d0 = " + string(d0) + ", d1 = " + string(d1));
    
    e0 = 0;
    e1 = 0;
    FOREACH value IN [4, 3, 2, 1, 0] THEN
        e0++;
        IF value == 3 THEN
            CONTINUE
        END_IF
        e1++;
    END
    show_debug_message("e0 = " + string(e0) + ", e1 = " + string(e1));
CO_END