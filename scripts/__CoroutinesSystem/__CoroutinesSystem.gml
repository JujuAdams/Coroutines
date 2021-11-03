#macro __COROUTINES_VERSION       "0.2.1"
#macro __COROUTINES_DATE          "2021-11-03"
#macro __COROUTINES_CHECK_SYNTAX  true

show_debug_message("Welcome to Coroutines by @jujuadams! This is version " + __COROUTINES_VERSION + ", " + __COROUTINES_DATE);



enum __COROUTINE_ESCAPE_STATE
{
    __NONE,
    __YIELD,
    __PAUSE,
    __RETURN
}

#macro __COROUTINE_PUSH_TO_STACK  array_push(global.__coroutineStack, _new);
#macro __COROUTINE_PUSH_TO_PARENT  global.__coroutineStack[array_length(global.__coroutineStack)-1].__Add(_new);

#macro __COROUTINE_TRY_EXECUTING_FUNCTION  if (is_method(_function))\
                                           {\
                                               _function();\
                                               ++__index;\
                                           }\
                                           else if (is_struct(_function))\
                                           {\
                                               _function.__Run();\
                                               if (_function.__complete) __index++;\
                                           }



#region What hath Science birthed on this Moon-less night

#macro CO_BEGIN                __CoroutineGetNext();(function(){__CoroutineBegin(function(){ //__CoroutineGetNext() is required to work around GM compiler bug (https://github.com/JujuAdams/Coroutines/issues/7)
#macro CO_ON_COMPLETE          });__CoroutineOnComplete(function(){
#macro CO_END                  });return __CoroutineEnd();})();
#macro THEN                    });__CoroutineThen(function(){
#macro YIELD                   });__CoroutineEscape(__COROUTINE_ESCAPE_STATE.__YIELD,function(){return 
#macro PAUSE                   });__CoroutineEscape(__COROUTINE_ESCAPE_STATE.__PAUSE,function(){return 
#macro RETURN                  });__CoroutineEscape(__COROUTINE_ESCAPE_STATE.__RETURN,function(){return 
#macro BREAK                   });__CoroutineBreak(function(){ //N.B. This opens a blind function - it is never executed
#macro REPEAT                  });__CoroutineRepeat(function(){return 
#macro WHILE                   });__CoroutineWhile(function(){return 
#macro FOREACH                 });__CoroutineForEach(function(_value){
#macro IN                      =_value;});__CoroutineForEachIn(function(){return 
#macro END                     });__CoroutineEndLoop(function(){
#macro IF                      });__CoroutineIf(function(){return 
#macro ELSE                    });__CoroutineElse(function(){
#macro ELSE_IF                 });__CoroutineElseIf(function(){return 
#macro END_IF                  });__CoroutineEndIf(function(){
#macro AWAIT                   });__CoroutineAwait(function(){return 
#macro DELAY                   });__CoroutineDelay(function(){return 
#macro AWAIT_ASYNC_HTTP        });__CoroutineAwaitAsync("http",function(){
#macro AWAIT_ASYNC_NETWORKING  });__CoroutineAwaitAsync("networking",function(){
#macro AWAIT_ASYNC_SOCIAL      });__CoroutineAwaitAsync("social",function(){
#macro AWAIT_ASYNC_SAVE_LOAD   });__CoroutineAwaitAsync("save_load",function(){
#macro AWAIT_ASYNC_DIALOG      });__CoroutineAwaitAsync("dialog",function(){
#macro AWAIT_ASYNC_SYSTEM      });__CoroutineAwaitAsync("system",function(){
#macro AWAIT_ASYNC_STEAM       });__CoroutineAwaitAsync("steam",function(){
#macro TIMEOUT                 });__CoroutineAsyncTimeout(function(){return 
#macro ASYNC_COMPLETE          return true;

#endregion



global.__coroutineManagerObject = undefined;
global.__coroutineSyntaxCheckerPrevious = "CO_END";

global.__coroutineEscapeState = __COROUTINE_ESCAPE_STATE.__NONE;
global.__coroutineBreak = false;
global.__coroutineReturnValue = undefined;
global.__coroutineApproxDuration = undefined;

global.__coroutineStack = [];
global.__coroutineLastTick = current_time;

global.__coroutineExecuting = [];
global.__coroutineAwaitingAsync = { //TODO - Is this faster as a map or a struct?
    networking: [],
    http      : [],
    social    : [],
    save_load : [],
    dialog    : [],
    system    : [],
    steam     : [],
};



#macro CO_PARAMS  global.__coroutineNext
global.__coroutineNext = __CoroutineInstantiate();



function __CoroutineTrace()
{
    var _string = "Coroutines: ";
    var _i = 0;
    repeat(argument_count)
    {
        _string += string(argument[_i]);
        ++_i;
    }
    
    show_debug_message(_string);
}

function __CoroutineError()
{
    var _string = "Coroutines:\n";
    var _i = 0;
    repeat(argument_count)
    {
        _string += string(argument[_i]);
        ++_i;
    }
    
    show_error(_string + "\n ", true);
}

