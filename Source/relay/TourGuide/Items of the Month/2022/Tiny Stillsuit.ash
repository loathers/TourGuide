//Tiny stillsuit
RegisterResourceGenerationFunction("IOTMTinyStillsuitResource");
void IOTMTinyStillsuitResource(ChecklistEntry [int] resource_entries)
{
    string title;
    string [int] description;
    string url = "inventory.php?action=distill&pwd=" + my_hash();
    title = "Distill a Familiar's Sweat via Stillsuit";
    description.listAppend("Two gross tastes that taste horrible together!");
    
    resource_entries.listAppend(ChecklistEntryMake("__item sweat-ade", url, ChecklistSubentryMake(title, description), -2).ChecklistEntrySetIDTag("tiny stillsuit resource"));
}