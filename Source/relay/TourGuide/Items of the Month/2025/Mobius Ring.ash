// mobius ring
RegisterTaskGenerationFunction("IOTMMobiusRingGenerateTasks");
void IOTMMobiusRingGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    item mobRing = $item[möbius ring];
    if (mobRing.available_amount() == 0) return;

    // Native game prefs. Wish there was a Paradoxicity one...
    int lastMobiusTurn = get_property_int("_lastMobiusStripTurn");
    int countMobiusNCs = get_property_int("_mobiusStripEncounters");
    int countTimeCops = get_property_int("_timeCopsFoughtToday");

    // Is it equipped?
    boolean mobEquipped = mobRing.equipped_amount() == 1;

    // There are clearly better ways to do this, but I'm tired and this 
    //   is "fine." After 17 NCs, they'll all be 76 turns between, so cap 
    //   inputs to 17.
    int [int] turnsBetweenNCs = listMake(4,7,13,19,25,31,41,41,41,41,41,51,51,51,51,51,76);
    int turnsSinceLastNC = total_turns_played() - lastMobiusTurn;
    int turnsUntilNextNC = max(0, turnsBetweenNCs[min(17, countMobiusNCs + 1)] - turnsSinceLastNC);
    int turnsUntilNextNextNC = max(0, turnsBetweenNCs[min(17, countMobiusNCs + 2)] - turnsSinceLastNC);

    // This is sort of a dumb way to do this too, but alas. Also incorrect,
    //   as we don't have paradoxicity in mafia yet...
    int [int] timeCopRate = listMake(2,2,2,2,2,4,4,4,4,4,8,8,8,8,8,16,16,16,16,16,32);
    int assumedTimeCopRate = timeCopRate[min(countMobiusNCs + 1, 21)];

    // First, a generic time cop counter task. Low priority if you have 
    //   freebies left, high priority if you don't.
	string url = "inventory.php?ftext=bius+ring";
	string [int] copDescription;
	string copTitle = HTMLGenerateSpanFont(pluralise(min(11-countTimeCops, 0), "free Time Cop fight", "free Time Cop fights"), "black");
    boolean copsNoLongerFree = countTimeCops > 11;
    int priority = 10;

	if (mobEquipped) {
		if (!copsNoLongerFree) copDescription.listAppend(HTMLGenerateSpanFont("Ring equipped, it's Möbing time!", "blue"));
		if (copsNoLongerFree) 
		{
			copDescription.listAppend(HTMLGenerateSpanFont("Möbius ring equipped, danger!", "red"));
            priority = -11;
		}
		task_entries.listAppend(ChecklistEntryMake("__monster time cop", "", ChecklistSubentryMake(copTitle, copDescription), priority).ChecklistEntrySetIDTag("morb ring cop task"));
	}

    // Next, a supernag if you happen to have an NC available.
    string [int] ncDescription;
    string ncTitle = "Möbius non-combat available!";

    if (mobEquipped) ncDescription.listAppend("Keep your Möbius ring equipped for a shot at a Paradoxicity NC!");
    if (!mobEquipped) ncDescription.listAppend(HTMLGenerateSpanFont("Equip your Möbius ring for a shot at a Paradoxicity NC!", "red"));
	
    task_entries.listAppend(ChecklistEntryMake("__item möbius ring", "", ChecklistSubentryMake(ncTitle, ncDescription), -11).ChecklistEntrySetIDTag("morb ring nc task"));

}

RegisterResourceGenerationFunction("IOTMMobiusRingGenerateResource");
void IOTMMobiusRingGenerateResource(ChecklistEntry [int] resource_entries)
{
    item mobRing = $item[möbius ring];
    if (mobRing.available_amount() == 0) return;

    // Native game prefs. Wish there was a Paradoxicity one...
    int lastMobiusTurn = get_property_int("_lastMobiusStripTurn");
    int countMobiusNCs = get_property_int("_mobiusStripEncounters");
    int countTimeCops = get_property_int("_timeCopsFoughtToday");

    // There are clearly better ways to do this, but I'm tired and this 
    //   is "fine." After 17 NCs, they'll all be 76 turns between, so cap 
    //   inputs to 17.
    int [int] turnsBetweenNCs = listMake(4,7,13,19,25,31,41,41,41,41,41,51,51,51,51,51,76);
    int turnsSinceLastNC = total_turns_played() - lastMobiusTurn;
    int turnsUntilNextNC = max(0, turnsBetweenNCs[min(17, countMobiusNCs + 1)] - turnsSinceLastNC);
    int turnsUntilNextNextNC = max(0, turnsBetweenNCs[min(17, countMobiusNCs + 2)] - turnsSinceLastNC);

    // This is sort of a dumb way to do this too, but alas. Also incorrect, as
    //   we don't have paradoxicity in mafia yet...
    int [int] timeCopRate = listMake(2,2,2,2,2,4,4,4,4,4,8,8,8,8,8,16,16,16,16,16,32);
    int assumedTimeCopRate = timeCopRate[min(countMobiusNCs + 1, 21)];
	
	string [int] description;
    string url = "inventory.php?ftext=bius+ring";
	string title = HTMLGenerateSpanFont(pluralise(turnsUntilNextNC, " turn", " turns") + " to your next Möbius NC", "black");
	 
	description.listAppend("You have encountered " + countMobiusNCs +" NCs so far today.");
        description.listAppend("|*You have "+pluralise(turnsUntilNextNC, " turn", " turns")+" turns to the next NC, and at least"+pluralise(turnsUntilNextNextNC, " turn", " turns")+" until the NC after that.");
	description.listAppend("You have encountered " + countTimeCops +" time cops so far today.");
	    if(countTimeCops < 11) description.listAppend(pluralise(min(11-countTimeCops,0),"free time cop remains."," free time cops remain."));
	    if(countTimeCops > 11) description.listAppend(HTMLGenerateSpanFont("No free time cops remain; be careful wearing your ring!", "red"));
		description.listAppend("|*If every NC today raised Paradoxicity, you have at minimum a " + assumedTimeCopRate + "% chance of encountering a time cop on any given adventure with the mobius ring equipped. Increase Paradoxicity to gradually increase that rate!");
    description.listAppend("Try to get to 13 Paradoxicity for +100% item & +50% booze drop on your ring!");
	resource_entries.listAppend(ChecklistEntryMake("__item möbius ring", url, ChecklistSubentryMake(title, "", description), 0));
}