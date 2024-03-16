# Grave Defence
**Grave Defence** is tower defence game, in which you control a ghost tasked with defending the souls resting in a mausoleum from the incoming hordes of skeletons! 

## Controls
- Arrow keys to move the character
- X key to place and pickup torches
- O key to toggle flame aura indicators

## Rules
Torches must be powered by near by Power Flames. Once powered they will shoot enemies within range.
Shooting torches will consume the energy of the flames they are linked to.

Power Flames can die out if over tapped so keep an eye out for their size.
However, Flames will recharge over time unless fully extinguished.

Torches can be relocated; the mausoleum must be protected and you will need to move around the map to do so!

# About
I have recently been getting into game development and learning to work with PICO-8.
After the mandatory [Lazy Devs](https://www.youtube.com/@LazyDevs) tutorial I decided to challenge myself to develop a complete game in two weeks, that would include functioning mechanics, art and some basic music. Grave Defence is the end result!

## Nerdy notes
The actual code is a bit of a mess; there are still chunks of code for mechanics that have been scrapped because they ended up being unintuitive and a hindrance to the fun.
These include an interaction system that would display a cursor based on the last movement direction of the player as well as collision system that initially would involve most sprites in the map, but in the final version has been almost completely removed (thanks to SpaceCat and [this video](https://www.youtube.com/watch?v=KtszrmKwL1U&amp;list=PLavIQQGm3RCmgcBCb0aK4hT7morWlQ19A&amp;index=8) for the collision logic).
I might get around to cleaning it up in the future, if a feel there is something interesting I would like to add to the game.

# Credits and thanks
- Developed by Elfamir, that's me
- QA Tested by my lovely partner ♥

Thanks to the Pico-8 community as a hole for all the great material and inspiration.

If you read all the way to here, congrats!
I would greatly appreciate any feedback on the gaming experience as I am looking to improve my game dev skills :)

# Changelog
### V.1.0
Initial release of the game.
### V.1.1
- Added 2 new levels
- Added snap controls
- Added flame aura indicator
- Added flame low-power alert and changed sprites
- Added *level reset* and *level select* menu items
- Reworked enemy movement

# Technical notes
Grave Defence is developed in PICO-8. Allowing the creation of all the required assets in a single cohesive environment.
More information on the PICO-8 fantasy console can be found on official [PICO-8 website](https://www.lexaloffle.com/pico-8.php)
