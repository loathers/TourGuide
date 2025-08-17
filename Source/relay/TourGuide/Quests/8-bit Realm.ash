void Q8BitInit()
{
    // This is a convoluted enough keygen method that I'm refactoring it as a quest as 
    //   opposed to a set. This could be wrong! But I think it is a good exercise.
    QuestState state;

    // Set the state as "started" if you have the continuum transfunctioner.
    if (!state.started && $items[continuum transfunctioner].available_amount() > 0)
        state.started = true;
        
    // Finish this quest if you are in 11,037 Leagues Under the Sea, so the tiles never generate.
    if (my_path().id == PATH_SEA) state.finished = true;

    // Finish this quest if you are in community service, so the tiles never generate.
    if (my_path().id == PATH_COMMUNITY_SERVICE) state.finished = true;

    // Finish this quest tile if you are in Kingdom of Exploathing, as 8-bit doesn't exist there.
    if (my_path().id == PATH_KINGDOM_OF_EXPLOATHING) state.finished = true;

    // Finish this quest tile if you are no longer in-run. Currently commented for testing.
    if (!__misc_state["in run"]) state.finished = true;

    boolean haveDigitalKey = $item[digital key].available_amount() > 0;
    boolean turnedInDigitalKey = __quest_state["Level 13"].state_boolean["digital key used"];

    if (haveDigitalKey || turnedInDigitalKey) state.finished = true;

    // Establish basic information for tile generation
    state.quest_name = "Digital Key Quest";
    state.image_name = "__item digital key"; // if the bespoke logic fails 
    // state.image_name = "inexplicable door";
    state.council_quest = true;

    // Total 8-bit score
    state.state_int["currentScore"] = get_property_int("8BitScore");

    // Bonus zone is tracked via the 8BitColor pref; black/red/blue/green are the zone colors 
    state.state_string["currentColor"] = get_property("8BitColor");

    if (state.state_string["currentColor"] == "") state.state_string["currentColor"] = "black";

	__quest_state["Digital Key"] = state;
}

