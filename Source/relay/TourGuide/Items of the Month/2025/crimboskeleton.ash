//crimbo skeleton
RegisterTaskGenerationFunction("IOTMSkeletonOfCrimboPastGenerateTasks");
void IOTMSkeletonOfCrimboPastGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if (!lookupFamiliar("skeleton of crimbo past").familiar_is_usable()) return;
	string url = "main.php?talktosocp=1";
	string [int] description;
	
	int fightKnucklebones = get_property_int("_knuckleboneDrops");
	int restKnucklebones = get_property_int("_knuckleboneRests");
	int totalKnucklebonesLeft = clampi(100 - (fightKnucklebones + restKnucklebones), 0, 100);
	description.listAppend(5 - restKnucklebones + " rest knucklebones available.");
	
	if (totalKnucklebonesLeft == 0 && my_familiar() == lookupFamiliar("skeleton of crimbo past")) {
		task_entries.listAppend(ChecklistEntryMake("__familiar skeleton of crimbo past", url, ChecklistSubentryMake(HTMLGenerateSpanFont("No more knucklebone drops", "red"), description), -11).ChecklistEntrySetIDTag("crimbo skeleton knucklebones"));
	}
	else if (totalKnucklebonesLeft > 0 && my_familiar() == lookupFamiliar("skeleton of crimbo past")) {
		task_entries.listAppend(ChecklistEntryMake("__familiar skeleton of crimbo past", url, ChecklistSubentryMake(HTMLGenerateSpanFont(totalKnucklebonesLeft + " knucklebone drops left", "green"), description), -11).ChecklistEntrySetIDTag("crimbo skeleton knucklebones"));
	}
}

RegisterResourceGenerationFunction("IOTMSkeletonOfCrimboPastGenerateResource");
void IOTMSkeletonOfCrimboPastGenerateResource(ChecklistEntry [int] resource_entries)
{
	if (!lookupFamiliar("skeleton of crimbo past").familiar_is_usable()) return;
	string url = "main.php?talktosocp=1";
	string [int] description;
	string title;
	
	int fightKnucklebones = get_property_int("_knuckleboneDrops");
	int restKnucklebones = get_property_int("_knuckleboneRests");
	int totalKnucklebonesLeft = clampi(100 - (fightKnucklebones + restKnucklebones), 0, 100);
	
	description.listAppend(5 - restKnucklebones + " rest knucklebones available.");
	
	if (totalKnucklebonesLeft == 0) {
		title = (HTMLGenerateSpanFont("No more knucklebone drops", "red"));
	}
	else if (totalKnucklebonesLeft > 0) {
		title = (HTMLGenerateSpanFont(totalKnucklebonesLeft + " knucklebone drops left", "green"));
	}
	resource_entries.listAppend(ChecklistEntryMake("__familiar skeleton of crimbo past", url, ChecklistSubentryMake(title, description), 11));
}
