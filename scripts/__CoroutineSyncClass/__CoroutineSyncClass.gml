function __CoroutineSync(_function)
{
    if (COROUTINES_CHECK_SYNTAX) __CoroutineCheckSyntax("SYNC");
    
    var _new = new __CoroutineSyncClass();
    _new.__function = method(global.__coroutineStack[0], _function);
    
    __COROUTINE_PUSH_TO_PARENT;
    __COROUTINE_PUSH_TO_STACK;
}

function __CoroutineSyncClass() constructor
{
    __function = undefined;
    
    __initialized    = false;
    __complete       = false;
    __coroutineArray = undefined;
    
    static Restart = function()
    {
        //TODO - Do we need to cancel child coroutines if we are cancelled?
        
        __initialized    = false;
        __complete       = false;
        __coroutineArray = undefined;
    }
    
    static __Run = function()
    {
        if (!__initialized)
        {
            __initialized = true;
            __coroutineArray = [];
            
            var _oldManagerArray = global.__coroutineManagerArray;
            global.__coroutineManagerArray = __coroutineArray;
            __function();
            global.__coroutineManagerArray = _oldManagerArray;
        }
        else
        {
            var _i = 0;
            repeat(array_length(__coroutineArray))
            {
                var _coroutine = __coroutineArray[_i];
                _coroutine.__Run();
                
                if (_coroutine.GetComplete())
                {
                    array_delete(__coroutineArray, _i, 1);
                    _coroutine.__executing = false;
                }
                else
                {
                    ++_i;
                }
            }
            
            if (array_length(__coroutineArray) <= 0)
            {
                __complete = true;
                __coroutineArray = undefined;
            }
            else
            {
                global.__coroutineEscapeState = __COROUTINE_ESCAPE_STATE.__YIELD;
            }
        }
    }
}