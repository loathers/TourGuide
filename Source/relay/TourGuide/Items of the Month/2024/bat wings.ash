// Bat Wings
RegisterTaskGenerationFunction("IOTMRomanBatWingsTasks");
void IOTMRomanBatWingsTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	if (lookupItem("bat wings").available_amount() == 0) return;

	string [int] description;
	string url;
	// 25 bridge parts
	if (get_property_int("chasmBridgeProgress") >= 25 && !questPropertyPastInternalStepNumber("questL09Topping", 2)) 
	{
		if (lookupItem("bat wings").equipped_amount() == 0) {
			url = "inventory.php?ftext=bat+wings";
			description.listAppend(HTMLGenerateSpanFont("Equip the bat wings first.", "red"));
		}	else {
			url = "place.php?whichplace=orc_chasm";
			description.listAppend(HTMLGenerateSpanFont("Leap across the bridge!", "blue"));
		}
		task_entries.listAppend(ChecklistEntryMake("__item miniature suspension bridge", url, ChecklistSubentryMake("Bat wings to cross the chasm!", "", description), -11));
	}
}

RegisterResourceGenerationFunction("IOTMBatWingsGenerateResource");
void IOTMBatWingsGenerateResource(ChecklistEntry [int] resource_entries)
{
	if (lookupItem("bat wings").available_amount() == 0) return;

  int batWingSwoopsLeft = clampi(11 - get_property_int("_batWingsSwoopUsed"), 0, 11);
	int batWingRestsLeft = clampi(11 - get_property_int("_batWingsRestUsed"), 0, 11);
	int batWingFreeFlapsLeft = clampi(5 - get_property_int("_batWingsFreeFights"), 0, 5);
	int bridge = get_property_int("chasmBridgeProgress");
	boolean guanoBat = get_property_boolean("batWingsGuanoJunction");

	if (batWingSwoopsLeft == 0 &&
			batWingRestsLeft == 0 &&
			batWingFreeFlapsLeft == 0 &&
			(bridge >= 30 || questPropertyPastInternalStepNumber("questL09Topping", 2)) &&
			(guanoBat || questPropertyPastInternalStepNumber("questL10Garbage", 2)) &&
			questPropertyPastInternalStepNumber("questL10Garbage", 8)) {
				return;
			}

  string [int] description;
	string url = "inventory.php?ftext=bat+wings";
	
	if (lookupItem("bat wings").equipped_amount() == 0)
	{
		description.listAppend(HTMLGenerateSpanFont("Equip your bat wings.", "red"));
	}
	if (!$location[The Castle in the Clouds in the Sky (Basement)].locationAvailable()) {
    description.listAppend(HTMLGenerateSpanFont("This saves turns in the Airshit!", "blue"));
	}
	if (batWingSwoopsLeft > 0)
	{
		description.listAppend("Swoop Evilpockets: " + (HTMLGenerateSpanOfClass(batWingSwoopsLeft, "r_bold")) + " left.");
	}
	if (batWingRestsLeft > 0)
	{
		description.listAppend("Rest +1000 HP/MP: " + (HTMLGenerateSpanOfClass(batWingRestsLeft, "r_bold")) + " left.");
	}
	if (batWingFreeFlapsLeft > 0)
	{
		description.listAppend("Free flaps: " + (HTMLGenerateSpanOfClass(batWingFreeFlapsLeft, "r_bold")) + " left.");
	}
	
	if (bridge >= 25 && !questPropertyPastInternalStepNumber("questL09Topping", 2)) {
		description.listAppend("You can skip the rest of the bridge!");
	}
	if ($locations[The Penultimate Fantasy Airship] contains __last_adventure_location && !questPropertyPastInternalStepNumber("questL10Garbage", 8)) {
		description.listAppend("Saves turns hunting for Immateria/S.O.C.K!");
	}
		
	if (!guanoBat && !questPropertyPastInternalStepNumber("questL10Garbage", 2)) {
		description.listAppend("Visit the Bat Hole zones to unlock the Beanbat Chamber and get a bean");
	}

	resource_entries.listAppend(ChecklistEntryMake("__item bat wings", url, ChecklistSubentryMake("Bat Wings functions", "", description), 8));
}
