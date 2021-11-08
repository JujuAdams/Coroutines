a = {};
aWeakRef = weak_ref_create(a);

with(a)
{
    other.coroutine = CO_BEGIN
        WHILE true THEN YIELD THEN END
    CO_ON_COMPLETE
        show_debug_message("complete");
    CO_END
}

coroutine.WeakReference(true);
coroutine.CancelWhenOrphaned(true);