RegisterTaskGenerationFunction("PathBodyguardGenerateTasks");
void PathBodyguardGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if (my_path().id != PATH_BODYGUARD)
        return;
    
    int bodychat = (get_property_int("bodyguardCharge"));
	string [int] description;
	
	description.listAppend("Lots of options.");
		
	string [int][int] tooltip_table2;
	tooltip_table2.listAppend(listMake("astronomer / skinflute", "star key"));
	tooltip_table2.listAppend(listMake("white lion / whitesnake", "wet stew"));
	tooltip_table2.listAppend(listMake("topiary animals", "level 9"));
	tooltip_table2.listAppend(listMake("wine rack / cabinet", "wine bomb"));
	tooltip_table2.listAppend(listMake("dairy goat", "goat cheese"));
	tooltip_table2.listAppend(listMake("harem girl", "outfit"));
	tooltip_table2.listAppend(listMake("pygmy bowler / accountant / surgeon", "hidden city"));
	tooltip_table2.listAppend(listMake("blur", "drum machine"));
	tooltip_table2.listAppend(listMake("tool gremlins", "gremlin tools"));
	tooltip_table2.listAppend(listMake("war hippies", "WAR!"));
		
	buffer tooltip_text2;
	tooltip_text2.append(HTMLGenerateTagWrap("div", "Stillsuit buff target", mapMake("class", "r_bold r_centre", "style", "padding-bottom:0.25em;")));
	tooltip_text2.append(HTMLGenerateSimpleTableLines(tooltip_table2));
		
	string stillSweatTypeTooltip = HTMLGenerateSpanOfClass(HTMLGenerateSpanOfClass(tooltip_text2, "r_tooltip_inner_class r_tooltip_inner_class_margin") + "Suggested Stillsuit Familiars", "r_tooltip_outer_class");
	
	
    if (bodychat == 50)
    {
        string main_title = HTMLGenerateSpanFont("Force a bodyguard", "blue");
		string url = "main.php?talktobg=1";
        task_entries.listAppend(ChecklistEntryMake("__familiar burly bodyguard", url, ChecklistSubentryMake(main_title, "", description), -11));
    }
	else if (bodychat < 50)
    {
        string main_title = HTMLGenerateSpanFont((50 - bodychat) + " combats until next bodyguard chat", "black");
        optional_task_entries.listAppend(ChecklistEntryMake("__item adventurer clone egg", "", ChecklistSubentryMake(main_title, "", description), 11));
    }
}