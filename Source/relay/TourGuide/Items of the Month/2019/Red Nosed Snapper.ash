RegisterResourceGenerationFunction("IOTMRedNosedSnapperResource");
void IOTMRedNosedSnapperResource(ChecklistEntry [int] resource_entries)
{
    ChecklistSubentry getPhylumRewards() {
        // Title
        string redSnapperPhylum = get_property("redSnapperPhylum");
        int redSnapperProgress = get_property_int("redSnapperProgress");
		string main_title = redSnapperProgress + "/11 fights until next Snapper drop";
        
        // Subtitle
        string subtitle = "";

        // Entries
        string [int] description;
        if (redSnapperPhylum != "") 
		{
			description.listAppend("Tracked phylum gains +2 copies per monster.");
			string snapperPhylum = get_property("redSnapperPhylum");
			description.listAppend(HTMLGenerateSpanFont("Currently tracking " + redSnapperPhylum + "-type.", "blue"));
			description.listAppend("Red Zeppelin - track Dudes.");
			description.listAppend("The Palindrome - track Dudes.");
			description.listAppend("Twin Peak - track Beasts.");
			description.listAppend("Whitey's Grove - track Beasts.");		
			description.listAppend("The Haunted Laundry Room - track Undead");
			description.listAppend("The Haunted Wine Cellar - track Constructs.");
			description.listAppend(HTMLGenerateSpanFont("WARNING: changing phylum resets progress.", "red"));
            description.listAppend(HTMLGenerateSpanOfClass("Dudes:", "r_bold") + " Free banish item");
            description.listAppend(HTMLGenerateSpanOfClass("Goblins:", "r_bold") + " 3-size " + HTMLGenerateSpanOfClass("awesome", "r_element_awesome") + " food");
            description.listAppend(HTMLGenerateSpanOfClass("Orcs:", "r_bold") + " 3-size " + HTMLGenerateSpanOfClass("awesome", "r_element_awesome") + " booze");
            description.listAppend(HTMLGenerateSpanOfClass("Undead:", "r_bold") + " +5 " + HTMLGenerateSpanOfClass("spooky", "r_element_spooky") + " res potion");
            description.listAppend(HTMLGenerateSpanOfClass("Constellations:", "r_bold") + " Yellow ray");
        }

        return ChecklistSubentryMake(main_title, subtitle, description);
    }

	if (!lookupFamiliar("Red Nosed Snapper").familiar_is_usable()) return;

	int muskBanishes_left = clampi(3 - get_property_int("_humanMuskUses"), 0, 3);
	if ($item[human musk].available_amount() > 0 && in_ronin() && $item[human musk].item_is_usable())
    {
        resource_entries.listAppend(ChecklistEntryMake("__item human musk", "", ChecklistSubentryMake(pluralise($item[human musk]), "", "" + muskBanishes_left + " free uses left today."), 6).ChecklistEntryTagEntry("banish"));
    }

    ChecklistEntry entry;
    entry.image_lookup_name = "__familiar red-nosed snapper";

    ChecklistSubentry rewards = getPhylumRewards();
    if (rewards.entries.count() > 0) {
        entry.subentries.listAppend(rewards);
    }

    if (entry.subentries.count() > 0) {
        resource_entries.listAppend(entry);
    }
}