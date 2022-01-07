function __CoroutineAwaitBroadcast(_function)
{
    if (COROUTINES_CHECK_SYNTAX) __CoroutineCheckSyntax("AWAIT_BROADCAST");
    
    var _new = new __CoroutineAwaitBroadcastClass();
    _new.__function = method(global.__coroutineScope, _function);
    
    __COROUTINE_PUSH_TO_PARENT;
}

function __CoroutineAwaitBroadcastClass() constructor
{
    __function      = undefined;
    __broadcastName = undefined;
    __complete      = false;
    
    static Restart = function()
    {
        __broadcastName = undefined;
        __complete      = false;
    }
    
    static __Run = function()
    {
        if (__broadcastName == undefined)
        {
            __broadcastName = __function();
            if (!is_string(__broadcastName)) __CoroutineError("Broadcast names must be strings");
            
            var _array = global.__coroutineAwaitingBroadcast[$ __broadcastName];
            if (!is_array(_array))
            {
                _array = [];
                global.__coroutineAwaitingBroadcast[$ __broadcastName] = _array;
            }
            
            array_push(_array, self);
        }
        
        if (!__complete)
        {
            global.__coroutineEscapeState = __COROUTINE_ESCAPE_STATE.__YIELD;
        }
    }
}