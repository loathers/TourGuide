//Clovers and Lucky
RegisterResourceGenerationFunction("LuckyGenerateResource");
void LuckyGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (!__misc_state["in run"]) return;
	{
		string [int] description;
		string url;
		description.listAppend(HTMLGenerateSpanFont("Have a Lucky adventure!", "green"));
		description.listAppend("1x ore, 4x Zeppelin protesters, 1x wand.");
		
		if ($item[11-leaf clover].available_amount() > 0)
		{
			url = invSearch("11-leaf clover");
			resource_entries.listAppend(ChecklistEntryMake("__item 11-leaf clover", url, ChecklistSubentryMake(pluralise($item[11-leaf clover]), "Inhale leaves for good luck", description), 2).ChecklistEntrySetCombinationTag("fortune"));
		}
		if ($item[[10883]astral energy drink].available_amount() > 0 && $item[11-leaf clover].available_amount() == 0)
		{
			url = invSearch("astral energy drink");
			resource_entries.listAppend(ChecklistEntryMake("__item [10883]astral energy drink", url, ChecklistSubentryMake(pluralise($item[[10883]astral energy drink]), "Costs 5 spleen each", description), 2).ChecklistEntrySetCombinationTag("fortune"));
		}
		else if ($item[[10883]astral energy drink].available_amount() > 0 && $item[11-leaf clover].available_amount() > 0)
		{
			url = invSearch("astral energy drink");
			resource_entries.listAppend(ChecklistEntryMake("__item [10883]astral energy drink", url, ChecklistSubentryMake(pluralise($item[[10883]astral energy drink]), "Costs 5 spleen each", ""), 2).ChecklistEntrySetCombinationTag("fortune"));
		}
	}
}

RegisterTaskGenerationFunction("LuckyGenerateTasks");
void LuckyGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if ($effect[lucky!].have_effect() > 0) {
        string [int] description;
		string main_title = HTMLGenerateSpanFont("You feel lucky, punk!", "green") + "";
		if (__misc_state["in run"] && my_path().id == 44) {
			description.listAppend("1x ore, 1x freezerburned ice cube, 1x full-length mirror.");
		}
		else if (__misc_state["in run"]) {
			description.listAppend("1x ore, 4x Zeppelin protesters, 1x wand.");
		}
		else {
			description.listAppend("I dunno. Full-length mirror?");
		}
		task_entries.listAppend(ChecklistEntryMake("__item 11-leaf clover", "", ChecklistSubentryMake(main_title, description), -11).ChecklistEntrySetIDTag("Fortune adventure now"));
    }
}