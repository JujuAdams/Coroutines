function __CoroutineIf(_conditionFunction)
{
    __COROUTINE_ASSERT_STACK_NOT_EMPTY;
    
    //TODO - Check for "ELSE IF" rather than the correct "ELSE_IF"
    
    var _new = new __CoroutineIfClass();
    with(_new) __branchConditionArray[__branchWriteIndex] = method(global.__coroutineStack[0], _conditionFunction);
    
    __COROUTINE_PUSH_TO_PARENT;
    __COROUTINE_PUSH_TO_STACK;
}

function __CoroutineElseIf(_conditionFunction)
{
    __COROUTINE_ASSERT_STACK_NOT_EMPTY;
    
    global.__coroutineStack[array_length(global.__coroutineStack)-1].__AddBranch(method(global.__coroutineStack[0], _conditionFunction));
}

function __CoroutineElse()
{
    __COROUTINE_ASSERT_STACK_NOT_EMPTY;
    
    global.__coroutineStack[array_length(global.__coroutineStack)-1].__AddBranch(undefined);
}

function __CoroutineIfClass() constructor
{
    __branchFunctionArray = [[]];
    __branchConditionArray = [];
    __branchWriteIndex = 0;
    
    __index = 0;
    __complete = false;
    
    __branch = undefined;
    
    static Restart = function()
    {
        __index = 0;
        __complete = false;
        
        __branch = undefined;
        
        var _i = 0;
        repeat(array_length(__branchFunctionArray))
        {
            var _array = __branchFunctionArray[_i];
            var _j = 0;
            repeat(array_length(_array))
            {
                var _function = _array[_j];
                if (is_struct(_function) && !is_method(_function)) _function.Restart();
                ++_j;
            }
            
            ++_i;
        }
    }
    
    static __Run = function()
    {
        if (__complete) return undefined;
        
        if (__branch == undefined)
        {
            var _max = array_length(__branchConditionArray);
            
            __branch = -1;
            do
            {
                __branch++;
                
                if (__branch >= _max)
                {
                    __complete = true;
                    return undefined;
                }
                
                var _function = __branchConditionArray[__branch];
            }
            until ((_function == undefined) || _function())
        }
        
        var _functionArray = __branchFunctionArray[__branch];
        do
        {
            var _function = _functionArray[__index];
            __COROUTINE_TRY_EXECUTING_FUNCTION;
            
            //Move to the next function
            if (__index >= array_length(_functionArray))
            {
                __complete = true;
            }
        }
        until ((global.__coroutineEscapeState > 0)
           ||  global.__coroutineBreak
           ||  __complete
           ||  (get_timer() > global.__coroutineApproxEndTime));
        
        //N.B. We don't clear up the BREAK state because we want break to bleed through to the next loop
    }
    
    static __Add = function(_new)
    {
        array_push(__branchFunctionArray[__branchWriteIndex], _new);
    }
    
    static __AddBranch = function(_condition)
    {
        __branchWriteIndex++;
        __branchFunctionArray[@  __branchWriteIndex] = [];
        __branchConditionArray[@ __branchWriteIndex] = _condition;
    }
}