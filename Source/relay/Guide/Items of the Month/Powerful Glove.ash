RegisterResourceGenerationFunction("IOTMPowerfulGloveGenerateResource");
void IOTMPowerfulGloveGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (!$item[Powerful Glove].have()) return;

    int chargeLeft = 100 - get_property_int("_powerfulGloveBatteryPowerUsed");

    if (chargeLeft < 5) return;

    string url = "skillz.php";
    if (!$item[Powerful Glove].equipped())
        url = "inventory.php?ftext=powerful+glove";

    string [int] description;
    description.listAppend(HTMLGenerateSpanOfClass("Invisible Avatar (5% charge):", "r_bold") + " -10% combat.");
    description.listAppend(HTMLGenerateSpanOfClass("Triple Size (5% charge):", "r_bold") + " +200% all attributes.");
    if (chargeLeft >= 10)
        description.listAppend(HTMLGenerateSpanOfClass("Replace Enemy (10% charge):", "r_bold") + " Swap monster.");
    description.listAppend(HTMLGenerateSpanOfClass("Shrink Enemy (5% charge):", "r_bold") + " Delevel.");

    resource_entries.listAppend(ChecklistEntryMake("__item Powerful Glove", url, ChecklistSubentryMake(chargeLeft + "% battery charge", "", description)).ChecklistEntrySetIDTag("Powerful glove skills resource"));
}

RegisterTaskGenerationFunction("IOTMPowerfulGloveTask");
void IOTMPowerfulGloveTask(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if (!__misc_state["in run"] || !$item[Powerful Glove].have() || $item[Powerful Glove].have_equipped()) return;

    boolean is_plumber = my_path_id() == PATH_OF_THE_PLUMBER;

    string [int] glove_drops;

    if (!__quest_state["Level 13"].state_boolean["digital key used"] && $item[digital key].available_amount() + $item[digital key].creatable_amount() == 0)
        glove_drops.listAppend("pixels");
    if (is_plumber)
        glove_drops.listAppend("coins");
    
    if (glove_drops.count() == 0) return;

    optional_task_entries.listAppend(ChecklistEntryMake("__item white pixel", "place.php?whichplace=forestvillage&action=fv_mystic", ChecklistSubentryMake("Equip Powerful Glove", "", "Get extra " + glove_drops.listJoinComponents(" and ") + "."), is_plumber ? -10 : 0).ChecklistEntrySetIDTag("Powerful glove equip reminder"));
}
