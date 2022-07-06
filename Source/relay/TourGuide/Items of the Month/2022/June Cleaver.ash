//June cleaver
RegisterTaskGenerationFunction("IOTMJuneCleaverGenerateTasks");
void IOTMJuneCleaverGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    // Nags you to put on the cleaver if you have a dream coming up.
    if (!lookupItem("June cleaver").have()) return;

    string url = "inventory.php?ftext=june+cleaver";
	string [int] description;
	string main_title = "June Cleaver dream ready!";
	
	int juneCleaverCharge = (get_property_int("_juneCleaverFightsLeft"));
	int juneCleaverEncounters = (get_property_int("_juneCleaverEncounters"));
	int juneCleaverSkips = clampi(5 - get_property_int("_juneCleaverSkips"), 0, 5);
	
	if (juneCleaverCharge == 0) 
	{
		description.listAppend("Cleaver dream ready!");
		description.listAppend("" + juneCleaverSkips + " dream skips remaining for today.");
		if (lookupItem("june cleaver").equipped_amount() == 0) {
			description.listAppend(HTMLGenerateSpanFont("Equip the June cleaver", "red"));
		}
		task_entries.listAppend(ChecklistEntryMake("__item June Cleaver", url, ChecklistSubentryMake(main_title, description), -11).ChecklistEntrySetIDTag("June cleaver dreams"));
	}
}

RegisterResourceGenerationFunction("IOTMJuneCleaverGenerateResource");
void IOTMJuneCleaverGenerateResource(ChecklistEntry [int] resource_entries)
{
    // Shows combats until the next dream & how many skips you have left. 
    if (!lookupItem("June cleaver").have()) return;

    string url = "inventory.php?ftext=june+cleaver";
	string [int] description;
	string main_title = "You can be a June Cleaver";
	
	int juneCleaverCharge = (get_property_int("_juneCleaverFightsLeft"));
	int juneCleaverEncounters = (get_property_int("_juneCleaverEncounters"));
	int juneCleaverSkips = clampi(5 - get_property_int("_juneCleaverSkips"), 0, 5);
	
	if (juneCleaverCharge == 0)
		description.listAppend("Cleaver dream ready!");
	else if (juneCleaverEncounters > 0)
		description.listAppend("" + juneCleaverCharge + " combats left until next dream.");
	description.listAppend("" + juneCleaverSkips + " dream skips remaining for today.");
	
	if (lookupItem("june cleaver").equipped_amount() == 0) {
        description.listAppend(HTMLGenerateSpanFont("Equip the June cleaver", "red"));
	}
	
	resource_entries.listAppend(ChecklistEntryMake("__item June Cleaver", url, ChecklistSubentryMake(main_title, description)).ChecklistEntrySetIDTag("June cleaver dreams"));
}