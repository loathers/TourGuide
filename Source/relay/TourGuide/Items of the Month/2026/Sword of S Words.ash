//sword of s words
RegisterTaskGenerationFunction("IOTMSwordofSWordsGenerateTasks");
void IOTMSwordofSWordsGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if (!lookupFamiliar("sword of s words").familiar_is_usable()) return;
	string url = "familiar.php";
	string [int] description;
	
	int swordKills = get_property_int("_swordOfSWordsKills");
	int swordChangesLeft = clampi(3 - get_property_int("_swordOfSWordsMonsterChanged"), 0, 3);
	monster swordTarget = to_monster(get_property("swordOfSWordsMonster"));
	
	if (swordKills == 100 && my_familiar() == lookupFamiliar("sword of s words")) {
		description.listAppend("Target: " + HTMLGenerateSpanFont(swordTarget, "blue") + "");
		description.listAppend(swordChangesLeft + " S-Sword re-targets left.");
		task_entries.listAppend(ChecklistEntryMake("__familiar sword of s words", url, ChecklistSubentryMake(HTMLGenerateSpanFont("No more S-Sword drops", "red"), description), -11).ChecklistEntrySetIDTag("sword kills"));
	}
	else if (swordKills < 100 && my_familiar() == lookupFamiliar("sword of s words")) {
		description.listAppend("Target: " + HTMLGenerateSpanFont(swordTarget, "blue") + "");
		task_entries.listAppend(ChecklistEntryMake("__familiar sword of s words", url, ChecklistSubentryMake(HTMLGenerateSpanFont((100 - swordKills) + " S-Sword drops left", "black"), description), -11).ChecklistEntrySetIDTag("s-sword kills"));
	}
}

RegisterResourceGenerationFunction("IOTMSwordofSWordsGenerateResource");
void IOTMSwordofSWordsGenerateResource(ChecklistEntry [int] resource_entries)
{
	if (!lookupFamiliar("sword of s words").familiar_is_usable()) return;
	string url = "familiar.php";
	string [int] description;
	
	int swordKills = get_property_int("_swordOfSWordsKills");
	int swordChangesLeft = clampi(3 - get_property_int("_swordOfSWordsMonsterChanged"), 0, 3);
	monster swordTarget = to_monster(get_property("swordOfSWordsMonster"));
	string title;
	
	if (swordKills == 100) {
		title = (HTMLGenerateSpanFont("No more S-Sword drops", "red"));
		description.listAppend("Target: " + HTMLGenerateSpanFont(swordTarget, "blue") + "");
	}
	else if (swordKills < 100) {
		title = (HTMLGenerateSpanFont((100 - swordKills) + " S-Sword drops left", "black"));
		description.listAppend("Target: " + HTMLGenerateSpanFont(swordTarget, "blue") + "");
		description.listAppend(swordChangesLeft + " S-Sword re-targets left.");
	}
	resource_entries.listAppend(ChecklistEntryMake("__familiar sword of s words", url, ChecklistSubentryMake(title, description), 11));
}
