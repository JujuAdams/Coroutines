<h1 align="center">Coroutines 1.4.0</h1>

<p align="center">Asynchronous execution in GML for GameMaker Studio 2.3.6 (and above)</p>

<p align="center"><a href="https://github.com/JujuAdams/Coroutines/releases/">Download the .yymps</a></p>
<p align="center">Chat about Coroutines on the <a href="https://discord.gg/e9wrvnCWkK">Discord server</a></p>
<p align="center"> <a href="https://github.com/JujuAdams/Coroutines/wiki">Documentation</a></p>

&nbsp;

&nbsp;

This library allows you to write pauseable functions in GameMaker. These pauseable functions are called "coroutines": a block of code that can be paused in the middle of execution and resumed later. Coroutines can be used for UI animation, complex networking protocols, REST API and OAuth flows, multi-stage visual effects, asynchronous save/load (required for console development), and more still. They're fantastically useful.

Getting coroutines to work in GameMaker is one thing, but making them fun to write requires a creative solution. Instead of implementing a slow custom scripting language or editor-side extension to generate coroutine-esque code, this library uses native GML macros to extend GML syntax to accommodate coroutine definitions. You can read all about the new syntax [here](https://github.com/JujuAdams/Coroutines/wiki/Coroutine-Syntax) or understand how and why it works [here](https://github.com/JujuAdams/Coroutines/wiki/How-do-we-extend-GML%3F).

Because this library uses native GML at its core it is cross-platform, requires no additional software, and requires no external Included Files. The codebase is MIT Licensed and can be used everywhere, for free, forever. Regretably, GameMaker's HTML5 runtime is hot garbage and as a result this library is not supported for HTML5.

&nbsp;

***Please note** that due to changes made in GMS2.3.6 to async event constant names, you will need to modify library code to get it to compile in versions older than v2.3.6.*
