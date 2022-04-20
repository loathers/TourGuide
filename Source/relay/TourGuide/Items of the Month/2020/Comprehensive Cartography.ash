RegisterTaskGenerationFunction("IOTMComprehensiveCartographyGenerateTasks");
void IOTMComprehensiveCartographyGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if (!lookupSkill("Map the Monsters").have_skill()) return;
    if (get_property_boolean("mappingMonsters")) {
        task_entries.listAppend(ChecklistEntryMake("__skill Map the Monsters", "", ChecklistSubentryMake("Mapping the Monsters now!", "", "Fight a chosen monster in the next zone."), -11).ChecklistEntrySetIDTag("Cartography skill map now"));
    }
}

//experimental cartography code
RegisterResourceGenerationFunction("IOTMCartographyMapsGenerateResource");
void IOTMCartographyMapsGenerateResource(ChecklistEntry [int] resource_entries)
{
	if (!(__misc_state["in run"] && in_ronin())) return;
    
    int maps_left = clampi(3 - get_property_int("_monstersMapped"), 0, 3);
    if (maps_left > 0 && my_path_id() != PATH_POCKET_FAMILIARS)
	{
		string [int] description;
        description.listAppend("Map the monsters you want to fight!");
		description.listAppend("This IotM also gives you a special noncom in the following zones:");
		string [int] options;
			if (!__quest_state["cc_spookyravennecklace"].finished)
				{
					options.listAppend("The Haunted Billiards Room");
				}
			if (!__quest_state["cc_friars"].finished)
				{
					options.listAppend("The Dark Neck of the Woods");
				}
			if (get_property_int("cyrptNookEvilness") > 25)
				{
					options.listAppend("The Defiled Nook");
				}
			if (get_property_int("twinPeakProgress") != 15)
				{
					options.listAppend(HTMLGenerateSpanOfClass("First adv", "r_bold") + " A-Boo Peak: gives Twin Peak noncom");
				}
			if (!__quest_state["cc_castletop"].finished)
				{
					options.listAppend("Castle Top Floor");
				}
			if (!__quest_state["warProgress"].started)
				{
					options.listAppend("The Hippy Camp (Verge of War)");
				}			
		string [int] monsterMaps;
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
			if ($location[The Battlefield (Frat Uniform)].turns_spent < 100)
            {
                monsterMaps.listAppend("Green Ops Soldier. Combine with Olfaction/Use the Force and Spit and Explodinal pills.");
            }
		
		if (options.count() > 0)
            description.listAppend("Noncoms of interest:|*-" + options.listJoinComponents("|*-"));
		if (monsterMaps.count() > 0)
            description.listAppend("Monsters to map:|*-" + monsterMaps.listJoinComponents("|*-"));
        
        resource_entries.listAppend(ChecklistEntryMake("__item Comprehensive Cartographic Compendium", "", ChecklistSubentryMake(pluralise(maps_left, "Cartography skill use", "Cartography skill uses"), "", description), 5).ChecklistEntrySetIDTag("Cartography skills resource"));
    }
}
