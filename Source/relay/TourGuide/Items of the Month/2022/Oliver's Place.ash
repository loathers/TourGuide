RegisterResourceGenerationFunction("IOTMOliversPlaceGenerateResource");
void IOTMOliversPlaceGenerateResource(ChecklistEntry [int] resource_entries) 
{
    // Only generate if they actually have Oliver's Place
    if (!get_property_boolean("ownsSpeakeasy")) return;

    int free_oliver_fights_left = 3 - get_property_int("_speakeasyFreeFights");
    string url = "place.php?whichplace=speakeasy";
    string [int] description;

    if (free_oliver_fights_left > 0) {
        description.listAppend("Consider dragging wanderers into the speakeasy.");

        resource_entries.listAppend(ChecklistEntryMake("__item Marltini", "", ChecklistSubentryMake(pluralise(free_oliver_fights_left, "Oliver's Tavern fight", "Oliver's Tavern fights"), "", description), 9).ChecklistEntrySetCombinationTag("daily free fight").ChecklistEntrySetIDTag("Oliver's Tavern free fights"));
    }
}