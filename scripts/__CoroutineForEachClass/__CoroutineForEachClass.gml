function __CoroutineForEach(_setterFunction)
{
    if (__COROUTINES_CHECK_SYNTAX) __CoroutineCheckSyntax("FOREACH");
    
    var _new = new __CoroutineForEachClass();
    _new.__setterFunction = method(global.__coroutineStack[0], _setterFunction);
    
    __COROUTINE_PUSH_TO_PARENT;
    __COROUTINE_PUSH_TO_STACK;
}

function __CoroutineForEachIn(_function)
{
    if (__COROUTINES_CHECK_SYNTAX) __CoroutineCheckSyntax("IN");
    
    //Set the data function for the previous command on the stack
    //This is hopefully a FOREACH command!
    global.__coroutineStack[array_length(global.__coroutineStack)-1].__dataFunction = method(global.__coroutineStack[0], _function);
}

function __CoroutineForEachClass() constructor
{
    __functionArray = [];
    __setterFunction = undefined;
    __dataFunction = undefined;
    
    __index = 0;
    __complete = false;
    
    __dataType    = undefined; //0 = array, 1 = struct, 2 = coroutine
    __repeatData  = undefined;
    __repeatNames = undefined; //Only used for structs
    __repeatCount = 0;
    __repeatIndex = 0;
    
    static Restart = function()
    {
        __dataType    = undefined;
        __repeatData  = undefined;
        __repeatNames = undefined; //Only used for structs
        __repeatCount = 0;
        __repeatIndex = 0;
        
        __Loop();
    }
    
    static __Loop = function()
    {
        __index = 0;
        __complete = false;
        
        var _i = 0;
        repeat(array_length(__functionArray))
        {
            var _function = __functionArray[_i];
            if (is_struct(_function) && !is_method(_function)) _function.Restart();
            ++_i;
        }
    }
    
    static __Run = function()
    {
        if (__complete) return undefined;
        
        //If we haven't collected the data that we're going to repeat, then call the function to generate that
        if (__repeatData == undefined)
        {
            __repeatData = __dataFunction();
            
            //Depending on what datatype we're iterating over, set our expected iteration size
            if (is_array(__repeatData))
            {
                __repeatCount = array_length(__repeatData);
                __dataType = 0; //Array
            }
            else if (is_struct(__repeatData))
            {
                if (instanceof(__repeatData) == "__CoroutineRootClass")
                {
                    //Ensure that this function is only processed when this FOREACH loop is processed
                    __repeatData.__RemoveFromAutomation();
                    
                    __repeatCount = infinity; //We use different logic for coroutine iterators based on the .Get() method
                    __dataType = 2; //Coroutine
                }
                else
                {
                    __repeatCount = variable_struct_names_count(__repeatData);
                    __repeatNames = variable_struct_get_names(__repeatData);
                    __dataType = 1; //Struct
                }
            }
            else
            {
                __CoroutineError("Cannot iterate over datatype \"", typeof(__repeatData), "\"\nData must be an array or a struct");
            }
            
            //Early out if there's no data to iterate over
            if (__repeatCount <= 0)
            {
                __Complete();
                return undefined;
            }
            
            //Set the initial starting value for the output of the foreach loop
            switch(__dataType)
            {
                case 0: //Array
                    __setterFunction(__repeatData[0]);
                break;
                
                case 1: //Struct
                    __setterFunction(__repeatData[$ __repeatNames[0]]);
                break;
                
                case 2: //Coroutine
                    if (__repeatData.GetComplete())
                    {
                        __Complete();
                        return undefined;
                    }
                    
                    __repeatData.__Run();
                    __setterFunction(__repeatData.Get());
                break;
            }
        }
        
        do
        {
            var _function = __functionArray[__index];
            __COROUTINE_TRY_EXECUTING_FUNCTION;
            
            //Move to the next function
            if (__index >= array_length(__functionArray))
            {
                //Increase our repeats count. If we've reached the end then call us complete!
                ++__repeatIndex;
                if (__repeatIndex >= __repeatCount)
                {
                    __Complete();
                }
                else
                {
                    switch(__dataType)
                    {
                        case 0: //Array
                            __setterFunction(__repeatData[__repeatIndex]);
                            __Loop();
                        break;
                        
                        case 1: //Struct
                            __setterFunction(__repeatData[$ __repeatNames[__repeatIndex]]);
                            __Loop();
                        break;
                        
                        case 2: //Coroutine
                            __repeatData.__Run();
                            __setterFunction(__repeatData.Get());
                            
                            if (__repeatData.GetComplete())
                            {
                                __Complete();
                            }
                            else
                            {
                                __Loop();
                            }
                        break;
                    }
                }
            }
        }
        until ((global.__coroutineEscapeState > 0) || global.__coroutineBreak || __complete); //TODO - Are we leaking memory if we receive a RETURN escape?
        
        //Clean up the BREAK state
        if (global.__coroutineBreak)
        {
            global.__coroutineBreak = false;
            __Complete();
            return undefined;
        }
    }
    
    static __Complete = function()
    {
        __complete = true;
        __repeatData = undefined; //Make sure we don't keep more references around than we have to
    }
    
    static __Add = function(_new)
    {
        array_push(__functionArray, _new);
    }
}