CO_BEGIN
    AWAIT_BROADCAST "a" THEN
    AWAIT_BROADCAST "b" THEN
    show_debug_message("Coroutine 1 done");
CO_END

CO_BEGIN
    AWAIT_BROADCAST "b" THEN
    show_debug_message("Coroutine 2 done");
CO_END