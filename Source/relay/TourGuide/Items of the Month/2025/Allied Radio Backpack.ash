//allied radio backpack
RegisterResourceGenerationFunction("IOTTAlliedRadioBackpackGenerateResource");
void IOTTAlliedRadioBackpackGenerateResource(ChecklistEntry [int] resource_entries)
{
    if ($item[allied radio backpack].available_amount() == 0) return;
	
    string url = "inventory.php?action=requestdrop&pwd=" + my_hash();
	int radioDropsLeft = clampi(3 - get_property_int("_alliedRadioDropsUsed"), 0, 3);
    boolean usedIntel = get_property_boolean("_alliedRadioMaterielIntel");
	string [int] description;
	string title = HTMLGenerateSpanFont(radioDropsLeft + " Allied Radio Drops", "black");
	
	if (radioDropsLeft > 0) 
	{
		description.listAppend("Request an airdrop!");
		description.listAppend("|*SNIPER SUPPORT for +1 Sneak! +100% item, or weak turngen");
		if (!usedIntel) description.listAppend("|*MATERIAL INTEL for 10 turns of +100% item!");
		description.listAppend("|*FUEL or RATIONS for weak turngen");
		resource_entries.listAppend(ChecklistEntryMake("__item allied radio backpack", url, ChecklistSubentryMake(title, "", description)));
	}
}