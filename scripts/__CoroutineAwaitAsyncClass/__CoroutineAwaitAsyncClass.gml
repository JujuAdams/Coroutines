function __CoroutineAwaitAsync(_type, _function)
{
    if (COROUTINES_CHECK_SYNTAX) __CoroutineCheckSyntax("AWAIT_ASYNC_*");
    
    var _new = new __CoroutineAwaitAsyncClass();
    _new.__type = _type;
    _new.__function = method(global.__coroutineScope, _function);
    _new.__coroutineRoot = global.__coroutineStack[0];
    
    __COROUTINE_PUSH_TO_PARENT;
}

function __CoroutineAsyncTimeout(_function)
{
    if (COROUTINES_CHECK_SYNTAX) __CoroutineCheckSyntax("ASYNC_TIMEOUT");
    
    //Set the timeout function for the previous command on the stack
    //This is hopefully an AWAIT_ASYNC_* command!
    global.__coroutineStack[array_length(global.__coroutineStack)-1].__timeoutFunction = method(global.__coroutineScope, _function);
}

function __CoroutineAwaitAsyncClass() constructor
{
    __function = undefined;
    __type = undefined;
    __timeoutFunction = undefined;
    __coroutineRoot = undefined;
    
    __complete = false;
    __startTime = undefined;
    
    static Restart = function()
    {
        if (!__complete && (__startTime != undefined))
        {
            var _array = global.__coroutineAwaitingAsync[$ __type];
            var _i = 0;
            repeat(array_length(_array))
            {
                if (_array[_i] == self)
                {
                    array_delete(_array, _i, 1);
                    break;
                }
                
                ++_i;
            }
        }
        
        __complete = false;
        __startTime = undefined;
    }
    
    static __Run = function()
    {
        if (__startTime == undefined)
        {
            __startTime = current_time;
            
            var _array = global.__coroutineAwaitingAsync[$ __type];
            array_push(_array, self);
        }
        
        if (is_method(__timeoutFunction) && (current_time - __startTime > __timeoutFunction()))
        {
            try
            {
                __Callback();
            }
            catch(_error)
            {
                show_debug_message(_error);
                __CoroutineTrace("Error whilst handling timeout for coroutine async callback (type = \"", __type, "\")");
                __CoroutineTrace("Please ensure async callbacks handle timeouts appropriately (async_load = -1)");
            }
            
            __complete = true;
        }
        else
        {
            global.__coroutineEscapeState = __COROUTINE_ESCAPE_STATE.__YIELD;
        }
    }
    
    static __Callback = function()
    {
        if (__complete)
        {
            return true;
        }
        else
        {
            var _previousRootStruct = global.__coroutineRootStruct;
            global.__coroutineRootStruct = __coroutineRoot;
            
            var _result = __function();
            
            global.__coroutineRootStruct =_previousRootStruct;
            
            if (_result == true)
            {
                __complete = true;
                return true;
            }
        }
        
        return false;
    }
}