//Familiar scrapbook
RegisterResourceGenerationFunction("IOTMFamiliarScrapbookGenerateResource");
void IOTMFamiliarScrapbookGenerateResource(ChecklistEntry [int] resource_entries)
{
	// Title
	string main_title = "Familiar scraps";
	string [int] description;

	// Entries
	int familiar_scraps = get_property_int("scrapbookCharges");
	int familiar_scrap_banishes = familiar_scraps / 100;
	
	if (available_amount($item[familiar scrapbook]) > 0) {
		if (familiar_scraps < 100) {
			description.listAppend(familiar_scraps + " /100 scraps until a banish is available.");
		} 
		else {
			description.listAppend(familiar_scraps + " scraps collected.");
		}

		description.listAppend("Charge up your familiar scrapbook by letting familiars act in combat.");
		if (!have_equipped($item[familiar scrapbook]))
			description.listAppend(HTMLGenerateSpanFont("Equip the familiar scrapbook first", "red"));
				
		resource_entries.listAppend(ChecklistEntryMake("__item familiar scrapbook", "url", ChecklistSubentryMake(familiar_scraps / 100 + " scrapbook banishes available", "", description)).ChecklistEntrySetCombinationTag("banish").ChecklistEntrySetIDTag("Familiar scrapbook boring pictures banish"));
	}
}
