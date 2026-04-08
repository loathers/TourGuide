//monodent of the sea
RegisterResourceGenerationFunction("IOTMMonodentGenerateResource");
void IOTMMonodentGenerateResource(ChecklistEntry [int] resource_entries)
{
    // TODO: tile updates:
    //   - remove indigo/blue, no need for color on this


	if (__iotms_usable[lookupItem("monodent of the sea")]) return;
	
    string url = "inventory.php?ftext=dent+of+the+sea";
	int monodentLightningsLeft = clampi(11 - get_property_int("_seadentLightningUsed"), 0, 11);
    boolean monodentWaveUsed = get_property_boolean("_seadentWaveUsed");
	string monodentWaveZone = get_property("_seadentWaveZone");
	string [int] description;
	string title = "Monodent/Seadent powers";
	
	if (!monodentWaveUsed) {
		description.listAppend(HTMLGenerateSpanFont("Flood a zone for +30% item/meat", "blue"));		
	}
	else if (monodentWaveUsed) {
		description.listAppend(HTMLGenerateSpanFont(monodentWaveZone + " flooded, +30 item/meat", "indigo"));	
		if ($effect[fishy].have_effect() < 1 && lookupItem("monodent of the sea").equipped_amount() == 0) {
			description.listAppend(HTMLGenerateSpanFont("Equip Monodent for Fishy?", "red"));		
		}		
	}
	if (monodentLightningsLeft > 0) {
		description.listAppend("Killbanish, preserves drops. " + monodentLightningsLeft + " left.");
	}
	
	int monodentUpgrades = get_property_int("seadentConstructKills");
	if (monodentUpgrades < 100) {
		int constructsNeededForNextPerk = floor(sqrt(monodentUpgrades) + 1) ** 2 - monodentUpgrades;
        description.listAppend("Current upgrades: " + monodentUpgrades + "/100");
        description.listAppend((HTMLGenerateSpanFont(constructsNeededForNextPerk, "blue")) + " constructs needed for upgrade");
    }
	if (lookupItem("monodent of the sea").equipped_amount() == 0)
    {
		description.listAppend(HTMLGenerateSpanFont("Equip the Seadent first", "red"));		
	}
	if (lookupItem("monodent of the sea").equipped_amount() > 0)
	{
		description.listAppend(HTMLGenerateSpanFont("Seadent lightning ready!", "blue"));		
	}
	resource_entries.listAppend(ChecklistEntryMake("__item monodent of the sea", url, ChecklistSubentryMake(title, "", description)));
}