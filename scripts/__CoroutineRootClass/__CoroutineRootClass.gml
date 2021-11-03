function __CoroutineInstantiate()
{
    if ((global.__coroutineManagerObject != undefined) && !instance_exists(global.__coroutineManagerObject))
    {
        __CoroutineError(object_get_name(global.__coroutineManagerObject), " was created but no longer exists\nPlease check it has not been deactivated");
    }
    
    var _new = new __CoroutineRootClass();
    __COROUTINE_PUSH_TO_STACK;
    
    return _new;
}

function __CoroutineGetNext()
{
    return global.__coroutineNext;
}

function __CoroutineBegin(_function)
{
    if (__COROUTINES_CHECK_SYNTAX) __CoroutineCheckSyntax("CO_BEGIN");
    
    //Push this function into the struct at the top of the stack
    global.__coroutineStack[array_length(global.__coroutineStack)-1].__Add(method(global.__coroutineStack[0], _function));
}

function __CoroutineEnd()
{
    if (array_length(global.__coroutineStack) != 1)
    {
        var _string  = "Command stack is still open. Some common syntax errors to check for are:\n"
            _string += "- Every REPEAT, WHILE, and FOREACH loop must have a matching END command\n"
            _string += "- Every IF command must have a matching END_IF command\n"
            _string += "- \"ELSE IF\" (with a space) is invalid, use \"ELSE_IF\" instead";
        __CoroutineError(_string);
    }
    
    if (__COROUTINES_CHECK_SYNTAX) __CoroutineCheckSyntax("CO_END");
    array_resize(global.__coroutineStack, 0);
    global.__coroutineNext.coroutineCreator = self;
    global.__coroutineNext.__Execute();
    
    var _result = global.__coroutineNext;
    global.__coroutineNext = __CoroutineInstantiate();
    return _result;
}

function __CoroutineRootClass() constructor
{
    __functionArray = [];
    __onCompleteFunction = undefined;
    
    __index = 0;
    __complete = false;
    
    __paused = false;
    __returnValue = undefined;
    
    __executing = false;
    
    static Get = function()
    {
        return __returnValue;
    }
    
    static Resume = function()
    {
        if (__paused)
        {
            __paused = false;
            __returnValue = undefined;
        }
    }
    
    static GetPaused = function()
    {
        return __paused;
    }
    
    static Pause = function(_returnValue = undefined)
    {
        if (!__paused)
        {
            __paused = true;
            __returnValue = _returnValue;
        }
    }
    
    static Cancel = function()
    {
        //Call the CO_ON_COMPLETE function if one exists
        if (!__complete)
        {
            if (is_method(__onCompleteFunction)) __onCompleteFunction();
        }
        
        __complete = true;
        __executing = false;
        
        __RemoveFromAutomation();
    }
    
    static Restart = function()
    {
        __index = 0;
        __complete = false;
        
        __paused = false;
        __returnValue = undefined;
        
        if (!__executing) array_push(global.__coroutineExecuting, self);
        
        var _i = 0;
        repeat(array_length(__functionArray))
        {
            var _function = __functionArray[_i];
            if (is_struct(_function) && !is_method(_function)) _function.Restart();
            ++_i;
        }
    }
    
    static GetComplete = function()
    {
        return __complete;
    }
    
    static __Run = function()
    {
        //If we're finished or we're paused, we shouldn't run any coroutine code
        if (__complete || __paused) return undefined;
        
        //Set up some global state variables that child classes will read
        global.__coroutineEscapeState = __COROUTINE_ESCAPE_STATE.__NONE;
        global.__coroutineBreak = false;
        global.__coroutineReturnValue = undefined;
        
        //Always guarantee one iteration so we're updating loops and AWAIT commands etc.
        do
        {
            //Call the relevant function
            var _function = __functionArray[__index];
            __COROUTINE_TRY_EXECUTING_FUNCTION;
            
            if (__index >= array_length(__functionArray)) __complete = true;
            
            //Clean up any hanging BREAK commands
            global.__coroutineBreak = false;
        }
        until ((global.__coroutineEscapeState > 0) || __complete);
        
        //Set state based on what escape code we were given
        //This covers YIELD, PAUSE, and RETURN
        switch(global.__coroutineEscapeState)
        {
            case __COROUTINE_ESCAPE_STATE.__NONE:
                __returnValue = undefined;
            break;
            
            case __COROUTINE_ESCAPE_STATE.__YIELD:
                __returnValue = global.__coroutineReturnValue;
            break;
            
            case __COROUTINE_ESCAPE_STATE.__PAUSE:
                Pause(global.__coroutineReturnValue);
            break;
            
            case __COROUTINE_ESCAPE_STATE.__RETURN:
                __complete = true;
                __returnValue = global.__coroutineReturnValue;
            break;
        }
        
        //Call the CO_ON_COMPLETE function if one exists
        if (__complete)
        {
            if (is_method(__onCompleteFunction)) __onCompleteFunction();
        }
    }
    
    static __Add = function(_new)
    {
        array_push(__functionArray, _new);
    }
    
    static __Execute = function()
    {
        if (!__executing)
        {
            __executing = true;
            array_push(global.__coroutineExecuting, self);
        }
    }
    
    static __RemoveFromAutomation = function()
    {
        var _array = global.__coroutineExecuting;
        var _i = 0;
        repeat(array_length(_array))
        {
            if (_array[_i] == self)
            {
                array_delete(_array, _i, 1);
                return undefined;
            }
            
            ++_i;
        }
    }
}