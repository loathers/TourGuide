// Sept-Ember Censer
RegisterResourceGenerationFunction("IOTMSeptemberCenserGenerateResource");
void IOTMSeptemberCenserGenerateResource(ChecklistEntry [int] resource_entries) {
	if (!__iotms_usable[lookupItem("Sept-Ember Censer")]) return;

	int septEmbers = get_property_int("availableSeptEmbers");

    // Tile is unnecessary if you don't have embers remaining.
	if (septEmbers == 0) return;

	string [int] description;
	string title = "Spend your "+pluralise(septEmbers,"ember","embers");

	// General amount counts
	int bembershootCount = lookupItem("bembershoot").available_amount();
	boolean canUseMouthwash = true;

	if (my_path().id == PATH_GREY_YOU) canUseMouthwash = false;
	if (my_path().id == PATH_ZOOTOMIST) canUseMouthwash = false;
	if (my_path().id == PATH_MEAT) canUseMouthwash = false;

	description.listAppend("Stoke the embers in your Sept-Ember Censer");
	description.listAppend(`|*1 embers: +5 cold res accessory (You have {HTMLGenerateSpanFont(bembershootCount, "red")})`);
	if (canUseMouthwash && septEmbers > 1 && my_level() < 13 && __misc_state["in run"]) {
		// Math for the statgain from spading
		float coldResistance = numeric_modifier("cold resistance");
		int mainstatGain = (7 * (coldResistance) ** 1.7) * (1.0 + numeric_modifier(my_primestat().to_string() + " Experience Percent") / 100.0);
		int mouthwashCount = lookupItem("Mmm-brr! brand mouthwash").available_amount();
		description.listAppend(`|*2 embers: mmm-brr! mouthwash for {HTMLGenerateSpanFont(mainstatGain, "blue")} mainstat. (You have {HTMLGenerateSpanFont(mouthwashCount, "red")})`);
	}

	if (!get_property_boolean("_structuralEmberUsed") && septEmbers > 3 && get_property_int("chasmBridgeProgress") < 30 && !questPropertyPastInternalStepNumber("questL09Topping", 2)) {
		description.listAppend("|*4 embers: +5/5 bridge parts (1/day)");
	}

	if (!lookupFamiliar("Emberiza Aureola").have_familiar()) {
		if (!get_property_boolean("_emberingHulkFought") && septEmbers > 5) {
			description.listAppend("|*6 embers: embering hulk (1/day)");
		}
		int hunkCount = lookupItem("embering hunk").available_amount();
		if (!__misc_state["in run"]) description.listAppend(`(You have {HTMLGenerateSpanFont(hunkCount, "blue")} hunks)`);
	}
	resource_entries.listAppend(ChecklistEntryMake("__item sept-ember censer", "shop.php?whichshop=september", ChecklistSubentryMake(title, "", description), 8));
}

// Helper function on the KoLmafia wiki that I just decided to use for this
float roundFloat(float number, int place) {
    float value = round(number*10.00**-place)*10.0**place; 
    return value;
}

RegisterTaskGenerationFunction("MmmBrrMouthwashGenerateTask");
void MmmBrrMouthwashGenerateTask(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries) {

    // Check a few things. Don't need this tile over level 11.
    int mouthwashCount = $item[Mmm-brr! brand mouthwash].available_amount();
    boolean doNotNeedToLevel = my_level() > 11;

    if (my_path().id == PATH_GREY_YOU) return;
    if (my_path().id == PATH_ZOOTOMIST) return;
    if (my_path().id == PATH_MEAT) return;

    if (mouthwashCount == 0 || doNotNeedToLevel) return;

    string [int] description;
    string url = "inventory.php?ftext=brand+mouthwash";
    string main_title = "Level up with your Mmm-brr Mouthwash";  
    string subtitle;

    // Math for the statgain from spading
    float coldResistance = numeric_modifier("cold resistance");
    int mainstatGain = (7 * (coldResistance) ** 1.7) * (1.0 + numeric_modifier(my_primestat().to_string() + " Experience Percent") / 100.0);
    float levelFromMouthwash = roundFloat(square_root(my_basestat(my_primestat()) + mainstatGain*mouthwashCount),2);

    subtitle="currently @ " + coldResistance + " cold res";

    description.listAppend("You currently have "+pluralise(mouthwashCount, "mouthwash","mouthwashes")+" at "+mainstatGain+" mainstat apiece");
    description.listAppend("|*Will gain "+(mainstatGain*mouthwashCount)+" stats when used");
    description.listAppend("|*This will get you to level "+levelFromMouthwash);

    if (levelFromMouthwash < 12) {
        description.listAppend("Consider stacking more "+HTMLGenerateSpanOfClass("cold resistance", "r_element_cold")+" for a higher level");
    }

    // FIXME: add possible recommendations for obvious sources? probably a nice hoverover thing...

    optional_task_entries.listAppend(ChecklistEntryMake("__item mmm-brr mouthwash", url, ChecklistSubentryMake(main_title, subtitle, description), 8).ChecklistEntrySetIDTag("mmm brr mouthwash math"));
    

}