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
    state.image_name = "__item digital key";
    state.council_quest = true;

    // Total 8-bit score
    state.state_int["currentScore"] = get_property_int("8BitScore");

    // Bonus zone is tracked via the 8BitColor pref; black/red/blue/green are the zone colors 
    state.currentColor = get_property("8BitColor");

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

    // Basically every info piece will be keyed by black/red/blue/green.

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

    // Mapping zones for fun and profit, but mostly to make future things easier.
    string [string] zoneMap;

    zoneMap["black"] = "Vanya's Castle";
    zoneMap["red"] = "The Fungus Plains";
    zoneMap["blue"] ="Megalo City";
    zoneMap["green"] = "Hero's Field";

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

    foreach key in helpfulModifier
        int addedBonus = (currentColor == key ? 100 : 50)
        int denominator = (currentColor == key ? 10 : 20)
        int rawPoints = min(300, max(0, userModifier[key] - minimumToAddPoints[key]));

        expectedPoints[key] = addedBonus + round(rawPoints/denominator) * 10;

    // Now that we have calculated everything, we can finally make the tile!
	ChecklistSubentry subentry;
	subentry.header = base_quest_state.quest_name;
	string [int] modifiers;
    string image = base_quest_state.image_name;
    
    string url = "place.php?whichplace=8bit";
    
    // We have a return up top for a finished quest. As a result, it should only hit !started
    //   in the right order, even if our finishing reassignment in QuestInit doesn't work.
    if (!base_quest_state.started)
    {
        url = "place.php?whichplace=forestvillage&action=fv_mystic";
        image = "__item continuum transfunctioner";
        subentry.entries.listAppend("Visit the crackpot mystic for your transfunctioner!")
    }
    else {
        // Establish easier shorthand for the active bonus modifier.
        string activeMod = helpfulModifier[base_quest_state.currentColor];
        
        // Add nice shorthand text to the subentry w/ the stat to maximize.
        if (activeMod = "Initiative") {modifiers.listAppend("+init")};
        if (activeMod = "Meat Drop") {modifiers.listAppend("+meat")};
        if (activeMod = "Damage Absorption") {modifiers.listAppend("+DA")};
        if (activeMod = "Item Drop") {modifiers.listAppend("+item")};

        // Give descriptive information about the current zone.
        subentry.entries.listAppend("Adventure in "+zoneMap[base_quest_state.currentColor]+" for maximum points!";)
        subentry.entries.listAppend("Current expected points: "+expectedPoints[base_quest_state.currentColor];)

        if ($item[continuum transfunctioner].equipped_amount() == 0)
            url = "inventory.php?ftext=continuum+transfunctioner";
            subentry.entries.listAppend("Equip your transfunctioner to access the realm.");
    }
    
    // If the user is below level 5, probably have better things to be doing unless they're 
    //   already maxed out at the relevant bonus zone; ergo, shift the tile to "Future Tasks"
    if (my_level() > 5 || expectedPoints[base_quest_state.currentColor] == 300)
	    task_entries.listAppend(ChecklistEntryMake(image, url, subentry).ChecklistEntrySetIDTag("Digital Key Quest"));
    else 
        future_task_entries.listAppend(ChecklistEntryMake(image, url, subentry).ChecklistEntrySetIDTag("Digital Key Quest"));

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
    if (!my_path().id == PATH_KINGDOM_OF_EXPLOATHING)
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
