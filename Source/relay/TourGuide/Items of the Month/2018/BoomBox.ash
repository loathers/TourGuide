//Songboom
RegisterTaskGenerationFunction("IOTMBoomBoxGenerateTasks");
void IOTMBoomBoxGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	if (lookupItem("SongBoom&trade; BoomBox").available_amount() == 0) return;

	string song = get_property("boomBoxSong");
	int changes_left = get_property_int("_boomBoxSongsLeft"); //the boys are back in town, eleven times. everyone will love it
	int boomboxProgress = get_property_int("_boomBoxFights");
	string [int] description;
	description.listAppend("Now playing: " + HTMLGenerateSpanOfClass(song, "r_bold")); //+ " (" + changes_left + " song swaps today)");
	if (boomboxProgress < 9)
	{
		description.listAppend((11 - boomboxProgress).pluralise("combat", "combats") + " until next drop.");
		optional_task_entries.listAppend(ChecklistEntryMake("__item SongBoom&trade; BoomBox", "inv_use.php?pwd=" + my_hash() + "&whichitem=9919", ChecklistSubentryMake("Boombox song stuff", "", description), 8));
	}
	int priority = (__misc_state["in run"] ? -11 : 8);
	if (boomboxProgress == 9)
	{
		task_entries.listAppend(ChecklistEntryMake("__item SongBoom&trade; BoomBox", "inv_use.php?pwd=" + my_hash() + "&whichitem=9919", ChecklistSubentryMake("Boombox drop in 2 fights", "", description), priority));
	}
	
	if (boomboxProgress == 10)
	{
		task_entries.listAppend(ChecklistEntryMake("__item SongBoom&trade; BoomBox", "inv_use.php?pwd=" + my_hash() + "&whichitem=9919", ChecklistSubentryMake("Boombox drop this fight", "", description), priority));
	}

	if (song == "" && changes_left > 0)
	{
		string [int] description;
		if (!__quest_state["Level 7"].finished && my_path().id != PATH_COMMUNITY_SERVICE)
			description.listAppend("Eye of the Giger: Nightmare Fuel for the cyrpt.");
		if (fullness_limit() > 0)
			description.listAppend("Food Vibrations: extra adventures from food" + (__misc_state["in run"] ? ", +30% food drop" : "") + ".");
		description.listAppend("Total Eclipse of Your Meat: extra meat, +30% meat.");

		optional_task_entries.listAppend(ChecklistEntryMake("__item SongBoom&trade; BoomBox", "inv_use.php?pwd=" + my_hash() + "&whichitem=9919", ChecklistSubentryMake("Set BoomBox song", "", description), 8).ChecklistEntrySetIDTag("SongBoom BoomBox turn on"));
	}
}
