//mobius ring
RegisterTaskGenerationFunction("IOTMMobiusRingGenerateTasks");
void IOTMMobiusRingGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if ($item[M&ouml;bius ring].available_amount() == 0) return;
	string url = "inventory.php?ftext=bius+ring";
	string [int] description;
	int timecopFights = clampi(11 - get_property_int("_timeCopsFoughtToday"), 0, 11);
	string title = HTMLGenerateSpanFont("" + timecopFights + " free Time Cop fights", "black");
	
	if (lookupItem("M&ouml;bius ring").equipped_amount() == 1) {
		if (timecopFights > 0) 
		{
			description.listAppend(HTMLGenerateSpanFont("Ring equipped, it's Möbing time!", "blue"));
		}
		if (timecopFights == 0) 
		{
			description.listAppend(HTMLGenerateSpanFont("Mobius ring equipped, danger!", "red"));
		}
		task_entries.listAppend(ChecklistEntryMake("__monster time cop", "", ChecklistSubentryMake(title, description), -11).ChecklistEntrySetIDTag("morb ring task"));
	}
}

RegisterResourceGenerationFunction("IOTMMobiusRingGenerateResource");
void IOTMMobiusRingGenerateResource(ChecklistEntry [int] resource_entries)
{
    if ($item[M&ouml;bius ring].available_amount() == 0) return;
	
    string url = "inventory.php?ftext=bius+ring";
	int timecopFights = clampi(11 - get_property_int("_timeCopsFoughtToday"), 0, 11);
	string [int] description;
	string title = HTMLGenerateSpanFont("Mobius ring " + timecopFights + " free Time Cop fights", "black");
	
	description.listAppend("Try to get to 13 Paradoxicity (+100% item, +50% booze)");
	if (timecopFights > 0) 
	{
		if (lookupItem("Möbius ring").equipped_amount() == 1) {
			description.listAppend(HTMLGenerateSpanFont("Step back, Adventurer, I'm about to Möb!", "blue"));
		}
		if (lookupItem("Möbius ring").equipped_amount() == 0) {
			description.listAppend(HTMLGenerateSpanFont("Equip the Mobius ring", "red"));
		}
	}
	if (timecopFights == 0) 
	{
		description.listAppend(HTMLGenerateSpanFont("No more free time cops", "red"));
		if (lookupItem("Möbius ring").equipped_amount() == 1) {
			description.listAppend(HTMLGenerateSpanFont("Mobius ring equipped, danger!", "red"));
		}
		if (lookupItem("Möbius ring").equipped_amount() == 0) {
			description.listAppend(HTMLGenerateSpanFont("Equip the Mobius ring", "red"));
		}
	}
	resource_entries.listAppend(ChecklistEntryMake("__item M&ouml;bius ring", url, ChecklistSubentryMake(title, "", description), 0));
}
