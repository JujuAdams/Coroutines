/// Returns if the given value is a coroutine created by CO_BEGIN...CO_END
/// 
/// @param value

function IsCoroutine(_value)
{
    if (!is_struct(_value)) return false;
    return (instanceof(_value) == "__CoroutineRootClass");
}