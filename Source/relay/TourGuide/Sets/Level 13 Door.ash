
void SLevel13DoorGenerateMissingItems(ChecklistEntry [int] tower_door_entries)
{
    if (__quest_state["Level 13"].state_boolean["past keys"]) return;

    if ($item[skeleton key].available_amount() == 0 && !__quest_state["Level 13"].state_boolean["skeleton key used"]) {
        string line = "loose teeth (" + ($item[loose teeth].available_amount() == 0 ? "need" : "have") + ")";
        line += " + skeleton bone (" + ($item[skeleton bone].available_amount() == 0 ? "need" : "have") + ")";
        tower_door_entries.listAppend(ChecklistEntryMake("__item skeleton key", $location[the defiled nook].getClickableURLForLocation(), ChecklistSubentryMake("Skeleton key", "", line)).ChecklistEntrySetIDTag("Council L13 tower door skeleton key"));
    }

    S8bitRealmGenerateMissingItems(tower_door_entries);

    SDailyDungeonGenerateMissingItems(tower_door_entries);

    QHitsGenerateMissingItems(tower_door_entries);
}
