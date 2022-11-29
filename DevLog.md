
26th 8AM-12PM
Saw the 3-Star Game Jam, and after seeing an ad on my phone I became inspired to create an arcade space shooter like Millipede or whatever.
Within this 4-hour period before I left to meet some friends IRL, I had:
- Created the background art
- Created all the sprite art
- Programmed the movement logic
- Programmed the shooting logic to spawn bullets
- Programmed the Bee enemy AI
- Programmed the collision logic and health logic, including invincibility frames

This meant I essentially a basic playable prototype, which I was really proud of.

26th 8PM-10PM
Here, I plotted out a checklist of the things that still needed to be done, and banged out some of the logic for the menus (didn't finish them though) and scoring logic before going to bed.
This period was mainly dealing with annoying stuff, such as:
- Wondering why the character wasn't moving (I had forgotten to call `super.update()`)
- Wondering why desktop builds weren't playing MP3s (I had to convert to OGG)
- Wondering why adding new files broke HaxeFlixel's AssetPaths utility (I had to restart the IDE every time I added new files)
Overall stuff that felt more like inconveniences then challenges.

27th 12PM-4PM 6PM-8PM
Here, with a break to visit with family, I got to work on:
- Finishing up the main menu with credits text
- Finishing up the intro scroll (ripping of Star Wars, as one does when making a space game)
- Pause screen
- Defeat animation (graphics + sfx)
- Results screen
- Score calculation
- Score persistence and save data
- High score report on main menu

Github Copilot has been a major boon for swift development; I can type:
`// Wobble the logo text back and forth.`
and Copilot will intuit my intent and suggest something like:
`logoText.angle = Math.sin(totalElapsed * WOBBLE_SPEED) * WOBBLE_AMPLITUDE;`

28th 10AM-12PM
At this point, the game was mostly complete. My main remaining tasks were designing the AI for the tougher enemies and finishing up the victory screen. I also had some additional ideas for features to implement, but decided I had to go with only one of them. Between a more elaborate final battle and Newgrounds integration (awards + scoreboard API), I decided the latter would be less problematic to develop, while also leaving time for playtesting and providing me with more useful experience. At this point the only thing left was to design the second and third level.
[X] Newgrounds login
[x] Newgrounds scores
[X] Newgrounds awards (beat level 1, beat level 2, beat level 3)
[X] Victory screen

28th 12PM-3PM
Finally, I finished up the remaining levels. I had to add some code to fix a weird bug where Bee's bullets would fire at an angle, which was fine in Level 1 but made it a lot harder to keep track of what's going on in levels 2 and 3.
I'm happy with the AI for the Queen, her random movement is very bee-like.
[X] Level 2 layout
[X] Hornet AI
[X] Level 3 layout
[X] Queen AI