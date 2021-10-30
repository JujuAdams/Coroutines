function __CoroutineAwait(_function)
{
    __COROUTINE_ASSERT_STACK_NOT_EMPTY;
    
    var _new = new __CoroutineAwaitClass();
    _new.__function = method(global.__coroutineStack[0], _function);
    
    __COROUTINE_PUSH_TO_PARENT;
}

function __CoroutineAwaitClass() constructor
{
    __function = undefined;
    
    __complete = false;
    
    static Restart = function()
    {
        __complete = false;
    }
    
    static __Run = function()
    {
        if (__function())
        {
            __complete = true;
        }
        else
        {
            global.__coroutineEscapeState = __COROUTINE_ESCAPE_STATE.__YIELD;
        }
    }
}