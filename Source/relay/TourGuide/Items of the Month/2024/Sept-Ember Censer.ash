// Sept-Ember Censer
RegisterResourceGenerationFunction("IOTMSeptemberCenserGenerateResource");
void IOTMSeptemberCenserGenerateResource(ChecklistEntry [int] resource_entries) {
	if (!__iotms_usable[lookupItem("Sept-Ember Censer")]) return;

	int septEmbers = get_property_int("availableSeptEmbers");
	if (septEmbers < 1) return;

	string [int] description;
	if (septEmbers > 0)	{
		description.listAppend(`Have {HTMLGenerateSpanFont(septEmbers, "red")} Sept-Embers to make stuff with!`);
	}

	if (my_level() < 13 && __misc_state["in run"]) {
		int bembershootCount = lookupItem("bembershoot").available_amount();
		description.listAppend(`1 embers: +5 cold res accessory (You have {HTMLGenerateSpanFont(bembershootCount, "red")})`);
		int mouthwashCount = lookupItem("Mmm-brr! brand mouthwash").available_amount();
		float coldResistance = numeric_modifier("cold resistance");
		int mainstatGain = (7 * (coldResistance) ** 1.7) * (1.0 + numeric_modifier(my_primestat().to_string() + " Experience Percent") / 100.0);
		description.listAppend(`2 embers: mmm-brr! mouthwash for {HTMLGenerateSpanFont(mainstatGain, "blue")} mainstat. (You have {HTMLGenerateSpanFont(mouthwashCount, "red")})`);
	}

	if (!get_property_boolean("_structuralEmberUsed") && septEmbers > 3 && get_property_int("chasmBridgeProgress") < 30 && !questPropertyPastInternalStepNumber("questL09Topping", 2)) {
		description.listAppend("4 embers: +5/5 bridge parts (1/day)");
	}

	if (!lookupFamiliar("Emberiza Aureola").have_familiar()) {
		if (!get_property_boolean("_emberingHulkFought") && septEmbers > 5) {
			description.listAppend("6 embers: fight embering hulk (1/day)");
		}
		int hunkCount = lookupItem("embering hunk").available_amount();
		description.listAppend(`(You have {HTMLGenerateSpanFont(hunkCount, "red")} hunks)`);
	}

	resource_entries.listAppend(ChecklistEntryMake("__item sept-ember censer", "shop.php?whichshop=september", ChecklistSubentryMake("Sept-Ember Censer", "", description), 8));
}
