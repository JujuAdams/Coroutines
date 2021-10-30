//Draw a little message at the top of the screen explaining the coroutine's state
draw_text(10, 10, animationCoroutine.GetComplete()? "(coroutine finished)" : "(coroutine playing)");

//Iterate over our text and draw it to the screen, using data that we pull from <textArray>
var _i = 0;
repeat(array_length(textArray))
{
    var _data = textArray[_i];
    draw_set_alpha(_data.alpha);
    draw_text(_data.x, _data.y, _data.text);
    ++_i;
}

draw_set_alpha(1.0);