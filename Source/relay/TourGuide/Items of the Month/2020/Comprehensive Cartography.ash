//comprehensive cartography
RegisterTaskGenerationFunction("IOTMComprehensiveCartographyGenerateTasks");
void IOTMComprehensiveCartographyGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if (!lookupSkill("Comprehensive Cartography").have_skill()) return;
    if (get_property_boolean("mappingMonsters")) {
        task_entries.listAppend(ChecklistEntryMake("__skill Map the Monsters", "", ChecklistSubentryMake("Mapping the Monsters now!", "", "Fight a chosen monster in the next zone."), -11).ChecklistEntrySetIDTag("Cartography skill map now"));
    }
}

RegisterResourceGenerationFunction("IOTMComprehensiveCartographyGenerateResource");
void IOTMComprehensiveCartographyGenerateResource(ChecklistEntry [int] resource_entries)
{
	if (!lookupSkill("Comprehensive Cartography").have_skill())
	return;
	int maps_left = clampi(3 - get_property_int("_monstersMapped"), 0, 3);
    string [int] description;
	string [int] options;
	string [int] monsterMaps;
	if (maps_left > 0) 
	{
		description.listAppend("Map the monsters you want to fight!");
		
		if (__misc_state["in run"] && my_path().id != PATH_COMMUNITY_SERVICE)
		{
			//automatic carto NCs
			description.listAppend("This IotM also gives you a special noncom in the following zones:");
			int cartoAbooAscension = get_property_int("lastCartographyBooPeak");
			if (my_ascensions() > cartoAbooAscension) {
				options.listAppend(HTMLGenerateSpanOfClass("First adv", "r_bold") + " A-Boo Peak: free A-boo clue");
			}
			int cartoCastleAscension = get_property_int("lastCartographyCastleTop");
			if (my_ascensions() > cartoCastleAscension) {
				options.listAppend("Castle Top: finish quest");
			}
			int cartoDarkNeckAscension = get_property_int("lastCartographyDarkNeck");
			if (my_ascensions() > cartoDarkNeckAscension) {
				options.listAppend("The Dark Neck of the Woods: +2 progress");
			}
			int cartoNookAscension = get_property_int("lastCartographyDefiledNook");
			if (my_ascensions() > cartoNookAscension) {
				options.listAppend("The Defiled Nook: +2 Evil Eyes");
			}
			int cartoFratAscension = get_property_int("lastCartographyFratHouse");
			if (my_ascensions() > cartoFratAscension) {
				options.listAppend(HTMLGenerateSpanOfClass("First adv", "r_bold") + " Orcish Frat House: free garbage");
			}
			int cartoGuanoAscension = get_property_int("lastCartographyGuanoJunction");
			if (my_ascensions() > cartoGuanoAscension) {
				options.listAppend(HTMLGenerateSpanOfClass("First adv", "r_bold") + " Guano Junction: Screambat");
			}
			int cartoBilliardsAscension = get_property_int("lastCartographyHauntedBilliards");
			if (my_ascensions() > cartoBilliardsAscension) {
				options.listAppend("Haunted Billiards: play pool immediately");
			}
			int cartoProtestersAscension = get_property_int("lastCartographyZeppelinProtesters");
			if (my_ascensions() > cartoProtestersAscension) {
				options.listAppend("Mob of Zeppelin Protesters: pick any NC");
			}
			int cartoWarFratAscension = get_property_int("lastCartographyFratHouseVerge");
			if (my_ascensions() > cartoWarFratAscension) {
				options.listAppend("Wartime Frat House: pick any NC");
			}
			int cartoWarHippyAscension = get_property_int("lastCartographyHippyCampVerge");
			if (my_ascensions() > cartoWarHippyAscension) {
				options.listAppend("Wartime Hippy Camp: pick any NC");
			}	
			//monstermap options
			if (!__quest_state["Level 11 Ron"].finished)
			{
				monsterMaps.listAppend("Red Butler, 30% free kill item and 15% fun drop item. Combine with Olfaction/Use the Force?");
			}
			if (get_property_int("twinPeakProgress") < 15 && $item[rusty hedge trimmers].available_amount() < 4)
			{
				monsterMaps.listAppend("hedge beast, 15% quest progress item. Possibly Spit.");
			}
			if (__quest_state["Level 9"].state_int["a-boo peak hauntedness"] > 0)
			{
				monsterMaps.listAppend("Whatsian Commander Ghost, 15% free runaway item. Possibly Spit.");
			}
			if ($item[star chart].available_amount() < 1 || $item[richard's star key].available_amount() < 1)
			{
				monsterMaps.listAppend("Astronomer");
			}
			if (!__quest_state["Level 12"].state_boolean["Lighthouse Finished"] && $item[barrel of gunpowder].available_amount() < 5)
			{
				monsterMaps.listAppend("Lobsterfrogman, probably a weak option. Combine with Use the Force?");
			}
			if ($location[The Battlefield (Frat Uniform)].turns_spent > 20)
			{
				monsterMaps.listAppend("Green Ops Soldier. Combine with Olfaction/Use the Force and Spit and Explodinal pills.");
			}
			if (options.count() > 0)
				description.listAppend(HTMLGenerateSpanOfClass("Noncoms of interest:", "r_bold") + "|*-" + options.listJoinComponents("|*-"));
			if (monsterMaps.count() > 0)
				description.listAppend(HTMLGenerateSpanOfClass("Monsters to map:", "r_bold") + "|*-" + monsterMaps.listJoinComponents("|*-"));
		}
		resource_entries.listAppend(ChecklistEntryMake("__item Comprehensive Cartographic Compendium", "", ChecklistSubentryMake(pluralise(maps_left, "Cartography skill use", "Cartography skill uses"), "", description), 5).ChecklistEntrySetIDTag("Cartography skills resource"));
	}
}