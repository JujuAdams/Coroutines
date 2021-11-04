// Whether to perform runtime syntax checking on coroutines. This carries a performance
// penalty when starting coroutines, but not when executing them. Syntax checking is,
// furthermore, something of an experimental feature. It may throw false negatives
// If you're finding that the syntax checker isn't being helpful:
//   1) Make a bug report! The problem is fixable: https://github.com/JujuAdams/Coroutines/issues
//   2) Turn off this macro
#macro COROUTINES_CHECK_SYNTAX  true





// Below is a big list of macros that are used as syntax elements for coroutines Due to
// upstream bugs in GameMaker, sometimes these macros might interfere with enums (2.3.6 20201-11-04).
// You're welcome to change these macros to whatever you want to get this library to fit
// into your game. There will be no impact on functionality (though the syntax checker
// will use the default macro names).
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