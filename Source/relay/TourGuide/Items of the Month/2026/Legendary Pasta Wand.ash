//legendary pasta wand
RegisterTaskGenerationFunction("IOTMLegendaryWandGenerateTasks");
void IOTMLegendaryWandGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    int LegendaryAmy = get_property_int("legendaryNoodlesAmygdala");
	string [int] description;
	if (LegendaryAmy > 0) {
		description.listAppend("Ninja snowman assassin / LFMs?");
		task_entries.listAppend(ChecklistEntryMake("__item formica e pepe", "", ChecklistSubentryMake(HTMLGenerateSpanFont(LegendaryAmy + " Legendary Noodle Combat Forces", "blue"), description), -11).ChecklistEntrySetIDTag("legendary noodles"));
	}
}
RegisterResourceGenerationFunction("IOTMLegendaryPastaWandGenerateResource");
void IOTMLegendaryPastaWandGenerateResource(ChecklistEntry [int] resource_entries)
{
	if (available_amount($item[legendary pasta wand]) > 0) {
		string url = "inventory.php?ftext=legendary+pasta+wand";
		string [int] description;
		int LegendaryRats = get_property_int("_legendaryVermincelliFreeRats");
			
		if (LegendaryRats < 11 && $thrall[Vermincelli].level < 11) {
			description.listAppend("Level up Vermincelli to make rats free");
		}
		else if (LegendaryRats < 11 && $thrall[Vermincelli].level == 11) {
			description.listAppend("Some rats are free!");
		}
		resource_entries.listAppend(ChecklistEntryMake("__item ratarang", url, ChecklistSubentryMake(HTMLGenerateSpanFont(LegendaryRats +"/3 free rat fights", "orange"), description), 7).ChecklistEntrySetIDTag("LPW ability"));
	}
}
