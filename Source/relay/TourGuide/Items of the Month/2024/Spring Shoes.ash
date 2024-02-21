//Spring shoes
RegisterTaskGenerationFunction("IOTMSpringShoesGenerateTasks");
RegisterResourceGenerationFunction("IOTMSpringShoesGenerateResource");

void IOTMSpringShoesGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	if (available_amount($item[spring shoes]) > 0 && my_path().id != PATH_COMMUNITY_SERVICE)
	{
		if ($effect[everything looks green].have_effect() == 0) 
		{
			string [int] description;
			string url = "inventory.php?ftext=spring+shoes";
			description.listAppend(HTMLGenerateSpanFont("Run away from your problems!", "green"));
			if (lookupItem("spring shoes").equipped_amount() == 0)
			{
				description.listAppend(HTMLGenerateSpanFont("Equip the spring shoes first.", "red"));
			}
			task_entries.listAppend(ChecklistEntryMake("__item spring shoes", url, ChecklistSubentryMake("Spring shoes runaway available!", "", description), -11));
		}
	}
}

void IOTMSpringShoesGenerateResource(ChecklistEntry [int] resource_entries)
{
	string [int] banishDescription;
	banishDescription.listAppend("All day banish, doesn't end combat");
	if (lookupItem("spring shoes").equipped_amount() == 0)
	{
		banishDescription.listAppend(HTMLGenerateSpanFont("Equip the spring shoes first.", "red"));
	}
	resource_entries.listAppend(ChecklistEntryMake("__skill spring shoes", "", ChecklistSubentryMake("Spring Kick", "", banishDescription)).ChecklistEntrySetCombinationTag("banish").ChecklistEntrySetIDTag("Spring shoes spring kick banish"));
}