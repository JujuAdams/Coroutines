function TestPowersOfTwo(_count)
{
    CO_PARAMS.limit = _count;
    
    var _coroutine = CO_BEGIN
        i = 1;
        REPEAT limit THEN
            YIELD i THEN
            i *= 2;
        END
    CO_END;
    
    return _coroutine;
}