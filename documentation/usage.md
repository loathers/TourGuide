<img src="https://user-images.githubusercontent.com/8014761/190516106-6e8c948c-9302-47e0-b09e-114a5456301d.png" alt="tourguide logo" style="width: 50%;">

# Using TourGuide

This file is meant to be a more detailed introduction to what TourGuide is and what kind of features TourGuide has. 

## Walking Through TourGuide
The easiest way to explain what TourGuide does is to show screenshots. To start, this is a view of what TourGuide looks like on initial run, for a user who is midway through a run.

![image](https://user-images.githubusercontent.com/8014761/192012161-1a120f69-e811-47ac-9915-28c91ceb4cb2.png)

At the top, TourGuide will tell you how many turns you've played in your ascension -- this helps speedrunners tell how they're doing on broader turncount relative to their overarching turncount goal. Underneath, it will start out by telling you your **Tasks**, which is the language TourGuide uses to represent things the user needs to do, most prominently main game quests -- as seen in the screenshot, things like the Boss Bat Quest, Knob Goblin Quest, Highland Lord Quest, etc.

Each quest is associated with a tile. The tile changes as the user proceeds on the quest, giving different advice for different stages in the respective quest. Note that the boss bat tile is telling the user that there are just two extra zones that need to be unlocked -- the user has unlocked one chamber, but still needs sonars or screambats to unlock the Beanbat Chamber and the Boss Bat Chamber. If you were to click on the task tile, TourGuide will try to send you to the container zone where the quest is set -- for instance, if we were to click on Castle quest, we'd get this in our main window:

![image](https://user-images.githubusercontent.com/8014761/192012232-e6805ffc-44ff-4ad7-86fa-a219e0a43472.png)

Directly below tasks, TourGuide reports **Optional Tasks** -- these are tasks that are (surprise!) very optional. Tracked tasks like your nemesis quest will live here, tasks that are not required at the present time and in many cases not required for ascension at all. Sometimes, tasks that will eventually be required but are not yet required (like burning delay in Spookyraven's Haunted Ballroom) will also appear here.

Below tasks & optional tasks, there are **Resources**, tracking the myriad resources users have at their disposal during an ascension. Things like free kills, banishes, buffs, et cetera. 

![image](https://user-images.githubusercontent.com/8014761/192012329-84f29dc2-3564-4910-809f-3e011cfaa44d.png)

These can get very, very large in unrestricted paths, as seen in the banish tile (headlined by Snokebombs and the Middle Finger Ring). There are often significant resources that go either unused or virtually unable-to-be-used in unrestricted. But in Standard paths, this tends to be a great end-of-day reminder zone -- if you're getting close to the end of your day, it's a good idea to scroll down to resources and ensure that you've used everything that's available in some way or another. 

When relevant, Resource tiles will link to the relevant container zone (for example, the cloud-talk buff tile will link to your Getaway Campsite). More often, they will link to either the skills page (if the Resource is a skill), your equipment page (if you need to equip something to make that resource work), or your terrarium (if the resource is a familiar that needs to be equipped). 

One thing that's important to call out is the alert system. TourGuide is coded such that it tries to explicitly alert you when there are time-dependent tasks that are imminently available. Alerts will float at the top of the sidebar, ensuring they don't go away even if you are scrolled down and examining a tile lower in the sidebar. Alerts will look like this:

![image](https://user-images.githubusercontent.com/8014761/192012398-d9f0efef-2aa2-4414-a359-08017c63e30a.png)

Things that TourGuide tries to alert the user of are too varied to fully account. Here are some examples:

- If a digitized monster will show up in your next adventure
- If you have a Cold Medicine Cabinet consultation available
- If you have an Asdon Martin banish available right now (as seen above)
- If you have a Cleaver NC ready to go on your next adventure

Finally, there's the bottom bar of TourGuide. This includes links that will take you to the top item in each of the previously described tile zones (Tasks, Optional Tasks, and Resources). It also includes something even more useful -- a zone summary. 

![image](https://user-images.githubusercontent.com/8014761/192012470-2266aa41-c49e-4d17-bef9-4cfe535b0730.png)

When you aren't hovering over the summary, it will show you the bottom part of that screenshot: the name of the zone, the environment of the zone (Underground, Indoors, Outdoors, etc) and the number of turns you've spent in the zone (including freeruns and delay you've burned there). This is useful for delay burn tracking and complaining about how long a task is taking during your ascension, one of the most important parts of KOL. When you hover over the summary, it will show you the monsters within the zone, the phylum of the given monsters, their respective item drop tables, and the projected probability that you will encounter any given monster in the zone on your incoming turn, based on KoLMafia's calculation of rejection probability and the current banishes. It will also show you which monsters in the zone are banished, ultra rares that exist within the zone, and the drop rate of items on monsters in the zone in their drop tables. Here, when it says "100%" for the GOTO item, that means that my item drop % is high enough that I can cap a 30% drop; I will get it every time I fight a BASIC Elemental.

## Tile Minimization

There are a lot of tiles in TourGuide. Like, a LOT of tiles. On fully-decked-out accounts, you can get all the way to 200-300 tiles, which is an absolutely absurd amount of information. To try and help manage this, TourGuide has a tile minimization feature. To minimize the tiles, click the arrow in the top right hand corner of any given tile. 

That will turn this:

![image](https://user-images.githubusercontent.com/8014761/192012531-d2359940-3037-4684-9222-c1abfd541245.png)

Into this:

![image](https://user-images.githubusercontent.com/8014761/192012589-ac94aab8-8e0e-461e-82cb-fe9403af6f3c.png)

You can do this with, again, -every- tile. You can even set default values for it! If you right-click the arrow, you will get the following menu:

![image](https://user-images.githubusercontent.com/8014761/192012624-868558b4-ffaf-4b83-be1e-c22722a9d1bf.png)

Here, if there are certain tiles you want to permanently hide, you can set "Auto-Expansion" to "no" on the tile in question; TourGuide will store this in your LocalStorage, keeping the tile minimized over rollover and ascension if you choose to do so. You can also make the minimized tiles even smaller -- if you select "Don't Display" for tile image and "Replace all with tile ID" for content to show, the tile will minimize even further; instead of the default minimization above, it could look like this:

![image](https://user-images.githubusercontent.com/8014761/192012683-b6a3733c-0f79-48eb-a124-6d4c810665ae.png)

## Other Features

Many people like using the KoL Chat while ascending. TourGuide supports generating two sidebars, so you can access in-game chat while you're using TourGuide. To access this, click the left-facing arrow at the top of TourGuide (which has the alt-text "Show Chat Pane".)

![image](https://user-images.githubusercontent.com/8014761/192012791-f6ba72f0-2278-4930-9106-85aa501ca7e4.png)

Alternatively, you can also pop TourGuide out into its own window, using the double-square box next to the described arrow.

<img src="https://user-images.githubusercontent.com/8014761/192012845-a7797807-b05e-496d-b365-5ff352cc4bf5.png" alt="tourguide windowed" style="width: 25%;">
