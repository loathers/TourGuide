//Ski set
RegisterTaskGenerationFunction("IOTMSkiSetGenerateTasks");
void IOTMSkiSetGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries) {
	if (!__iotms_usable[$item[McHugeLarge deluxe ski set]]) return;
	// supernag to use it if unopened. Should appear once per ascension.
	if (!lookupItem("McHugeLarge left ski").have())	{
		task_entries.listAppend(ChecklistEntryMake("__item McHugeLarge duffel bag", "inventory.php?ftext=McHugeLarge+duffel+bag", ChecklistSubentryMake("McHugeLarge duffel bag", "", "Open it!"), -11).ChecklistEntrySetIDTag("McHugeLarge duffel bag resource"));
	}
}

RegisterResourceGenerationFunction("IOTMSkiSetAvalancheGenerateResource");
void IOTMSkiSetAvalancheGenerateResource(ChecklistEntry [int] resource_entries) {
	if (!__iotms_usable[$item[McHugeLarge deluxe ski set]]) return;
	// resource for Avalanche (3/day non-combat force).
	int skiAvalanchesLeft = clampi(3 - get_property_int("_mcHugeLargeAvalancheUses"), 0, 3);

	if (skiAvalanchesLeft < 1) return;

	string [int] description;
	string url = "inventory.php?ftext=McHugeLarge";
	
	if (skiAvalanchesLeft > 0) {
		description.listAppend(HTMLGenerateSpanOfClass(skiAvalanchesLeft + " avalanches", "r_bold") + " left.");
		if (!lookupItem("McHugeLarge left ski").equipped()) {
			description.listAppend(HTMLGenerateSpanFont("Equip the McHugeLarge Left Ski first.", "red"));
		}
	}
	resource_entries.listAppend(ChecklistEntryMake("__item McHugeLarge Left Ski", url, ChecklistSubentryMake("McHugeLarge Avalanche", description), -11).ChecklistEntrySetCombinationTag("sneaks"));
}
