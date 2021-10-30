coroutine = CO_BEGIN
    show_debug_message("move your mouse to the right");
    AWAIT (mouse_x > room_width/2) THEN
    IF (mouse_y > room_height/2) THEN
        show_debug_message("mouse low, returning");
        RETURN THEN
    END_IF
    show_debug_message("move your mouse to the left");
    AWAIT (mouse_x < room_width/2) THEN
CO_ON_COMPLETE
    show_debug_message("CO_ON_COMPLETE executed");
CO_END