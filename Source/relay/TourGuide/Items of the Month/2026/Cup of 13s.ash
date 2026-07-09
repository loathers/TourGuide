//cup of 13s
RegisterResourceGenerationFunction("IOTMCupof13sGenerateResource");
void IOTMCupof13sGenerateResource(ChecklistEntry [int] resource_entries)
{
	if (available_amount($item[cup of 13s]) > 0) {
		string url = "inventory.php?pwd=" + my_hash() + "&action=cupof13s";
		string [int] description;
		
		int Cupof13GemsLeft = get_property_int("_cupOf13sJewels");
		string title = (HTMLGenerateSpanFont(Cupof13GemsLeft, "blue") + " Cup of 13s advs");
		
		if (Cupof13GemsLeft > 0) {
			description.listAppend("Drink 1 liver for 13 advs " + HTMLGenerateSpanFont("", "blue") + "");
			description.listAppend("2x snow cleats + gingerbread cigarette?");
			resource_entries.listAppend(ChecklistEntryMake("__item cup of 13s", url, ChecklistSubentryMake(title, description), -11));
		}
	}
}
