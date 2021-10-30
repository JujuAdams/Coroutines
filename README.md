<h1 align="center">Coroutines 0.0.11</h1>

<p align="center">Asynchronous execution in GML for GameMaker Studio 2.3 by <b>@jujuadams</b></p>

<p align="center"><a href="https://github.com/JujuAdams/Coroutines/releases/">Download the .yymps</a></p>
<p align="center">Chat about Coroutines on the <a href="https://discord.gg/8krYCqr">Discord server</a></p>

&nbsp;

&nbsp;

This library allows you to write pauseable functions in GameMaker. These pauseable functions are called "coroutines": a block of code that can be paused in the middle of execution and resumed later.

When you write code and run your game, the code that you wrote is executed sequentially, with one command being executed immediately after the previous command has finished. We store code in functions with the intention that the program will move from one function to the next, making the game work. When the program enters into a function it has to complete the entire function (or at least up to a `return` command) before the program can exit the function and run other code. This is called "synchronous execution" and this is the way GameMaker works - code is run synchronously, one line after another, thousands of lines of code per frame spread over hundreds of functions.

Asynchronous functions are different. Asynchronous functions **don't** have to fully complete all their code before the program can leave that function and do something else and, crucially, asynchronous functions can pick up where they left off and resume execution from where they were paused. This means you can write some code that, in the middle of it, can allow the overarching program to go do something else and come back to the function later.

Many languages natively support writing asynchronous code, either as a core language feature, or a library that enables asynchronous execution. GML is the latter. As a result, it is necessary to develop our own system that emulates the features and behaviours of languages that do support ansynchronous functions. This library extends the syntax of GML so that we can describe coroutines.

Before we get carried away with the technical specifics let's look at a quick example: a cutscene.

Animating cutscenes is a nightmare, and a lot of energy has been spent over the years designing and building different solutions for The Cutscene Problem. The most common solution is to use a big switch...case statement to control what instance does what and when. It is very time-consuming to build these systems and they always end up ugly and unweildy. In reality, what we want for a cutscene function is an asynchronous function - a pauseable function that can deliver instructions to the game to animate objects and show text, without that function preventing the remainder of the game from running.

Here's an example cutscene. We'll go through exactly what's happening later on, but this should give you a flavour of what sort of things are possible with coroutines:

```
function CutsceneFindMyFroggy()
{
	return CO_BEGIN
		//Prevent the player from moving around using normal controls
		oPlayer.inCutscene = true;
		
		//Walk the player into the room
		WHILE (oPlayer.x != 55) THEN
			oPlayer.x = min(oPlayer.x + 2, 55);
			YIELD THEN
		END
		
		//Display some dialogue
		oTextbox.text = "Where's my frog?";
		oTextbox.expression = sPlayerSad;
		AWAIT keyboard_check_pressed(vk_space) THEN
		
		oTextbox.text = "...";
		
		//Pause for a brief moment for comedy effect
		DELAY 350 THEN //milliseconds
		
		oTextbox.text = "Ribbit!";
		oTextbox.expression = sFrog;
		audio_play_sound(sndLonelyRibbit, 1, false);
		
		//Hop the frog into the player's arms
		WHILE (oFrog.x != 55) THEN
			oFrog.x = max(oFrog.x - 2, 55);
			YIELD THEN
		END
		
		oTextbox.text = "Ah, there she is! Who's my beautiful amphibian?";
		oTextbox.expression = sPlayerHappy;
		AWAIT keyboard_check_pressed(vk_space) THEN
		
		oTextbox.text = "Ribbit! :)";
		oTextbox.expression = sFrog;
		audio_play_sound(sndHappyRibbit, 1, false);
		AWAIT keyboard_check_pressed(vk_space) THEN
		
		//Clear out the textbox and then release the player
		oTextbox.text = "";
		player.inCutscene = false;
	CO_END
}
```

This syntax is a little different to normal GML. Of particular note is the use of a few new flow control keywords. `WHILE` you've seen before no doubt (albeit as the lowercase `while` loop command) whereas a lot of the other allcaps commands are new or unfamiliar.
