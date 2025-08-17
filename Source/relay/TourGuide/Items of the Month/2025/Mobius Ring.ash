// mobius ring
RegisterTaskGenerationFunction("IOTMMobiusRingGenerateTasks");
void IOTMMobiusRingGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    item mobRing = $item[M&ouml;bius ring];
    if (mobRing.available_amount() == 0) return;

    // Native game prefs. Note that my_paradoxicity() also exists!
    int lastMobiusTurn = get_property_int("_lastMobiusStripTurn");
    int countMobiusNCs = get_property_int("_mobiusStripEncounters");
    int countTimeCops = get_property_int("_timeCopsFoughtToday");

    // Is it equipped?
    boolean mobEquipped = mobRing.equipped_amount() == 1;

    // There are clearly better ways to do this, but I'm tired and this 
    //   is "fine." After 17 NCs, they'll all be 76 turns between, so cap 
    //   inputs to 17.
    
    int [int] turnsBetweenNCs = {1:4, 2:7, 3:13, 4:19, 5:25, 6:31, 7:41, 8:41, 9:41, 10:41, 11:41, 12:51, 13:51, 14:51, 15:51, 16:51, 17:76};
    int turnsSinceLastNC = total_turns_played() - lastMobiusTurn;
    int turnsUntilNextNC = max(0, turnsBetweenNCs[min(17, countMobiusNCs + 1)] - (lastMobiusTurn == 0 ? my_turncount() : turnsSinceLastNC));
    int turnsUntilNextNextNC = max(0, turnsBetweenNCs[min(17, countMobiusNCs + 2)] + turnsUntilNextNC);

    // This is sort of a dumb way to do this too, but alas.
    int [int] timeCopRate = {
        0:2, 1:2, 2:2, 3:2, 4:2, 
        5:4, 6:4, 7:4, 8:4, 9:4, 
        10:8, 11:8, 12:8, 13:8, 14:8,
        15:16, 16:16, 17:16, 18:16, 19:19,
        20:32};
    int currentTimeCopRate = timeCopRate[min(my_paradoxicity(), 20)];

    // First, a generic time cop counter task. Low priority if you have 
    //   freebies left, high priority if you don't.
	string url = "inventory.php?ftext=bius+ring";
	string [int] copDescription;
    string copSubTitle = "Forecast is "+currentTimeCopRate+"% chance of cops";
	string copTitle = HTMLGenerateSpanFont(pluralise(min(11-countTimeCops, 0), "free Time Cops fought today", "free Time Cops fought today"), "black");
    boolean copsNoLongerFree = countTimeCops > 11;
    int priority = 10;

	if (mobEquipped) {
		if (!copsNoLongerFree) {
            copDescription.listAppend(HTMLGenerateSpanFont("Ring equipped, it's Möbing time!", "blue"));
            optional_task_entries.listAppend(ChecklistEntryMake("__monster time cop", "", ChecklistSubentryMake(copTitle, copSubtitle, copDescription), priority).ChecklistEntrySetIDTag("morb ring cop task"));
        }
		if (copsNoLongerFree) 
		{
			copDescription.listAppend(HTMLGenerateSpanFont("Möbius ring equipped, danger!", "red"));
            priority = -11;
            task_entries.listAppend(ChecklistEntryMake("__monster time cop", "", ChecklistSubentryMake(copTitle, copSubtitle, copDescription), priority).ChecklistEntrySetIDTag("morb ring cop task"));
		}
	}

    // Next, a supernag if you happen to have an NC available. (Demote from
    //   a supernag if you already have 11 free cops fought, though.)
    string [int] ncDescription;
    string ncTitle = "Möbius non-combat available!";
    string ncSubtitle = "Currently @ " + my_paradoxicity() + " paradoxicity";
    int ncPriority = copsNoLongerFree ? 0 : -11;

    if (mobEquipped) ncDescription.listAppend("Keep your Möbius ring equipped for an NC");
    if (!mobEquipped) ncDescription.listAppend(HTMLGenerateSpanFont("Equip your Möbius ring for a shot at a Paradoxicity NC!", "red"));
	
    if(turnsUntilNextNC == 0) task_entries.listAppend(ChecklistEntryMake("__item M&ouml;bius ring", "", ChecklistSubentryMake(ncTitle, ncSubtitle, ncDescription), ncPriority).ChecklistEntrySetIDTag("morb ring nc task"));

}

