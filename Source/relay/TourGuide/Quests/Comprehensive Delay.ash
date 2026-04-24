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

    final.location = lookupLocation(l);
    final.delay = totalDelayForLocation(final.location);
    final.delayRemaining = delayRemainingInLocation(final.location);
    final.relevant = r;
    final.accessible = can_adventure(final.location);

    return final;
}

// Populating all delay zones into a list
DelayTrack [int] delayZones;

delayZones.listAppend(makeDelayRecord("The Spooky Forest", true));
delayZones.listAppend(makeDelayRecord("The Boss Bat's Lair", true)); 
delayZones.listAppend(makeDelayRecord("The Outskirts of Cobb's Knob", true));
delayZones.listAppend(makeDelayRecord("The Penultimate Fantasy Airship", true)); // bat wing dependent
delayZones.listAppend(makeDelayRecord("The Castle in the Clouds in the Sky (Ground Floor)", true));
delayZones.listAppend(makeDelayRecord("The Hidden Park", true));
delayZones.listAppend(makeDelayRecord("The Hidden Apartment Building", true));
delayZones.listAppend(makeDelayRecord("The Hidden Office Building", true));
delayZones.listAppend(makeDelayRecord("The Haunted Gallery", true));
delayZones.listAppend(makeDelayRecord("The Haunted Bathroom", true));
delayZones.listAppend(makeDelayRecord("The Haunted Bedroom", true));
delayZones.listAppend(makeDelayRecord("The Haunted Ballroom", true));
// delayZones.listAppend(makeDelayRecord(5, "SHEN ZONE", true)); // TODO: needs custom
delayZones.listAppend(makeDelayRecord("The Copperhead Club", true));
delayZones.listAppend(makeDelayRecord("The Upper Chamber", true));
delayZones.listAppend(makeDelayRecord("The Middle Chamber", true));

void QGenerateDelayRemainingTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    // This is a new brick as of mid-2026 that assesses remaining delay. I'm putting 
    //   this in as an unfinished brick that compiles all delay and puts it in a thing 
    //   for your speedrunning fun.

    ChecklistEntry entry;

    entry.url = "";
    entry.image_lookup_name = "__monster running man";
    entry.tags.id = "Total delay remaining task";
    entry.importance_level = 10;

    int totalDelay = 0;
    int totalDelayRemaining = 0;
    string [int] description;
    string [int] delayTeaser;
    string [int] delayEntries;
    string color;

    foreach key, delayEntry in delayZones {
        currLoc = delayEntry.location;
        currDelay = delayEntry.delay;
        currDelayRemaining = delayEntry.delayRemaining;
        currRelevant = delayEntry.relevant;
        currAccessible = delayEntry.accessible;

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
            delayEntries.listAppend(HTMLGenerateSpanFont("|* <b>" + currDelayRemaining + "</b> @ " + currLoc.name, color));
            entry.url = currLoc.getClickableURLForLocation();
        }
    }

    // no need to generate the tile if no delay is remaining
    if (delayEntries.count() == 0) return;

    description.listAppend("Eat up delay in these zones using wanderers, free runs, and free fights to advance your quests!");

    delayTeaser.listAppend(HTMLGenerateSpanOfClass("Mouse over for your delay zones!","r_bold r_element_spooky_desaturated"))

    string delayTitle = pluralise(totalDelayRemaining, "delay turn remains", "delay turns remain");

    // Store the base description within the mouseover subentries, then the enumerated delay entries
    entry.subentries_on_mouse_over.listAppend(ChecklistSubentryMake("Burn away your delay!", "", description));
    entry.subentries_on_mouse_over.listAppend(ChecklistSubentryMake(delayTitle, "", delayEntries));
    // Store the base description within the non-mouseover version of the tile
    entry.subentries.listAppend(ChecklistSubentryMake("Burn away your delay!", "", description));
    entry.subentries.listAppend(ChecklistSubentryMake(delayTitle, "", delayTeaser));

    task_entries.listAppend(entry);
}