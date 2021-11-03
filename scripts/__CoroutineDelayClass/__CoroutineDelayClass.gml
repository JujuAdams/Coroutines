function __CoroutineDelay(_delayFunction)
{
    if (__COROUTINES_CHECK_SYNTAX) __CoroutineCheckSyntax("DELAY");
    
    var _new = new __CoroutineDelayClass();
    _new.__delayFunction = method(global.__coroutineStack[0], _delayFunction);
    
    __COROUTINE_PUSH_TO_PARENT;
}

function __CoroutineDelayClass() constructor
{
    __delayFunction = undefined;
    
    __complete = false;
    __startTime = undefined;
    
    static Restart = function()
    {
        __complete = false;
        __startTime = undefined;
    }
    
    static __Run = function()
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
}