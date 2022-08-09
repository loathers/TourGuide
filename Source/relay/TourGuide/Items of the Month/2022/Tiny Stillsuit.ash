//Tiny stillsuit
RegisterResourceGenerationFunction("IOTMTinyStillsuitResource");
void IOTMTinyStillsuitResource(ChecklistEntry [int] resource_entries)
{
    int fam_sweat_o_meter = get_property_int("familiarSweat");

    // Cannot drink the distillate until you have 10+ drams.
    if (!lookupItem("tiny stillsuit").have() || fam_sweat_o_meter < 10 ) return;

	int sweatAdvs = (fam_sweat_o_meter ** 0.4);
	int sweatAdvsConversion = (sweatAdvs - 0.5) ** 2.5;
	int nextSweatDrams = (sweatAdvs+0.51) ** 2.5; # - fam_sweat_o_meter;
	
    string title;
    string [int] description;
    string url = "inventory.php?action=distill&pwd=" + my_hash();
	title = HTMLGenerateSpanFont(fam_sweat_o_meter + " drams of stillsuit sweat", "purple");
	description.listAppend("Two gross tastes that taste horrible together.");
	//an amish paradise is as primitive as can be
	int sweatCalcSweat;
	int sweatCalcAdvs;

	if (fam_sweat_o_meter >= 279) {
		sweatCalcSweat = 358;
		sweatCalcAdvs = 10;
	}
	else if (fam_sweat_o_meter >= 211) {
		sweatCalcSweat = 279;
		sweatCalcAdvs = 9;
	}
	else if (fam_sweat_o_meter >= 155) {
		sweatCalcSweat = 211;
		sweatCalcAdvs = 8;
	}
	else if (fam_sweat_o_meter >= 108) {
		sweatCalcSweat = 155;
		sweatCalcAdvs = 7;
	}
	else if (fam_sweat_o_meter >= 71) {
		sweatCalcSweat = 108;
		sweatCalcAdvs = 6;
	}
	else if (fam_sweat_o_meter >= 43) {
		sweatCalcSweat = 71;
		sweatCalcAdvs = 5;
	}
	else if (fam_sweat_o_meter >= 23) {
		sweatCalcSweat = 43;
		sweatCalcAdvs = 4;
	}
	else if (fam_sweat_o_meter >= 10) {
		sweatCalcSweat = 23;
		sweatCalcAdvs = 3;
	}
	
	if (fam_sweat_o_meter > 358) {
		description.listAppend("" + HTMLGenerateSpanOfClass("11", "r_bold") + " advs when guzzling now (costs 1 liver).");
		description.listAppend("You should probably guzzle your sweat now.");
	}
	else {
		description.listAppend("" + HTMLGenerateSpanOfClass(sweatCalcAdvs, "r_bold") + " advs when guzzling now (costs 1 liver).");
		description.listAppend("" + HTMLGenerateSpanOfClass(sweatCalcSweat - fam_sweat_o_meter, "r_bold") + " more sweat until +1 more adventure. (" + CEIL(sweatCalcSweat - fam_sweat_o_meter)/3 + " combats on current familiar)");
	}
		
#	description.listAppend("" + HTMLGenerateSpanOfClass(sweatAdvs, "r_bold") + " advs when guzzling now (costs 1 liver).");

    if ($item[tiny stillsuit].item_amount() == 1) {
		description.listAppend("" + HTMLGenerateSpanFont("Not collecting sweat from any familiar right now.", "red") + "");
		url = "familiar.php";
	}
	else if ($item[tiny stillsuit].equipped_amount() == 1) {
		description.listAppend("" + HTMLGenerateSpanFont("Currently collecting sweat from current familiar!", "purple") + "");
	} else {
		description.listAppend("" + HTMLGenerateSpanFont("Currently collecting sweat on a different familiar!", "fuchsia") + "");
		#description.listAppend("Currently collecting sweat from " + HTMLGenerateSpanFont(stillsuitFamiliar, "purple") + "");
    }
		
    resource_entries.listAppend(ChecklistEntryMake("__item tiny stillsuit", url, ChecklistSubentryMake(title, description), -2).ChecklistEntrySetIDTag("tiny stillsuit resource"));
}