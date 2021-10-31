// Set up some text to draw to the screen
// We're going to use a coroutine to animate this!
textArray = [
    { x :  0, y :  50, targetX : 20, alpha : 0, text : "Coroutines" },
    { x :  0, y :  70, targetX : 20, alpha : 0, text : "@jujuadams 2021" },
    { x : 20, y : 100, targetX : 40, alpha : 0, text : "This is an example to demonstrate basic animations using a coroutine." },
];

// We're storing a reference to the coroutine here so we can show some debug information
// In this particular case, this is a "one-shot" coroutine that doesn't need to be tracked
// Accordingly, in a real world situation, keeping this reference would be unnecessary
animationCoroutine = CO_BEGIN
    // Pre-delay a little bit for feel
    DELAY 300 THEN
    
    // Set up our iterator, and iterate over every text entry in the array
    i = 0;
    
    // <coroutineCreator> is a special variable in every coroutine that refers to the
    // instance/struct that created the coroutine. Whilst code inside a coroutine
    // runs in its own scope, its often useful to have a coroutine affect data stored
    // in a specific instance/struct
    REPEAT array_length(coroutineCreator.textArray) THEN
        
        data = coroutineCreator.textArray[i];
        
        // Go around this loop until this specific piece of text is at 100% alpha and in the correct position
        WHILE (data.alpha < 1) or (data.x < data.targetX) THEN
            
            //Tween to the correct position, and fade in our alpha value
            data.x = min(data.x + 1, data.targetX);
            data.alpha = min(data.alpha + 0.04, 1.0);
            
            // YIELD breaks out of the coroutine temporarily
            // Next frame, we return to the coroutine at this position (which continues round the while-loop)
            YIELD
        END
        
        // Once we've animated one piece of text, move on to the next
        i++;
    END
CO_END;

// The above can be written in a much more compact way:
// 
// CO_BEGIN
//     DELAY 300 THEN
//     FOREACH data IN coroutineCreator.textArray THEN
//         data = coroutineCreator.textArray[i];
//         WHILE (data.alpha < 1) or (data.x < data.targetX) THEN
//             data.x = lerp(data.x, data.targetX, 0.2);
//             data.alpha = min(data.alpha + 0.04, 1.0);
//             YIELD
//         END
//     END
// CO_END;