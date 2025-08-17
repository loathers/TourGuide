//shower thoughts
RegisterTaskGenerationFunction("IOTMAprilShowerThoughtsGenerateTasks");
void IOTMAprilShowerThoughtsGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if ($item[April Shower Thoughts shield].available_amount() == 0) return;
	string url = "inventory.php?action=shower&pwd=" + my_hash();
	string [int] description;
	
	boolean showerGlobs = get_property_boolean("_aprilShowerGlobsCollected"); 
	if (showerGlobs == false) {
		description.listAppend("Collect globs");
		task_entries.listAppend(ChecklistEntryMake("__item April Shower Thoughts shield", url, ChecklistSubentryMake("Shower for Globs", "", description), -11));
    }
	if (lookupItem("april shower thoughts shield").equipped_amount() == 1)
	{
		string main_title = HTMLGenerateSpanFont("April Shower Powers", "black");
		boolean showerNEYR = get_property_boolean("_aprilShowerNorthernExplosion"); 
		if (showerNEYR == false) {
			description.listAppend(HTMLGenerateSpanFont("Northern Explosion YR available", "blue"));		
			task_entries.listAppend(ChecklistEntryMake("__item april shower thoughts shield", "", ChecklistSubentryMake(main_title, description), -11).ChecklistEntrySetIDTag("april shower thoughts calendar tasks"));
		}
	}
}

RegisterResourceGenerationFunction("IOTMAprilShowerThoughtsGenerateResource");
void IOTMAprilShowerThoughtsGenerateResource(ChecklistEntry [int] resource_entries)
{
	if ($item[April Shower Thoughts shield].available_amount() == 0) return;
	string url = "shop.php?whichshop=showerthoughts";
	string [int] description;
	
	string main_title = HTMLGenerateSpanFont("April Shower Powers", "black");
	boolean showerNEYR = get_property_boolean("_aprilShowerNorthernExplosion"); 
	if (showerNEYR == false) {
		description.listAppend(HTMLGenerateSpanFont("Northern Explosion YR available", "blue"));		
	}
	int globCount = available_amount($item[glob of wet paper]);
	{
		description.listAppend("Craft your shower thoughts, with your "+pluralise(globCount,"glob","globs")+"!");
	}
	resource_entries.listAppend(ChecklistEntryMake("__item april shower thoughts shield", url, ChecklistSubentryMake(main_title, description), 10).ChecklistEntrySetIDTag("april shower thoughts calendar resource"));
}