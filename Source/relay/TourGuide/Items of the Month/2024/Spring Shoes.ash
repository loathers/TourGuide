//Spring shoes
RegisterTaskGenerationFunction("IOTMSpringShoesGenerateTasks");
RegisterResourceGenerationFunction("IOTMSpringShoesGenerateResource");

void IOTMSpringShoesGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	// Initialization. Do not generate if you don't have spring shoes.
	if (!__iotms_usable[lookupItem("spring shoes")]) return;

	// Added a check for all paths where you do not want the tile at all:
	//   - Community Service: irrelevant
	//   - WereProfessor: is not a free run.

	boolean pathCheck = true;
	pathCheck = my_path().id == PATH_COMMUNITY_SERVICE ? false : true;
	pathCheck = my_path().id == PATH_WEREPROFESSOR ? false : true;

	// Technically, the available_amount here precludes the need for the initialization up top.
	if (__misc_state["in run"] && available_amount($item[spring shoes]) > 0 && pathCheck)
	{
		if ($effect[everything looks green].have_effect() == 0) 
		{
			string [int] description;
			string url = "inventory.php?ftext=spring+shoes";
			description.listAppend(HTMLGenerateSpanFont("Free-run away from your problems with the <b>Spring Away</b> skill!", "green"));
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
	// Initialization. Do not generate iof you don't have spring shoes.
	if (!__iotms_usable[lookupItem("spring shoes")]) return;

	string [int] banishDescription;
	banishDescription.listAppend("All day banish, doesn't end combat");
	if (lookupItem("spring shoes").equipped_amount() == 0)
	{
		banishDescription.listAppend(HTMLGenerateSpanFont("Equip the spring shoes first.", "red"));
	}
	resource_entries.listAppend(ChecklistEntryMake("__skill spring shoes", "", ChecklistSubentryMake("Spring Kick", "", banishDescription)).ChecklistEntrySetCombinationTag("banish").ChecklistEntrySetIDTag("Spring shoes spring kick banish"));
}