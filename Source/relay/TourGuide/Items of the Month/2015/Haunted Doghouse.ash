RegisterResourceGenerationFunction("IOTMHauntedDoghouseGenerateResource");
void IOTMHauntedDoghouseGenerateResource(ChecklistEntry [int] resource_entries)
{
    // No need for an in-run quash on this one.
    // if (!__misc_state["in run"])
    //     return;
    if ($item[tennis ball].available_amount() > 0 && $item[tennis ball].item_is_usable())
    {
        resource_entries.listAppend(ChecklistEntryMake("__item tennis ball", "", ChecklistSubentryMake(pluralise($item[tennis ball]), "", "Free run, 30-turn banish."), 0).ChecklistEntrySetCombinationTag("banish").ChecklistEntrySetIDTag("Haunted doghouse banish"));
    }
    //I, um, hmm. I guess there's not much to say. Poor lonely file, nearly empty.
    //... right??? Smallest file! 
}



