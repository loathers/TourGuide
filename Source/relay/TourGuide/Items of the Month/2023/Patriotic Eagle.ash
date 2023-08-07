//Patriotic Eagle
RegisterTaskGenerationFunction("IOTMPatrioticEagleGenerateTasks");
void IOTMPatrioticEagleGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	if (!lookupFamiliar("Patriotic Eagle").familiar_is_usable()) return;

    monster RWB_monster = get_property_monster("rwbMonster");

    if (RWB_monster != $monster[none]) {
        // Have to subtract 1; mafia pref starts at 3 but only increments on start-of-fight text, which happens on 2 of them.
        int fights_left = clampi(get_property_int("rwbMonsterCount"), 0, 2) - 1;

        // Use ezan's weird location-finding-thing
        location [int] possible_appearance_locations = RWB_monster.getPossibleLocationsMonsterCanAppearInNaturally().listInvert();
        
        // Make the entry a bit more explicitly for readability
        ChecklistEntry entry;
        
        entry.url = possible_appearance_locations[0].getClickableURLForLocation();
        entry.image_lookup_name = "__monster " + RWB_monster;
        entry.tags.id = "RWB monster copies";
        entry.importance_level = -1;

        string [int] description;

        description.listAppend("Copied by your eagle's blast. Will appear when you adventure in " + possible_appearance_locations.listJoinComponents(", ", "or") + ".");

        phylum eaglePhylumBanished = $phylum[none];

        if (get_property("banishedPhyla") != "")
            eaglePhylumBanished = get_property("banishedPhyla").split_string(":")[1].to_phylum();
            
        if (RWB_monster.phylum == eaglePhylumBanished) {
            description.listAppend(HTMLGenerateSpanFont("<b>WARNING!</b> This monster will not appear, it's banished by your eagle screech!", "red"));
        } 

        entry.subentries.listAppend(ChecklistSubentryMake("Fight " + pluralise(fights_left, "more " + RWB_monster, "more " + RWB_monster + "s"), "", description)); 

        if (fights_left > 0 && possible_appearance_locations.count() > 0)
            optional_task_entries.listAppend(entry);
    }
}
	
