//shrunken head
RegisterTaskGenerationFunction("IOTMShrunkenHeadGenerateTasks");
void IOTMShrunkenHeadGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if ($item[shrunken head].available_amount() == 0) return;
	string url = "inventory.php?ftext=shrunken+head";
	string [int] description;
	
	if (lookupItem("shrunken head").equipped_amount() > 0)
	{
		description.listAppend("Targets:");
		description.listAppend("Baa sheep 25%");
		description.listAppend("Banshee librarian 10%");
		description.listAppend("Mountain man 40%");
		description.listAppend("Pygmy janitor 20%");
		description.listAppend("Pygmy bowler 40%");
		description.listAppend("Nook skeleton 20%");
		description.listAppend("Smut orc 10%");
		description.listAppend("Dairy goat 40%");
		task_entries.listAppend(ChecklistEntryMake("__item shrunken head", url, ChecklistSubentryMake(HTMLGenerateSpanFont("Shrunken head equipped", "blue"), description), -11).ChecklistEntrySetIDTag("shrunken head"));
	}
}
