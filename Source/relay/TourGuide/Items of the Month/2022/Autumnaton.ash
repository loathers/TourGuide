//Autumnaton
RegisterTaskGenerationFunction("IOTMAutumnatonGenerateTasks");
void IOTMAutumnatonGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    #if (!__misc_state["in run"]) return; 
	if (!get_property_boolean("hasAutumnaton")) return;
	int autobotsToday = get_property_int("_autumnatonQuests");
	int autobotsReturnTime = autobotsToday * 11;
	int turncountWhereAutobotReturns = get_property_int("autumnatonQuestTurn");
	
/*	if (get_property("autumnatonUpgrades").contains_text("leftleg1")) {
		autobotsReturnTime =- 11;
	} 
	else if (get_property("autumnatonUpgrades").contains_text("leftleg1") && get_property("autumnatonUpgrades").contains_text("rightleg1")) {
		autobotsReturnTime =- 22;
	} */	
	
    string url;
	string [int] description;
	string [int] targets;
    
	description.listAppend("Autobot grabs items from a zone you've previously visited.");
	
	// Autobot on expedition
	if (turncountWhereAutobotReturns -1 == total_turns_played()) 
	{
        string main_title = "Autumn-aton returns next adventure";
		string autobotZone = get_property("autumnatonQuestLocation");
        description.listAppend("Next mission takes " + HTMLGenerateSpanOfClass(autobotsReturnTime, "r_bold") + " adventures.");
		description.listAppend(HTMLGenerateSpanOfClass("Currently exploring: ", "r_bold") + autobotZone);
		task_entries.listAppend(ChecklistEntryMake("__item autumn-aton", url, ChecklistSubentryMake(main_title, description), -11));
	}
	else if (turncountWhereAutobotReturns > total_turns_played()) 
	{
        string main_title = "Autumn-aton on a mission";
		string autobotZone = get_property("autumnatonQuestLocation");
        description.listAppend("Will return in " + HTMLGenerateSpanOfClass(turncountWhereAutobotReturns +1 - total_turns_played(), "r_bold") + " adventures.");
		description.listAppend(HTMLGenerateSpanOfClass("Currently exploring: ", "r_bold") + autobotZone);
		optional_task_entries.listAppend(ChecklistEntryMake("__item autumn-aton", url, ChecklistSubentryMake("Autumn-aton on a mission", description), 8));
	}
	else if (lookupItem("autumn-aton").available_amount() > 0)
	{
        string main_title = "Use your autumn-aton";
        description.listAppend("Next use will take " + HTMLGenerateSpanOfClass(autobotsReturnTime, "r_bold") + " adventures.");
		task_entries.listAppend(ChecklistEntryMake("__item autumn-aton", "inv_use.php?pwd=" + my_hash() + "&whichitem=10954", ChecklistSubentryMake(main_title, "", description), -11));
	}

	if (!get_property("autumnatonUpgrades").contains_text("cowcatcher")) {
		description.listAppend("Visit mid underground for +1 autumn item (Cyrpt zone, Daily Dungeon?)");
	} 
	if (!get_property("autumnatonUpgrades").contains_text("leftarm1")) {
		description.listAppend("Visit low indoor for +1 item (Haunted Kitchen?)");
	} 
	if (!get_property("autumnatonUpgrades").contains_text("rightarm1")) {
		description.listAppend("Visit mid outdoor for +1 item (Smut Orc Camp?)");
	} 
	if (!get_property("autumnatonUpgrades").contains_text("leftleg1")) {
		description.listAppend("Visit low underground for -11 cooldown (Ratbats?)");
	} 
	if (!get_property("autumnatonUpgrades").contains_text("rightleg1")) {
		description.listAppend("Visit mid indoor for -11 cooldown (Haunted Library?)");
	} 
	
	if (__misc_state["in run"] && my_path().id != 25)	
	{
		if (locationAvailable($location[sonofa beach]) == true && available_amount($item[barrel of gunpowder]) < 5)
		{	
			targets.listAppend("barrel of gunpowder");
		}
		if (locationAvailable($location[twin peak]) == false && get_property_int("chasmBridgeProgress") < 30)
		{	
			targets.listAppend("bridge parts");
		}
		if (get_property_int("hiddenBowlingAlleyProgress") < 6)
		{	
			targets.listAppend("bowling balls");
		}
		if (get_property_int("twinPeakProgress") < 14);
		{	
			targets.listAppend("bubblin' crude");
		}
		if (get_property_int("desertExploration") < 100);
		{	
			targets.listAppend("killing jar");
		}
		if (locationAvailable($location[the oasis]) == true && get_property_int("desertExploration") < 100);
		{	
			targets.listAppend("drum machine");
		}
		if (__quest_state["Level 11 Ron"].mafia_internal_step < 5)
		{	
			targets.listAppend("glark cables");
		}
		if (targets.count() > 0)
			description.listAppend(HTMLGenerateSpanOfClass("Potential autobot targets:", "r_bold") + "|*-" + targets.listJoinComponents("|*-")); 
	}
}