RegisterResourceGenerationFunction("IOTMMobiusRingGenerateResource");
void IOTMMobiusRingGenerateResource(ChecklistEntry [int] resource_entries)
{
    item mobRing = $item[M&ouml;bius ring];
    if (mobRing.available_amount() == 0) return;

    // Native game prefs. Note that my_paradoxicity() also exists!
    int lastMobiusTurn = get_property_int("_lastMobiusStripTurn");
    int countMobiusNCs = get_property_int("_mobiusStripEncounters");
    int countTimeCops = get_property_int("_timeCopsFoughtToday");

    // Is it equipped?
    boolean mobEquipped = mobRing.equipped_amount() == 1;

    // There are clearly better ways to do this, but I'm tired and this 
    //   is "fine." After 17 NCs, they'll all be 76 turns between, so cap 
    //   inputs to 17.
    
    int [int] turnsBetweenNCs = {1:4, 2:7, 3:13, 4:19, 5:25, 6:31, 7:41, 8:41, 9:41, 10:41, 11:41, 12:51, 13:51, 14:51, 15:51, 16:51, 17:76};
    int turnsSinceLastNC = total_turns_played() - lastMobiusTurn;
    int turnsUntilNextNC = max(0, turnsBetweenNCs[min(17, countMobiusNCs + 1)] - (lastMobiusTurn == 0 ? my_turncount() : turnsSinceLastNC));
    int turnsUntilNextNextNC = max(0, turnsBetweenNCs[min(17, countMobiusNCs + 2)] + turnsUntilNextNC);

    // This is sort of a dumb way to do this too, but alas.
    int [int] timeCopRate = {
        0:2, 1:2, 2:2, 3:2, 4:2, 
        5:4, 6:4, 7:4, 8:4, 9:4, 
        10:8, 11:8, 12:8, 13:8, 14:8,
        15:16, 16:16, 17:16, 18:16, 19:19,
        20:32};
    int currentTimeCopRate = timeCopRate[min(my_paradoxicity(), 20)];
	
	string [int] description;
    string url = "inventory.php?ftext=bius+ring";
	string title = HTMLGenerateSpanFont(pluralise(turnsUntilNextNC, " turn", " turns") + " to your next Möbius NC", "black");
	 
    if (turnsUntilNextNC == 0) description.listAppend(HTMLGenerateSpanFont("You can encounter NC #" + (countMobiusNCs+1) +" right now!", "blue"));
    if (turnsUntilNextNC > 0) description.listAppend("You have "+pluralise(turnsUntilNextNC, " turn", " turns")+" turns to NC #" +(countMobiusNCs+1)+ ".");
        description.listAppend("|*You have at least "+pluralise(turnsUntilNextNextNC, " turn", " turns")+" until NC #"+(countMobiusNCs+2)+".");
	description.listAppend("" + countTimeCops +"/11 free time cops today. (currently @ "+currentTimeCopRate+"% rate)");
	    if(countTimeCops > 11) description.listAppend(HTMLGenerateSpanFont("No free time cops remain; be careful wearing your ring!", "red"));
    if(my_paradoxicity() < 13) description.listAppend("Boost to 13 Paradoxicity for +100% item & +50% booze drop!");
	resource_entries.listAppend(ChecklistEntryMake("__item M&ouml;bius ring", url, ChecklistSubentryMake(title, "", description), 0));
}