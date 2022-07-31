// Whether to perform runtime syntax checking on coroutines. This carries a performance
// penalty when starting coroutines, but not when executing them. Syntax checking is,
// furthermore, something of an experimental feature. It may throw false negatives so
// if you're finding that the syntax checker isn't being helpful:
//   1) Make a bug report! The problem is fixable: https://github.com/JujuAdams/Coroutines/issues
//   2) Turn off this macro
// Additionally, runtime syntax checking carries a small performance penalty when
// creating a coroutine. If you feel like you need a little more speed, and once you've
// tested your game fully, you may want to set this macro to false to reclaim a little
// CPU time.
#macro COROUTINES_CHECK_SYNTAX  true

// Set this macro to <true> to measure DELAY command durations in milliseconds. If you
// need per-frame accuracy then set this this macro to <false>
#macro COROUTINES_DELAY_REALTIME  true

// Controls the default cancellation behaviour for coroutines when their creator is
// destroyed or garbage collected. Whether or not a specific coroutines is cancelled
// when orphaned can also be controlled using the .CancelWhenOrphaned() method.
// 
// N.B. A deactivated instance counts as a non-existent instance.
// 
#macro COROUTINES_DEFAULT_CANCEL_WHEN_ORPHANED  false

// This macro is related to the one above. If you're creating a coroutine in the scope
// of a struct, the coroutine needs to keep a reference to that struct so that the
// .GetCreator() method can return a value. This causes a problem if you're expecting
// (or intending for) that struct to be garbage collected at some point because the
// coroutine will keep the struct alive if the coroutine holds a strong reference.
// Setting this macro to <true> will default every struct reference to a weak reference
// to avoid this problem. The type of reference that an individual coroutine holds can
// be further adjusted using the .WeakReference() method.
#macro COROUTINES_DEFAULT_CREATOR_WEAK_REFERENCE  false

// Coroutines has its own native broadcast system. Broadcasts can be made with the
// CoroutineBroadcast() function and listeners can be set up with AWAIT_BROADCAST
// (see online documentation for more details). GameMaker has its own broadcast system
// whereby sprites and sequences can emit events. GameMaker broadcasts can be picked up
// by Coroutines using AWAIT_ASYNC_BROADCAST, and the GameMaker global variable
// <event_data> will be accessible as you'd expect. Coroutine broadcasts and GameMaker
// broadcasts are two different systems and normal don't interact.
// 
// It is sometimes useful to be able to pick up GameMaker broadcasts using AWAIT_BROADCAST.
// Setting the macro below to <true> will allow GameMaker broadcasts to trigger native
// Coroutine broadcast listeners. However, if a GameMaker broadcast triggers a native
// listener then event_data will *not* be accessible. Setting this macro to <true> will
// not disable AWAIT_ASYNC_BROADCAST so be careful not to confuse behaviours.
#macro COROUTINES_GAMEMAKER_BROADCASTS_TRIGGER_NATIVE  false






// Below is a big list of macros that are used as syntax elements for coroutines Due to
// upstream bugs in GameMaker, sometimes these macros might interfere with enums (2.3.6 20201-11-04).
// You're welcome to change these macros to whatever you want to get this library to fit
// into your game. There will be no impact on functionality (though the syntax checker
// will use the default macro names).
#macro CO_BEGIN                ((function(){__CoroutineBegin(function(){ //__CoroutineGetNext() is required to work around GM compiler bug (https://github.com/JujuAdams/Coroutines/issues/7)
#macro CO_ON_COMPLETE          });__CoroutineOnComplete(function(){
#macro CO_END                  });return __CoroutineEnd();})());
#macro CO_PARAMS               global.__coroutineNext
#macro CO_SCOPE                global.__coroutineScope
#macro CO_LOCAL                global.__coroutineRootStruct
#macro THEN                    });__CoroutineThen(function(){
#macro YIELD                   });__CoroutineEscape(__COROUTINE_ESCAPE_STATE.__YIELD,function(){return 
#macro PAUSE                   });__CoroutineEscape(__COROUTINE_ESCAPE_STATE.__PAUSE,function(){return 
#macro RETURN                  });__CoroutineEscape(__COROUTINE_ESCAPE_STATE.__RETURN,function(){return 
#macro RESTART                 });__CoroutineEscape(__COROUTINE_ESCAPE_STATE.__RESTART,undefined);__CoroutineThen(function(){
#macro BREAK                   });__CoroutineBreak(function(){ //N.B. This opens a blind function - it is never executed
#macro CONTINUE                });__CoroutineContinue(function(){ //N.B. This opens a blind function - it is never executed
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
#macro AWAIT_BROADCAST         });__CoroutineAwaitBroadcast(function(){return 
#macro AWAIT_FIRST             });__CoroutineAwaitFirst(function(){
#macro AWAIT_ALL               });__CoroutineAwaitAll(function(){
#macro AWAIT_ASYNC_HTTP        });__CoroutineAwaitAsync("http",function(){
#macro AWAIT_ASYNC_NETWORKING  });__CoroutineAwaitAsync("networking",function(){
#macro AWAIT_ASYNC_SOCIAL      });__CoroutineAwaitAsync("social",function(){
#macro AWAIT_ASYNC_SAVE_LOAD   });__CoroutineAwaitAsync("save_load",function(){
#macro AWAIT_ASYNC_DIALOG      });__CoroutineAwaitAsync("dialog",function(){
#macro AWAIT_ASYNC_SYSTEM      });__CoroutineAwaitAsync("system",function(){
#macro AWAIT_ASYNC_STEAM       });__CoroutineAwaitAsync("steam",function(){
#macro AWAIT_ASYNC_BROADCAST   });__CoroutineAwaitAsync("broadcast",function(){
#macro ASYNC_TIMEOUT           });__CoroutineAsyncTimeout(function(){return 
#macro ASYNC_COMPLETE          return true;