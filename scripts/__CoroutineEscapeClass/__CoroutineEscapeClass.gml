function __CoroutineEscape(_escapeState, _function)
{
    if (COROUTINES_CHECK_SYNTAX)
    {
        switch(_escapeState)
        {
            case __COROUTINE_ESCAPE_STATE.__YIELD:   __CoroutineCheckSyntax("YIELD"  ); break;
            case __COROUTINE_ESCAPE_STATE.__PAUSE:   __CoroutineCheckSyntax("PAUSE"  ); break;
            case __COROUTINE_ESCAPE_STATE.__RETURN:  __CoroutineCheckSyntax("RETURN" ); break;
            case __COROUTINE_ESCAPE_STATE.__RESTART: __CoroutineCheckSyntax("RESTART"); break;
        }
    }
    
    var _new = new __CoroutineEscapeClass();
    _new.__escapeState = _escapeState;
    _new.__function = is_method(_function)? method(global.__coroutineScope, _function) : undefined;
    
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
        global.__coroutineReturnValue = (is_method(__function))? __function() : undefined;
        __complete = true;
    }
}
