
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
    if ($effect[Mild-Mannered Professor].have_effect() > 0) {
        boolean should_nag = false;

        string [int] professor_tips;

        // Too high ML!
        if (monster_level_adjustment() > 25) {
            should_nag = true;
            professor_tips.listAppend(HTMLGenerateSpanFont(`Reduce ML, elemental monsters will kill you at the start of combat with +{monster_level_adjustment()} ML.`, "red"));
        }

        boolean wearing_quest_outfit = false;
        if (is_wearing_outfit("Knob Goblin Harem Girl Disguise")) wearing_quest_outfit = true;
        if (is_wearing_outfit("Knob Goblin Elite Guard Uniform")) wearing_quest_outfit = true;
        if (is_wearing_outfit("eXtreme Cold-Weather Gear")) wearing_quest_outfit = true;
        if (is_wearing_outfit("War Hippy Fatigues")) wearing_quest_outfit = true;
        if (is_wearing_outfit("Frat Warrior Fatigues")) wearing_quest_outfit = true;

        // Equip research equipment. TODO: don't show it if we have 2250 points total; don't nag it if we have all of stomach and liver skills
        foreach it in $items[biphasic molecular oculus,triphasic molecular oculus] {
            if (have(it) && it.equipped_amount() == 0) {
                if (!wearing_quest_outfit) {
                    should_nag = true;
                    professor_tips.listAppend(HTMLGenerateSpanFont(`Equip your {it} to do advanced research.`, "red"));
                }
                else professor_tips.listAppend(`Equip your {it} to do advanced research.`);
            }
        }

        // Equip attack avoidance pants
        foreach it in $items[high-tension exoskeleton,ultra-high-tension exoskeleton,irresponsible-tension exoskeleton] {
            if (have(it) && it.equipped_amount() == 0) {
                professor_tips.listAppend(`Equip your {it} to avoid enemy attacks.`);
            }
        }

        // Equip something to avoid the jump
        if (initiative_modifier() < 100 && $item[Jurassic Parka].equipped_amount() == 0) {
            if (__misc_state["Torso aware"] && have($item[Jurassic Parka])) {
                should_nag = true;
                professor_tips.listAppend(HTMLGenerateSpanFont("Equip your Jurassic Parka to avoid enemies getting the jump and instakilling you.", "red"));
            }
            else {
                professor_tips.listAppend(`Increase your initiative (currently {initiative_modifier()}%) to avoid enemies getting the jump and instakilling you.`);
            }
        }

        // Buy stuff
        string [int] stuff_to_buy;
        if (get_property_int("_cloversPurchased") < 3) stuff_to_buy.listAppend("11-leaf clovers");
        if (!__misc_state["desert beach available"]) {
            if (!knoll_available()) stuff_to_buy.listAppend("desert bus pass");
            else stuff_to_buy.listAppend("bitchin' meatcar components");
        }
        if (knoll_available() && !have($item[detuned radio])) stuff_to_buy.listAppend("detuned radio");
        // TODO: Dramatic Range 
        //if (__quest_state["Level 11 Manor"].mafia_internal_step < 4 && !have($item[Dramatic&trade; range]) && not in campground) stuff_to_buy.listAppend("Dramatic&trade; range");

        if (stuff_to_buy.count() > 0) {
            professor_tips.listAppend("Buy stuff before you become a Beast again: " + stuff_to_buy.listJoinComponents(", ", "or") + ".");
        }

        int priority = 12;
        ChecklistEntry [int] tips_location = optional_task_entries;
        if (should_nag) {
            priority = -11;
            tips_location = task_entries;
        }

        if (professor_tips.count() > 0) {
            tips_location.listAppend(ChecklistEntryMake("__monster government scientist", "", ChecklistSubentryMake("You are a Professor", professor_tips), priority));
        }
    }
}