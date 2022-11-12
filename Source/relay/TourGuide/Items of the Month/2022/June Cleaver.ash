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
			possibleDreams.listAppend(HTMLGenerateSpanOfClass("Poetic Justice", "r_bold") + ", +5 advs, +250 mox, +125 mys");
		}
		if (!get_property("juneCleaverQueue").contains_text("1468")) 
		{
			possibleDreams.listAppend(HTMLGenerateSpanOfClass("Aunts not Ants", "r_bold") + ", +150 mox, +250 mus, or +exp buff");
		}
		if (!get_property("juneCleaverQueue").contains_text("1469")) 
		{
			possibleDreams.listAppend(HTMLGenerateSpanOfClass("Beware of Aligator", "r_bold") + ", +ML buff, booze, or 1500 meat");
		}
		if (!get_property("juneCleaverQueue").contains_text("1470")) 
		{
			possibleDreams.listAppend(HTMLGenerateSpanOfClass("Teacher's Pet", "r_bold") + ", +famxp accessory or +250 mus");
		}
		if (!get_property("juneCleaverQueue").contains_text("1471")) 
		{
			possibleDreams.listAppend(HTMLGenerateSpanOfClass("Lost and Found", "r_bold") + ", +meat potion, +100 mus, +250 mys");
		}
		if (!get_property("juneCleaverQueue").contains_text("1472")) 
		{
			possibleDreams.listAppend(HTMLGenerateSpanOfClass("Summer Days", "r_bold") + ", noncom potion or +250 mox");
		}
		if (!get_property("juneCleaverQueue").contains_text("1473")) 
		{
			possibleDreams.listAppend(HTMLGenerateSpanOfClass("Bath Time", "r_bold") + ", +150 mus or resist buff");
		}
		if (!get_property("juneCleaverQueue").contains_text("1474")) 
		{
			possibleDreams.listAppend(HTMLGenerateSpanOfClass("Delicious Sprouts", "r_bold") + ", big exp food, +250 mys, +125 mus");
		}
		if (!get_property("juneCleaverQueue").contains_text("1475")) 
		{
			possibleDreams.listAppend(HTMLGenerateSpanOfClass("Hypnotic Master", "r_bold") + ", +rest accessory or +250 mus");
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
			possibleDreams.listAppend(HTMLGenerateSpanOfClass("Poetic Justice", "r_bold") + ", +5 advs, +250 mox, +125 mys");
		}
		if (!get_property("juneCleaverQueue").contains_text("1468")) 
		{
			possibleDreams.listAppend(HTMLGenerateSpanOfClass("Aunts not Ants", "r_bold") + ", +150 mox, +250 mus, or +exp buff");
		}
		if (!get_property("juneCleaverQueue").contains_text("1469")) 
		{
			possibleDreams.listAppend(HTMLGenerateSpanOfClass("Beware of Aligator", "r_bold") + ", +ML buff, booze, or 1500 meat");
		}
		if (!get_property("juneCleaverQueue").contains_text("1470")) 
		{
			possibleDreams.listAppend(HTMLGenerateSpanOfClass("Teacher's Pet", "r_bold") + ", +famxp accessory or +250 mus");
		}
		if (!get_property("juneCleaverQueue").contains_text("1471")) 
		{
			possibleDreams.listAppend(HTMLGenerateSpanOfClass("Lost and Found", "r_bold") + ", +meat potion, +100 mus, +250 mys");
		}
		if (!get_property("juneCleaverQueue").contains_text("1472")) 
		{
			possibleDreams.listAppend(HTMLGenerateSpanOfClass("Summer Days", "r_bold") + ", noncom potion or +250 mox");
		}
		if (!get_property("juneCleaverQueue").contains_text("1473")) 
		{
			possibleDreams.listAppend(HTMLGenerateSpanOfClass("Bath Time", "r_bold") + ", +150 mus or resist buff");
		}
		if (!get_property("juneCleaverQueue").contains_text("1474")) 
		{
			possibleDreams.listAppend(HTMLGenerateSpanOfClass("Delicious Sprouts", "r_bold") + ", big exp food, +250 mys, +125 mus");
		}
		if (!get_property("juneCleaverQueue").contains_text("1475")) 
		{
			possibleDreams.listAppend(HTMLGenerateSpanOfClass("Hypnotic Master", "r_bold") + ", +rest accessory or +250 mus");
		}
	if (possibleDreams.count() > 0)
	description.listAppend(HTMLGenerateSpanOfClass("Possible dreams (not in any order):", "r_bold") + "|*" + possibleDreams.listJoinComponents("|*"));
	
	resource_entries.listAppend(ChecklistEntryMake("__item June Cleaver", url, ChecklistSubentryMake(main_title, description)).ChecklistEntrySetIDTag("June cleaver dreams"));
}