RegisterResourceGenerationFunction("IOTMPatrioticEagleGenerateResource");
void IOTMPatrioticEagleGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (!lookupFamiliar("Patriotic Eagle").familiar_is_usable()) return;
    
    phylum eaglePhylumBanished = $phylum[none];

    if (get_property("banishedPhyla") != "")
        eaglePhylumBanished = get_property("banishedPhyla").split_string(":")[1].to_phylum();
            
	int screechRecharge = get_property_int("screechCombats");
	
    string title;
    string [int] description;
    
    if (screechRecharge > 0) {
        title = (screechRecharge + " combats (or freeruns) until your Patriotic Eagle can screech again.");
    } else {
        title = "Patriotic Eagle can screech and banish an entire phylum!";
        description.listAppend(HTMLGenerateSpanFont("SCREEEE", "red") + HTMLGenerateSpanFont("EEEEE", "grey") + HTMLGenerateSpanFont("EEEEE!,", "blue"));
    }

    // Color the pledge zones by zone availability
    string [int] itemPledges;
    itemPledges.listAppend(HTMLGenerateFutureTextByLocationAvailability("Haunted Library", $location[the haunted library]));
    itemPledges.listAppend(HTMLGenerateFutureTextByLocationAvailability("Haunted Laundry Room", $location[the haunted laundry room]));
    itemPledges.listAppend(HTMLGenerateFutureTextByLocationAvailability("Whitey's Grove", $location[Whitey's Grove]));

    string [int] meatPledges;
    meatPledges.listAppend(HTMLGenerateFutureTextByLocationAvailability("Ninja Snowmen Lair", $location[Lair of the Ninja Snowmen]));
    meatPledges.listAppend(HTMLGenerateFutureTextByLocationAvailability("Hidden Hospital", $location[The Hidden Hospital]));
    meatPledges.listAppend(HTMLGenerateFutureTextByLocationAvailability("Haunted Bathroom", $location[The Haunted Bathroom]));
    meatPledges.listAppend(HTMLGenerateFutureTextByLocationAvailability("the Oasis", $location[the oasis]));

    string [int] initPledges;
    initPledges.listAppend(HTMLGenerateFutureTextByLocationAvailability("Haunted Kitchen", $location[the haunted kitchen]));
    initPledges.listAppend(HTMLGenerateFutureTextByLocationAvailability("Oil Peak", $location[oil peak]));
    initPledges.listAppend(HTMLGenerateFutureTextByLocationAvailability("Oliver's Tavern", $location[an unusually quiet barroom brawl]));
    
	if ($effect[Citizen of A Zone].have_effect() == 0) {
        description.listAppend(HTMLGenerateSpanFont("Pledge ", "red") + HTMLGenerateSpanFont("allegiance ", "grey") + HTMLGenerateSpanFont("to a zone!", "blue"));
        if (itemPledges.count() > 0) description.listAppend("|*"+HTMLGenerateSpanOfClass("+30% item: ", "r_bold") + itemPledges.listJoinComponents(", ", "or ") + ".");
        if (meatPledges.count() > 0) description.listAppend("|*"+HTMLGenerateSpanOfClass("+50% meat: ", "r_bold") + meatPledges.listJoinComponents(", ", "or ") + ".");
        if (initPledges.count() > 0) description.listAppend("|*"+HTMLGenerateSpanOfClass("+100% init: ", "r_bold") + initPledges.listJoinComponents(", ", "or ") + ".");
	}

    // Making option frames for the phylums you want to banish, with if statements that should remove them 
    //   when you have completed the task. Additionally, the location availability should ensure these show 
    //   in gray if you cannot access the zone.
	
    string [int] dudeOptions;
    if ( __quest_state["Level 11"].mafia_internal_step < 2)
        dudeOptions.listAppend(HTMLGenerateFutureTextByLocationAvailability("Black Forest (2/5)", $location[The Black Forest]));
    if (__quest_state["Level 9"].state_int["twin peak progress"] < 15) 
        dudeOptions.listAppend(HTMLGenerateFutureTextByLocationAvailability("Twin Peak (5/8)", $location[Twin Peak]));
    if (!__quest_state["Level 11 Palindome"].state_boolean["dr. awkward's office unlocked"]) 
        dudeOptions.listAppend(HTMLGenerateFutureTextByLocationAvailability("Whitey's Grove (1/4)", $location[Whitey's Grove]));

    string [int] beastOptions;
    if (__quest_state["Level 11 Hidden City"].state_boolean["need machete for liana"])
        beastOptions.listAppend(HTMLGenerateFutureTextByLocationAvailability("Hidden Park (1/4)", $location[The Hidden Park]));
    if (!__quest_state["Level 11 Palindome"].state_boolean["dr. awkward's office unlocked"]) 
        beastOptions.listAppend(HTMLGenerateFutureTextByLocationAvailability("Palindome (3/7)", $location[Inside the Palindome]));
    if (!$location[The Castle in the Clouds in the Sky (Basement)].locationAvailable())
        beastOptions.listAppend(HTMLGenerateFutureTextByLocationAvailability("Airship (2/7)", $location[The Penultimate Fantasy Airship]));

    string [int] constructOptions;
    if (!__quest_state["Level 11 Palindome"].state_boolean["dr. awkward's office unlocked"]) 
        constructOptions.listAppend(HTMLGenerateFutureTextByLocationAvailability("Whitey's Grove (1/4)", $location[Whitey's Grove]));
    if (!$location[The Haunted Library].locationAvailable()) 
        constructOptions.listAppend(HTMLGenerateFutureTextByLocationAvailability("Billiards Room (1/2)", $location[The Haunted Billiards Room]));
    if (!$location[The Castle in the Clouds in the Sky (Basement)].locationAvailable())
        beastOptions.listAppend(HTMLGenerateFutureTextByLocationAvailability("Airship (1/7)", $location[The Penultimate Fantasy Airship]));

    string [int] undeadOptions;
    if (!$location[The Haunted Bathroom].locationAvailable()) 
        undeadOptions.listAppend(HTMLGenerateFutureTextByLocationAvailability("Haunted Library (1/3)", $location[The Haunted Library]));
    if (__quest_state["Level 11 Ron"].mafia_internal_step <= 4)
        undeadOptions.listAppend(HTMLGenerateFutureTextByLocationAvailability("Red Zeppelin (1/5)", $location[The Red Zeppelin]));
    if (__quest_state["Level 11 Manor"].mafia_internal_step < 3)
        undeadOptions.listAppend(HTMLGenerateFutureTextByLocationAvailability("Haunted Wine Cellar (1/3)", $location[The Haunted Wine Cellar]));
    if (__quest_state["Level 11 Manor"].mafia_internal_step < 3)
        undeadOptions.listAppend(HTMLGenerateFutureTextByLocationAvailability("Haunted Boiler (1/3)", $location[The Haunted Boiler Room]));
    if (!__quest_state["Level 11 Pyramid"].finished)
        undeadOptions.listAppend(HTMLGenerateFutureTextByLocationAvailability("Pyramid Middle (1/3)", $location[The Middle Chamber]));
    

    string [int] options;
	{
        if (dudeOptions.count() > 0) options.listAppend(HTMLGenerateSpanOfClass("Dude: ", "r_bold") + dudeOptions.listJoinComponents(", ")); 
        if (beastOptions.count() > 0) options.listAppend(HTMLGenerateSpanOfClass("Beast: ", "r_bold") + beastOptions.listJoinComponents(", "));
        if (constructOptions.count() > 0) options.listAppend(HTMLGenerateSpanOfClass("Construct: ", "r_bold") + constructOptions.listJoinComponents(", "));
        if (undeadOptions.count() > 0) options.listAppend(HTMLGenerateSpanOfClass("Undead: ", "r_bold") + undeadOptions.listJoinComponents(", "));
    }
    if (options.count() > 0)
        description.listAppend("Screech these phylums away to banish a fraction of monsters from a relevant zone:" + options.listJoinComponents("<hr>").HTMLGenerateIndentedText());
    
    resource_entries.listAppend(ChecklistEntryMake("__familiar Patriotic Eagle", "familiar.php", ChecklistSubentryMake(title, description), 8).ChecklistEntrySetIDTag("Patriotic Eagle familiar resource"));
}