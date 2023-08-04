RegisterTaskGenerationFunction("IOTMKramcoSausageOMaticGenerateTasks");
void IOTMKramcoSausageOMaticGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if (!__iotms_usable[lookupItem("Kramco Sausage-o-Matic&trade;")]) return;
    
    //If goblin is up, display reminder:
    KramcoSausageFightInformation fight_information = KramcoCalculateSausageFightInformation();
    if (fight_information.turns_to_next_guaranteed_fight == 0 && my_path().id != PATH_LIVE_ASCEND_REPEAT && __misc_state["in run"])
    {
        
        string url = "";
        string [int] description;
        string title = "Fight sausage goblin ";
        int kramcosEquipped = lookupItem("Kramco Sausage-o-Matic&trade;").equipped_amount() + lookupItem("replica Kramco Sausage-o-Matic&trade;").equipped_amount();

        if (kramcosEquipped == 0) {
            description.listAppend(HTMLGenerateSpanFont("Equip the Kramco Sausage-o-Matic&trade; first.", "red"));
            url = "inventory.php?ftext=kramco+sausage-o-matic";
        }
        description.listAppend("Free fight that burns delay.");
        location [int] possible_locations = generatePossibleLocationsToBurnDelay();
        if (possible_locations.count() > 0) {
            description.listAppend("Adventure in " + possible_locations.listJoinComponents(", ", "or") + " to burn delay.");
            if (url == "")
                url = possible_locations[0].getClickableURLForLocation();
        }
        task_entries.listAppend(ChecklistEntryMake("__item Kramco Sausage-o-Matic&trade;", url, ChecklistSubentryMake(title, "", description), -11).ChecklistEntrySetIDTag("Kramco sausage grinder goblin fight reminder"));
    }
}

RegisterResourceGenerationFunction("IOTMKramcoSausageOMaticGenerateResource");
void IOTMKramcoSausageOMaticGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (!__iotms_usable[lookupItem("Kramco Sausage-o-Matic &trade;")] || my_path().id == PATH_LIVE_ASCEND_REPEAT) return;

    ChecklistEntry entry;
    entry.image_lookup_name = "__item Kramco Sausage-o-Matic&trade;";
    entry.url = "inventory.php?action=grind";
    entry.tags.id = "Kramco sausage grinder resource";
    entry.importance_level = -2;
    
    string [int] main_description;
    string main_title;
    
    KramcoSausageFightInformation fight_information = KramcoCalculateSausageFightInformation();
    
    int kramcosEquipped = lookupItem("Kramco Sausage-o-Matic&trade;").equipped_amount() + lookupItem("replica Kramco Sausage-o-Matic&trade;").equipped_amount();

    if (fight_information.turns_to_next_guaranteed_fight == 0) {
        main_title = "Sausage goblin fight available";
        if (kramcosEquipped == 0) {
            main_description.listAppend(HTMLGenerateSpanFont("Equip the Kramco Sausage-o-Matic&trade; first.", "red"));
            entry.url = "inventory.php?action=grind";
        }
    } else {
        main_title = round(fight_information.probability_of_sausage_fight * 100.0) + "% chance of Kramco fight this turn";
        main_description.listAppend(pluralise(fight_information.turns_to_next_guaranteed_fight, "turn", "turns") + " until next guaranteed goblin fight.");
        if (kramcosEquipped == 0) {
            main_description.listAppend(HTMLGenerateSpanFont("Equip the Kramco Sausage-o-Matic&trade; first.", "red"));
            entry.url = "inventory.php?action=grind";
        }
    }

    main_description.listAppend("Does not cost a turn; burns delay.");
    
    int fights_so_far = get_property_int("_sausageFights");
    if (fights_so_far > 0) {
        main_description.listAppend("Fought " + pluralise(fights_so_far, "goblin", "goblins") + " so far.");
    }

    entry.subentries.listAppend(ChecklistSubentryMake(main_title, "", main_description));

    int sausage_casings = lookupItem("magical sausage casing").available_amount();
    int sausages_eaten = get_property_int("_sausagesEaten");
    int sausages_available = lookupItem("magical sausage").available_amount();
    int possible_sausages = sausages_available + sausage_casings;
    if (possible_sausages > 0 && sausages_eaten < 23) {
        string [int] sausage_description;
        int sausages_made = get_property_int("_sausagesMade");
        int meat_cost = 111 * (sausages_made + 1);
        sausage_description.listAppend("+1 adventure and +999 MP each.");
        sausage_description.listAppend(HTMLGenerateSpanOfClass(sausage_casings, "r_bold") + " casings available, " + HTMLGenerateSpanOfClass(sausages_eaten + "/23", "r_bold") + " eaten today.");
        if (sausages_made > 22)
		{
            sausage_description.listAppend(HTMLGenerateSpanFont(sausages_made + " sausages made today.", "purple"));
        }	
        else
		{
			sausage_description.listAppend(pluralise(sausages_made, "sausage", "sausages") + " made; next costs " + meat_cost + " meat.");
		}
        entry.subentries.listAppend(ChecklistSubentryMake(pluralise(MIN(sausages_available, 23 - sausages_eaten), "magical sausage", "magical sausages") + " edible", "", sausage_description));
    }
    
    resource_entries.listAppend(entry);
}