//Tiny stillsuit
RegisterTaskGenerationFunction("IOTMTinyStillsuitGenerateTasks");
void IOTMTinyStillsuitGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if (!lookupItem("tiny stillsuit").have()) return;
	int fam_sweat_o_meter = get_property_int("familiarSweat");
	
	string title;
	string [int] description;
	string url = "inventory.php?action=distill&pwd=" + my_hash();
	int sweatCalcSweat;
	int sweatAdvs = round(to_int(get_property("familiarSweat"))**0.4);

	if (fam_sweat_o_meter >= 358) {
		sweatCalcSweat = 449;
	}
	else if (fam_sweat_o_meter >= 279) {
		sweatCalcSweat = 358;
	}
	else if (fam_sweat_o_meter >= 211) {
		sweatCalcSweat = 279;
	}
	else if (fam_sweat_o_meter >= 155) {
		sweatCalcSweat = 211;
	}
	else if (fam_sweat_o_meter >= 108) {
		sweatCalcSweat = 155;
	}
	else if (fam_sweat_o_meter >= 71) {
		sweatCalcSweat = 108;
	}
	else if (fam_sweat_o_meter >= 43) {
		sweatCalcSweat = 71;
	}
	else if (fam_sweat_o_meter >= 23) {
		sweatCalcSweat = 43;
	}
	else if (fam_sweat_o_meter >= 10) {
		sweatCalcSweat = 23;
	}
	else if (fam_sweat_o_meter < 10) {
		sweatCalcSweat = 10;
	}
	
	if (fam_sweat_o_meter > 449) {
		description.listAppend("" + HTMLGenerateSpanOfClass(sweatAdvs, "r_bold") + " advs when guzzling now (costs 1 liver).");
		description.listAppend("You should probably guzzle your sweat now.");
	}
	else {
		description.listAppend(HTMLGenerateSpanOfClass(fam_sweat_o_meter + "/" + sweatCalcSweat, "r_bold") + " drams of stillsuit sweat for next adventure.");
		description.listAppend("" + HTMLGenerateSpanOfClass(sweatCalcSweat - fam_sweat_o_meter, "r_bold") + " more sweat until +1 more adventure. (" + (1+ (sweatCalcSweat - fam_sweat_o_meter)/3) + " combats on current familiar)");
	}
	
	if ($item[tiny stillsuit].item_amount() == 1) {
		title = HTMLGenerateSpanFont("Equip the stillsuit", "purple");
		description.listAppend("" + HTMLGenerateSpanFont("Not collecting sweat from any familiar right now.", "red") + "");
		task_entries.listAppend(ChecklistEntryMake("__item tiny stillsuit", url, ChecklistSubentryMake(title, description), -11).ChecklistEntrySetIDTag("tiny stillsuit task"));
	}
	else if ($item[tiny stillsuit].equipped_amount() == 1) {
		description.listAppend("" + HTMLGenerateSpanFont("Currently collecting sweat from current familiar!", "purple") + "");
	} else {
		description.listAppend("" + HTMLGenerateSpanFont("Currently collecting sweat on a different familiar!", "fuchsia") + "");
    }	
	title = HTMLGenerateSpanFont(sweatAdvs + " adv stillsuit sweat booze", "purple");
	if (__misc_state["in run"] && sweatAdvs > 3) {
		task_entries.listAppend(ChecklistEntryMake("__item tiny stillsuit", url, ChecklistSubentryMake(title, description), -11).ChecklistEntrySetIDTag("tiny stillsuit task"));
	}
	else if (!__misc_state["in run"] && sweatAdvs > 8) {
		task_entries.listAppend(ChecklistEntryMake("__item tiny stillsuit", url, ChecklistSubentryMake(title, description), -11).ChecklistEntrySetIDTag("tiny stillsuit task"));
	}
}

RegisterResourceGenerationFunction("IOTMTinyStillsuitGenerateResource");
void IOTMTinyStillsuitGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (!lookupItem("tiny stillsuit").have()) return;

    int fam_sweat_o_meter = get_property_int("familiarSweat");
	int sweatAdvs = round(to_int(get_property("familiarSweat"))**0.4);
