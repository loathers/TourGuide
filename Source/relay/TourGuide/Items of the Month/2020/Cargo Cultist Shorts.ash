RegisterResourceGenerationFunction("IOTMCargoCultistShortsGenerateResource");
void IOTMCargoCultistShortsGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (available_amount($item[cargo cultist shorts]) < 1 || !is_unrestricted($item[cargo cultist shorts])) return;
 
	if (!get_property_boolean("_cargoPocketEmptied")) {
        string image_name = "__item cargo cultist shorts";
 
		string [int] options;
		string [int] description;
        description.listAppend("Pick a pocket for something useful! Too many to list!");
        if (__misc_state["in run"] && my_path_id() != PATH_COMMUNITY_SERVICE)
		{
        	if (!locationAvailable($location[The royal guard Chamber]) == true)
			{
				options.listAppend(HTMLGenerateSpanOfClass("343 - Filthworm Drone Stench:", "r_bold") + " Stinky!");
            }		
			if ($item[star chart].available_amount() < 1 || $item[richard's star key].available_amount() < 1)
            {
                options.listAppend(HTMLGenerateSpanOfClass("533 - greasy desk bell:", "r_bold") + " star key components");
			}
			if (!locationAvailable($location[The eXtreme Slope]) == false)
			{
				options.listAppend(HTMLGenerateSpanOfClass("565 - mountain man:", "r_bold") + " YR for 2x ore");
            }				
			if ($location[The Battlefield (Frat Uniform)].turns_spent < 100)
            {
                options.listAppend(HTMLGenerateSpanOfClass("589 - Green Ops Soldier:", "r_bold") + " olfact for funny meme strategies.");
            }
 
		}
		if (options.count() > 0)
            description.listAppend("Potentially pickable pockets:|*" + options.listJoinComponents("|*"));
 
        resource_entries.listAppend(ChecklistEntryMake("__item cargo cultist shorts", "inventory.php?action=pocket", ChecklistSubentryMake("Cargo shorts pocket openable", "", description), 1).ChecklistEntrySetIDTag("Cargo shorts resource"));
    }
}