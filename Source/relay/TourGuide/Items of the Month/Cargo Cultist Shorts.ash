RegisterResourceGenerationFunction("IOTMCargoCultistShortsGenerateResource");
void IOTMCargoCultistShortsGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (available_amount($item[cargo cultist shorts]) < 1 || !is_unrestricted($item[cargo cultist shorts])) return;
 
	if (!get_property_boolean("_cargoPocketEmptied")) {
        string image_name = "__item cargo cultist shorts";
        string description = "Pick a pocket for something useful! Too many to list!";
 
		string [int] options;
        if (__misc_state["in run"] && my_path_id() != PATH_COMMUNITY_SERVICE)
        {
        	if (!locationAvailable($location[The royal guard Chamber]))
			{
				options.listAppend("Stink like a filthworm drone");
            }		
			if (!locationAvailable($location[The eXtreme Slope]) == false)
			{
				options.listAppend("Mountain Man, YR for 2x ore");
            }				
			if ($location[The Battlefield (Frat Uniform)].turns_spent < 100)
            {
                options.listAppend("Green Ops Soldier, olfact for funny meme strategies");
            }
		}
		if (options.count() > 0)
        	options.listAppend("Possible pockets:<hr>" + options.listJoinComponents("<hr>").HTMLGenerateIndentedText());
 
        resource_entries.listAppend(ChecklistEntryMake("__item cargo cultist shorts", "inventory.php?action=pocket", ChecklistSubentryMake("Cargo shorts pocket openable", "", description), 1).ChecklistEntrySetIDTag("Cargo shorts resource"));
    }
}
