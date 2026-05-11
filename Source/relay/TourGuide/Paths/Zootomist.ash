RegisterTaskGenerationFunction("PathZootomistGenerateTasks");
void PathZootomistGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    string [int] description;
	string [int] ydescription;
	string [int] bdescription;
	if (my_path().id != PATH_ZOOTOMIST) return;
	{
        if ($effect[Everything Looks Yellow].have_effect() == 0) {
			string ymain_title = HTMLGenerateSpanFont("Quantum Left Kick castable", "orange");
			ydescription.listAppend("Free YR (31 adv cooldown)");
			task_entries.listAppend(ChecklistEntryMake("__familiar quantum entangler", "", ChecklistSubentryMake(ymain_title, "", ydescription), -11));
		}
        if ($effect[Everything Looks Blue].have_effect() == 0) {
			string bmain_title = HTMLGenerateSpanFont("Phantom Right Kick castable", "blue");
			bdescription.listAppend("Banish (31 adv cooldown)");
			task_entries.listAppend(ChecklistEntryMake("__skill toss", "", ChecklistSubentryMake(bmain_title, "", bdescription), -11));
		}
    	
		string url = 'place.php?whichplace=graftinglab&action=graftinglab_chamber';
		int famWeight = floor(sqrt(my_familiar().experience));
		int famExperienceGain = numeric_modifier("familiar experience") +1;
		int benchPrepsLeft = (1 + get_property_int("zootomistPoints") - get_property_int("zootSpecimensPrepared"));
		int graftFXP = (my_level() +2) ** 2;
		int famExpNeeded = graftFXP - my_familiar().experience;
		int fxpCalc = 1 + (famExpNeeded/famExperienceGain);
		if (benchPrepsLeft > 0) {
			description.listAppend("+20 fxp usable " + benchPrepsLeft + " more times.");
		}
		description.listAppend("" + (my_level() -1) + "/11 grafted.");
		if (famExpNeeded < 1) {
			description.listAppend(HTMLGenerateSpanFont("You can graft this fam! (" + my_familiar().experience + ") fxp", "green"));
		}
		else {
			description.listAppend("Currently gain " + famExperienceGain + " fxp/fight");
			description.listAppend("" + famExpNeeded + " more fxp to graft current fam. (" + fxpCalc + " fights)");
		}
		if (my_level() < 12)
		{
			task_entries.listAppend(ChecklistEntryMake("__monster stephen spookyraven", url, ChecklistSubentryMake(HTMLGenerateSpanFont("Familiar grafting time", "blue"), "", description), -11));
		}
	/*	else if (famWeight +2 < my_level() && my_level() < 12)
		{
			optional_task_entries.listAppend(ChecklistEntryMake("__monster stephen spookyraven", url, ChecklistSubentryMake(HTMLGenerateSpanFont("Not fat enough to graft", "red"), "", description), 11));
		} */
    }
}