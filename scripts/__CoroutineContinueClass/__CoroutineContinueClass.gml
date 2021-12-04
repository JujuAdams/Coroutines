function __CoroutineContinue(_blindFunction)
{
    if (COROUTINES_CHECK_SYNTAX) __CoroutineCheckSyntax("CONTINUE");
    
    var _new = new __CoroutineContinueClass();
    
    __COROUTINE_PUSH_TO_PARENT;
}

function __CoroutineContinueClass() constructor
{
    __complete = false;
    
    static Restart = function()
    {
        __complete = false;
    }
    
    static __Run = function()
    {
        global.__coroutineContinue = true;
        __complete = true;
    }
}
