test1 = COROUTINE_BEGIN
    AWAIT (mouse_x > room_width/2) THEN
    IF (mouse_y < room_height/2) THEN
        PAUSE "up" THEN
    ELSE
        PAUSE "down" THEN
    END_IF
    YIELD "done" THEN
COROUTINE_END;

test2 = ExampleFetchURL("https://www.jujuadams.com/");
test3 = ExampleFetchURL("https://www.veryfakeURL.com/");