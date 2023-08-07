//Shortest-Order Cook
RegisterResourceGenerationFunction("IOTMShortCookGenerateResource");
void IOTMShortCookGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (!__misc_state["in run"]) return;
    int shartCookCharge = get_property_int("_shortOrderCookCharge");
    string [int] description;
    string url = "familiar.php";
    string subtitle = "also, use your cook to feed XP to another familiar";
    if (shartCookCharge < 11)
    {
        description.listAppend("Use the short cook to get a +10 famwt potion.");
        resource_entries.listAppend(ChecklistEntryMake("__familiar shorter-order cook", url, ChecklistSubentryMake(shartCookCharge + "/11 Shorter-Order Cook charge", subtitle, description), 8));
    }    
}