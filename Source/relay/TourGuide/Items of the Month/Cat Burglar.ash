
RegisterResourceGenerationFunction("IOTMCatBurglarGenerateResource");
void IOTMCatBurglarGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (!lookupFamiliar("cat burglar").familiar_is_usable()) return;
    
    int charges_left = CatBurglarChargesLeftToday();
    if (charges_left > 0) {
        string [int] description;
        string url = "familiar.php";
        if (my_familiar() == lookupFamiliar("cat burglar"))
            url = "main.php?heist=1";
        //√rusty hedge trimmers
        //√bowling ball
        //cigarette lighter, if they're doing zeppelin
        //scent glands, but only if they don't xoxoxoxo
        //√green smoke bomb
        //There are also certainly even more options.
        description.listAppend("Obtains one item from a recent fight.");
        string [int] options;
        if (__misc_state["in run"] && my_path_id() != PATH_COMMUNITY_SERVICE) {
            int bowling_progress = get_property_int("hiddenBowlingAlleyProgress");
            if (bowling_progress < 7) {
                int balls_needed = 6 - bowling_progress - $item[bowling ball].available_amount();
                if (balls_needed > 0)
                    options.listAppend("Bowling ball, from the hidden bowling alley.");
            }
            if (get_property_int("twinPeakProgress") != 15 && $item[rusty hedge trimmers].available_amount() < __quest_state["Level 9"].state_int["peak tests remaining"]) {
                options.listAppend("Rusty hedge trimmers, from the twin peak.");
            }
            if (!__quest_state["Level 12"].finished && get_property("sidequestOrchardCompleted") == "none") {
                options.listAppend("Green smoke bomb, from the war.");
                if (!lookupFamiliar("XO Skeleton").familiar_is_usable())
                    options.listAppend("Scent glands, from the filthworms quest.");
            }
            if (get_property_int("zeppelinProtestors") < 80 && QuestState("questL11Ron").mafia_internal_step < 3) {
                options.listAppend("Cigarette lighters, from the zeppelin protesters.");
            }
            if ($item[pirate fledges].available_amount() == 0 && !have_outfit_components("Swashbuckling Getup") && __quest_state["Pirate Quest"].state_boolean["valid"]) {
            	options.listAppend("Pirate outfit.");
            }
            
            if ($item[S.O.C.K.].available_amount() == 0) {
                string [int] airship_stealables;
                foreach it in $items[mohawk wig,amulet of extreme plot significance] {
                    if (it.available_amount() == 0)
                        airship_stealables.listAppend(it);
                }
                if (airship_stealables.count() > 0)
                    options.listAppend(airship_stealables.listJoinComponents(", ", "and").capitaliseFirstLetter() + ", from the airship.");
            }
            if (__quest_state["Level 4"].state_int["areas unlocked"] + $item[sonar-in-a-biscuit].available_amount() < 3)
                options.listAppend("Sonar-in-a-biscuit, from the bat hole.");
            if (!__quest_state["Level 11 Desert"].state_boolean["Desert Explored"] && !__quest_state["Level 11 Desert"].state_boolean["Killing Jar Given"] && $item[killing jar].available_amount() == 0) // && !($location[The Haunted Gallery].locationAvailable() && !$location[The Haunted Library].locationAvailable()) //that was from when you could use copied/wished writing desks to skip the library...
                options.listAppend("Killing jar, from the haunted library.");
            if (!have_outfit_components("Knob Goblin Elite Guard Uniform") && !have_outfit_components("Knob Goblin Harem Girl Disguise") && !__quest_state["Level 5"].finished)
                options.listAppend("Harem girl outfit, if you can't reach +400% item.");
        }
        if (options.count() > 0)
            description.listAppend("Could steal:|*-" + options.listJoinComponents("|*-"));
          
        resource_entries.listAppend(ChecklistEntryMake("__familiar Cat Burglar", url, ChecklistSubentryMake(pluralise(charges_left, "heist", "heists"), "", description), 1).ChecklistEntrySetIDTag("Cat burglar resource"));      
    }
}
