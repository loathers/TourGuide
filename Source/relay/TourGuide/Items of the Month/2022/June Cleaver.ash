//June cleaver
RegisterTaskGenerationFunction("IOTMJuneCleaverGenerateTasks");
void IOTMJuneCleaverGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if (!lookupItem("June cleaver").have()) return;

    string url = "inventory.php?ftext=june+cleaver";
	string [int] description;
	string main_title = "June Cleaver dream ready!";
	
	int juneCleaverCharge = (get_property_int("_juneCleaverFightsLeft"));
	int juneCleaverEncounters = (get_property_int("_juneCleaverEncounters"));
	int juneCleaverSkips = clampi(5 - get_property_int("_juneCleaverSkips"), 0, 5);
	
	//cleaver dream charging
	if (juneCleaverCharge == 0) 
	{
		description.listAppend("Cleaver dream ready!");
		description.listAppend("" + juneCleaverSkips + " dream skips remaining for today.");
		//cleaver dream queue
		string [int] possibleDreams;
		if (!get_property("juneCleaverQueue").contains_text("1467")) 
		{
			possibleDreams.listAppend("Poetic Justice, +5 adv");
		}
		if (!get_property("juneCleaverQueue").contains_text("1468")) 
		{
			possibleDreams.listAppend("Aunts not Ants, exp or +exp buff");
		}
		if (!get_property("juneCleaverQueue").contains_text("1469")) 
		{
			possibleDreams.listAppend("Beware of Aligator, booze or 1500 meat");
		}
		if (!get_property("juneCleaverQueue").contains_text("1470")) 
		{
			possibleDreams.listAppend("Teacher's Pet, famxp accessory");
		}
		if (!get_property("juneCleaverQueue").contains_text("1471")) 
		{
			possibleDreams.listAppend("Lost and Found, +meat potion");
		}
		if (!get_property("juneCleaverQueue").contains_text("1472")) 
		{
			possibleDreams.listAppend("Summer Days, noncom potion or +mox");
		}
		if (!get_property("juneCleaverQueue").contains_text("1473")) 
		{
			possibleDreams.listAppend("Bath Time, +mus or resist buff");
		}
		if (!get_property("juneCleaverQueue").contains_text("1474")) 
		{
			possibleDreams.listAppend("Delicious Sprouts, big exp food");
		}
		if (!get_property("juneCleaverQueue").contains_text("1475")) 
		{
			possibleDreams.listAppend("Hypnotic Master, +rest accessory");
		}
		if (possibleDreams.count() > 0)
		description.listAppend(HTMLGenerateSpanOfClass("Possible dreams (not in any order):", "r_bold") + "|*" + possibleDreams.listJoinComponents("|*"));
		
		if (lookupItem("june cleaver").equipped_amount() == 0) {
			description.listAppend(HTMLGenerateSpanFont("Equip the June cleaver", "red"));
		}
		task_entries.listAppend(ChecklistEntryMake("__item June Cleaver", url, ChecklistSubentryMake(main_title, description), -11).ChecklistEntrySetIDTag("June cleaver dreams"));
	}
}

RegisterResourceGenerationFunction("IOTMJuneCleaverGenerateResource");
void IOTMJuneCleaverGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (!lookupItem("June cleaver").have()) return;

    string url = "inventory.php?ftext=june+cleaver";
	string [int] description;
	string main_title = "You can be a June Cleaver";
	
	int juneCleaverCharge = (get_property_int("_juneCleaverFightsLeft"));
	int juneCleaverEncounters = (get_property_int("_juneCleaverEncounters"));
	int juneCleaverSkips = clampi(5 - get_property_int("_juneCleaverSkips"), 0, 5);
	
	if (juneCleaverCharge == 0)
		description.listAppend("Cleaver dream ready!");
	else if (juneCleaverCharge > 0)
		description.listAppend("" + juneCleaverCharge + " combats left until next dream.");
	description.listAppend("" + juneCleaverSkips + " dream skips remaining for today.");
	//cleaver dream queue
	string [int] possibleDreams;
		if (!get_property("juneCleaverQueue").contains_text("1467")) 
		{
			possibleDreams.listAppend("Poetic Justice, +5 adv");
		}
		if (!get_property("juneCleaverQueue").contains_text("1468")) 
		{
			possibleDreams.listAppend("Aunts not Ants, exp or +exp buff");
		}
		if (!get_property("juneCleaverQueue").contains_text("1469")) 
		{
			possibleDreams.listAppend("Beware of Aligator, booze or 1500 meat");
		}
		if (!get_property("juneCleaverQueue").contains_text("1470")) 
		{
			possibleDreams.listAppend("Teacher's Pet, famxp accessory");
		}
		if (!get_property("juneCleaverQueue").contains_text("1471")) 
		{
			possibleDreams.listAppend("Lost and Found, +meat potion");
		}
		if (!get_property("juneCleaverQueue").contains_text("1472")) 
		{
			possibleDreams.listAppend("Summer Days, noncom potion or +mox");
		}
		if (!get_property("juneCleaverQueue").contains_text("1473")) 
		{
			possibleDreams.listAppend("Bath Time, +mus or resist buff");
		}
		if (!get_property("juneCleaverQueue").contains_text("1474")) 
		{
			possibleDreams.listAppend("Delicious Sprouts, big exp food");
		}
		if (!get_property("juneCleaverQueue").contains_text("1475")) 
		{
			possibleDreams.listAppend("Hypnotic Master, +rest accessory");
		}
	if (possibleDreams.count() > 0)
	description.listAppend(HTMLGenerateSpanOfClass("Possible dreams (not in any order):", "r_bold") + "|*" + possibleDreams.listJoinComponents("|*"));
	
	resource_entries.listAppend(ChecklistEntryMake("__item June Cleaver", url, ChecklistSubentryMake(main_title, description)).ChecklistEntrySetIDTag("June cleaver dreams"));
}