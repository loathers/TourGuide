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
		description.listAppend("|*" + HTMLGenerateSpanOfClass("SNIPER SUPPORT", "r_bold") + " for a sneak!");
		if (!usedIntel) description.listAppend("|*" + HTMLGenerateSpanOfClass("MATERIAL INTEL", "r_bold") + " for +100% item! "+HTMLGenerateSpanFont("(10 turns)", "gray", "0.9em"));
		description.listAppend("|*" + HTMLGenerateSpanOfClass("FUEL or RATIONS", "r_bold") + " for weak turngen!");
		resource_entries.listAppend(ChecklistEntryMake("__item allied radio backpack", url, ChecklistSubentryMake(title, "", description)));
	}
}