RegisterTaskGenerationFunction("SMonorailStationGenerateTasks");
void SMonorailStationGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if (in_bad_moon()) return; // No Breakfast Counter in Bad Moon

    if (__misc_state["can eat just about anything"] && get_property("muffinOnOrder") == "earthenware muffin tin")
        task_entries.listAppend(ChecklistEntryMake("__item earthenware muffin tin", "place.php?whichplace=monorail&action=monorail_downtown", ChecklistSubentryMake("Get your muffin tin back", "", "Vist the monorail's breakfast counter"), -11).ChecklistEntrySetIDTag("Monorail get muffin tin"));
 
    if (get_property_boolean("_muffinOrderedToday") || get_property("muffinOnOrder") == "earthenware muffin tin")
        return;

    item order = get_property("muffinOnOrder").lookupItem();
    if (order != $item[none]) {
        task_entries.listAppend(ChecklistEntryMake("__item " + order.to_string(), "place.php?whichplace=monorail&action=monorail_downtown", ChecklistSubentryMake("Go grab your " + order.to_string()), -11).ChecklistEntrySetIDTag("Monorail muffin resource"));
    }
    else if (lookupItem("earthenware muffin tin").available_amount() > 0 && __misc_state["in run"]) {
        optional_task_entries.listAppend(ChecklistEntryMake("__item earthenware muffin tin", "place.php?whichplace=monorail", ChecklistSubentryMake("Order a new muffin"), 5).ChecklistEntrySetIDTag("Monorail muffin resource"));
    }
}