RegisterTaskGenerationFunction("PathLegacyOfLoathingGenerateTasks");
void PathLegacyOfLoathingGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{

    // Variables re: replicas available and path currency available.
    int replicasAvailable = $item[replica mr. accessory].available_amount();
    int momsCreditCardAvailable = $item[replica ten dollars].available_amount();
    int momsCreditCardUsed = $path[legacy of loathing].points;
    
    // Only generate tile if the user has replicas and is in-path.
    if (replicasAvailable + momsCreditCardAvailable == 0) return;
    if (my_path() != $path[Legacy of Loathing]) return;

    ChecklistEntry entry;
    string [int] description;
    
	entry.url = "shop.php?whichshop=mrreplica";
	entry.image_lookup_name = "__item replica mr. accessory";
    entry.tags.id = "Replicas available reminder";
    entry.importance_level = -11;


    description.listAppend("Use all your replicas for shiny old treasures!");

    if (momsCreditCardAvailable > 0) {
        if (momsCreditCardUsed < 19) {
            int usableDollars = min(19-momsCreditCardUsed, momsCreditCardAvailable);
            description.listAppend(`You also have <b>{usableDollars}</b> usable replica ten dollars for more progression; try using those?`);
            entry.url = "inventory.php?ftext=replica+ten+dollars";
        }
    }

    entry.subentries.listAppend(ChecklistSubentryMake(pluralise(replicasAvailable, "replica Mr. Accessory","replica Mr. Accessories"), "", description));

    task_entries.listAppend(entry);

}