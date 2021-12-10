function __CoroutineDelay(_delayFunction)
{
    if (COROUTINES_CHECK_SYNTAX) __CoroutineCheckSyntax("DELAY");
    
    var _new = new __CoroutineDelayClass();
    _new.__delayFunction = method(global.__coroutineScope, _delayFunction);
    
    __COROUTINE_PUSH_TO_PARENT;
}

function __CoroutineDelayClass() constructor
{
    __delayFunction = undefined;
    
    __complete  = false;
    __startTime = undefined;
    __frames    = undefined;
    
    static Restart = function()
    {
        __complete  = false;
        __startTime = undefined;
        __frames    = undefined;
    }
    
    static __Run = function()
    {
        if (COROUTINES_DELAY_REALTIME)
        {
            if (__startTime == undefined) __startTime = current_time;
            
            if (current_time - __startTime > __delayFunction())
            {
                __complete = true;
            }
            else
            {
                global.__coroutineEscapeState = __COROUTINE_ESCAPE_STATE.__YIELD;
            }
        }
        else
        {
            if (__frames == undefined)
            {
                __frames = 0;
            }
            else
            {
                __frames++;
            }
            
            if (__frames > __delayFunction())
            {
                __complete = true;
            }
            else
            {
                global.__coroutineEscapeState = __COROUTINE_ESCAPE_STATE.__YIELD;
            }
        }
    }
}