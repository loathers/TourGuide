record DelayTracker
{
    location zone;      // zone containing delay
    int delay;          // total amt of delay
    int delayRemaining; // amt of delay turns left
    boolean relevant;   // if currently relevant
    boolean accessible; // if zone accessible
};

DelayTracker makeDelayRecord(string l, boolean r) {
    DelayTracker final;

    final.zone = lookupLocation(l);
    final.delay = totalDelayForLocation(final.zone);
    final.delayRemaining = delayRemainingInLocation(final.zone);
    final.relevant = r;
    final.accessible = can_adventure(final.zone);

    return final;
}

void listAppend(DelayTracker [int] list, DelayTracker entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

// Populating all delay zones into a list
DelayTracker [int] delayZones;

delayZones.listAppend(makeDelayRecord("The Spooky Forest", !__quest_state["Level 2"].finished && !__quest_state["Hidden Temple Unlock"].finished));
delayZones.listAppend(makeDelayRecord("The Boss Bat's Lair", !__quest_state["Level 4"].finished)); 
delayZones.listAppend(makeDelayRecord("The Outskirts of Cobb's Knob", !__quest_state["Level 5"].finished));
delayZones.listAppend(makeDelayRecord("The Penultimate Fantasy Airship", !can_adventure($location[The Castle in the Clouds in the Sky (Basement)]))); // bat wing dependent
delayZones.listAppend(makeDelayRecord("The Castle in the Clouds in the Sky (Ground Floor)", !can_adventure($location[The Castle in the Clouds in the Sky (Top Floor)])));
delayZones.listAppend(makeDelayRecord("The Hidden Park", __quest_state["Level 11 Hidden City"].state_boolean["need machete for liana"]));
delayZones.listAppend(makeDelayRecord("The Hidden Apartment Building", get_property_int("hiddenApartmentProgress") < 7));
delayZones.listAppend(makeDelayRecord("The Hidden Office Building", get_property_int("hiddenOfficeProgress") < 7));
delayZones.listAppend(makeDelayRecord("The Haunted Gallery", get_property("questM21Dance") == "finished"));
delayZones.listAppend(makeDelayRecord("The Haunted Bathroom", get_property("questM21Dance") == "finished"));
delayZones.listAppend(makeDelayRecord("The Haunted Bedroom", get_property("questM21Dance") == "finished"));
delayZones.listAppend(makeDelayRecord("The Haunted Ballroom", !can_adventure($location[The Haunted Wine Cellar])));
// delayZones.listAppend(makeDelayRecord(5, "SHEN ZONE", true)); // TODO: needs custom
delayZones.listAppend(makeDelayRecord("The Copperhead Club", get_property("questL11Shen") == "finished"));
delayZones.listAppend(makeDelayRecord("The Upper Chamber", !can_adventure($location[The Middle Chamber])));
delayZones.listAppend(makeDelayRecord("The Middle Chamber", !can_adventure($location[The Lower Chambers])));

void QGenerateDelayRemainingTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    // This is a new brick as of mid-2026 that assesses remaining delay. I'm putting 
    //   this in as an unfinished brick that compiles all delay and puts it in a thing 
    //   for your speedrunning fun.

    ChecklistEntry entry;

    entry.url = "";
    entry.image_lookup_name = "__monster rushing bum";
    entry.tags.id = "Total delay remaining task";
    entry.importance_level = 10;

    int totalDelay = 0;
    int totalDelayRemaining = 0;
    string [int] description;
    string [int] delayTeaser;
    string [int] delayEntries;
    string color;

    foreach key, delayEntry in delayZones {
        location currLoc = delayEntry.zone;
        int currDelay = delayEntry.delay;
        int currDelayRemaining = delayEntry.delayRemaining;
        boolean currRelevant = delayEntry.relevant;
        boolean currAccessible = delayEntry.accessible;

        // fix airship delay in the event user has bat wings
        if ($item[bat wings].available_amount() > 0 && currLoc == $location[The Penultimate Fantasy Airship]) {
            currDelay = currDelay - 5;
            currDelayRemaining = max(currDelayRemaining - 5, 0);
        }

        // add totalDelay & totalDelayRemaining
        totalDelay += currDelay;
        totalDelayRemaining += currDelayRemaining;

        // only make an entry if there's delay left & it's still relevant
        if (currRelevant && currDelayRemaining > 0) {
            // gray out inaccessible entries
            color = currAccessible ? "black" : "gray";
            if (color == "black") entry.url = currLoc.getClickableURLForLocation();
            delayEntries.listAppend("|* • "+HTMLGenerateSpanFont("<b>" + currDelayRemaining + "</b> @ " + to_string(currLoc), color, "0.9em")+"");
            
        }
    }

    // Custom handling for active shen snake zone
    int shenDay = get_property_int("shenInitiationDay");
    int shenMeetings = __quest_state["Level 11 Shen"].state_int["Shen meetings"];
    location shenLocation = __shen_items_to_locations[get_property_item("shenQuestItem")];
    boolean onAnAssignment = __quest_state["Level 11 Shen"].state_boolean["on an assignment"];
    int remainingShenDelay = max((3-shenMeetings)*5,0); 

    if (onAnAssignment) {
        DelayTracker shenDelay = makeDelayRecord(to_string(shenLocation), true);

        if (shenDelay.delayRemaining > 0) {
            color = shenDelay.accessible ? "black" : "gray";
            if (color == "black") entry.url = currLoc.getClickableURLForLocation();
            delayEntries.listAppend("|* • "+HTMLGenerateSpanFont("<b>" + shenDelay.delayRemaining + "</b> @ " + to_string(shenLocation), color, "0.9em")+"");
        }
    }

    if (remainingShenDelay > 0) {
        string color = can_adventure(shenLocation) ? "black" : "gray";
        delayEntries.listAppend("|* • "+HTMLGenerateSpanFont("<b>" + remainingShenDelay + "</b> @ remaining Shen assignments", color, "0.9em")+"")
    }


    // no need to generate the tile if no delay is remaining
    if (delayEntries.count() == 0) return;

    description.listAppend("Use free runs and wanderers to avoid spending turns.");

    delayTeaser.listAppend(HTMLGenerateSpanOfClass("Mouse over for your delay zones!","r_bold r_element_spooky_desaturated"));

    string delayTitle = pluralise(totalDelayRemaining, "delay turn remains", "delay turns remain");

    // For the first run with it I'm just going to have the thing always available IDGAF
    //   (TODO: also for update, maybe leverage generatePossibleLocationsToBurnDelay() ?)

    
    // // Store the base description within the mouseover subentries, then the enumerated delay entries
    // entry.subentries_on_mouse_over.listAppend(ChecklistSubentryMake("Burn away your delay!", "", description));
    // entry.subentries_on_mouse_over.listAppend(ChecklistSubentryMake(delayTitle, "", delayEntries));
    // // Store the base description within the non-mouseover version of the tile
    // entry.subentries.listAppend(ChecklistSubentryMake("Burn away your delay!", "", description));
    // entry.subentries.listAppend(ChecklistSubentryMake(delayTitle, "", delayTeaser));

    entry.subentries.listAppend(ChecklistSubentryMake("Burn away your delay!", "", description));
    entry.subentries.listAppend(ChecklistSubentryMake(delayTitle, "", delayEntries));


    task_entries.listAppend(entry);
}