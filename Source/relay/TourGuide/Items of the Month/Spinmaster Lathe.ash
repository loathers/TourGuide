RegisterResourceGenerationFunction("IOTMSpinmasterLatheGenerateResource");
void IOTMSpinmasterLatheGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (available_amount($item[SpinMaster™ lathe]) < 1 || !is_unrestricted($item[SpinMaster™ lathe])) return;
 
	if (!get_property_boolean("_spinmasterLatheVisited")) {
        string image_name = "__item purpleheart logs";
        string description = "Get wood for an +xp weapon.";
 
	    resource_entries.listAppend(ChecklistEntryMake("__item purpleheart logs", "inventory.php?ftext=spinmaster", ChecklistSubentryMake("SpinMaster lathe wood obtainable", "", description), 1).ChecklistEntrySetIDTag("SpinMaster lathe resource"));
    }
}
