#macro __COROUTINES_VERSION "0.1.0"
#macro __COROUTINES_DATE    "2021-10-31"

show_debug_message("Welcome to Coroutines by @jujuadams! This is version " + __COROUTINES_VERSION + ", " + __COROUTINES_DATE);



enum __COROUTINE_ESCAPE_STATE
{
    __NONE,
    __YIELD,
    __PAUSE,
    __RETURN
}

#macro __COROUTINE_ASSERT_STACK_EMPTY  if (array_length(global.__coroutineStack) > 0) __CoroutineError("Cannot define more than one coroutine at a time");
#macro __COROUTINE_ASSERT_STACK_NOT_EMPTY  if (array_length(global.__coroutineStack) <= 0) __CoroutineError("Must use coroutine function after __CoroutineBegin() and before CoroutineEnd()");
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

#macro CO_BEGIN                ((function(){__CoroutineFunction(function(){
#macro CO_ON_COMPLETE          });__CoroutineOnComplete(function(){
#macro CO_END                  });\
                               if (array_length(global.__coroutineStack) != 1) __CoroutineError("Illegal stack size (", array_length(global.__coroutineStack), ")");\
                               array_resize(global.__coroutineStack, 0);\
                               global.__coroutineNext.coroutineCreator=self;\
                               global.__coroutineNext.__Execute();\
                               var _result = global.__coroutineNext;\
                               global.__coroutineNext = __CoroutineBegin();\
                               return _result;\
                               })())
#macro THEN                    });__CoroutineFunction(function(){
#macro YIELD                   });__CoroutineEscape(__COROUTINE_ESCAPE_STATE.__YIELD,function(){return 
#macro PAUSE                   });__CoroutineEscape(__COROUTINE_ESCAPE_STATE.__PAUSE,function(){return 
#macro RETURN                  });__CoroutineEscape(__COROUTINE_ESCAPE_STATE.__RETURN,function(){return 
#macro BREAK                   {global.__coroutineBreak=true;return undefined;}
#macro REPEAT                  });__CoroutineRepeat(function(){return 
#macro WHILE                   });__CoroutineWhile(function(){return 
#macro FOREACH                 });__CoroutineForEach(function(_value){
#macro IN                      =_value;},function(){return 
#macro END                     });__CoroutineEndLoop();__CoroutineFunction(function(){
#macro IF                      });__CoroutineIf(function(){return 
#macro ELSE                    });__CoroutineElse();__CoroutineFunction(function(){
#macro ELSE_IF                 });__CoroutineElseIf(function(){return 
#macro END_IF                  });__CoroutineEndLoop();__CoroutineFunction(function(){
#macro AWAIT                   });__CoroutineAwait(function(){return 
#macro DELAY                   });__CoroutineDelay(function(){return 
#macro AWAIT_ASYNC_HTTP        });__CoroutineAwaitAsync("http",function(){
#macro AWAIT_ASYNC_NETWORKING  });__CoroutineAwaitAsync("networking",function(){
#macro AWAIT_ASYNC_SOCIAL      });__CoroutineAwaitAsync("social",function(){
#macro AWAIT_ASYNC_SAVE_LOAD   });__CoroutineAwaitAsync("save_load",function(){
#macro AWAIT_ASYNC_DIALOG      });__CoroutineAwaitAsync("dialog",function(){
#macro AWAIT_ASYNC_SYSTEM      });__CoroutineAwaitAsync("system",function(){
#macro AWAIT_ASYNC_STEAM       });__CoroutineAwaitAsync("steam",function(){
#macro TIMEOUT                 },function(){return 
#macro ASYNC_COMPLETE          return true;

#endregion



global.__coroutineManagerObject = undefined;

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
global.__coroutineNext = __CoroutineBegin();



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