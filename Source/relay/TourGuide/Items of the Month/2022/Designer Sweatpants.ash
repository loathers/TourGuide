//ants
RegisterResourceGenerationFunction("IOTMDesignerSweatpantsResource");
void IOTMDesignerSweatpantsResource(ChecklistEntry [int] resource_entries)
{
    if (!__iotms_usable[$item[designer sweatpants]]) return;

    int sweat_o_meter = get_property_int("sweat");
    int booze_sweats_left = clampi(3 - get_property_int("_sweatOutSomeBoozeUsed"), 0, 3);
	
    string title;
    string [int] description;
    string url = "inventory.php?ftext=designer+sweatpants";
	
    if (sweat_o_meter < 100) {
        title = HTMLGenerateSpanFont(sweat_o_meter + "% sweatpants Sweatiness", "purple");
    } else {
        title = HTMLGenerateSpanFont("Designer sweatpants: 100% sweaty!", "purple");
        description.listAppend(HTMLGenerateSpanFont("Use up your sweat, maybe!", "purple"));
    }
    
    description.listAppend(HTMLGenerateSpanOfClass("Sweat Flick (1% sweat):", "r_bold") + HTMLGenerateSpanFont(" " + sweat_o_meter + " Sleaze Damage attack", "purple"));
    description.listAppend(HTMLGenerateSpanOfClass("Sweat Spray (3% sweat):", "r_bold") + HTMLGenerateSpanFont(" recurring Sleaze Damage attack", "purple"));
	description.listAppend(HTMLGenerateSpanOfClass("Sweat Flood (5% sweat):", "r_bold") + " 5-turn stun");
	description.listAppend(HTMLGenerateSpanOfClass("Sip Some Sweat (5% sweat):", "r_bold") + " Regain 50 MP");
	description.listAppend(HTMLGenerateSpanOfClass("Sweat Sip (5% sweat):", "r_bold") + " Regain 50 MP");
	description.listAppend(HTMLGenerateSpanOfClass("Drench Yourself In Sweat (15% sweat):", "r_bold") + " +100% Initiative");
	description.listAppend(HTMLGenerateSpanOfClass("Make Sweat-Ade (50% sweat):", "r_bold") + " make a PvP Fight spleen item");
    if (booze_sweats_left > 0)
        description.listAppend(HTMLGenerateSpanOfClass("Sweat Out Some Booze (25% sweat):", "r_bold") + HTMLGenerateSpanFont(" -1 Drunkenness. " + booze_sweats_left + " uses left for today.", "orange"));
    resource_entries.listAppend(ChecklistEntryMake("__item designer sweatpants", url, ChecklistSubentryMake(title, description), 1).ChecklistEntrySetIDTag("designer sweatpants resource"));
}