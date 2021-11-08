coroutine = CO_BEGIN
    WHILE true THEN YIELD THEN END
CO_ON_COMPLETE
    show_debug_message("complete");
CO_END

coroutine.CancelWhenOrphaned(false);