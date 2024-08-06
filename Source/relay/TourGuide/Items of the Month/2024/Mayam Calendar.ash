//Mayam calendar
RegisterResourceGenerationFunction("IOTMMayamCalendarGenerateResource");
void IOTMMayamCalendarGenerateResource(ChecklistEntry [int] resource_entries)
{
	string [int] description;
	if (__misc_state["in run"] && available_amount($item[mayam calendar]) > 0 && my_path().id != PATH_COMMUNITY_SERVICE)
	{
		string url = "inv_use.php?pwd=" + my_hash() + "&which=99&whichitem=11572";
		int TempleResetAscension = get_property_int("lastTempleAdventures");
		description.listAppend("Happy Mayam New Year!");
		
		if (!get_property("_mayamSymbolsUsed").contains_text("yam4") && !get_property("_mayamSymbolsUsed").contains_text("clock") && !get_property("_mayamSymbolsUsed").contains_text("explosion") && (my_ascensions() == TempleResetAscension))
		{
			description.listAppend(HTMLGenerateSpanOfClass("1st ring:", "r_bold") + "");
			if (!get_property("_mayamSymbolsUsed").contains_text("yam1")) {
				description.listAppend(HTMLGenerateSpanOfClass("A yam", "r_bold") + ": craftable ingredient");
			}
			if (!get_property("_mayamSymbolsUsed").contains_text("sword")) {
				description.listAppend(HTMLGenerateSpanOfClass("Sword", "r_bold") + ": +" + min(150,10*my_level()) + " mus stats");
			}
			if (!get_property("_mayamSymbolsUsed").contains_text("vessel")) {
				description.listAppend(HTMLGenerateSpanOfClass("Vessel", "r_bold") + ": +1000 MP");
			}
			if (!get_property("_mayamSymbolsUsed").contains_text("fur")) {
				description.listAppend(HTMLGenerateSpanOfClass("Fur", "r_bold") + ": +100 Fxp");
			}
			if (!get_property("_mayamSymbolsUsed").contains_text("chair")) {
				description.listAppend(HTMLGenerateSpanOfClass("Chair", "r_bold") + ": +5 free rests");
			}
			if (!get_property("_mayamSymbolsUsed").contains_text("eye")) {
				description.listAppend(HTMLGenerateSpanOfClass("Eye", "r_bold") + ": +30% item for 100 advs");
			}
			
			description.listAppend(HTMLGenerateSpanFont(" ", "r_bold") + "");
			description.listAppend(HTMLGenerateSpanOfClass("2nd ring:", "r_bold") + "");
			if (!get_property("_mayamSymbolsUsed").contains_text("yam2")) {
				description.listAppend(HTMLGenerateSpanOfClass("Another yam", "r_bold") + ": craftable ingredient");
			}
			if (!get_property("_mayamSymbolsUsed").contains_text("lightning")) {
				description.listAppend(HTMLGenerateSpanOfClass("Lightning", "r_bold") + ": +" + min(150,10*my_level()) + " mys stats");
			}
			if (!get_property("_mayamSymbolsUsed").contains_text("bottle")) {
				description.listAppend(HTMLGenerateSpanOfClass("Bottle", "r_bold") + ": +1000 HP");
			}
			if (!get_property("_mayamSymbolsUsed").contains_text("wood")) {
				description.listAppend(HTMLGenerateSpanOfClass("Wood", "r_bold") + ": +4 bridge parts");
			}
			if (!get_property("_mayamSymbolsUsed").contains_text("meat")) {
				description.listAppend(HTMLGenerateSpanOfClass("Meat", "r_bold") + ": +" + min(150,10*my_level()) + " meat");
			}
			
			description.listAppend(HTMLGenerateSpanFont(" ", "r_bold") + "");
			description.listAppend(HTMLGenerateSpanOfClass("3rd ring:", "r_bold") + "");
			if (!get_property("_mayamSymbolsUsed").contains_text("yam3")) {
				description.listAppend(HTMLGenerateSpanOfClass("A third yam", "r_bold") + ": craftable ingredient");
			}
			if (!get_property("_mayamSymbolsUsed").contains_text("eyepatch")) {
				description.listAppend(HTMLGenerateSpanOfClass("Eyepatch", "r_bold") + ": +" + min(150,10*my_level()) + " mox stats");
			}
			if (!get_property("_mayamSymbolsUsed").contains_text("cheese")) {
				description.listAppend(HTMLGenerateSpanOfClass("Cheese", "r_bold") + ": +1 goat cheese");
			}
			if (!get_property("_mayamSymbolsUsed").contains_text("wall")) {
				description.listAppend(HTMLGenerateSpanOfClass("Wall", "r_bold") + ": +2 res for 100 advs");
			}
			
			description.listAppend(HTMLGenerateSpanFont(" ", "r_bold") + "");
			description.listAppend(HTMLGenerateSpanOfClass("4th ring:", "r_bold") + "");
			if (!get_property("_mayamSymbolsUsed").contains_text("yam4")) {
				description.listAppend(HTMLGenerateSpanOfClass("A fourth yam", "r_bold") + ": yep.");
			}
			if (!get_property("_mayamSymbolsUsed").contains_text("clock")) {
				description.listAppend(HTMLGenerateSpanOfClass("Clock", "r_bold") + ": +5 advs");
			}
			if (!get_property("_mayamSymbolsUsed").contains_text("explosion")) {
				description.listAppend(HTMLGenerateSpanOfClass("Explosion", "r_bold") + ": +5 fites");
			}
			
			string [int] Resonances;
			{
				Resonances.listAppend(HTMLGenerateSpanOfClass("15-turn banisher", "r_bold") + ": Vessel + Yam + Cheese + Explosion");
				Resonances.listAppend(HTMLGenerateSpanOfClass("Yam and swiss", "r_bold") + ": Yam + Meat + Cheese + Yam");
				Resonances.listAppend(HTMLGenerateSpanOfClass("+55% meat accessory", "r_bold") + ": Yam + Meat + Eyepatch + Yam");
				Resonances.listAppend(HTMLGenerateSpanOfClass("+100% Food drops", "r_bold") + ": Yam + Yam + Cheese + Clock");
			}
			if (Resonances.count() > 0)
			description.listAppend(HTMLGenerateSpanFont(" ", "r_bold") + "");
			description.listAppend(HTMLGenerateSpanFont(" ", "r_bold") + "");
			description.listAppend(HTMLGenerateSpanOfClass("Cool Mayam combos!", "r_bold") + Resonances.listJoinComponents("<hr>").HTMLGenerateIndentedText());
			
			if (my_ascensions() > TempleResetAscension) {
				description.listAppend(HTMLGenerateSpanFont("Temple reset available!", "r_bold") + "");
			}
			
			resource_entries.listAppend(ChecklistEntryMake("__item mayam calendar", url, ChecklistSubentryMake("Mayam Calendar", "", description), 8));	
		}	
	}
}
