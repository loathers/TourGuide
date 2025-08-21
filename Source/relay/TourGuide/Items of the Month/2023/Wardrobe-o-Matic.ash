// Wardrobe-o-Matic
void GenerateWardrobeDescription(slot currSlot, int tier) {

    // Helper function to translate the wardrobe mods to useful strings.
    string entry = "";
    string [modifier] allWardrobeMods = futuristic_wardrobe(currSlot, tier);

    // Only displaying useful equipment mods.
    foreach mod, value in allWardrobeMods {
        if (mod == $modifier[Item Drop]) entry += value+"% +item ";
        if (mod == $modifier[Monster Level]) entry += value+" +ML ";
        if (mod == $modifier[Meat Drop]) entry += value+"% +meat ";
        if (mod == $modifier[Familiar Weight]) entry += value+" +fam wt ";
        if (mod == $modifier[Familiar Experience]) entry += value+" +fam xp ";
    }

    return entry;
}

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
    string main_title = "Open your Wardrobe-O-Matic.";  
    string subtitle;
    int priority = 11;
    boolean isMainTask = false;

    // Grab general wardrobe properties
    int currentTier = clampi(( my_level()/5 ) + 1, 0, 5);

    // If they're > 15, promote to tasks. If they're >20, promote to supernag.
    if (my_level() >= 15) isMainTask = true;
    if (my_level() >= 20) priority = -11;  

    // Level needed for your next wardrobe tier
    if (currentTier == 1) {subtitle = "advances @ level 5";}
    if (currentTier == 2) {subtitle = "advances @ level 10";}
    if (currentTier == 3) {subtitle = "advances @ level 15... with new mods!";}
    if (currentTier == 4) {subtitle = "advances @ level 20";}
    if (currentTier == 5) {subtitle = "as good as it gets!";}

    // Grab useful mods via the helper function
    string hatMods = GenerateWardrobeDescription($slot[hat], currentTier);
    string shirtMods = GenerateWardrobeDescription($slot[shirt], currentTier);
    string famEquipMods = GenerateWardrobeDescription($slot[familiar], currentTier);

    foreach it in [hatMods, shirtMods, famEquipMods] {
        if (it == "") it += HTMLGenerateSpanFont("no useful modifiers", "gray");
    }

    // Add a little note if you've maxed it.
    description.listAppend("Acquire some questionably useful clothing!");
    if (my_level() > 19) description.listAppend(HTMLGenerateSpanFont("You're level "+my_level()+"? It can't get any better, open it!", "blue"));

    description.listAppend(HTMLGenerateSpanOfClass("Hat: ", "r_bold")+hatMods);
    description.listAppend(HTMLGenerateSpanOfClass("Shirt: ", "r_bold")+shirtMods);
    description.listAppend(HTMLGenerateSpanOfClass("Fam Equip: ", "r_bold")+famEquipMods);

    if (isMainTask)  task_entries.listAppend(ChecklistEntryMake("__item wardrobe-o-matic", url, ChecklistSubentryMake(main_title, subtitle, description), -11).ChecklistEntrySetIDTag("Wardrobe-o-Matic"));
    if (!isMainTask) optional_task_entries.listAppend(ChecklistEntryMake("__item wardrobe-o-matic", url, ChecklistSubentryMake(main_title, subtitle, description), -11).ChecklistEntrySetIDTag("Wardrobe-o-Matic"));
    
}