void Q8bitRealmGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] future_task_entries)
{
    // In 2023, there was a large rework of the 8-bit realm. Instead of needing 30 white
    //   pixels to generate your Digital Key, you now need a certain amount of score. This
    //   new tile is an attempt to help users figure out the new 8-bit zone!

    // Read in the information initialized in the quest initializer.
    QuestState base_quest_state = __quest_state["Digital Key"];

    // Do not generate tiles if you do not need the digital key anymore.
    if (base_quest_state.finished) { return; }

    // Because I'm doing nested subentries, the broader quest is a ChecklistEntry.
    ChecklistEntry entry;
    entry.url = "place.php?whichplace=8bit";
    entry.image_lookup_name = base_quest_state.image_name;
    entry.tags.id = "Digital Key Pixels 8bit L13";
    entry.should_indent_after_first_subentry = true;
    entry.subentries.listAppend(ChecklistSubentryMake(base_quest_state.quest_name));
    entry.should_highlight = $locations[Vanya's Castle, The Fungus Plains, Megalo-City, Hero's Field] contains __last_adventure_location;

    // NOTE: Technically speaking, I think some of this probably -should- be in the Q8BitInit()
    //   function. However, I like the fact that this lets me read in currentColor as an index
    //   key on this data; while you can make state.state_int[] and state.state_string[] fields,
    //   it seems much less straightforward to make int/string fields keyed by a string but with
    //   proper reference parameters. So instead, I initialize a ton of crap here. Hopefully the
    //   comments help make everything a bit cleaner and clearer!

    // Make it easier to reference currentColor, as it keys everything else.
    string currentColor = base_quest_state.state_string["currentColor"];

    // Will use the keys of this array as the loop key later.
    string [string] helpfulModifier;

    helpfulModifier["black"] = "Initiative";
    helpfulModifier["red"] = "Meat Drop";
    helpfulModifier["blue"] = "Damage Absorption";
    helpfulModifier["green"] = "Item Drop";

    // I'm using the same math that Beldur did in the 8-bit relay. These are the associated
    //    values needed to make the expectedPoints equation work; basically, it's the level
    //    of the modifier you need to see actual point generation increase.
    int [string] minimumToAddPoints;

    minimumToAddPoints["black"] = 300;
    minimumToAddPoints["red"] = 150;
    minimumToAddPoints["blue"] = 300;
    minimumToAddPoints["green"] = 100;

    // NOTE: to get to the max point, you add 300 to any of the minimumToAddPoints lol

    // Mapping zones for fun and profit, but mostly to make future things easier.
    string [string] zoneMap;

    zoneMap["black"] = "Vanya's Castle";
    zoneMap["red"] = "The Fungus Plains";
    zoneMap["blue"] = "Megalo-City";
    zoneMap["green"] = "Hero's Field";

    // Storing this so the tile can tell which zone is next. This made me realize that I, like a
    //   fool, ordered every one of these black/red/blue/green instead of the actual order of 
    //   black/blue/green/red. Sorry, mom. Sorry, college.
    string [string] nextColor;

    nextColor["black"] = "blue";
    nextColor["red"] = "black";
    nextColor["blue"] = "green";
    nextColor["green"] = "red";

    int bonusTurnsRemaining = 5 - get_property("8BitBonusTurns").to_int();
    
    // Populate user's modifier for each bonus; iterates through black/red/blue/green
    int [string] userModifier; 

    foreach key in helpfulModifier
        userModifier[key] = numeric_modifier(helpfulModifier[key]);

    // Populate expected points in each zone
    int [string] expectedPoints;
    int addedBonus;
    int denominator;
    int rawPoints;
    boolean isCurrentZoneBonus;

    foreach key in helpfulModifier
    {
        isCurrentZoneBonus = (currentColor == key);
        addedBonus = (isCurrentZoneBonus ? 100 : 50);
        denominator = (isCurrentZoneBonus ? 10 : 20);
        rawPoints = min(300, max(0, userModifier[key] - minimumToAddPoints[key]));

        expectedPoints[key] = addedBonus + round(rawPoints/denominator) * 10;
    }

    // Figure out if the user is better-suited to adventure elsewhere.
    string highestPointColor = currentColor;

    foreach key, value in expectedPoints {
        if (value > expectedPoints[currentColor]) {
            if (value > expectedPoints[highestPointColor]) {
                highestPointColor = key;
            }
        }
    }

    // Now that we have calculated everything, we can finally make the tile! Before the very 
    //   detailed subentry, we have a quick statement of what the quest wants you to do. We
    //   do this by adding to the subentries[0] guy.
    entry.subentries[0].entries.listAppend("Gain "+pluralise(max(10000-base_quest_state.state_int["currentScore"],0), "more point","more points")+" to get your digital key.");

    // OK, now we make our subentry for the bonus zone.
	ChecklistSubentry subentry;
    
    // We have a return up top for a finished quest. As a result, it should only hit !started
    //   in the right order, even if our finishing reassignment in QuestInit doesn't work.
    if (!base_quest_state.started)
    {
        subentry.header = "Go listen to a crackpot!";
        entry.url = "place.php?whichplace=forestvillage&action=fv_mystic";
        entry.image_lookup_name = "__item continuum transfunctioner";
        subentry.entries.listAppend("Visit the crackpot mystic for your transfunctioner.");
    }
    else if (base_quest_state.state_int["currentScore"] < 10000) {
        
	    subentry.header = "BONUS ZONE: "+zoneMap[currentColor]+" ("+pluralise(bonusTurnsRemaining, "more fight", "more fights")+")";

        // Modify the overarching image to match the current zone.
        entry.image_lookup_name = zoneMap[currentColor];

        // Establish easier shorthand for the active bonus modifier.
        string activeMod = helpfulModifier[currentColor];
        string neededModifier = to_string(minimumToAddPoints[currentColor]+300);
        
        // Add nice shorthand text to the subentry w/ the stat to maximize.
        if (activeMod == "Initiative") {subentry.modifiers.listAppend("+"+neededModifier+"% init");}
        if (activeMod == "Meat Drop") {subentry.modifiers.listAppend("+"+neededModifier+"% meat");}
        if (activeMod == "Damage Absorption") {subentry.modifiers.listAppend("+"+neededModifier+" DA");}
        if (activeMod == "Item Drop") {subentry.modifiers.listAppend("+"+neededModifier+"% item");}
        if (zoneMap[currentColor] != "Megalo-City") {subentry.modifiers.listAppend("outdoor zone");}

        // Give descriptive information about the current zone.
        if (expectedPoints[currentColor] == 400)
        {
            // If the user is at maximum, color the tile a bit and be merry.
            subentry.entries.listAppend(HTMLGenerateSpanFont("<b>MAXIMUM POINTS!</b>",currentColor));
            subentry.entries.listAppend("Adventure in "+HTMLGenerateSpanFont("<b>"+zoneMap[currentColor]+"</b>", currentColor)+" for 400 points per turn!");
        }
        else
        {
            // If the user is not at maximum, point out what they need to buff.
            subentry.entries.listAppend("Current expected points: "+to_string(expectedPoints[currentColor]));

            string percentCharacter = (activeMod != "Damage Absorption" ? "%" : "");
            string modifierNeededText = to_string(minimumToAddPoints[currentColor]+300 - userModifier[currentColor])+percentCharacter;

            string buffUpLine = "Consider buffing <b>"+HTMLGenerateSpanFont(helpfulModifier[currentColor], currentColor)+"</b> for more points.";
            buffUpLine += "|*You need "+modifierNeededText+" more for max points.";
            subentry.entries.listAppend(buffUpLine);
        }
        
        // In both cases, show the # of turns remaining of bonus in this zone.
        subentry.entries.listAppend("In "+pluralise(bonusTurnsRemaining, "more fight", "more fights")+", bonus zone will be <b>"+HTMLGenerateSpanFont(zoneMap[nextColor[currentColor]],nextColor[currentColor])+"</b>.");

        if (highestPointColor != currentColor) {
            subentry.entries.listAppend("Alternate Route:|*"+HTMLGenerateSpanFont("At current stats, you'd earn <b>"+expectedPoints[highestPointColor]+" points</b> per fight at <b>"+zoneMap[highestPointColor]+"</b>. Not recommended!","gray"));
        }

        // If they don't have the transfunctioner equipped, equip it and change the URL.
        if ($item[continuum transfunctioner].equipped_amount() == 0) 
        {
            entry.url = "inventory.php?ftext=continuum+transfunctioner";
            subentry.entries.listAppend(HTMLGenerateSpanFont("Equip your transfunctioner to access the realm.", "red"));

        }
    }

    entry.subentries.listAppend(subentry);

    // Add small subentry near the end w/ current score! But only add it if they have their transfunctioner.
    if (base_quest_state.started) {
        ChecklistSubentry keyCompletionSubentry;
    
        keyCompletionSubentry.header = "Projected Key Completion";
        keyCompletionSubentry.modifiers.listAppend("Current Score: "+to_string(base_quest_state.state_int["currentScore"])+" of 10000");
        
        if (base_quest_state.state_int["currentScore"] < 10000) 
        {
            int pointsLeft = 10000 - base_quest_state.state_int["currentScore"];
            int minimumTurnsToGetKey = ceil(pointsLeft / 400.0); // ceil always rounds up, so any fraction of a leftover turn will add 1
            keyCompletionSubentry.entries.listAppend("If you max your bonus, you'll have your key in "+pluralise(minimumTurnsToGetKey, "more turn", "more turns")+".");
        } 
        else 
        {
            keyCompletionSubentry.entries.listAppend("Woah, 10000 points??? That's this life's high score!");
            keyCompletionSubentry.entries.listAppend("Visit the <b>Treasure House</b> to claim your hard-earned Digital Key.");
        }
        entry.subentries.listAppend(keyCompletionSubentry);
    }
    
    // If the user is below level 5, probably have better things to be doing unless they're 
    //   already maxed out at the relevant bonus zone; ergo, shift the tile to "Future Tasks"
    
    if (my_level() > 5 || expectedPoints[currentColor] == 400)
	    task_entries.listAppend(entry);
    else 
        future_task_entries.listAppend(entry);

}


