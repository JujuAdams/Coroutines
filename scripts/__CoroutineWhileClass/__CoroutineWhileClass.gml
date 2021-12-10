function __CoroutineWhile(_conditionFunction)
{
    if (COROUTINES_CHECK_SYNTAX) __CoroutineCheckSyntax("WHILE");
    
    var _new = new __CoroutineWhileClass();
    _new.__whileFunction = method(global.__coroutineScope, _conditionFunction);
    
    __COROUTINE_PUSH_TO_PARENT;
    __COROUTINE_PUSH_TO_STACK;
}

function __CoroutineWhileClass() constructor
{
    __functionArray = [];
    __whileFunction = undefined;
    
    __index = 0;
    __complete = false;
    
    static Restart = function()
    {
        __index = 0;
        __complete = false;
        
        var _i = 0;
        repeat(array_length(__functionArray))
        {
            var _function = __functionArray[_i];
            if (is_struct(_function) && !is_method(_function)) _function.Restart();
            ++_i;
        }
    }
    
    static __Run = function()
    {
        if (__complete) return undefined;
        
        //Check the while loop condition if one exists
        if (is_method(__whileFunction) && !__whileFunction())
        {
            __complete = true;
            return undefined;
        }
        
        do
        {
            var _function = __functionArray[__index];
            __COROUTINE_TRY_EXECUTING_FUNCTION;
            
            //Move to the next function
            if (global.__coroutineContinue || (__index >= array_length(__functionArray)))
            {
                global.__coroutineContinue = false;
                
                //Increase our repeats count. If we've reached the end then call us complete!
                if (is_method(__whileFunction) && !__whileFunction())
                {
                    __complete = true;
                }
                else
                {
                    Restart();
                }
            }
        }
        until ((global.__coroutineEscapeState > 0) || global.__coroutineBreak || __complete);
        
        //Clean up the BREAK state
        if (global.__coroutineBreak)
        {
            global.__coroutineBreak = false;
            __complete = true;
        }
    }
    
    static __Add = function(_new)
    {
        array_push(__functionArray, _new);
    }
}