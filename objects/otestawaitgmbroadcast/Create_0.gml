CO_BEGIN
    AWAIT_GAMEMAKER_BROADCAST
        show_debug_message("AWAIT_GM_BROADCAST:");
        show_debug_message("  event_type = \"" + event_data[? "event_type"] + "\"");
        show_debug_message("  message = \"" + event_data[? "message"] + "\"");
        show_debug_message("  element_id = " + string(event_data[? "element_id"]));
        if (event_data[? "message"] == "boop!") ASYNC_COMPLETE;
    THEN
    show_debug_message("AWAIT_GM_BROADCAST complete");
    RESTART
CO_END

CO_BEGIN
    AWAIT_BROADCAST "boop!" THEN
    show_debug_message("AWAIT_BROADCAST: boop!");
    RESTART
CO_END