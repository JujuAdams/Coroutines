function CoroutineEventHook()
{
    if ((event_type == ev_step) || (event_type == ev_draw))
    {
        //We don't care what event type this is specifically, only that this event is called every frame
        
        var _expectedFrameTime = game_get_speed(gamespeed_microseconds)/1000;
        if (current_time - global.__coroutineLastTick > 0.9*_expectedFrameTime)
        {
            global.__coroutineLastTick = current_time;
            
            var _array = global.__coroutineExecuting;
            var _i = 0;
            repeat(array_length(_array))
            {
                var _coroutine = _array[_i];
                _coroutine.__Run();
                
                if (_coroutine.__complete)
                {
                    array_delete(_array, _i, 1);
                    _coroutine.__executing = false;
                }
                else
                {
                    ++_i;
                }
            }
        }
    }
    
    if (event_type == ev_other)
    {
        var _key = undefined;
        switch(event_number)
        {
            case ev_async_web_networking: _key = "networking"; break;
            case ev_async_web:            _key = "http";       break;
            case ev_async_social:         _key = "social";     break;
            case ev_async_save_load:      _key = "save_load";  break;
            case ev_async_dialog:         _key = "dialog";     break;
            case ev_async_web_steam:      _key = "steam";      break;
            case ev_async_system_event:   _key = "system";     break;
        }
        
        if (_key == undefined)
        {
            __CoroutineError("Async event not supported at this time");
        }
        else
        {
            var _array = global.__coroutineAwaitingAsync[$ _key];
            var _i = 0;
            repeat(array_length(_array))
            {
                if (_array[_i].__Callback())
                {
                    array_delete(_array, _i, 1);
                }
                else
                {
                    ++_i;
                }
            }
        }
    }
}