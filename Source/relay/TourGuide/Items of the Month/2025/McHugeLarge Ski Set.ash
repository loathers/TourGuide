
//Ski set
RegisterTaskGenerationFunction("IOTMSkiSetGenerateTasks");
void IOTMSkiSetGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	if ($item[McHugeLarge duffel bag].available_amount() < 1) return;

	if ($item[McHugeLarge duffel bag].available_amount() > 0 && $item[McHugeLarge right ski].available_amount() == 0)
	{
		task_entries.listAppend(ChecklistEntryMake("__item McHugeLarge duffel bag", "inventory.php?ftext=McHugeLarge+duffel+bag", ChecklistSubentryMake("McHugeLarge duffel bag", "", "Open it!"), -10).ChecklistEntrySetIDTag("McHugeLarge duffel bag resource"));
    }
}


RegisterResourceGenerationFunction("IOTMSkiSetGenerateResource");
void IOTMSkiSetGenerateResource(ChecklistEntry [int] resource_entries)
{
	if ($item[McHugeLarge duffel bag].available_amount() < 1) return;
	
	int skiAvalanchesLeft = clampi(3 - get_property_int("_mcHugeLargeAvalancheUses"), 0, 3);
	int skiSlashesLeft = clampi(3 - get_property_int("_mcHugeLargeSlashUses"), 0, 3);
	string [int] description;
	string url = "inventory.php?ftext=McHugeLarge";
	
	if (skiAvalanchesLeft > 0)
	{
		description.listAppend(HTMLGenerateSpanOfClass(skiSlashesLeft + " avalanches", "r_bold") + " left. Sneak!");
    //fixme: currently not supported by sneako tile
		if (lookupItem("McHugeLarge left ski").equipped_amount() == 1)
		{
			description.listAppend(HTMLGenerateSpanFont("|*LEFT SKI equipped!", "blue"));
		}
		else if (lookupItem("McHugeLarge left ski").equipped_amount() == 0)
		{
			description.listAppend(HTMLGenerateSpanFont("|*Equip the LEFT SKI first.", "red"));
		}
	}
	if (skiSlashesLeft > 0)
	{
		description.listAppend(HTMLGenerateSpanOfClass(skiSlashesLeft + " slashes", "r_bold") + " left. Track a monster.");
		if (lookupItem("McHugeLarge left pole").equipped_amount() == 1)
		{
			description.listAppend(HTMLGenerateSpanFont("|*LEFT POLE equipped!", "blue"));
		}
		else if (lookupItem("McHugeLarge left pole").equipped_amount() == 0)
		{
			description.listAppend(HTMLGenerateSpanFont("|*Equip the LEFT POLE first.", "red"));
		}
	}
	resource_entries.listAppend(ChecklistEntryMake("__item McHugeLarge duffel bag", url, ChecklistSubentryMake("McHugeLarge ski set skills", description), 1));
}
