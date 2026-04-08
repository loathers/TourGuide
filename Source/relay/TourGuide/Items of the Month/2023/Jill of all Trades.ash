RegisterTaskGenerationFunction("IOTMJillMapGenerateTask");
void IOTMJillMapGenerateTask(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries) {

    boolean mapAvailable = ($item[map to a candy-rich block].available_amount() > 0);

    // Don't generate a tile if the user doesn't have a map.
    if (!mapAvailable) return;

    boolean usedMap = get_property_boolean("_mapToACandyRichBlockUsed");	

    // Populate a free fights count of trick-or-treat fights.
	string trickOrTreatMap = get_property("_trickOrTreatBlock");
	string[int] splitToT = split_string(trickOrTreatMap, "");

    int fightsParsed;

	foreach house in splitToT {
		if (splitToT[house] == "D") {fightsParsed +=1;}
		if (splitToT[house] == "d") {fightsParsed +=1;}
	}

    string [int] description;
    string url = "inventory.php?ftext=candy-rich";
    string main_title = "Use your Map to a Candy-Rich Block.";  

    // Do not generate the tile if the user has access to trick-or-treat zones because it's Halloween
    if (getHolidaysToday()["Halloween"]) return;

    // Do not generate the tile if the user has access to trick-or-treat zones and has visited it
    if (fightsParsed > 0 && usedMap) return;

    // Still generate it even if they've used the map because mafia needs one T&T visit to generate the pref for the freefight tile
    if (fightsParsed == 0 && usedMap) {
        main_title = "Visit your Trick-or-Treat block!";
        string url = "place.php?whichplace=town&action=town_trickortreat";
        description.listAppend("Might have a star house... 👀");
    }

    if (fightsParsed == 0 && !usedMap) {
        description.listAppend("Use your map for five free fights & some candy!");
    }

    optional_task_entries.listAppend(ChecklistEntryMake("__item plastic pumpkin bucket", url, ChecklistSubentryMake(main_title, "", description), 7).ChecklistEntrySetIDTag("map to a candy-rich block"));
    

}

// TILE SPEC: 
//    - Remind the user to get a halloween map. 
//    - Remind the user to get an LED candle.
//    - Recommend halloween monsters for habitation.

RegisterResourceGenerationFunction("IOTMJillv2GenerateResource");
void IOTMJillv2GenerateResource(ChecklistEntry [int] resource_entries)
{
    familiar bigJillyStyle = lookupFamiliar("Jill-of-All-Trades");
	if (!bigJillyStyle.familiar_is_usable()) return;

	int mapsDropped = get_property_int("_mapToACandyRichBlockDrops");
	
	string url = "familiar.php";
	if (bigJillyStyle == my_familiar())
		url = "";
  
    // Initial chance is 35% with a masssive dropoff (multiply by 5% per map dropped)
    float estimatedMapProbability = 35 * (0.05 ** clampi(mapsDropped, 0, 3)); // confirmed by cannonfire to stop decreasing after 3rd time

    // Convert to turns
    float turnsToMap = 1/(estimatedMapProbability/100);

    string [int] description;
    if (mapsDropped == 0) {
        description.listAppend("You haven't gotten a map to halloween town yet! Try using your Jill for a map at ~"+round(estimatedMapProbability)+"% chance, or approximately "+round(turnsToMap,1)+" turns.");
    }
    else if (mapsDropped < 2) { // The third map drop chance is less than 1 in a thousand - not something that is particularly useful to hunt for
        description.listAppend("You already got a map; the next map is at a ~"+round(estimatedMapProbability)+"% chance, or approximately "+round(turnsToMap,1)+" turns.");
    }
    
	int habitatRecallsLeft = clampi(3 - get_property_int("_monsterHabitatsRecalled"), 0, 3);
    if (!lookupSkill("Just the Facts").have_skill() && !__iotms_usable[$item[book of facts (dog-eared)]]) habitatRecallsLeft = 0;
    if (habitatRecallsLeft > 0)
		description.listAppend("Halloween monsters make excellent targets for <b>Recall Habitat</b> from BoFA.");

    // Adding a small exception here to not generate this if they weirdly acquired LED through other means (like casual or a pull or something)
    if (!get_property_boolean("ledCandleDropped") && $item[LED Candle].item_amount() < 1) {
        description.listAppend("Fight a dude for an LED candle, to tune your Jill!");
    }

    // Populate a free fights count of trick-or-treat fights.
	string trickOrTreatMap = get_property("_trickOrTreatBlock");
	string[int] splitToT = split_string(trickOrTreatMap, "");
    int freeFightsLeft;

	foreach house in splitToT {
		if (splitToT[house] == "D") {freeFightsLeft +=1;}
	}

    if (freeFightsLeft > 0) {resource_entries.listAppend(ChecklistEntryMake("__familiar jill-of-all-trades", "place.php?whichplace=town&action=town_trickortreat", ChecklistSubentryMake(pluralise(freeFightsLeft, "Trick or Treat fight", "Trick or Treat fights"), "", "Equip an outfit and mess with some halloweenies."), 0).ChecklistEntrySetCombinationTag("daily free fight").ChecklistEntrySetIDTag("trick or treat free fights"));}

    // If we have nothing to say, do not display the tile
    if (count(description) == 0) return;
	
    resource_entries.listAppend(ChecklistEntryMake("__familiar jill-of-all-trades", url, ChecklistSubentryMake("Celebrating the Jillenium", "", description)).ChecklistEntrySetIDTag("Jill of All Trades tile"));
}
