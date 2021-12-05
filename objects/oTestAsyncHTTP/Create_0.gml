CO_BEGIN
    url = "https://www.jujuadams.com/";
    data = "";
    handle = http_get(url);
    
    AWAIT_ASYNC_HTTP
        if (async_load < 0)
        {
            show_debug_message("HTTP GET for \"" + url + "\" timed out");
        }
        else if (async_load[? "id"] == handle)
        {
            if (async_load[? "status"] == 0)
            {
                data = async_load[? "result"];
                show_debug_message("HTTP GET for \"" + url + "\" successful");
                ASYNC_COMPLETE;
            }
            else if (async_load[? "status"] < 0)
            {
                show_debug_message("HTTP GET for \"" + url + "\" unsuccessful");
                ASYNC_COMPLETE;
            }
            else
            {
                //Request pending
            }
        }
    ASYNC_TIMEOUT 3000 THEN
    
    show_debug_message("data = \"" + data + "\"");
    show_debug_message("HTTP GET for \"" + url + "\" complete");
CO_END