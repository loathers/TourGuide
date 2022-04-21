//Power Plant
RegisterResourceGenerationFunction("IOTMPowerPlantGenerateResource");
void IOTMPowerPlantGenerateResource(ChecklistEntry [int] resource_entries)
{
	if (!lookupItem("potted power plant").have())
		return;
	// Title
	string main_title = "Power plant batteries";
	string [int] description;
	string batteriesToHarvest = (get_property("_pottedPowerPlant"));
	// Entries
	if (batteriesToHarvest != "0,0,0,0,0,0,0")
	{
		string [int] harvest;
		harvest.listAppend("Harvest your potted power plant batteries.");
		resource_entries.listAppend(ChecklistEntryMake("__item potted power plant", "inv_use.php?pwd=" + my_hash() + "&whichitem=10738", ChecklistSubentryMake("Power plant batteries", "", harvest), 1));
	}

	int batteryTotalCharge;
	for i from 1 to 6
	{
		batteryTotalCharge += i*available_amount(to_item(10738+i));
	}
	if (batteryTotalCharge > 3)
	{
		description.listAppend(HTMLGenerateSpanFont("This free kill is also a yellow ray!", "orange"));
		if (batteriesToHarvest != "0,0,0,0,0,0,0") {
			description.listAppend("(Harvest your batteries for a more accurate count.)");
		}
		description.listAppend("Alternatively, make " + HTMLGenerateSpanOfClass(batteryTotalCharge / 5, "r_bold") + " lantern batteries for +100% item drops.");
		description.listAppend("Alternatively, make " + HTMLGenerateSpanOfClass(batteryTotalCharge / 6, "r_bold") + " car batteries for +100% item/meat drops.");
		description.listAppend("Total charge: " + HTMLGenerateSpanOfClass(batteryTotalCharge, "r_bold") + "");
		resource_entries.listAppend(ChecklistEntryMake("__item eternal car battery", "url", ChecklistSubentryMake((get_property_int("shockingLickCharges") + (batteryTotalCharge / 4)) + " shocking licks available", "", description), 0).ChecklistEntrySetCombinationTag("free instakill").ChecklistEntrySetIDTag("Shocking lick free kill"));
	}
}