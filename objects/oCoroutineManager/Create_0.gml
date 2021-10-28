// This is an optional object designed to make it easier to use coroutines in your game.
// Coroutines require an instance to call the CoroutineEventHook() function in multiple
// events, including the Step event and many Async events. This object has those events
// pre-configured to execute CoroutineEventHook().
// 
// Place this object in the first room in your game (the room with the house icon).
// Make sure that this instance is never destroyed. Additionally, if you're using instance
// deactivation in your game, ensure that this instance is never deactivated.