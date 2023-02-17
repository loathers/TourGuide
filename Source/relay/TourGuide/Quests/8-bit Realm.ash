void Q8BitInit()
{
    // This is a convoluted enough keygen method that I'm refactoring it as a quest as 
    //   opposed to a set. This could be wrong! But I think it is a good exercise.
    QuestState state;

    // Set the state as "started" if you have the continuum transfunctioner.
    if (!state.started && $items[continuum transfunctioner].available_amount() > 0)
        QuestStateParseMafiaQuestPropertyValue(state, "started");

    // Finish this quest if you are in community service, so the tiles never generate.
    if (my_path().id == PATH_COMMUNITY_SERVICE) QuestStateParseMafiaQuestPropertyValue(state, "finished");

    // Finish this quest tile if you are in Kingdom of Exploathing, as 8-bit doesn't exist there.
    if (my_path().id == PATH_KINGDOM_OF_EXPLOATHING) QuestStateParseMafiaQuestPropertyValue(state, "finished");

    // Finish this quest tile if you are no longer in-run. Currently commented for testing.
    // if (!__misc_state["in run"]) QuestStateParseMafiaQuestPropertyValue(state, "finished");

    // Establish basic information for tile generation
    state.quest_name = "Digital Key Quest";
    // state.image_name = "__item digital key"; // digital key was my O.G. pick but door is better 
    state.image_name = "inexplicable door";
    state.council_quest = true;

    // Total 8-bit score
    state.state_int["currentScore"] = get_property_int("8BitScore");

    // Bonus zone is tracked via the 8BitColor pref; black/red/blue/green are the zone colors 
    state.state_string["currentColor"] = get_property("8BitColor");

    // If you don't have the digital key, you need the digital key
    state.state_boolean["haveDigitalKey"] = $item[digital key].available_amount() > 0;

    // Have you turned in the digital key?
    state.state_boolean["turnedInDigitalKey"] = __quest_state["Level 13"].state_boolean["digital key used"];

    if (state.finished)
    {
        state.state_boolean["haveDigitalKey"] = false;
        state.state_boolean["turnedInDigitalKey"] = true;
    }

	__quest_state["Digital Key"] = state;
}

void Q8bitRealmGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] future_task_entries)
{
    // In 2023, there was a large rework of the 8-bit realm. Instead of needing 30 white
    //   pixels to generate your Digital Key, you now need a certain amount of score. This
    //   new tile is an attempt to help users figure out the new 8-bit zone!

    // Read in the information initialized in the quest initializer.
    QuestState base_quest_state = __quest_state["Digital Key"];

    // Do not generate tiles if you do not need the digital key anymore. Need to add the 
    //   commented bit back when I finish testing!!!

    // if (base_quest_state.finished) { return }

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

    // Storing this so the tile can tell which zone is next.
    string [string] nextColor;

    nextColor["black"] = "blue";
    nextColor["red"] = "black";
    nextColor["blue"] = "green";
    nextColor["green"] = "red";

    int [string] turnsInZone;
    
    // I do not like using turnsSpent; it has weird behavior w/ freeruns. Best we got tho!
    foreach key in helpfulModifier
        turnsInZone[key] = to_location(zoneMap[key]).turns_spent;

    int bonusTurnsRemaining = 5 - ((turnsInZone["black"]+
                                turnsInZone["red"]+
                                turnsInZone["blue"]+
                                turnsInZone["green"]) % 5);
    
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

    // Now that we have calculated everything, we can finally make the tile! Before the very 
    //   detailed subentry, we have a quick statement of what the quest wants you to do. We
    //   do this by adding to the subentries[0] guy.
    entry.subentries[0].entries.listAppend("Gain "+pluralise(10000-base_quest_state.state_int["currentScore"], "more point","more points")+" to get your digital key.");

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
    else {
        
	    subentry.header = "BONUS ZONE: "+zoneMap[currentColor]+" ("+pluralise(bonusTurnsRemaining, "more fight", "more fights")+")";

        // Establish easier shorthand for the active bonus modifier.
        string activeMod = helpfulModifier[currentColor];
        string neededModifier = to_string(minimumToAddPoints[currentColor]);
        
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

            string percentCharacter = (activeMod != "Damage Absorption" ? "?" : "");
            string fractionNeeded = to_string(userModifier[currentColor])+percentCharacter+"/"+ to_string(minimumToAddPoints[currentColor]+300)+percentCharacter;

            string buffUpLine = "Consider buffing <b>"+HTMLGenerateSpanFont(helpfulModifier[currentColor], currentColor)+"</b> for more points.";
            buffUpLine += "|*Currently at "+fractionNeeded+" needed "+helpfulModifier[currentColor]+".";
            subentry.entries.listAppend(buffUpLine);
        }
        
        // In both cases, show the # of turns remaining of bonus in this zone.
        subentry.entries.listAppend("In "+pluralise(bonusTurnsRemaining, "more fight", "more fights")+", bonus zone will be <b>"+HTMLGenerateSpanFont(zoneMap[nextColor[currentColor]],nextColor[currentColor])+"</b>.");

        // If they don't have the transfunctioner equipped, equip it and change the URL.
        if ($item[continuum transfunctioner].equipped_amount() == 0) 
        {
            entry.url = "inventory.php?ftext=continuum+transfunctioner";
            subentry.entries.listAppend(HTMLGenerateSpanFont("Equip your transfunctioner to access the realm.", "red"));

        }
    }

    entry.subentries.listAppend(subentry);

    // Add small subentry near the end w/ current score!
    ChecklistSubentry keyCompletionSubentry;
    
    keyCompletionSubentry.header = "Projected Key Completion";
    keyCompletionSubentry.modifiers.listAppend("Current Score: "+to_string(base_quest_state.state_int["currentScore"])+" of 10000");
    keyCompletionSubentry.entries.listAppend("If you max your bonus, you'll have your key in "+pluralise((10000-round(base_quest_state.state_int["currentScore"]))/400," more turn","more turns"));
    entry.subentries.listAppend(keyCompletionSubentry);
    
    // If the user is below level 5, probably have better things to be doing unless they're 
    //   already maxed out at the relevant bonus zone; ergo, shift the tile to "Future Tasks"
    
    if (my_level() > 5 || expectedPoints[currentColor] == 300)
	    task_entries.listAppend(entry);
    else 
        future_task_entries.listAppend(entry);

}