void Q8bitRealmGenerateResource(ChecklistEntry [int] resource_entries)
{
    // This resource tile is still valuable for newbies who need/want red pixel potions. Somewhat
    //   ironically, this is actually more useful post-revamp since newbies have more reason to
    //   get black pixels. It might be slightly annoying for some speedrunners, but they can just
    //   hide the tile if they don't like it.
    
    // ... though even I can't pretend we want this in aftercore, lol
    if (!__misc_state["in run"] || !in_ronin())
        return;

    // Comment originally from Ezandora noting good things in the pixel shop:
    //   - Blue pixel potion - [50,80] MP restore
    //   - monster bait - +5% combat
    //   - pixel sword - +15% init
    //   - red pixel potion - [100,120] HP restore - the shadow knows
    //   - pixel whip - useful against vampires

    string [item] craftables;
    int [item] max_craftables_wanted;
    craftables[$item[pixel bread]] = "+50% meat";
    craftables[$item[pixel whiskey]] = "+50% item";
    craftables[$item[blue pixel potion]] = "~65 MP restore";
    craftables[$item[monster bait]] = "+5% combat";
    max_craftables_wanted[$item[monster bait]] = 1;

    // Only generate red pixels if you need them for tower healing. They sell like shit.
    if (__quest_state["Level 13"].state_boolean["shadow will need to be defeated"])
        craftables[$item[red pixel potion]] = "~110 HP restore; good for shadow";
    if ($locations[dreadsylvanian castle,the spooky forest,The Haunted Sorority House,The Daily Dungeon] contains __last_adventure_location) //known vampire locations. it's perfectly reasonable to test against the sorority house, here in 2023
    {
        craftables[$item[pixel whip]] = "vampire killer";
        max_craftables_wanted[$item[pixel whip]] = 1;
    }
    
    max_craftables_wanted[$item[blue pixel potion]] = 11;
    max_craftables_wanted[$item[red pixel potion]] = 4; //4 minimum to out-shadow
    
    string [int] crafting_list_have;
    string [int] crafting_list_cannot;
    foreach it, reason in craftables
    {
        if (it.available_amount() >= MAX(1, max_craftables_wanted[it]))
            continue;
        string line = it;
        
        if (max_craftables_wanted[it] != 1 && it.creatable_amount() > 0)
            line = pluralise(it.creatable_amount(), it);
        line += ": " + reason;
        if (it.creatable_amount() == 0)
        {
            line = HTMLGenerateSpanFont(line, "grey");
            crafting_list_cannot.listAppend(line);
        }
        else
            crafting_list_have.listAppend(line);
    }
    if (crafting_list_have.count() > 0)
    {
        string [int] crafting_list = crafting_list_have;
        crafting_list.listAppendList(crafting_list_cannot);
        string pixels_have = "Craft a few Pixel sundries";
        resource_entries.listAppend(ChecklistEntryMake("__item red pixel potion", "shop.php?whichshop=mystic", ChecklistSubentryMake(pixels_have,  "", crafting_list), 10).ChecklistEntrySetIDTag("Crackpot mystic pixel crafting resource"));
    }
}

