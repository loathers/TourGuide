//meat shield maiden
RegisterTaskGenerationFunction("IOTMMeatShieldMaidenGenerateTasks");
void IOTMMeatShieldMaidenGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if (!lookupFamiliar("meat shield maiden").familiar_is_usable()) return;
	string url = "familiar.php";
	string [int] description;
	boolean MSMHot = get_property_boolean("_blessingShieldHotReceived");
	boolean MSMCold = get_property_boolean("_blessingShieldColdReceived");
	boolean MSMSpooky = get_property_boolean("_blessingShieldSpookyReceived");
	boolean MSMStench = get_property_boolean("_blessingShieldStenchReceived");
	boolean MSMSleaze = get_property_boolean("_blessingShieldSleazeReceived");
	boolean MSMPhys = get_property_boolean("_blessingShieldPhysicalReceived");
	
	if (!MSMPhys) {
		description.listAppend(HTMLGenerateSpanFont("Physical damage: +exp/DR", "black"));
	}	
	if (!MSMHot) {
		description.listAppend(HTMLGenerateSpanFont("Hot damage: +Init", "red"));
	}	
	if (!MSMCold) {
		description.listAppend(HTMLGenerateSpanFont("Cold damage: +mus, HPreg", "blue"));
	}	
	if (!MSMSpooky) {
		description.listAppend(HTMLGenerateSpanFont("Spooky damage: +mys, MPreg", "grey"));
	}	
	if (!MSMStench) {
		description.listAppend(HTMLGenerateSpanFont("Stench damage: +stenchres, NC%", "green"));
	}	
	if (!MSMSleaze) {
		description.listAppend(HTMLGenerateSpanFont("Sleaze damage: +mox, meat%", "purple"));
	}	
	if (my_familiar() == lookupFamiliar("meat shield maiden")) {
		//msm damage
			string [int][int] tooltip_table2;
			tooltip_table2.listAppend(listMake("Tier 1", "1-8 dmg"));
			tooltip_table2.listAppend(listMake("Tier 2", "9-35 dmg"));
			tooltip_table2.listAppend(listMake("Tier 3", "36-80 dmg"));
			tooltip_table2.listAppend(listMake("Tier 4", "81-143 dmg"));
			tooltip_table2.listAppend(listMake("Tier 5", "144-224 dmg"));
			tooltip_table2.listAppend(listMake("Tier 6", "225-323 dmg"));
			tooltip_table2.listAppend(listMake("Tier 7", "324-440 dmg"));
			tooltip_table2.listAppend(listMake("Tier 8", "441-575 dmg"));
			tooltip_table2.listAppend(listMake("Tier 9", "576-728 dmg"));
			tooltip_table2.listAppend(listMake("Tier 10", "729-899 dmg"));
			tooltip_table2.listAppend(listMake("Tier 11", "900-1088 dmg"));
				
			buffer tooltip_text2;
			tooltip_text2.append(HTMLGenerateTagWrap("div", "Meat Shield damage", mapMake("class", "r_bold r_centre", "style", "padding-bottom:0.25em;")));
			tooltip_text2.append(HTMLGenerateSimpleTableLines(tooltip_table2));
				
			string bawdyTooltip = HTMLGenerateSpanOfClass(HTMLGenerateSpanOfClass(tooltip_text2, "r_tooltip_inner_class r_tooltip_inner_class_margin") + HTMLGenerateSpanFont("Boost damage taken with less DA", "orange"), "r_tooltip_outer_class");
			description.listAppend(bawdyTooltip);		
		task_entries.listAppend(ChecklistEntryMake("__familiar meat shield maiden", url, ChecklistSubentryMake(HTMLGenerateSpanFont("Get hit for buffs?", "black"), description), -11).ChecklistEntrySetIDTag("MSM buffs"));
	}
}
