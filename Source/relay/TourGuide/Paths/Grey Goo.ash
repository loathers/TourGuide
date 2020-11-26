RegisterTaskGenerationFunction("PathGreyGooGenerateTasks");
void PathGreyGooGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if (my_path_id() != PATH_GREY_GOO)
        return;

    if (my_daycount() >= 3) {
        task_entries.listAppend(ChecklistEntryMake("astral gash", "place.php?whichplace=greygoo", ChecklistSubentryMake("Ascend", "", "Prism appeared. Ascend whenever."),-10).ChecklistEntrySetIDTag("Grey goo path prism open"));
    }
}