void Q8bitRealmGenerateMissingItems(ChecklistEntry [int] items_needed_entries)
{
    // This is still helpful, but mostly for KoE, the only remaining path where you need 
    //   to generate white pixels for the digital key. Keep it just for KoE? Heh.

    if (!__misc_state["in run"] && !__misc_state["Example mode"])
        return;
    if (__quest_state["Level 13"].state_boolean["digital key used"])
        return;
    if (my_path().id == PATH_COMMUNITY_SERVICE)
        return;
    
    if ($item[digital key].available_amount() == 0) {
        string url = "place.php?whichplace=8bit";
        if (my_path().id == PATH_KINGDOM_OF_EXPLOATHING)
            url = "shop.php?whichshop=exploathing";
        string [int] options;
        // I had a change of heart and kept it for normal runs too. Dreams can come true.
        if (__quest_state["Digital Key"].state_int["currentScore"] > 9999) {
            options.listAppend("Visit 8-bit Realm's Treasure House and claim your key!");
        } else if (my_path().id == PATH_KINGDOM_OF_EXPLOATHING) { 
            options.listAppend("Go fight invader bullets, or find some way to fight a Ghost.");
        } else {
            options.listAppend("Visit the 8-bit Realm and max your score to claim a Digital Key.");
        }
        items_needed_entries.listAppend(ChecklistEntryMake("__item digital key", url, ChecklistSubentryMake("Digital key", "", options)).ChecklistEntrySetIDTag("Council L13 quest tower door digital key"));
    }
}
