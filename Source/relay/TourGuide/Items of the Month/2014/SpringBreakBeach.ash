//Spring Break Beach cash register
RegisterTaskGenerationFunction("IOTMSpringBreakBeachGenerateTasks");
void IOTMSpringBreakBeachGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if (!__misc_state["sleaze airport available"])
        return;
	int dinerBucksLeft = clampi(4 - get_property_int("_sloppyDinerBeachBucks"), 0, 4);
	string url;
	string [int] description;
	if (dinerBucksLeft > 0)
	{
        string title = (dinerBucksLeft + " Sloppy Seconds Diner cash register raids");
		url = "place.php?whichplace=airport_sleaze";
		description.listAppend("Money money money money monay!");
		if (!lookupSkill("sloppy secrets").have_skill()) {
			description.listAppend("Learn Sloppy Secrets for more Beach Bucks.");
		}
		optional_task_entries.listAppend(ChecklistEntryMake("__item beach buck", url, ChecklistSubentryMake(title, "", description), 8));
	}
}