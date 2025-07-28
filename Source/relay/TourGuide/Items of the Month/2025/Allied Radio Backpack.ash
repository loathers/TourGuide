//allied radio backpack
RegisterResourceGenerationFunction("IOTTAlliedRadioBackpackGenerateResource");
void IOTTAlliedRadioBackpackGenerateResource(ChecklistEntry [int] resource_entries)
{
    if ($item[allied radio backpack].available_amount() == 0) return;
	
    string url = "inventory.php?action=requestdrop&pwd=" + my_hash();
	int radioDropsLeft = clampi(3 - get_property_int("_alliedRadioDropsUsed"), 0, 3);
	string [int] description;
	string title = HTMLGenerateSpanFont(radioDropsLeft + " Allied Radio Drops", "black");
	
	if (radioDropsLeft > 0) 
	{
		description.listAppend("Request an airdrop!");
		description.listAppend("Sneak, +100% item, or weak turngen");
		resource_entries.listAppend(ChecklistEntryMake("__item allied radio backpack", url, ChecklistSubentryMake(title, "", description)));
	}
}
