//shower thoughts
RegisterTaskGenerationFunction("IOTMAprilShowerThoughtsGenerateTasks");
void IOTMAprilShowerThoughtsGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries) {
	if (lookupItem("april shower thoughts shield").available_amount() == 0) return;
	
	if (lookupItem("april shower thoughts shield").equipped() && !get_property_boolean("_aprilShowerNorthernExplosion") && lookupSkill("Northern Explosion").have_skill()) {
		string [int] description;
		string main_title = HTMLGenerateSpanFont("April Shower Powers", "black");
		description.listAppend(HTMLGenerateSpanFont("Northern Explosion YR available", "blue"));		
		task_entries.listAppend(ChecklistEntryMake("__item april shower thoughts shield", "", ChecklistSubentryMake(main_title, description), -11).ChecklistEntrySetIDTag("april shower thoughts calendar tasks"));
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
		if (!lookupSkill("Northern Explosion").have_skill()) showerNEYR = true;
	if (showerNEYR == false) {
		description.listAppend(HTMLGenerateSpanFont("Northern Explosion YR available", "blue"));		
	}
	int globCount = available_amount($item[glob of wet paper]);
	{
		description.listAppend("Craft your shower thoughts, with your "+pluralise(globCount,"glob","globs")+"!");
	}
	if (description.count() > 0)
		resource_entries.listAppend(ChecklistEntryMake("__item april shower thoughts shield", url, ChecklistSubentryMake(main_title, description), 10).ChecklistEntrySetIDTag("april shower thoughts calendar resource"));
}