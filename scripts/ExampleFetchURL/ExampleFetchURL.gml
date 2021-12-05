function ExampleFetchURL(_url)
{
    //Pass our function arguments into the coroutine we're going to make
    CO_PARAMS.url = string(_url);
    
    //Build a coroutine, and then return it out of this function
    return CO_BEGIN
        
        //Set up a variable to store the data we get back from the remote server
        data = "";
        
        //Make an HTTP GET request to the specified URL
        handle = http_get(url);
        
        //Then wait for an asynchronous HTTP event to come back
        AWAIT_ASYNC_HTTP
            if (async_load < 0) //If we're timed out, async_load is -1
            {
                show_debug_message("HTTP GET for \"" + url + "\" timed out");
            }
            else if (async_load[? "id"] == handle)
            {
                if (async_load[? "status"] == 0)
                {
                    //When we get a proper response, grab the data
                    data = async_load[? "result"];
                    show_debug_message("HTTP GET for \"" + url + "\" successful");
                    
                    //Tell the coroutine that we're done and to continue executing
                    ASYNC_COMPLETE;
                }
                else
                {
                    //Womp womp, failure
                    show_debug_message("HTTP GET for \"" + url + "\" unsuccessful");
                    
                    //Tell the coroutine that we're done and to continue executing
                    ASYNC_COMPLETE;
                }
            }
        ASYNC_TIMEOUT 3000 THEN //Set our timeout to 3 seconds
        
        //The coroutine is done now so output the data we received
        show_debug_message("data = \"" + data + "\"");
        show_debug_message("HTTP GET for \"" + url + "\" complete");
        
    CO_END
}