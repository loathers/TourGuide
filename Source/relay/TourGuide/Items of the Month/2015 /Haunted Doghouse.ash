//hallowiener dog
RegisterTaskGenerationFunction("IOTMHallowienerGenerateTasks");
void IOTMHallowienerGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	string [int] description;
	string url = "place.php?whichplace=airport_hot";
	if (__iotms_usable[$item[haunted doghouse]] && !get_property_boolean("hallowienerVolcoino")) {
	
		if (($locations[the bubblin' caldera] contains __last_adventure_location) && (!get_property_boolean("hallowienerVolcoino"))) {
			description.listAppend("Spend 5 turn-taking combats in The Bubblin' Caldera.");
			task_entries.listAppend(ChecklistEntryMake("__item volcoino", url, ChecklistSubentryMake("Hallowiener volcoino", "", description), -11));
		}
		else {
			description.listAppend("Spend 5 turn-taking combats in The Bubblin' Caldera.");
			optional_task_entries.listAppend(ChecklistEntryMake("__item volcoino", url, ChecklistSubentryMake("Hallowiener volcoino", "", description), 8));
		}
	}
}

RegisterResourceGenerationFunction("IOTMHauntedDoghouseGenerateResource");
void IOTMHauntedDoghouseGenerateResource(ChecklistEntry [int] resource_entries)
{
	if (!__misc_state["in run"])
		return;
	if ($item[tennis ball].available_amount() > 0 && in_ronin() && $item[tennis ball].item_is_usable())
	{
		resource_entries.listAppend(ChecklistEntryMake("__item tennis ball", "", ChecklistSubentryMake(pluralise($item[tennis ball]), "", "Free run/banish."), 6).ChecklistEntrySetCombinationTag("banish").ChecklistEntrySetIDTag("Haunted doghouse banish"));
	}
	//I, um, hmm. I guess there's not much to say. Poor lonely file, nearly empty.
}
