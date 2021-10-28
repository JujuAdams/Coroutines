function __CoroutineEscape(_escapeState, _function)
{
    __COROUTINE_ASSERT_STACK_NOT_EMPTY;
    
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
