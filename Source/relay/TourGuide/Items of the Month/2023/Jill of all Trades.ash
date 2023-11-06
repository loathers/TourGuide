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
    float estimatedMapProbability = 35 * (0.05 ** min(maps_dropped, 3)); // confirmed by cannonfire to stop decreasing after 3rd time

    // Convert to turns
    float turnsToMap = clampf(1/(estimatedMapProbability/100),0,1);

    string [int] description;
    if (mapsDropped == 0) {
        description.listAppend("You haven't gotten a map to halloween town yet! Try using your Jill for a map at ~"+round(estimatedMapProbability)+"% chance, or approximately "+round(turnsToMap,1)+" turns.");
    }
    else {
        description.listAppend("You have a map; the next map is at a ~"+round(estimatedMapProbability)+"% chance, or approximately "+round(turnsToMap,1)+" turns.");
    }
    
	int habitatRecallsLeft = clampi(3 - get_property_int("_monsterHabitatsRecalled"), 0, 3);
    if (!lookupSkill("Just the Facts").have_skill() && !__iotms_usable[$item[book of facts (dog-eared)]]) habitatRecallsLeft = 0;
    if (habitatRecallsLeft > 0)
		description.listAppend("Halloween monsters make excellent targets for <b>Recall Habitat</b> from BoFA.");

    if (!get_property_boolean("ledCandleDropped")) {
        description.listAppend("Fight a dude for an LED candle, to tune your Jill!");
    }
	
    resource_entries.listAppend(ChecklistEntryMake("__familiar jill-of-all-trades", url, ChecklistSubentryMake("Celebrating the Jillenium", "", description)).ChecklistEntrySetIDTag("Jill of All Trades tile"));
}
