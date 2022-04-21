//Cold Medicine Cabinet
RegisterTaskGenerationFunction("IOTMColdMedicineCabinetGenerateTasks");
void IOTMColdMedicineCabinetGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	monster gregarious_monster = get_property_monster("beGregariousMonster");
	int fights_left = clampi(get_property_int("beGregariousFightsLeft"), 0, 3);
	string [int] description;
	
	if (gregarious_monster != $monster[none] && fights_left > 0) 
	{
		description.listAppend("Neaaaar, faaaaaaar, wherever you aaaaaaaare, I believe that the heart does go on.");
		description.listAppend("Will appear in any zone, so try to find a zone with few monsters.");
		optional_task_entries.listAppend(ChecklistEntryMake("__monster " + gregarious_monster, "url", ChecklistSubentryMake("Fight " + pluralise(fights_left, "more gregarious " + gregarious_monster, "more gregarious " + gregarious_monster + "s"), "", description), -1));
	}
	if (!__iotms_usable[lookupItem("cold medicine cabinet")])
		return;

	int CMC_consults = clampi(5 - get_property_int("_coldMedicineConsults"), 0, 5);
	if (CMC_consults > 0) 
	{
		int next_CMC_Turn = get_property_int("_nextColdMedicineConsult");
		string [int] description;
		string url = "campground.php?action=workshed";
			
		if (next_CMC_Turn -1 == total_turns_played())
		{
			description.listAppend(HTMLGenerateSpanFont("Consultation ready next turn!", "blue"));
			description.listAppend("You have " + CMC_consults + " consultations remaining.");
			optional_task_entries.listAppend(ChecklistEntryMake("__item snow suit", url, ChecklistSubentryMake("The cold medicine cabinet is almost in session", "", description), -11));
		}
		else if (next_CMC_Turn <= total_turns_played())
		{
			description.listAppend(HTMLGenerateSpanFont("Just what the doctor ordered!", "blue"));
			description.listAppend("You have " + CMC_consults + " consultations remaining.");
			optional_task_entries.listAppend(ChecklistEntryMake("__item snow suit", url, ChecklistSubentryMake("The cold medicine cabinet is in session", "", description), -11));
		}
	}
}

RegisterResourceGenerationFunction("IOTMColdMedicineCabinetGenerateResource");
void IOTMColdMedicineCabinetGenerateResource(ChecklistEntry [int] resource_entries)
{
	//gregariousness
	int uses_remaining = get_property_int("beGregariousCharges");
	if (uses_remaining > 0) 
	{
		//The section that will be sent as a stand-alone resource
		string url;
		string [int] description;
		description.listAppend("Be gregarious in combat, which lets you turn foe into friend!");
		string [int] gregfriends;
		gregfriends.listAppend("eldritch tentacle");
		gregfriends.listAppend("lobsterfrogman");
		gregfriends.listAppend("lynyrd");
		gregfriends.listAppend("dense liana");
		gregfriends.listAppend("drunk pygmy");
		gregfriends.listAppend("war monster");
		gregfriends.listAppend("[degenerate aftercore farming target]");
		
		description.listAppend("Potentially good friendships:|*" + gregfriends.listJoinComponents("|*"));
		resource_entries.listAppend(ChecklistEntryMake("__effect Good Karma", url, ChecklistSubentryMake(uses_remaining.pluralise("gregarious handshake", "gregarious handshakes"), "", description)).ChecklistEntrySetIDTag("gregarious wanderer resource")); 
	}
	
	//breathitin
	int breaths_remaining = get_property_int("breathitinCharges");
	if (breaths_remaining > 0) 
	{
		string [int] description;
		description.listAppend("Outdoor fights become free.");
		resource_entries.listAppend(ChecklistEntryMake("__item beefy pill", "", ChecklistSubentryMake(pluralise(breaths_remaining, "breathitin breath", "breathitin breaths"), "", description), -2));
	}
	//homebodyl
	int homebodyls_remaining = get_property_int("homebodylCharges");
	if (homebodyls_remaining > 0) 
	{
		string [int] description;
		description.listAppend("Free crafting.");
		description.listAppend("Lynyrd equipment, potions, and more.");
		resource_entries.listAppend(ChecklistEntryMake("__item excitement pill", "", ChecklistSubentryMake(pluralise(homebodyls_remaining, "homebodyl free craft", "homebodyl free crafts"), "", description)));
	}
	
	//consultation counter
	if (!__iotms_usable[lookupItem("cold medicine cabinet")])
		return;
	int CMC_consults = clampi(5 - get_property_int("_coldMedicineConsults"), 0, 5);
	if (CMC_consults > 0) 
	{
		int next_CMC_Turn = get_property_int("_nextColdMedicineConsult");
		int next_CMC_Timer = (next_CMC_Turn - total_turns_played());
		string [int] description;
		string url = "campground.php?action=workshed";
			
		if (next_CMC_Turn > total_turns_played())
		{
			description.listAppend("" + HTMLGenerateSpanOfClass(next_CMC_Timer, "r_bold") + " adventures until your next consultation.");
			description.listAppend(HTMLGenerateSpanFont("Diagnosis: dickstabbing", "blue"));
			description.listAppend("Do 11+ combats in underground zones for 5 free kills.");
			description.listAppend("Do 11+ combats in indoor zones for a wanderer.");
			description.listAppend("Do 11+ combats in outdoor zones for 11 free crafts.");
			resource_entries.listAppend(ChecklistEntryMake("__item snow suit", url, ChecklistSubentryMake(CMC_consults.pluralise("Cold medicine cabinet consultation", "Cold medicine cabinet consultations" + " remaining"), "", description)).ChecklistEntrySetIDTag("cold medicine cabinet resource")); 
		}	
	}
}