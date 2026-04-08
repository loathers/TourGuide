// Sept-Ember Censer
RegisterResourceGenerationFunction("IOTMSeptemberCenserGenerateResource");
void IOTMSeptemberCenserGenerateResource(ChecklistEntry [int] resource_entries)
{
    if ($item[Sept-Ember Censer].available_amount() == 0) return;

    int septEmbers = get_property_int("availableSeptEmbers");

    // Tile is unnecessary if you don't have embers remaining.
    if (septEmbers == 0) return;

    string [int] description;    
    string url = "shop.php?whichshop=september";
    string title = "Spend your "+pluralise(septEmbers,"ember","embers");

    // Math for the statgain from spading
    float coldResistance = numeric_modifier("cold resistance");
    int mainstatGain = (7 * (coldResistance) ** 1.7) * (1.0 + numeric_modifier(my_primestat().to_string() + " Experience Percent") / 100.0);

    // General amount counts
    int bembershootCount = $item[bembershoot].available_amount();
    int mouthwashCount = $item[Mmm-brr! brand mouthwash].available_amount();
    int structureCount = $item[structural ember].available_amount();
    int hunkCount = $item[embering hunk].available_amount();
    boolean hulkFought = get_property_boolean("_emberingHulkFought");
    boolean structureUsed = get_property_boolean("_structuralEmberUsed");

    if (septEmbers > 0)
    {
        description.listAppend("Stoke the embers in your Sept-Ember Censer");
    }

    description.listAppend(`|*1 embers: +5 cold res accessory (You have {HTMLGenerateSpanFont(bembershootCount, "red")})`);
    description.listAppend(`|*2 embers: mmm-brr! mouthwash for {HTMLGenerateSpanFont(mainstatGain, "blue")} mainstat. (You have {HTMLGenerateSpanFont(mouthwashCount, "red")})`);

    if (structureUsed) {
        description.listAppend((HTMLGenerateSpanFont("|*Already used structural ember today", "blue")));
    } else {
        description.listAppend("|*4 embers: +5/5 bridge parts (1/day)");
    }

    if (hulkFought) {
        description.listAppend((HTMLGenerateSpanFont("|*Already fought embering hulk today", "blue")));
    } else {
        description.listAppend("|*6 embers: embering hulk (1/day)");
    }

    if (!__misc_state["in run"]) description.listAppend(`(You have {HTMLGenerateSpanFont(hunkCount, "blue")} hunks)`);

    resource_entries.listAppend(ChecklistEntryMake("__item sept-ember censer", url, ChecklistSubentryMake(title, "", description), 8));
}

// Helper function on the KoLmafia wiki that I just decided to use for this
float roundFloat(float number, int place) {
    float value = round(number*10.00**-place)*10.0**place; 
    return value;
}

RegisterTaskGenerationFunction("MmmBrrMouthwashGenerateTask");
void MmmBrrMouthwashGenerateTask(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries) {

    // Check a few things. Don't need this tile over level 11.
    int mouthwashCount = $item[Mmm-brr! brand mouthwash].available_amount();
    boolean doNotNeedToLevel = my_level() > 11;

    if (mouthwashCount == 0 || doNotNeedToLevel) return;

    string [int] description;
    string url = "inventory.php?ftext=brand+mouthwash";
    string main_title = "Level up with your Mmm-brr Mouthwash";  
    string subtitle;

    // Math for the statgain from spading
    float coldResistance = numeric_modifier("cold resistance");
    int mainstatGain = (7 * (coldResistance) ** 1.7) * (1.0 + numeric_modifier(my_primestat().to_string() + " Experience Percent") / 100.0);
    float levelFromMouthwash = roundFloat(square_root(my_basestat(my_primestat()) + mainstatGain*mouthwashCount),2);

    subtitle="currently @ " + coldResistance + " cold res";

    description.listAppend("You currently have "+pluralise(mouthwashCount, "mouthwash","mouthwashes")+" at "+mainstatGain+" mainstat apiece");
    description.listAppend("|*Will gain "+(mainstatGain*mouthwashCount)+" stats when used");
    description.listAppend("|*This will get you to level "+levelFromMouthwash);

    if (levelFromMouthwash < 12) {
        description.listAppend("Consider stacking more "+HTMLGenerateSpanOfClass("cold resistance", "r_element_cold")+" for a higher level");
    }

    // FIXME: add possible recommendations for obvious sources? probably a nice hoverover thing...

    optional_task_entries.listAppend(ChecklistEntryMake("__item mmm-brr mouthwash", url, ChecklistSubentryMake(main_title, subtitle, description), 8).ChecklistEntrySetIDTag("mmm brr mouthwash math"));
    

}