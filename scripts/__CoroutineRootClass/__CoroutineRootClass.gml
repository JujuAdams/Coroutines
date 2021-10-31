function __CoroutineBegin()
{
    __COROUTINE_ASSERT_STACK_EMPTY;
    
    if ((global.__coroutineManagerObject != undefined) && !instance_exists(global.__coroutineManagerObject))
    {
        __CoroutineError(object_get_name(global.__coroutineManagerObject), " was created but no longer exists\nPlease check it has not been deactivated");
    }
    
    var _new = new __CoroutineRootClass();
    __COROUTINE_PUSH_TO_STACK;
    
    return _new;
}

function __CoroutineOnComplete(_function)
{
    __COROUTINE_ASSERT_STACK_NOT_EMPTY;
    
    //Push this function into the struct at the top of the stack
    global.__coroutineStack[0].__onCompleteFunction = method(global.__coroutineStack[0], _function);
}

function __CoroutineFunction(_function)
{
    __COROUTINE_ASSERT_STACK_NOT_EMPTY;
    
    //Push this function into the struct at the top of the stack
    global.__coroutineStack[array_length(global.__coroutineStack)-1].__Add(method(global.__coroutineStack[0], _function));
}

function __CoroutineEndLoop()
{
    __COROUTINE_ASSERT_STACK_NOT_EMPTY;
    
    array_pop(global.__coroutineStack);
}

function __CoroutineRootClass() constructor
{
    __functionArray = [];
    __onCompleteFunction = undefined;
    
    __index = 0;
    __complete = false;
    __continuous = false;
    __duration = infinity;
    
    __paused = false;
    __returned = false;
    __returnValue = undefined;
    
    __executing = false;
    __topLevel = true;
    
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
        __returned = false;
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
    
    static SetDuration = function(_duration = infinity)
    {
        __duration = _duration;
    }
    
    static GetDuration = function()
    {
        return __duration;
    }
    
    static SetContinuous = function(_state)
    {
        __continuous = _state;
    }
    
    static GetContinuous = function()
    {
        return __continuous;
    }
    
    static __Run = function()
    {
        //If we're finished or we're paused, we shouldn't run any coroutine code
        if (__complete || __paused) return undefined;
        
        //Set up some global state variables that child classes will read
        if (__topLevel) global.__coroutineApproxEndTime = get_timer() + __duration;
        global.__coroutineEscapeState = __COROUTINE_ESCAPE_STATE.__NONE;
        global.__coroutineBreak = false;
        global.__coroutineReturnValue = undefined;
        
        //Always guarantee one iteration so we're updating loops and AWAIT commands etc.
        do
        {
            //Call the relevant function
            var _function = __functionArray[__index];
            
            __COROUTINE_TRY_EXECUTING_FUNCTION;
            
            //Move to the next function
            if (__index >= array_length(__functionArray))
            {
                if (__continuous && !__returned)
                {
                    Restart();
                }
                else
                {
                    __complete = true;
                }
            }
            
            //Clean up any hanging BREAK commands
            global.__coroutineBreak = false;
        }
        until ((global.__coroutineEscapeState > 0)
           ||  __complete
           ||  (get_timer() > global.__coroutineApproxEndTime));
        
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
                __paused = true;
                __returnValue = global.__coroutineReturnValue;
            break;
            
            case __COROUTINE_ESCAPE_STATE.__RETURN:
                __complete = true;
                __returned = true;
                __returnValue = global.__coroutineReturnValue;
            break;
        }
        
        if (__topLevel) global.__coroutineEscapeState = __COROUTINE_ESCAPE_STATE.__NONE;
        
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