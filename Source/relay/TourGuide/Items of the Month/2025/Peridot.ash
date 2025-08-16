//peridot of peril
RegisterTaskGenerationFunction("IOTMPeridotGenerateTasks");
void IOTMPeridotGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if ($item[peridot of peril].available_amount() == 0) return;
	string url = "inventory.php?ftext=peridot+of+peril";
	string [int] description;
	
	if (lookupItem("peridot of peril").equipped_amount() == 1)
	{
		description.listAppend(HTMLGenerateSpanFont("PERIDOT POWER!", "green"));
		string main_title = HTMLGenerateSpanFont("Peridot picking power", "green");
		task_entries.listAppend(ChecklistEntryMake("__item peridot of peril", "", ChecklistSubentryMake(main_title, description), -11).ChecklistEntrySetIDTag("peridot task"));
	}
	else if (lookupItem("peridot of peril").equipped_amount() == 0 && (__misc_state["in run"]))
	{
		description.listAppend(HTMLGenerateSpanFont("Equip the peridot to map monsters", "red"));
		optional_task_entries.listAppend(ChecklistEntryMake("__item peridot of peril", "", ChecklistSubentryMake("Peridot picking power", description), 10).ChecklistEntrySetIDTag("peridot task"));
	}
}