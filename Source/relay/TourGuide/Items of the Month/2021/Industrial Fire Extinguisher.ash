//Industrial fire extinguisher
RegisterResourceGenerationFunction("IOTMFireExtinguisherGenerateResource");
void IOTMFireExtinguisherGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (!lookupItem("industrial fire extinguisher").have()) return;
		// Title
        string [int] description;
		string [int] options;

		// Entries
		int extinguisher_charge = get_property_int("_fireExtinguisherCharge");
		boolean extinguisher_refill = get_property_boolean("_fireExtinguisherRefilled");
		boolean is_on_fire = my_path_id() == 43; // Path 43 is Wildfire.

		string url = "inventory.php?ftext=industrial+fire+extinguisher";
		description.listAppend("Extinguish the fires in your life!");
		if (extinguisher_charge > 5) 
		{
            description.listAppend(HTMLGenerateSpanOfClass("Blast the Area (5% charge):", "r_bold") + " 1 turn of passive damage.");
			description.listAppend(HTMLGenerateSpanOfClass("Foam 'em Up (5% charge):", "r_bold") + " Stun!");
		if (extinguisher_charge >= 10)
			description.listAppend(HTMLGenerateSpanOfClass("Foam Yourself (10% charge):", "r_bold") + " 1 turn of +30 Hot Resist.");
			description.listAppend(HTMLGenerateSpanOfClass("Polar Vortex (10% charge):", "r_bold") + " Hugpocket duplicator, usable more than once per fight.");
        } 
	
	    
		if (__misc_state["in run"] && is_on_fire && !get_property_boolean("_fireExtinguisherRefilled") )
		{
			string description = "Tank refill available";
			resource_entries.listAppend(ChecklistEntryMake("__item fireman's helmet", "place.php?whichplace=wildfire_camp&action=wildfire_captain", ChecklistSubentryMake("Tank refill available", "", description)).ChecklistEntrySetIDTag("Tank refill resource"));
		}   
	
		if (!lookupItem("industrial fire extinguisher").equipped())
            description.listAppend(HTMLGenerateSpanFont("Equip the fire extinguisher first.", "red"));

		if (__misc_state["in run"] && my_path_id() != 25 && extinguisher_charge > 19) // Path 25 is Community Service.
		{
			if (!get_property_boolean("fireExtinguisherBatHoleUsed") && !__quest_state["Level 4"].finished);
			{
				options.listAppend(HTMLGenerateSpanOfClass("Bat Hole:", "r_bold") + " Unlock next zone for free.");
			}
			if (!get_property_boolean("fireExtinguisherHaremUsed") && !__quest_state["Level 5"].finished);
			{
				options.listAppend(HTMLGenerateSpanOfClass("Cobb's Knob Harem:", "r_bold") + " Get harem outfit for free.");
            }
			if (!get_property_boolean("fireExtinguisherCyrptUsed") && !__quest_state["Level 7"].finished);
			{
				options.listAppend(HTMLGenerateSpanOfClass("The Cyrpt:", "r_bold") + " -10 Evilness in one zone.");
            }
			if (!get_property_boolean("fireExtinguisherChasmUsed") && !__quest_state["Level 9"].finished);
			{
				options.listAppend(HTMLGenerateSpanOfClass("Smut Orc Logging Camp:", "r_bold") + " +66% Blech House progress.");
            }
			if (!get_property_boolean("fireExtinguisherDesertUsed") && !locationAvailable($location[The Upper Chamber]) == true);
			{
				options.listAppend(HTMLGenerateSpanOfClass("Arid, Extrawhatever Desert:", "r_bold") + " Ultrahydrated (15 advs).");
            }

		if (options.count() > 0)
			description.listAppend(HTMLGenerateSpanOfClass("Zone-specific skills (20% charge):", "r_bold") + " 1/ascension special options in the following zones:|*-" + options.listJoinComponents("|*-"));
        }	
        		
		resource_entries.listAppend(ChecklistEntryMake("__item industrial fire extinguisher", url, ChecklistSubentryMake(extinguisher_charge + "% fire extinguisher available", "", description)).ChecklistEntrySetIDTag("industrial fire extinguisher skills resource"));
}