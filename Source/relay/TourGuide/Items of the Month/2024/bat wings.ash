// Bat Wings
RegisterTaskGenerationFunction("IOTMRomanBatWingsTasks");
void IOTMRomanBatWingsTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries) {
	if (!__iotms_usable[lookupItem("bat wings")]) return;

	string [int] description;
	string url;
	// 25 bridge parts
	if (get_property_int("chasmBridgeProgress") >= 25 && !questPropertyPastInternalStepNumber("questL09Topping", 2)) {
		if (!lookupItem("bat wings").equipped()) {
			url = "inventory.php?ftext=bat+wings";
			description.listAppend(HTMLGenerateSpanFont("Equip the bat wings first.", "red"));
		}	else {
			url = "place.php?whichplace=orc_chasm";
			description.listAppend(HTMLGenerateSpanFont("Leap across the bridge!", "blue"));
		}
		task_entries.listAppend(ChecklistEntryMake("__item miniature suspension bridge", url, ChecklistSubentryMake("Bat wings to cross the chasm!", "", description), -11));
	}
	// TODO: expand this for in-run resources.
}

RegisterResourceGenerationFunction("IOTMBatWingsGenerateResource");
void IOTMBatWingsGenerateResource(ChecklistEntry [int] resource_entries) {
	if (!__iotms_usable[lookupItem("bat wings")]) return;
  int batWingSwoopsLeft = clampi(11 - get_property_int("_batWingsSwoopUsed"), 0, 11);
	int batWingRestsLeft = clampi(11 - get_property_int("_batWingsRestUsed"), 0, 11);
	int batWingFreeFlapsLeft = clampi(5 - get_property_int("_batWingsFreeFights"), 0, 5);
	if (batWingSwoopsLeft > 0) {
		string [int] description;
		string url = "";
		description.listAppend("Swoop like a Bat: Guaranteed Steal.");
		if (!lookupItem("bat wings").equipped()) {
			description.listAppend(HTMLGenerateSpanFont("Equip your bat wings.", "red"));
			url = "inventory.php?ftext=bat+wings";
		}
		resource_entries.listAppend(ChecklistEntryMake("__item bat wings", url, ChecklistSubentryMake(pluralise(batWingSwoopsLeft, "Bat Wings Swoop", "Bat Wings Swoops"), description), 0).ChecklistEntrySetCombinationTag("steals").ChecklistEntrySetIDTag("Bat Wings Swoops"));
	}
	if (batWingRestsLeft > 0) {
		string [int] description;
		string url = "";
		description.listAppend("Rest upside down: +1000 HP/MP.");
		if (!lookupItem("bat wings").equipped()) {
			description.listAppend(HTMLGenerateSpanFont("Equip your bat wings.", "red"));
			url = "inventory.php?ftext=bat+wings";
		}
		resource_entries.listAppend(ChecklistEntryMake("__item bat wings", url, ChecklistSubentryMake(pluralise(batWingRestsLeft, "Bat Wings Rest", "Bat Wings Rests"), description), 0).ChecklistEntrySetCombinationTag("regen").ChecklistEntrySetIDTag("Bat Wings heals"));
	}
	if (batWingFreeFlapsLeft > 0) {
		string [int] description;
		string url = "";
		description.listAppend("Win a fight without taking a turn (triggers randomly).");
		if (!lookupItem("bat wings").equipped()) {
			description.listAppend(HTMLGenerateSpanFont("Equip your bat wings.", "red"));
			url = "inventory.php?ftext=bat+wings";
		}
		resource_entries.listAppend(ChecklistEntryMake("__item bat wings", url, ChecklistSubentryMake(pluralise(batWingFreeFlapsLeft, "Bat Wings Free Fight", "Bat Wings Free Fights"), description), 0).ChecklistEntrySetCombinationTag("free instakill").ChecklistEntrySetIDTag("Bat Wings free fights"));
	}
}
