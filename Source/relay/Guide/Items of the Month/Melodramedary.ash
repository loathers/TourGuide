RegisterTaskGenerationFunction("IOTMMelodramedaryGenerateTasks");
void IOTMMelodramedaryGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if (my_familiar() != lookupFamiliar("Melodramedary")) return;

    if (get_property_int("camelSpit") == 100)
        task_entries.listAppend(ChecklistEntryMake("__familiar Melodramedary", "familiar.php", ChecklistSubentryMake("Melodramedary: Locked and Loaded!", "", HTMLGenerateSpanFont("Spit!", "blue")), -11).ChecklistEntrySetIDTag("Melodramedary familiar spit ready"));
}

RegisterResourceGenerationFunction("IOTMMelodramedaryResource");
void IOTMMelodramedaryResource(ChecklistEntry [int] resource_entries)
{
    if (!lookupFamiliar("Melodramedary").familiar_is_usable()) return;

    int spit_o_meter = get_property_int("camelSpit");
    
    if (!__misc_state["in run"] && spit_o_meter < 100 && my_familiar() != lookupFamiliar("Melodramedary")) return;
    
    string title;
    string [int] description;
    
    if (spit_o_meter < 100) {
        title = spit_o_meter + "% Melodramedary Spit Charge";

        boolean camelCapped = lookupFamiliar("Melodramedary").familiar_equipped_equipment() == lookupItem("dromedary drinking helmet");
        int fights_left = floor((101 - spit_o_meter) / 3.33);
        if (camelCapped)
            fights_left = ceil(fights_left / 1.3);

        description.listAppend("Ready in " + (camelCapped ? "~" : "") + fights_left.pluralise("fight", "fights") + ".");
    } else {
        title = "Melodramedary: Locked and Loaded!";
        description.listAppend(HTMLGenerateSpanFont("Spit!", "blue"));
    }
    
    description.listAppend("Spit on self for 15 turns of +100% stats & weapon/spell dmg.");
    description.listAppend("Spit on monsters to get 4x of each of their items (2x for conditional items).");
    //There are also certainly even more options of varying effectiveness.
    
    string [int] options;
    if (__misc_state["in run"] && my_path_id() != PATH_COMMUNITY_SERVICE) {
        int bowling_progress = get_property_int("hiddenBowlingAlleyProgress");
        if (bowling_progress > 0 && bowling_progress < 7) {
            int balls_needed = 6 - bowling_progress - $item[bowling ball].available_amount();
            if (balls_needed >= 2)
                options.listAppend("Pygmy bowler; needs +150% item.");
        }

        if (__quest_state["Level 9"].state_boolean["bridge complete"] && __quest_state["Level 9"].state_int["twin peak progress"] != 15 && $item[rusty hedge trimmers].available_amount() < __quest_state["Level 9"].state_int["peak tests remaining"] - 1)
            options.listAppend("Hedge beast; needs +567% item.");
        
        if (__quest_state["Level 11 Ron"].mafia_internal_step == 3 || __quest_state["Level 11 Ron"].mafia_internal_step == 4) //Can't really compare with progress/cable uses for that day, since they could encounter red herring/snapper / wait for the next day
            options.listAppend("Red butler; needs +234% item.");
        
        if (__quest_state["Level 12"].mafia_internal_step > 1 && !__quest_state["Level 12"].state_boolean["Lighthouse Finished"] && $item[barrel of gunpowder].available_amount() < 4)
            options.listAppend("Lobsterfrogman; prob. a weak option.");
        
        if (!__quest_state["Level 12"].finished && __quest_state["Level 12"].state_int["hippies left on battlefield"] > 0 && __quest_state["Level 12"].state_int["hippies left on battlefield"] <= 600 && __misc_state["yellow ray potentially available"])
            options.listAppend("Green Ops Soldier (for free runaways); needs yellow ray.");
    }
    if (options.count() > 0)
        description.listAppend("Possible targets:" + options.listJoinComponents("<hr>").HTMLGenerateIndentedText());
    
    resource_entries.listAppend(ChecklistEntryMake("__familiar Melodramedary", "familiar.php", ChecklistSubentryMake(title, description), 1).ChecklistEntrySetIDTag("Melodramedary familiar resource"));
}
