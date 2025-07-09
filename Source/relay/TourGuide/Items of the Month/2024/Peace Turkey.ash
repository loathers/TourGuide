RegisterResourceGenerationFunction("IOTMPeaceTurkeyGenerateResource");
void IOTMPeaceTurkeyGenerateResource(ChecklistEntry [int] resource_entries)
{
	string getNextDrop() {
		// Whirled Peas -> Olive/Jumbo Olive -> HP/MP Restoration -> Helping Fingers buff -> Whirled Peas -> Piece of Cake -> basic Advanced Cocktailcrafting drink -> Peace Shooter
		switch (get_property_int("peaceTurkeyIndex")) {
			case 7:
				return "Peace Shooter (3 turns stun combat item)";
			case 6:
				return "basic Advanced Cocktailcrafting drink";
			case 5:
				return "Piece of Cake (size 1 awesome quality food)";
			case 3:
				return "Helping Fingers buff (3 turns +100% Weapon Damage)";
			case 2:
				return "HP/MP Restoration";
			case 1:
				return "Olive/Jumbo Olive";
			default:
				return "Whirled Peas";
		}
	}
	if (!lookupFamiliar("Peace Turkey").familiar_is_usable()) return;

	int turkeyProc = 24 + sqrt(effective_familiar_weight(lookupFamiliar("Peace Turkey")) + weight_adjustment());	
	string [int] description;
	string url = "familiar.php";
	description.listAppend("Next drop: " + getNextDrop());
	description.listAppend("Can trigger on free runaways!");
	resource_entries.listAppend(ChecklistEntryMake("__familiar peace turkey", url, ChecklistSubentryMake(HTMLGenerateSpanFont(turkeyProc +"% Peace Turkey proc", "black"), "", description), 2).ChecklistEntrySetCombinationTag("familiar drops"));
}

RegisterResourceGenerationFunction("IOTMSplitPeaSoupGenerateResource");
void IOTMSplitPeaSoupGenerateResource(ChecklistEntry [int] resource_entries)
{
	if (lookupitem("handful of split pea soup").have())
	{
		resource_entries.listAppend(ChecklistEntryMake("__item handful of split pea soup", "", ChecklistSubentryMake(pluralise(lookupitem("handful of split pea soup")), "", "Free run/banish. Also have " + available_amount(lookupitem("whirled peas")) + " peas."), 0).ChecklistEntrySetCombinationTag("banish").ChecklistEntrySetIDTag("Purkey banish"));
	}
}
