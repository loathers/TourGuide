// TILE SPEC: 
//    - Remind the user to get a halloween map. 
//    - Remind the user to get an LED candle.
//    - Recommend halloween monsters for habitation.

// CANNOT DO YET:
//    - Add halloween fights to freebies combination tag; need better mafia tracking...

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
        description.listAppend("You have a map; the next map is at a ~"+round(estimatedMapProbability)+"% chance, or approximately "+round(turnsToMap,1)+" turns.");
    }
    
	int habitatRecallsLeft = clampi(3 - get_property_int("_monsterHabitatsRecalled"), 0, 3);
    if (!lookupSkill("Just the Facts").have_skill() && !__iotms_usable[$item[book of facts (dog-eared)]]) habitatRecallsLeft = 0;
    if (habitatRecallsLeft > 0)
		description.listAppend("Halloween monsters make excellent targets for <b>Recall Habitat</b> from BoFA.");

    // Adding a small exception here to not generate this if they weirdly acquired LED through other means (like casual or a pull or something)
    if (!get_property_boolean("ledCandleDropped") && $item[LED Candle].item_amount() < 1) {
        description.listAppend("Fight a dude for an LED candle, to tune your Jill!");
    }

    // If we have nothing to say, do not display the tile
    if (count(description) == 0) return;
	
    resource_entries.listAppend(ChecklistEntryMake("__familiar jill-of-all-trades", url, ChecklistSubentryMake("Celebrating the Jillenium", "", description)).ChecklistEntrySetIDTag("Jill of All Trades tile"));
}
