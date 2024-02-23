
RegisterResourceGenerationFunction("PathWereProfessorGenerateResource");
void PathWereProfessorGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (my_path().id != PATH_WEREPROFESSOR) return;

    // Smashed scientific equipment
    location [int] scientific_locations = {
        $location[Noob Cave],
        $location[The Haunted Pantry],
        $location[Madness Bakery],
        $location[The Thinknerd Warehouse],
        $location[Vanya's Castle],
        $location[The Old Landfill],
        $location[Cobb's Knob Laboratory],
        $location[Cobb's Knob Menagerie, Level 1],
        $location[Cobb's Knob Menagerie, Level 2],
        $location[Cobb's Knob Menagerie, Level 3],
        $location[The Haunted Laboratory],
        $location[The Castle in the Clouds in the Sky (Top Floor)],
        $location[The Hidden Hospital]
    };

    string [int] scientific_locations_description;
    scientific_locations_description.listAppend("Found in a free non-combat on 7th adventure in a zone.");
    if ($effect[Mild-Mannered Professor].have_effect() > 0) scientific_locations_description.listAppend(HTMLGenerateSpanFont("Can only be found as a Beast", "red"));

    location [int] scientific_locations_options;
    foreach key, loc in scientific_locations {
        boolean obtained_equipment = false;
        foreach nc_key, nc in loc.locationSeenNoncombats() {
            if (nc == "The Antiscientific Method") obtained_equipment = true;
        }
        if (!obtained_equipment) scientific_locations_options.listAppend(loc);
    }

    int scientific_locations_sort(location loc) {
        int score = 0;
        // +1 for each turn spent, up to 6
        // -30 if location is inaccessible
        // +3 if location is a quest one and the relevant quest is not yet done
        // +10 if location is the last adventured location

        int turns_spent = loc.turns_spent;
        score += min(6, loc.turns_spent);
        if (!loc.locationAvailable()) score -= 30;

        if (loc == $location[Vanya's Castle]) score += 3; // should always get that one in the optimal scenario
        if (loc == $location[The Castle in the Clouds in the Sky (Top Floor)] && !__quest_state["Level 10"].finished) score += 3;
        if (loc == $location[The Hidden Hospital] && !__quest_state["Level 11 Hidden City"].state_boolean["Hospital finished"]) score += 3;

        if (__last_adventure_location == loc) score += 10;
        return score;
    }

    sort scientific_locations_options by -scientific_locations_sort(value);

    string [int] loc_descriptions;

    foreach key, loc in scientific_locations_options {
        int turns_spent = loc.turns_spent;
        string scientific_locations_option = loc.HTMLGenerateFutureTextByLocationAvailability();
        if (turns_spent < 6) scientific_locations_option += " - " + pluralise(6 - turns_spent, "turn left", "turns left");
        else scientific_locations_option += " - drops next turn";
        loc_descriptions.listAppend(scientific_locations_option);
    }

    if (scientific_locations_options.count() > 0) {
        if (scientific_locations_options.count() > 3) {
            scientific_locations_description.listAppend("Drop locations:" + (loc_descriptions[0] + "<hr>" + HTMLGenerateSpanOfClass(HTMLGenerateSpanOfClass(loc_descriptions.listJoinComponents("<hr>").HTMLGenerateIndentedText(), "r_tooltip_inner_class") + "All locations", "r_tooltip_outer_class")).HTMLGenerateIndentedText());
        }
        else scientific_locations_description.listAppend("Drop locations:" + loc_descriptions.listJoinComponents("<hr>").HTMLGenerateIndentedText());

        resource_entries.listAppend(ChecklistEntryMake("__item smashed scientific equipment", "", ChecklistSubentryMake("Obtain smashed scientific equipment", "", scientific_locations_description)));
    }

    // Owned smashed scientific equipment
    if (have($item[smashed scientific equipment])) {
        string [int] smashed_equipment_description;
        string [int] craftable_items;

        if ($effect[Savage Beast].have_effect() > 0) smashed_equipment_description.listAppend("Wait until you are a Professor to craft stuff.");

        // Science-producting hats -- TODO: ignore if have all Stomach/Liver upgrades (pending Mafia support)
        if (!have($item[biphasic molecular oculus]) && !have($item[triphasic molecular oculus])) craftable_items.listAppend("biphasic molecular oculus (more Research Points)");
        if (have($item[biphasic molecular oculus])) craftable_items.listAppend("triphasic molecular oculus (more Research Points)");
        // Exoskeletons
        if (!have($item[high-tension exoskeleton]) && !have($item[ultra-high-tension exoskeleton]) && !have($item[irresponsible-tension exoskeleton])) craftable_items.listAppend("high-tension exoskeleton (avoid attacks)");
        if (have($item[high-tension exoskeleton])) craftable_items.listAppend("ultra-high-tension exoskeleton (avoid attacks)");
        if (have($item[ultra-high-tension exoskeleton])) craftable_items.listAppend("irresponsible-tension exoskeleton (avoid attacks)");
        // Initiative, consider if no Spring Shoes available (since they do the same thing) and cannot equip Parka (protection from the jump)
        if (!(__misc_state["Torso aware"] && have($item[Jurassic Parka])) && !have($item[spring shoes]) && !have($item[motion sensor])) craftable_items.listAppend("motion sensor (+100% initiative accessory)");

        if (craftable_items.count() > 0) {
            smashed_equipment_description.listAppend("Consider crafting:" + craftable_items.listJoinComponents("<hr>").HTMLGenerateIndentedText());
        }

        resource_entries.listAppend(ChecklistEntryMake("__item smashed scientific equipment", "", ChecklistSubentryMake(pluralise($item[smashed scientific equipment]) + " available", "", smashed_equipment_description)));
    }
}

RegisterTaskGenerationFunction("PathWereProfessorGenerateTasks");
void PathWereProfessorGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    // TODO: Professor shopping spree
    // (a reminder to buy stuff because Beast cannot access shops)
    // (also research stuff, but this requires Mafia support)

    // TODO: supernag to remove ML if you have 26+ ML and are a Professor
    // (start-of-combat elemental damage)
}