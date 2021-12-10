function __CoroutineIf(_conditionFunction)
{
    if (COROUTINES_CHECK_SYNTAX) __CoroutineCheckSyntax("IF");
    
    //TODO - Check for "ELSE IF" rather than the correct "ELSE_IF"
    
    var _new = new __CoroutineIfClass();
    with(_new) __branchConditionArray[__branchWriteIndex] = method(global.__coroutineScope, _conditionFunction);
    
    __COROUTINE_PUSH_TO_PARENT;
    __COROUTINE_PUSH_TO_STACK;
}

function __CoroutineElseIf(_conditionFunction)
{
    if (COROUTINES_CHECK_SYNTAX) __CoroutineCheckSyntax("ELSE_IF");
    
    global.__coroutineStack[array_length(global.__coroutineStack)-1].__AddBranch(method(global.__coroutineScope, _conditionFunction));
}

function __CoroutineElse(_function)
{
    if (COROUTINES_CHECK_SYNTAX) __CoroutineCheckSyntax("ELSE");
    
    global.__coroutineStack[array_length(global.__coroutineStack)-1].__AddBranch(undefined);
    
    //Push the follower function into the struct at the top of the stack
    global.__coroutineStack[array_length(global.__coroutineStack)-1].__Add(method(global.__coroutineScope, _function));
}

function __CoroutineEndIf(_function)
{
    if (COROUTINES_CHECK_SYNTAX) __CoroutineCheckSyntax("END_IF");
    
    array_pop(global.__coroutineStack);
    
    //Push the follower function into the struct at the top of the stack
    global.__coroutineStack[array_length(global.__coroutineStack)-1].__Add(method(global.__coroutineScope, _function));
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
            
            if (__index >= array_length(_functionArray)) __complete = true;
        }
        until ((global.__coroutineEscapeState > 0) || global.__coroutineBreak || global.__coroutineContinue || __complete);
        
        if (global.__coroutineBreak || global.__coroutineContinue)
        {
            //N.B. We don't clear up the BREAK or CONTINUE state because we want break to bleed through to the next loop
            __complete = true;
        }
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