//Roman Candelabra
RegisterTaskGenerationFunction("IOTMRomanCandelbraGenerateTasks");
void IOTMRomanCandelbraGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	#if (__misc_state["in run"] && available_amount($item[Roman Candelabra]) > 0 && my_path().id != PATH_COMMUNITY_SERVICE)
	if ($item[roman candelabra].available_amount() == 0) return;
	{
		string [int] description;
		string url = "inventory.php?ftext=Roman+Candelabra";

		//extra runaway nag for spring shoes unhavers
		if ($effect[everything looks green].have_effect() == 0 && ($item[spring shoes].available_amount() == 0)) 
		{
			string [int] description;
			description.listAppend(HTMLGenerateSpanFont("Green candle runaway!", "green"));
			if (lookupItem("Roman Candelabra").equipped_amount() == 0)
			{
				description.listAppend(HTMLGenerateSpanFont("Equip the Roman Candelabra first.", "red"));
			}
			else description.listAppend(HTMLGenerateSpanFont("Candelbra equipped", "blue"));
			task_entries.listAppend(ChecklistEntryMake("__item Abracandalabra", url, ChecklistSubentryMake("Roman Candelabra runaway available!", "", description), -11));
		}

		//purple people beater
		if ($effect[everything looks purple].have_effect() == 0) 
		{
			string [int] description;
			description.listAppend(HTMLGenerateSpanFont("Purple Candle chained fight!", "magenta"));
			if (lookupItem("Roman Candelabra").equipped_amount() == 0)
			{
				description.listAppend(HTMLGenerateSpanFont("Equip the Roman Candelabra first.", "red"));
			}
			else description.listAppend(HTMLGenerateSpanFont("Candelbra equipped", "blue"));
			task_entries.listAppend(ChecklistEntryMake("__item Abracandalabra", url, ChecklistSubentryMake("Roman Candelabra copy available!", "", description), -11));
		}
	}
}