#	int nextSweatDrams = (sweatAdvs+0.51) ** 2.5;# - fam_sweat_o_meter;
	
    string title;
    string [int] description;
    string url = "inventory.php?action=distill&pwd=" + my_hash();
	int sweatCalcSweat;

	description.listAppend("Two gross tastes that taste horrible together.");
	//an amish paradise is as primitive as can be

	if (fam_sweat_o_meter >= 358) {
		sweatCalcSweat = 449;
	}
	else if (fam_sweat_o_meter >= 279) {
		sweatCalcSweat = 358;
	}
	else if (fam_sweat_o_meter >= 211) {
		sweatCalcSweat = 279;
	}
	else if (fam_sweat_o_meter >= 155) {
		sweatCalcSweat = 211;
	}
	else if (fam_sweat_o_meter >= 108) {
		sweatCalcSweat = 155;
	}
	else if (fam_sweat_o_meter >= 71) {
		sweatCalcSweat = 108;
	}
	else if (fam_sweat_o_meter >= 43) {
		sweatCalcSweat = 71;
	}
	else if (fam_sweat_o_meter >= 23) {
		sweatCalcSweat = 43;
	}
	else if (fam_sweat_o_meter >= 10) {
		sweatCalcSweat = 23;
	}
	else if (fam_sweat_o_meter < 10) {
		sweatCalcSweat = 10;
	}
	
	if (fam_sweat_o_meter > 358) {
		description.listAppend("" + HTMLGenerateSpanOfClass("11", "r_bold") + " advs when guzzling now (costs 1 liver).");
		description.listAppend("You should probably guzzle your sweat now.");
	}
	else if (fam_sweat_o_meter > 10) {
		description.listAppend("" + HTMLGenerateSpanOfClass(sweatAdvs, "r_bold") + " advs when guzzling now (costs 1 liver).");
		description.listAppend("" + HTMLGenerateSpanOfClass(sweatCalcSweat - fam_sweat_o_meter, "r_bold") + " more sweat until +1 more adventure. (" + (1+ (sweatCalcSweat - fam_sweat_o_meter)/3) + " combats on current familiar)");
	}
	else {
		description.listAppend("" + HTMLGenerateSpanFont("Not enough sweat to guzzle.", "red") + "");
		description.listAppend("" + HTMLGenerateSpanOfClass(sweatCalcSweat - fam_sweat_o_meter, "r_bold") + " more sweat until +1 more adventure. (" + (1+ (sweatCalcSweat - fam_sweat_o_meter)/3) + " combats on current familiar)");
	}
		
    if ($item[tiny stillsuit].item_amount() == 1) {
		description.listAppend("" + HTMLGenerateSpanFont("Not collecting sweat from any familiar right now.", "red") + "");
		url = "familiar.php";
	}
	else if ($item[tiny stillsuit].equipped_amount() == 1) {
		description.listAppend("" + HTMLGenerateSpanFont("Currently collecting sweat from current familiar!", "purple") + "");
	} else {
		description.listAppend("" + HTMLGenerateSpanFont("Currently collecting sweat on a different familiar!", "fuchsia") + "");
    }

	title = HTMLGenerateSpanFont(fam_sweat_o_meter + "/" + sweatCalcSweat + " drams of stillsuit sweat", "purple");
	
	//sweat chart
	string [int][int] tooltip_table; 

    // These are the mappings for drams needed for certain adv thresholds.
    static string[int] advDramsTable = {
        3:"10",
        4:"23",
        5:"43",
        6:"71",
        7:"108",
        8:"155",
        9:"211",
        10:"279",
        11:"358",
        12:"449",
        13:"553",};

    foreach advs, drams in advDramsTable {
      // Only append it if the user hasn't yet reached that # of drams
      if (drams.to_int() > fam_sweat_o_meter) {
        tooltip_table.listAppend(listMake(advs.to_string(), drams+" drams (" + (drams.to_int() - fam_sweat_o_meter) + " more sweat)" ));
      }
    }

    if (fam_sweat_o_meter > 553) {
      tooltip_table.listAppend(listMake("> 13", "... yknow, you should probably just drink it, buddy"));
    }
		
	buffer tooltip_text;
	tooltip_text.append(HTMLGenerateTagWrap("div", "Sweat to Advs Conversion Table", mapMake("class", "r_bold r_centre", "style", "padding-bottom:0.25em;")));
	tooltip_text.append(HTMLGenerateSimpleTableLines(tooltip_table));
		
	string stillSweatTooltip = HTMLGenerateSpanOfClass(HTMLGenerateSpanOfClass(tooltip_text, "r_tooltip_inner_class r_tooltip_inner_class_margin") + "Sweat/Advs conversion", "r_tooltip_outer_class");
	description.listAppend(stillSweatTooltip);
		
	//famtype chart
	string [int][int] tooltip_table2;
	tooltip_table2.listAppend(listMake("Cubeling / Stomping Boots", "+item"));
	tooltip_table2.listAppend(listMake("Levitating Potato / Candy Carnie / Flan", "+item and +food"));
	tooltip_table2.listAppend(listMake("Star Starfish / Emilio / Globmule / Waifuton", "+item and +sleaze"));
		
	buffer tooltip_text2;
	tooltip_text2.append(HTMLGenerateTagWrap("div", "Stillsuit buff target", mapMake("class", "r_bold r_centre", "style", "padding-bottom:0.25em;")));
	tooltip_text2.append(HTMLGenerateSimpleTableLines(tooltip_table2));
		
	string stillSweatTypeTooltip = HTMLGenerateSpanOfClass(HTMLGenerateSpanOfClass(tooltip_text2, "r_tooltip_inner_class r_tooltip_inner_class_margin") + "Suggested Stillsuit Familiars", "r_tooltip_outer_class");
	description.listAppend(stillSweatTypeTooltip);
    resource_entries.listAppend(ChecklistEntryMake("__item tiny stillsuit", url, ChecklistSubentryMake(title, description), -2).ChecklistEntrySetIDTag("tiny stillsuit resource"));
}