// void S8bitRealmGenerateResource(ChecklistEntry [int] resource_entries)
// {
//     if (!(__quest_state["Level 13"].state_boolean["digital key used"] || $item[digital key].available_amount() > 0))
//         return;
//     if (!__misc_state["in run"] || !in_ronin())
//         return;
//     //This is mainly for one crazy random summer, where you have many pixels.
//     //Blue pixel potion - [50,80] MP restore
//     //monster bait - +5% combat
//     //pixel sword - ? - +15% init
//     //red pixel potion - [100,120] HP restore - the shadow knows
//     //pixel whip - useful against vampires
//     //pixel grappling hook would be useful, but it's unlikely anyone would defeat all four bosses in-run (resets upon ascension)
//     string [item] craftables;
//     int [item] max_craftables_wanted;
//     craftables[$item[blue pixel potion]] = "~65 MP restore";
//     craftables[$item[monster bait]] = "+5% combat";
//     max_craftables_wanted[$item[monster bait]] = 1;
//     //pixel sword?
//     if (__quest_state["Level 13"].state_boolean["shadow will need to be defeated"])
//         craftables[$item[red pixel potion]] = "~110 HP restore for shadow";
//     if ($locations[dreadsylvanian castle,the spooky forest,The Haunted Sorority House,The Daily Dungeon] contains __last_adventure_location) //known vampire locations. it's perfectly reasonable to test against the sorority house, here in 2015
//     {
//         craftables[$item[pixel whip]] = "vampire killer";
//         max_craftables_wanted[$item[pixel whip]] = 1;
//     }
    
//     max_craftables_wanted[$item[blue pixel potion]] = 11;
//     max_craftables_wanted[$item[red pixel potion]] = 4; //4 minimum to out-shadow
    
//     string [int] crafting_list_have;
//     string [int] crafting_list_cannot;
//     foreach it, reason in craftables
//     {
//         if (it.available_amount() >= MAX(1, max_craftables_wanted[it]))
//             continue;
//         string line = it;
        
//         if (max_craftables_wanted[it] != 1 && it.creatable_amount() > 0)
//             line = pluralise(it.creatable_amount(), it);
//         line += ": " + reason;
//         if (it.creatable_amount() == 0)
//         {
//             line = HTMLGenerateSpanFont(line, "grey");
//             crafting_list_cannot.listAppend(line);
//         }
//         else
//             crafting_list_have.listAppend(line);
//     }
//     if (crafting_list_have.count() > 0)
//     {
//         string [int] crafting_list = crafting_list_have;
//         crafting_list.listAppendList(crafting_list_cannot);
//         string pixels_have = "Pixel crafting";
//         resource_entries.listAppend(ChecklistEntryMake("__item white pixel", "shop.php?whichshop=mystic", ChecklistSubentryMake(pixels_have,  "", crafting_list), 10).ChecklistEntrySetIDTag("Crackpot mystic pixel crafting resource"));
//     }
// }

void S8bitRealmGenerateMissingItems(ChecklistEntry [int] items_needed_entries)
{
    // This is still helpful, but literally only for KoE. Keep it just for KoE.
    if (my_path().id != PATH_KINGDOM_OF_EXPLOATHING)
        return;
    if (!__misc_state["in run"] && !__misc_state["Example mode"])
        return;
    if (__quest_state["Level 13"].state_boolean["digital key used"])
        return;
    
    if ($item[digital key].available_amount() == 0) {
        string url = "place.php?whichplace=forestvillage&action=fv_mystic"; //forestvillage.php
        if (my_path().id == PATH_KINGDOM_OF_EXPLOATHING)
            url = "shop.php?whichshop=exploathing";
        string [int] options;
        if ($item[digital key].creatable_amount() > 0) {
            options.listAppend("Have enough pixels, make it.");
        } else {
            if ($item[psychoanalytic jar].item_is_usable() && (!in_hardcore() || $familiar[angry jung man].familiar_is_usable()))
                options.listAppend("Fear man's level (jar)");
            if (__misc_state["fax equivalent accessible"] && in_hardcore()) //not suggesting this in SC
                options.listAppend("Fax/copy a ghost");
            if (my_path().id == PATH_KINGDOM_OF_EXPLOATHING)
                options.listAppend("Fight invader bullets");
            else if ($item[continuum transfunctioner].item_is_usable())
                options.listAppend("8-bit realm (olfact blooper, slow)");
            if (my_path().id == PATH_ONE_CRAZY_RANDOM_SUMMER)
                options.listAppend("Wait for pixellated monsters");
            if (lookupItem("Powerful Glove").available_amount() > 0)
                options.listAppend("Adventure with the Powerful Glove equipped");
            
            int total_white_pixels = $item[white pixel].available_amount() + $item[white pixel].creatable_amount();
            if (total_white_pixels > 0)
                options.listAppend(total_white_pixels + "/30 white pixels found.");
        }
        items_needed_entries.listAppend(ChecklistEntryMake("__item digital key", url, ChecklistSubentryMake("Digital key", "", options)).ChecklistEntrySetIDTag("Council L13 quest tower door digital key"));
    }
}