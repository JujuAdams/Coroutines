function __CoroutineBreak(_blindFunction)
{
    if (COROUTINES_CHECK_SYNTAX) __CoroutineCheckSyntax("BREAK");
    
    var _new = new __CoroutineBreakClass();
    
    __COROUTINE_PUSH_TO_PARENT;
}

function __CoroutineBreakClass() constructor
{
    __complete = false;
    
    static Restart = function()
    {
        __complete = false;
    }
    
    static __Run = function()
    {
        global.__coroutineBreak = true;
        __complete = true;
    }
}
