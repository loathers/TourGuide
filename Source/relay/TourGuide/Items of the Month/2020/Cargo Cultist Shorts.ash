RegisterResourceGenerationFunction("IOTMCargoCultistShortsGenerateResource");
void IOTMCargoCultistShortsGenerateResource(ChecklistEntry [int] resource_entries)
{
	if (!__iotms_usable[$item[Cargo Cultist Shorts]]) return;
 
	if (!get_property_boolean("_cargoPocketEmptied")) {
        string image_name = "__item cargo cultist shorts";

        boolean [int] empty_pockets;
        string [int] empty_pocket_list = split_string(get_property("cargoPocketsEmptied"), ",");
        foreach pocket in split_string(get_property("cargoPocketsEmptied"), ",") {
            empty_pockets[to_int(empty_pocket_list[i])] = true;
        }
 
		string [int] options;
		string [int] description;
        description.listAppend("Pick a pocket for something useful! Too many to list!");
        if (__misc_state["in run"] && my_path().id != PATH_COMMUNITY_SERVICE)
		{
        	if (locationAvailable($location[The royal guard Chamber]) == true && !(empty_pockets contains 343))
            {
                options.listAppend(HTMLGenerateSpanOfClass("343 - Filthworm Drone Stench:", "r_bold") + " Stinky!");
            }        
            if ($item[star chart].available_amount() == 0 && $item[richard's star key].available_amount() == 0 && !(empty_pockets contains 533))
            {
                options.listAppend(HTMLGenerateSpanOfClass("533 - greasy desk bell:", "r_bold") + " star key components");
            }
            if (locationAvailable($location[The eXtreme Slope]) == false && !(empty_pockets contains 565))
            {
                options.listAppend(HTMLGenerateSpanOfClass("565 - mountain man:", "r_bold") + " YR for 2x ore");
            }                
            if (locationAvailable($location[The Battlefield (Frat Uniform)]) == false && !(empty_pockets contains 589))
            {
                options.listAppend(HTMLGenerateSpanOfClass("589 - Green Ops Soldier:", "r_bold") + " olfact for funny meme strategies.");
            }
 
		}
		if (options.count() > 0)
            description.listAppend("Potentially pickable pockets:|*" + options.listJoinComponents("|*"));
 
        resource_entries.listAppend(ChecklistEntryMake("__item cargo cultist shorts", "inventory.php?action=pocket", ChecklistSubentryMake("Cargo shorts pocket openable", "", description), 1).ChecklistEntrySetIDTag("Cargo shorts resource"));
    }
}