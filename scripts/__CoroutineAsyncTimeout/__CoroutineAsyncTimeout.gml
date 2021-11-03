function __CoroutineAsyncTimeout(_timeoutFunction)
{
    __COROUTINE_ASSERT_STACK_NOT_EMPTY;
    if (__COROUTINES_CHECK_SYNTAX) __CoroutineCheckSyntax("TIMEOUT");
    
    //Set the timeout function for the previous command on the stack
    //This is hopefully an AWAIT_ASYNC_* command!
    global.__coroutineStack[array_length(global.__coroutineStack)-1].__timeoutFunction = method(global.__coroutineStack[0], _timeoutFunction);
}