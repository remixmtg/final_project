# CS50 Pokemon Route 1
### By Jeremy Siegel aka RemixMTG
#### Video Demo:  <URL HERE>
#### Description:

This project started as an idea all the way back from Week 0 when we worked with Scratch. 
I'm a huge Pokemon fan, and as such wanted to understand how the game worked under the hood.
I did my best with scratch, but couldn't figure out how collisions and walls would work during that first week.
All I was able to accomplish was getting Ash to be animated and walk around the map, except he could walk on trees, through walls, etc.
Fast forward to the final project, and I watched the Love2D Lua seminar and realized I could try my hand at making a more functional game level.
I used the same sprite assets as I did for my scratch project, and scoured the internet for more Love2D tutorials.

I stumbled upon the [Challacade](https://www.youtube.com/@Challacade) youtube channel and their Zelda series was great and helped me understand a lot of the game making mechanics. I learned to incorporate the [anim8 library](https://github.com/kikito/anim8) to animate Ash, and use the [Windfield library](https://github.com/a327ex/windfield) as a physics engine to detect collisions and create my walls.

My first goal was to get Ash walking and animated, which was basically recreating my Scratch project with Lua. Instead of cutting out individual sprites like I did in my scratch project and toggling through each of them, I learned to use a spritesheet and cut out just the ones I wanted to create frames of animation with anim8.  Then, I spent time figuring out how I was going to create the walls on the map to prevent Ash from walking on top of trees and other obstacles.  I realized that in game levels are generated through the use of a tilemap after reading through [Sheepolution's book](https://www.sheepolution.com/learn/book/18) on Love2D, and that each obstacle would be printed/loaded up when the game started. However - this was beyond the scope of what I was comfortable handling in this project, and the sprites I had were of the final already completed map from Pokemon- so I decided to just draw my own boundaries instead.  

I created collision boundaries for my player so that Ash could not traverse past the walls, and I basically had a working prototype of the game. However, I realized that in the actual game, if Ash is walking downwards, he could jump over the bushes or walls in his way.  It took a lot of trial and error, but I was able to suspend the collision preventing Ash from walking through walls for a brief time, and slow his velocity down so he gave a different appearance. I also changed his animation from "walking down" to "jumping".

I wanted the game to be a bit more interactive, so I created a pokeball item that Ash could open, and it would generate an in game message, just like the original pokemon would.  To do this, I created a player query in front of Ash that would look for particular collision classes when the space bar was pressed. So - I gave the pokeball a "button" class, and when pressed - it animated the pokeball opening and the message to pop up. I achieved this by giving the pokeball different "states" and as they progressed, each message would pop up after the space bar was pressed. To tie it all together, I added in game messages at the start of the game that taught the player how to play, by using the space bar to interact with items, and the arrow keys or WASD to walk around.  

The final thing I added was to make the road sign display where the character can go, by pressing the space bar on the sign and for a message to pop up.  As it stands, the character has to repress the space bar at the sign for the message to go away, and that is a limitation of this space bar interaction that I have not been able to solve for.  Other than that - this game represents exactly what I was trying to create in our first week in Scratch, and I'm so grateful for CS50 for showing me how I can make it happen with code!