function __CoroutineCheckSyntax(_me)
{
    //No, I am not proud of this, but I also don't want to write something more complex
    switch(_me)
    {
        case "CO_BEGIN":
            switch(global.__coroutineSyntaxCheckerPrevious)
            {
                case "CO_END": break;
                default: __CoroutineError("Syntax error\nExpected \"CO_END\" before \"", _me, "\", but found \"", global.__coroutineSyntaxCheckerPrevious, "\"");
            }
        break;
        
        case "CO_END":
            switch(global.__coroutineSyntaxCheckerPrevious)
            {
                case "CO_BEGIN": case "THEN": case "END": case "END_IF": case "CO_ON_COMPLETE": break;
                default: __CoroutineError("Syntax error\nExpected \"CO_BEGIN\", \"THEN\", \"END\", \"END_IF\", or \"CO_ON_COMPLETE\" before \"", _me, "\", but found \"", global.__coroutineSyntaxCheckerPrevious, "\"");
            }
        break;
        
        case "THEN":
            switch(global.__coroutineSyntaxCheckerPrevious)
            {
                case "CO_BEGIN": case "THEN": case "YIELD": case "PAUSE": case "RETURN": case "END": case "REPEAT": case "WHILE": case "IN": case "BREAK": case "IF": case "ELSE": case "ELSE_IF": case "END_IF": case "AWAIT_ASYNC_*": case "TIMEOUT": case "AWAIT": case "DELAY": break;
                case "FOREACH": break; //FIXME - Get "IN" to be detectable
                default: __CoroutineError("Syntax error\nFound \"", global.__coroutineSyntaxCheckerPrevious, "\" before \"", _me, "\"");
            }
        break;
        
        case "CO_ON_COMPLETE":
            switch(global.__coroutineSyntaxCheckerPrevious)
            {
                case "THEN": case "END": case "END_IF": break;
                default: __CoroutineError("Syntax error\nExpected \"THEN\", \"END\", or \"END_IF\" before \"", _me, "\", but found \"", global.__coroutineSyntaxCheckerPrevious, "\"");
            }
        break;
        
        case "YIELD":
        case "PAUSE":
        case "RETURN":
            switch(global.__coroutineSyntaxCheckerPrevious)
            {
                case "CO_BEGIN": case "THEN": case "END": case "BREAK": case "END_IF": break;
                default: __CoroutineError("Syntax error\nExpected \"CO_BEGIN\", \"THEN\", \"END\", \"BREAK\", or \"END_IF\" before \"", _me, "\", but found \"", global.__coroutineSyntaxCheckerPrevious, "\"");
            }
        break;
        
        case "END":
        case "ELSE":
        case "ELSE_IF":
            switch(global.__coroutineSyntaxCheckerPrevious)
            {
                case "THEN": case "END": case "BREAK": case "END_IF": break;
                default: __CoroutineError("Syntax error\nExpected \"THEN\", \"END\", \"BREAK\", or \"END_IF\" before \"", _me, "\", but found \"", global.__coroutineSyntaxCheckerPrevious, "\"");
            }
        break;
        
        case "END_IF":
            switch(global.__coroutineSyntaxCheckerPrevious)
            {
                case "THEN": case "END": case "BREAK": case "ELSE": case "END_IF": break;
                default: __CoroutineError("Syntax error\nExpected \"THEN\", \"END\", \"BREAK\", \"ELSE\", or \"END_IF\" before \"", _me, "\", but found \"", global.__coroutineSyntaxCheckerPrevious, "\"");
            }
        break;
        
        case "REPEAT":
        case "WHILE":
        case "FOREACH":
        case "IF":
        case "AWAIT_ASYNC_*":
        case "AWAIT":
        case "DELAY":
            switch(global.__coroutineSyntaxCheckerPrevious)
            {
                case "CO_BEGIN": case "THEN": case "END": case "BREAK": case "ELSE": case "END_IF": break;
                default: __CoroutineError("Syntax error\nFound \"", global.__coroutineSyntaxCheckerPrevious, "\" before \"", _me, "\"");
            }
        break;
        
        case "IN":
            switch(global.__coroutineSyntaxCheckerPrevious)
            {
                case "FOREACH": break;
                default: __CoroutineError("Syntax error\nExpected \"FOREACH\" before \"", _me, "\", but found \"", global.__coroutineSyntaxCheckerPrevious, "\"");
            }
        break;
        
        case "BREAK":
            switch(global.__coroutineSyntaxCheckerPrevious)
            {
                case "THEN": case "END": case "BREAK": case "ELSE": case "END_IF": break;
                default: __CoroutineError("Syntax error\nExpected \"THEN\", \"END\", \"BREAK\", \"ELSE\", or \"END_IF\" before \"", _me, "\", but found \"", global.__coroutineSyntaxCheckerPrevious, "\"");
            }
        break;
        
        case "TIMEOUT":
            switch(global.__coroutineSyntaxCheckerPrevious)
            {
                case "AWAIT_ASYNC_*": break;
                default: __CoroutineError("Syntax error\nExpected \"AWAIT_ASYNC_*\" before \"", _me, "\", but found \"", global.__coroutineSyntaxCheckerPrevious, "\"");
            }
        break;
    }
    
    global.__coroutineSyntaxCheckerPrevious = _me;
}