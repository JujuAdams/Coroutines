function __CoroutineThen(_function)
{
    if (__COROUTINES_CHECK_SYNTAX) __CoroutineCheckSyntax("THEN");
    
    //Push this function into the struct at the top of the stack
    global.__coroutineStack[array_length(global.__coroutineStack)-1].__Add(method(global.__coroutineStack[0], _function));
}

function __CoroutineOnComplete(_function)
{
    if (__COROUTINES_CHECK_SYNTAX) __CoroutineCheckSyntax("CO_ON_COMPLETE");
    
    //Push this function into the struct at the top of the stack
    global.__coroutineStack[0].__onCompleteFunction = method(global.__coroutineStack[0], _function);
}

function __CoroutineEndLoop(_function)
{
    if (__COROUTINES_CHECK_SYNTAX) __CoroutineCheckSyntax("END");
    
    array_pop(global.__coroutineStack);
    
    //Push the follower function into the struct at the top of the stack
    global.__coroutineStack[array_length(global.__coroutineStack)-1].__Add(method(global.__coroutineStack[0], _function));
}