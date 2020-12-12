
RegisterLowKeyGenerationFunction("PathLowKeyGenerateKeys");
void PathLowKeyGenerateKeys(ChecklistEntry [int] low_key_entries) {

    if (my_path_id() != PATH_LOW_KEY_SUMMER) return;
    if (__quest_state["Lair"].state_boolean["past keys"]) return;

    //LKS-specific keys
    foreach index, key in LKS_keys {
        if (key.was_used || key.it.available_amount() > 0) continue;

        string url;

        // Entries
        string [int] description;

        // Set unlock messages or delay messages
        if (!key.zone.locationAvailable()) {
            description.listAppend("Unlock " + key.zone + " by " + key.condition_for_unlock);
            url = key.pre_unlock_url;
        } else {
            int delayLeft = 11 - key.zone.turns_spent;
            if (delayLeft > 0)
                description.listAppend("Delay for  " + pluralise(delayLeft, "turn", "turns") + " in " + key.zone + " to find key.");
            else
                description.listAppend("Find key on next turn in " + key.zone);

            url = key.zone.getClickableURLForLocation();
        }

        low_key_entries.listAppend(ChecklistEntryMake("__item " + key.it.name, url, ChecklistSubentryMake(key.it.name.capitaliseFirstLetter(), key.enchantment, description), boolean [location] {key.zone:true}).ChecklistEntrySetIDTag("Low key summer path " + key.it.name));
    }

    //base keys
    SLevel13DoorGenerateMissingItems(low_key_entries);
}
