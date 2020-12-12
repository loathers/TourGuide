RegisterTaskGenerationFunction("IOTMMaySaberPartyGenerateTasks");
void IOTMMaySaberPartyGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if (lookupItem("Fourth of May Cosplay Saber").available_amount() == 0) return;

    if (get_property_int("_saberMod") == 0) {
        string [int] options;
        if (in_ronin()) {
            options.listAppend("Regen ~17 MP/adventure.");
            options.listAppend("+20 ML.");
            options.listAppend("+3 all resistances.");
        }
        options.listAppend("+10 familiar weight.");
        
        string [int] description;
        if (options.count() > 1)
            description.listAppend("Choose one of:|*" + options.listJoinComponents("|*"));
        else
            description.listAppend(options.listJoinComponents("|"));
        optional_task_entries.listAppend(ChecklistEntryMake("__item Fourth of May Cosplay Saber", "main.php?action=may4", ChecklistSubentryMake("Modify your lightsaber", "", description), 8).ChecklistEntrySetIDTag("Fourth may saber daily upgrade"));
    }


    monster saber_monster = get_property_monster("_saberForceMonster");
    if (saber_monster != $monster[none]) {
        int fights_left = clampi(get_property_int("_saberForceMonsterCount"), 0, 3);
        location [int] possible_appearance_locations = saber_monster.getPossibleLocationsMonsterCanAppearInNaturally().listInvert();
        
        if (fights_left > 0 && possible_appearance_locations.count() > 0)
            optional_task_entries.listAppend(ChecklistEntryMake("__monster " + saber_monster, possible_appearance_locations[0].getClickableURLForLocation(), ChecklistSubentryMake("Fight " + pluralise(fights_left, "more " + saber_monster, "more " + saber_monster + "s"), "", "Will appear when you adventure in " + possible_appearance_locations.listJoinComponents(", ", "or") + "."), -1).ChecklistEntrySetIDTag("Fourth may saber friend copies"));
    }
}

RegisterResourceGenerationFunction("IOTMMaySaberGenerateResource");
void IOTMMaySaberGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (lookupItem("Fourth of May Cosplay Saber").available_amount() == 0) return;

    int uses_remaining = clampi(5 - get_property_int("_saberForceUses"), 0, 5);

    if (uses_remaining > 0) {
        if (true) {
            //The section that will be sent as a stand-alone resource
            string url;
            if (!lookupItem("Fourth of May Cosplay Saber").equipped())
                url = "inventory.php?ftext=fourth+of+may+cosplay+saber";

            string [int] description;
            description.listAppend("Use the force skill in combat, which lets you:");
            description.listAppend("Banish a monster for thirty turns.");
            description.listAppend("Make the monster appear 3x times its zone.");
            description.listAppend("Or collect all* their items.");
            if (my_path_id() == PATH_COMMUNITY_SERVICE && $skill[Meteor Lore].have_skill())
                description.listAppend("Bonus! Use Meteor Shower + lightsaber skill to save a bunch of turns on weapon damage/spell damage/familiar weight tests.");

            //description.listAppend("Choose one of:|*" + options.listJoinComponents("|*"));
            resource_entries.listAppend(ChecklistEntryMake("__item Fourth of May Cosplay Saber", url, ChecklistSubentryMake(uses_remaining.pluralise("force use", "forces uses"), "", description)).ChecklistEntrySetIDTag("Fourth may saber force resource")); //"forces uses"? typo or reference/joke?
        }

        if (true) {
            //The section that will be sent as a "banish" tile
            string [int] description;
            if (!lookupItem("Fourth of May Cosplay Saber").equipped())
                description.listAppend(HTMLGenerateSpanFont("Equip the Fourth of May saber first", "red"));
            else
                description.listAppend("Rollover runaway-like/banish");

            resource_entries.listAppend(ChecklistEntryMake("__item Fourth of May Cosplay Saber", "inventory.php?which=2", ChecklistSubentryMake("(up to) " + uses_remaining.pluralise("force banish", "forces banishes"), "", description)).ChecklistEntrySetCombinationTag("banish").ChecklistEntrySetIDTag("Fourth may saber force banish"));
        }
    }
}