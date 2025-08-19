// Wardrobe-o-Matic
RegisterTaskGenerationFunction("IOTMWardrobeOMaticGenerateTasks");
void IOTMWardrobeOMaticGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries) {
    // Don't generate a tile if the user doesn't have the wardrobe.
    if (!lookupItem("wardrobe-o-matic").have()) return;

    // If the property is populated, the user has opened the wardrobe.
    boolean openedWardrobe = length(get_property("_futuristicHatModifier"))>10;

    // Don't generate a tile if the user has opened the wardrobe today.
    if (openedWardrobe) return;

    string [int] description;
    string url = "inventory.php?ftext=drobe-o-matic";
    string main_title = "Open your Wardrobe-O-Matic";  
    string subtitle;
    int priority = 11;
    boolean isMainTask = false;

    // If they're > 15, promote to tasks. If they're >20, promote to supernag.
    if (my_level() >= 15) isMainTask = true;
    if (my_level() >= 20) priority = -11;  

    // Level needed for your next wardrobe tier
    if (my_level() < 5) subtitle = "advances @ level 5";
    if (my_level() < 10) subtitle = "advances @ level 10";
    if (my_level() < 15) subtitle = "advances @ level 15... with new mods!";
    if (my_level() < 20) subtitle = "advances @ level 20";

    // Add a little note if you've maxed it.
    description.listAppend("Acquire some questionably useful clothing!");
    if (my_level() < 20) description.listAppend(HTMLGenerateSpanFont("You're level "+my_level()+"? It can't get any better, open it!", "blue"));

    if (isMainTask)  task_entries.listAppend(ChecklistEntryMake("__item wardrobe-o-matic", url, ChecklistSubentryMake(main_title, subtitle, description), -11).ChecklistEntrySetIDTag("Wardrobe-o-Matic"));
    if (!isMainTask) optional_task_entries.listAppend(ChecklistEntryMake("__item wardrobe-o-matic", url, ChecklistSubentryMake(main_title, subtitle, description), -11).ChecklistEntrySetIDTag("Wardrobe-o-Matic"));
    
}