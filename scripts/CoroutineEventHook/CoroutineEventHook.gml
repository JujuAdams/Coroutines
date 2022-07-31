/// This function *must* be called once per frame in a Step event or corouintes will,
/// not execute. This is typically done by calling this function in the Step event of
/// a persistent instance. Be careful that instance doesn't get deactivated if you're
/// using instance deactivation in your game!
/// 
/// If you're using AWAIT_ASYNC_* calls, this function will also need to be placed in
/// the relevant async events in a persistent instance, with the above caveats.
/// 
/// If you don't want to handle all this yourself, you can place down an instance of
/// oCoroutineManager in the first room in your game (the one with the house icon)
/// and it'll take care of everything for you. You will still need to keep an eye
/// on instance deactivation though ;)

function CoroutineEventHook()
{
    switch(event_type)
    {
        case ev_step:
        case ev_draw:
            //We don't care what event type this is specifically, only that this event is called every frame
        
            var _expectedFrameTime = game_get_speed(gamespeed_microseconds)/1000;
            if (current_time - global.__coroutineLastTick > 0.9*_expectedFrameTime)
            {
                global.__coroutineLastTick = current_time;
            
                var _array = global.__coroutineManagerArray;
                var _i = 0;
                repeat(array_length(_array))
                {
                    var _coroutine = _array[_i];
                    if (!_coroutine.__executing)
                    {
                        array_delete(_array, _i, 1);
                    }
                    else
                    {
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
        break;
        
        case ev_other:
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
                case ev_broadcast_message:    _key = "broadcast";  break;
            }
            
            if (_key == undefined)
            {
                __CoroutineError("Async event not supported at this time");
            }
            else
            {
                if (COROUTINES_GAMEMAKER_BROADCASTS_TRIGGER_NATIVE && (event_number == ev_broadcast_message))
                {
                    CoroutineBroadcast(event_data[? "message"]);
                }
                
                var _array = global.__coroutineAwaitingAsync[$ _key];
                var _i = 0;
                repeat(array_length(_array))
                {
                    var _coroutineCommand = _array[_i];
                    var _coroutine = _coroutineCommand.__coroutineRoot;
                    if (!_coroutine.__executing)
                    {
                        array_delete(_array, _i, 1);
                    }
                    else if (_coroutineCommand.__Callback())
                    {
                        array_delete(_array, _i, 1);
                        _coroutine.__Run();
                    }
                    else
                    {
                        ++_i;
                    }
                }
            }
        break;
    }
}