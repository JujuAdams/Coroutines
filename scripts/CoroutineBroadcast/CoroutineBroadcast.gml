/// @param broadcastName

function CoroutineBroadcast(_broadcastName)
{
    var _array = global.__coroutineAwaitingBroadcast[$ _broadcastName];
    if (is_array(_array))
    {
        var _i = 0;
        repeat(array_length(_array))
        {
            _array[_i].__complete = true;
            ++_i;
        }
        
        //Remove this broadcast name from our dictionary to save on memory... hopefully
        variable_struct_remove(global.__coroutineAwaitingBroadcast, _broadcastName);
    }
}