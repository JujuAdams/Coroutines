function __CoroutineEscape(_escapeState, _function)
{
    if (__COROUTINES_CHECK_SYNTAX)
    {
        switch(_escapeState)
        {
            case __COROUTINE_ESCAPE_STATE.__YIELD:  __CoroutineCheckSyntax("YIELD" ); break;
            case __COROUTINE_ESCAPE_STATE.__PAUSE:  __CoroutineCheckSyntax("PAUSE" ); break;
            case __COROUTINE_ESCAPE_STATE.__RETURN: __CoroutineCheckSyntax("RETURN"); break;
        }
    }
    
    var _new = new __CoroutineEscapeClass();
    _new.__escapeState = _escapeState;
    _new.__function = method(global.__coroutineStack[0], _function);
    
    __COROUTINE_PUSH_TO_PARENT;
}

function __CoroutineEscapeClass() constructor
{
    __escapeState = __COROUTINE_ESCAPE_STATE.__NONE;
    __function = undefined;
    
    __complete = false;
    
    static Restart = function()
    {
        __complete = false;
    }
    
    static __Run = function()
    {
        global.__coroutineEscapeState = __escapeState;
        global.__coroutineReturnValue = __function();
        __complete = true;
    }
}
