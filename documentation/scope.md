<img src="https://user-images.githubusercontent.com/8014761/190516106-6e8c948c-9302-47e0-b09e-114a5456301d.png" alt="tourguide logo" style="width: 50%;">

# TourGuide Scope

In this page, we're going to outline exactly what TourGuide is meant to do. This is an evolving document that will (ideally) be updated over time, although given the age of TourGuide (and its predecessor, Guide), it seems unlikely that there will be massive scope changes without a large number of new developers coming in.

At its core, TourGuide is an advice script. Here are some things that are out of scope and in scope for TourGuide changes.

## Out-of-Scope

- **TourGuide will not run turns.**
    - TourGuide should never run turns by itself. This is an advice script, not an automation script.
- **TourGuide links will never directly run a turn.**
    - This is slightly different from the above bullet, but it is important -- TourGuide has a ton of links to container zones, skillcasting pages, the terrarium, IOTM interfaces, etc. However, we take great pains to ensure that a user idly clicking TourGuide will not accidentally spend a turn. All TourGuide links must go to (at most) a location where a link can be clicked to spend a turn, not the link that spends the turn itself. This is a really important part of the ethos for how TourGuide tiles are designed and how we are advising our users.
- **TourGuide will not require massive preference changes.**
    - TourGuide should work out of the box. There should not be a ton of preferences that require user management to make TourGuide work properly. This design ethos is part of why the tile minimization code does not involve anything in core KoLMafia preferences, instead preferring to use a user's LocalStorage. This is an active design choice.
- **TourGuide will not always be updated for quest changes in all challenge paths.**
    - TourGuide has a ton of support for old paths and old quests. However, at writing, there are over 40 challenge paths in KoL. TourGuide is not meant to support every small change and every tiny quest diversion in every single challenge path. We do our best! But we can't guarantee we have -every- change tracked. If there are areas where obvious changes can improve TourGuide support for a path, we encourage users to visit our **issues** page and post it as an issue -- if it's a good change, we'll try to put some work on it. But this is not the default, and as a user, please do not enter with the expectation that TourGuide will *always* and immediately account for path-by-path quest differences. We try, but we're a very limited dev team!
- **TourGuide will not account for every IOTM synergy.**
    - In many cases, TourGuide will account for important synergies. But it won't get everything, and it isn't meant to. While TourGuide will lightly poke the user and note that you should maximize your familiar weight before using free runs or running Professor Lectures, it will not string the Vintner tile and the Grey Goose tile together and tell you that you should run the Vintner for familiar experience wine to make your Grey Goose gain weight quicker. The tiles are (largely) meant to be somewhat laser focused on the resource or task in question, with only occasional notes encouraging synergistic use.

## In-Scope

- **TourGuide will expose as much information from mafia preferences as possible to the user.**
    - It is very important that TourGuide exposes the user to all the incredible data KoLMafia stores to make ascending easier. The entire point of TourGuide as an exercise is to take all that data and turn it into something that's powerful and helpful for a burgeoning speed ascender. 
- **TourGuide will be responsive.**
    - Users should not need to reload TourGuide -- it reloads itself constantly, making sure it stays up to date as you use resources in your KoL day.
- **TourGuide will make it easier to navigate the map by linking to container zones that make it easier to complete quests.**
    - While we will never link to a zone where you spend a turn, we will absolutely make the user's navigation tasks easier by linking to containers and areas that they need to be if they want to advance a particular quest.
- **TourGuide will help alert the user when they may be missing an important resource.**
    - This ties into the "alert" framework we discussed in our "Usage" documentation. This is a mild difference from prior iterations of TourGuide -- the current developers are much more focused on alerting the user when they have a resource pending they may want to use. If you do not want the alerts, we highly recommend using our minimization functions to ignore them -- they're a part of TourGuide now. 
- **TourGuide will tell bad jokes.**
    - Lots of them. Lots of bad jokes, all over the place.