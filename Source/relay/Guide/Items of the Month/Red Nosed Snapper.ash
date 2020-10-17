
RegisterTaskGenerationFunction("IOTMRedNosedSnapperTask");
void IOTMRedNosedSnapperTask(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if (!lookupFamiliar("Red Nosed Snapper").familiar_is_usable()) return;
    if (my_familiar() != lookupFamiliar("Red Nosed Snapper")) return;

    phylum current_snapper_phylum = get_property("redSnapperPhylum").to_phylum();

    if (current_snapper_phylum == $phylum[none]) {
        optional_task_entries.listAppend(ChecklistEntryMake("__familiar red-nosed snapper", "familiar.php?action=guideme&pwd=" + my_hash(), ChecklistSubentryMake("Track monsters", "+ of them and gives items", "Choose a phylum".HTMLGenerateSpanOfClass("r_element_important")), 8).ChecklistEntrySetIDTag("Red nosed snapper familiar set tracking"));
        return;
    }


    //Check if the currently tracked phylum is undoing a banish
    location l = __last_adventure_location;
    if (!__setting_location_bar_uses_last_location && !get_property_boolean("_relay_guide_setting_ignore_next_adventure_for_location_bar") && get_property_location("nextAdventure") != $location[none]) //want to mimic location bar popup, so they can look at it for information
        l = get_property_location("nextAdventure");

    monster [int] banishes_undone_by_snapper;
    foreach index, monstr in l.get_monsters()
        if (monstr.phylum == current_snapper_phylum && monstr.is_banished())
            banishes_undone_by_snapper.listAppend(monstr);

    if (banishes_undone_by_snapper.count() > 0) {
        string title = "Your Snapper is undoing a banish".HTMLGenerateSpanOfClass("r_element_important");
        task_entries.listAppend(ChecklistEntryMake("__familiar red-nosed snapper", "familiar.php?action=guideme&pwd=" + my_hash(), ChecklistSubentryMake(title, "Change tracked phylum or switch familiar", "Bringing your snapper while it is tracking <b>" + current_snapper_phylum + "</b> is unbanishing " + banishes_undone_by_snapper.listJoinComponents(", ", "and")), -10).ChecklistEntrySetIDTag("Red nosed snapper familiar warning"));

        ChecklistEntry pop_up_reminder_entry = ChecklistEntryMake("__familiar red-nosed snapper", "", ChecklistSubentryMake(title), -11);
        pop_up_reminder_entry.tags.id = "Red nosed snapper familiar popup";
        pop_up_reminder_entry.only_show_as_extra_important_pop_up = true;
        pop_up_reminder_entry.container_div_attributes["onclick"] = "navbarClick(0, 'Tasks_checklist_container')";
        pop_up_reminder_entry.container_div_attributes["class"] = "r_clickable";
        task_entries.listAppend(pop_up_reminder_entry);
    }
}

RegisterResourceGenerationFunction("IOTMRedNosedSnapperResource");
void IOTMRedNosedSnapperResource(ChecklistEntry [int] resource_entries)
{
    if (!lookupFamiliar("Red Nosed Snapper").familiar_is_usable()) return;

    boolean always_display = false; //user-preference

    if (my_familiar() != lookupFamiliar("Red Nosed Snapper") && !__misc_state["in run"] && !always_display) return;

    //beast = +5 cold res (not a lot of places to go for those, esp. since it's for a quite optional effect...)
    //bug = +100% HP, 8-10 HP regen (spleen) (not really... useful enough to mention those outside of the zones having them..?)
    //constellation = Yellow ray
    //construct = +150% init (spleen)
    //demon = +5 hot res (suggested in a zone that already has one (haunted kitchen)) (there's some hellseals, though..?)
    //dude = All-day free (3x/day) banish item
    //elemental = +50% MP, 3-5 MP regen (spleen) (would recommend the snowman ninja lair, but we can't know if they chose hippy route instead; we know when they ARE there...)
    //elf = +50% candy (not encountered in-run, nor has... any... use?)
    //fish = Fishy (spleen)
    //goblin = 3-size food
    //hippy = +5 stench res
    //hobo = +100% meat (spleen) (only seen in overgrown lot, sleazy back alley, or hobopolis)
    //horror = 5x/day free kill
    //humanoid = +50% muscle stats (spleen)
    //mer-kin = +30% underwater items
    //orc = 3-size booze
    //penguin = gives meat (never useful, nor encountered in run, really)
    //pirate = +50% moxie stats (spleen)
    //plant = Full HP restore in combat
    //slime = +5 sleaze res (would be good for bridge, but there's very few slimes before that...)
    //undead = +5 spooky res
    //weird = +50% myst stats (spleen) (way too rare in-run to recommend)

    boolean going_in_Degrassi_Knoll = !knoll_available() && my_path_id() != PATH_NUCLEAR_AUTUMN && !__misc_state["desert beach available"] && __misc_state["guild open"];
    boolean making_Junk_Junk = !__misc_state["mysterious island available"] && __quest_state["Old Landfill"].in_progress;
    boolean Azazel_quest_is_in_progress = __quest_state["Azazel"].in_progress && !in_bad_moon() && $locations[The Laugh Floor, Infernal Rackets Backstage].turnsAttemptedInLocation() > 0;
    boolean nemesis_quest_at_clown_house = __quest_state["Nemesis"].mafia_internal_step == 6;
    boolean nemesis_quest_at_Fungal_Nethers = $ints[13,14,15] contains __quest_state["Nemesis"].mafia_internal_step;
    boolean cyrpt_modern_zmobies_are_appreciated = !__quest_state["Cyrpt"].state_boolean["alcove finished"] && __quest_state["Cyrpt"].state_int["alcove evilness"] > 1;
    boolean at_chasm_bridge = __quest_state["Highland Lord"].mafia_internal_step == 1;
    boolean past_chasm_bridge = __quest_state["Highland Lord"].mafia_internal_step > 1;
    boolean want_more_rusty_hedge_trimmers = __quest_state["Highland Lord"].state_boolean["can complete twin peaks quest quickly"] && __quest_state["Highland Lord"].state_int["twin peak progress"] < 15 && $item[rusty hedge trimmers].available_amount() < __quest_state["Highland Lord"].state_int["peak tests remaining"];
    boolean looking_for_mining_gear = __quest_state["Trapper"].in_progress && !__quest_state["Trapper"].state_boolean["Past mine"] && __quest_state["Trapper"].state_string["ore needed"].to_item().available_amount() < 3 && !have_outfit_components("Mining Gear") && my_path_id() != PATH_AVATAR_OF_BORIS && my_path_id() != PATH_WAY_OF_THE_SURPRISING_FIST;
    boolean they_may_be_ninjas = __quest_state["Trapper"].state_boolean["Past mine"] && ($location[lair of the ninja snowmen].turns_spent > 0 || $location[the extreme slope].turns_spent == 0);
    boolean have_some_pirating_to_do = __misc_state["mysterious island available"] && __quest_state["Pirate Quest"].state_boolean["valid"] && !__quest_state["Island War"].state_boolean["War in progress"];
    boolean have_access_to_giant_castle = $item[s.o.c.k.].available_amount() > 0 || my_path_id() == PATH_EXPLOSION;
    boolean top_floor_done = __quest_state["Castle"].mafia_internal_step > 10 && $location[the hole in the sky].locationAvailable();
    boolean going_in_the_HITS = $location[the hole in the sky].locationAvailable() && $item[richard\'s star key].available_amount() == 0 && !__quest_state["Level 13"].state_boolean["Richard's star key used"];
    boolean exploring_desert = __quest_state["Level 11"].in_progress && !__quest_state["Level 11 Desert"].state_boolean["Desert Explored"];
    boolean at_hidden_city = __quest_state["Hidden Temple Unlock"].finished && __quest_state["Level 11 Hidden City"].in_progress;
    boolean have_more_dense_lianas_to_fight = at_hidden_city && __quest_state["Level 11 Hidden City"].state_int["lianas left"] > 0;
    boolean making_wine_bomb = __quest_state["Level 11 Manor"].mafia_internal_step == 3 && get_property("spookyravenRecipeUsed") == "with_glasses";
    boolean helping_Yossarian = __quest_state["Island War"].state_boolean["War in progress"] && !__quest_state["Island War"].state_boolean["Junkyard Finished"];
    boolean fighting_filthworms = __quest_state["Island War"].state_boolean["War in progress"] && !__quest_state["Island War"].state_boolean["Orchard Finished"] && my_path_id() != PATH_2CRS;
    boolean CS_need_to_pass_hot_res_test = my_path_id() == PATH_COMMUNITY_SERVICE && !(get_property("csServicesPerformed").split_string_alternate(",").listInvert() contains "Clean Steam Tunnels");


    string [int] currentlyReachableInstancesOfPhylum(phylum phyl) {
        string [int] reachable_instances;
        if (phyl == $phylum[constellation] && !$location[the hole in the sky].locationAvailable())
            reachable_instances.listAppend("Unreachable");

        switch (phyl) {
            case $phylum[beast]: //twin peak topiary animals (is that really all there is to "good" beasts locations?)
                if (past_chasm_bridge && want_more_rusty_hedge_trimmers)
                    reachable_instances.listAppend("twin peak topiary animals");
                break;

            case $phylum[bug]: //desert and filthworms
                if (exploring_desert)
                    reachable_instances.listAppend("arid, extra-dry desert");
                if (fighting_filthworms)
                    reachable_instances.listAppend("filthworms");
                break;

            case $phylum[constellation]: //Hole in the Sky, and nothing else
                if (going_in_the_HITS)
                    reachable_instances.listAppend("hole in the sky");
                break;

            case $phylum[construct]: //monstrous boiler and wine rack
                if (making_wine_bomb) {
                    if ($item[unstable fulminate].available_amount() == 0 && $item[bottle of Chateau de Vinegar].available_amount() == 0)
                        reachable_instances.listAppend("wine rack");
                    reachable_instances.listAppend("monstrous boiler");
                }
                break;

            case $phylum[demon]: //(some) hellseals and demons from friars and hey-deze
                if (my_class() == $class[seal clubber] && my_level() >= 5)
                    reachable_instances.listAppend("figurine of " + (my_level() >= 6 ? "ancient" : "cute baby") + " seal");
                if (__quest_state["Friars"].in_progress)
                    reachable_instances.listAppend("dark X of the woods (friars)");
                if (Azazel_quest_is_in_progress)
                    reachable_instances.listAppend("Hey Deze");
                break;

            case $phylum[dude]: //they're everywhere!!!! (I'm not even gonna TRY to do anything past that.)
                reachable_instances.listAppend("too many to count");
                break;

            case $phylum[elemental]: //ninja snowmen, not really worth it, though..?
                if (they_may_be_ninjas && !__quest_state["Trapper"].state_boolean["Mountain climbed"])
                    reachable_instances.listAppend("ninja snowmen");
                break;

            case $phylum[elf]: //can't reach, nor want, in-run
                break;

            case $phylum[fish]: //can't reach, nor want, in-run
                break;

            case $phylum[goblin]: //kramco & cobbs knob
                if (lookupItem("Kramco Sausage-o-Matic&trade;").available_amount() > 0)
                    reachable_instances.listAppend("kramco sausage goblins");
                if (!__quest_state["Knob Goblin King"].finished)
                    reachable_instances.listAppend("cobbs knob");
                break;

            case $phylum[hippy]: //hippy camp
                if (__misc_state["mysterious island available"] && __quest_state["Island War"].state_string["Side seemingly fighting for"] != "hippy")
                    reachable_instances.listAppend(__quest_state["Island War"].state_boolean["War in progress"] ? "war hippies" : "hippy camp");
                break;

            case $phylum[hobo]: //no hobos in one's normal path. There's some in the wrong side of the track, but we don't recommend they go there for that.
                break;

            case $phylum[horror]: //(some) hellseals and clowns
                if (my_class() == $class[seal clubber])
                    reachable_instances.listAppend("figurine of wretched-looking" + (my_level() >= 9 ? "/armored" : "") + " seal");
                if (nemesis_quest_at_clown_house)
                    reachable_instances.listAppend("clown fun house");
                break;

            case $phylum[humanoid]: //Degrassi Knoll, castle giants, old landfill, 7-foot dwarves, Junkyard gremlins
                if (going_in_Degrassi_Knoll)
                    reachable_instances.listAppend("Degrassi Knoll");
                if (have_access_to_giant_castle && !top_floor_done)
                    reachable_instances.listAppend("castle giants");
                if (making_Junk_Junk)
                    reachable_instances.listAppend("old landfill");
                if (looking_for_mining_gear)
                    reachable_instances.listAppend("7-foot dwarves");
                if (helping_Yossarian)
                    reachable_instances.listAppend("island junkyard");
                break;

            case $phylum[mer-kin]: //can't reach, nor want, in-run
                break;

            case $phylum[orc]: //smut orc logging camp and frat boys/warriors
                if (at_chasm_bridge)
                    reachable_instances.listAppend("smut orcs");
                if (__misc_state["mysterious island available"] && __quest_state["Island War"].state_string["Side seemingly fighting for"] != "frat boys")
                    reachable_instances.listAppend("frat " + (__quest_state["Island War"].state_boolean["War in progress"] ? "warriors" : "boys"));
                break;

            case $phylum[penguin]: //can't reach, nor want, in-run
                break;

            case $phylum[pirate]: //pirate cove
                if (have_some_pirating_to_do)
                    reachable_instances.listAppend("pirate cove");
                break;

            case $phylum[plant]: //fungal nethers and dense lianas
                if (nemesis_quest_at_Fungal_Nethers)
                    reachable_instances.listAppend("fungal nethers");
                if (have_more_dense_lianas_to_fight)
                    reachable_instances.listAppend("dense lianas");
                break;

            case $phylum[slime]: //oil peak (yes, I KNOW that the +5 sleaze res is supposed to be for the BRIDGE BUILDING, but there's just no consistent source of slimes before that; go cry me a river won't you)
                if (past_chasm_bridge && __quest_state["Highland Lord"].state_float["oil peak pressure"] > 0.0)
                    reachable_instances.listAppend("oil peak");
                break;

            case $phylum[undead]: //The whole spookyraven manor, or the cyrpt
                if (__quest_state["Manor Unlock"].in_progress)
                    reachable_instances.listAppend("Spookyraven manor");
                if (__quest_state["Cyrpt"].in_progress)
                    reachable_instances.listAppend("Cyrpt");
                break;

            case $phylum[weird]: //I've got nuthin', they are too rare in-run
                break;
        }
        return reachable_instances;
    }


    boolean [phylum] want_phylum_drop;
    if (true) { //always up for those if available:
        want_phylum_drop[$phylum[constellation]] = true; //yellow-ray
        want_phylum_drop[$phylum[dude]] = true; //banish
        want_phylum_drop[$phylum[horror]] = true; //free kill
        want_phylum_drop[$phylum[hobo]] = true; //+100% meat
    }

    if (false) { //those just... don't have an use
        want_phylum_drop[$phylum[elf]] = true; //+50% candy drop
        want_phylum_drop[$phylum[penguin]] = true; //an envelope which gives some meat...
        want_phylum_drop[$phylum[bug]] = true; //+100% HP, ~9HP regen (not really worth it...)
    }

    if (__misc_state["in run"]) {
        if (__misc_state["need to level"])
            switch (my_primestat()) { //+50% <stat> gains
                case $stat[muscle]:
                    want_phylum_drop[$phylum[humanoid]] = true; break;
                case $stat[mysticality]:
                    want_phylum_drop[$phylum[weird]] = true; break;
                case $stat[moxie]:
                    want_phylum_drop[$phylum[pirate]] = true; break;
            }

        if (!__quest_state["Level 13"].state_boolean["Init race completed"] || cyrpt_modern_zmobies_are_appreciated)
            want_phylum_drop[$phylum[construct]] = true; //+150% initiative

        if (my_path_id() != PATH_COMMUNITY_SERVICE && $item[Spookyraven billiards room key].available_amount() == 0 && get_property_int("manorDrawerCount") < 20) {
            if (numeric_modifier("hot resistance") < 7)
                want_phylum_drop[$phylum[demon]] = true; //+5 hot res
            if (numeric_modifier("stench resistance") < 7)
                want_phylum_drop[$phylum[hippy]] = true; //+5 stench res
        } else if (CS_need_to_pass_hot_res_test)
            want_phylum_drop[$phylum[demon]] = true; //demon again; +5 hot res

        if (past_chasm_bridge) {
            if (__quest_state["Highland Lord"].state_boolean["can complete twin peaks quest quickly"] && !__quest_state["Highland Lord"].state_boolean["Peak Stench Completed"] && numeric_modifier("stench resistance") <= 1.0) //if they have 2 or 3, they don't need a plus-FIVE
                want_phylum_drop[$phylum[hippy]] = true; //hippy again; +5 stench res
            
            if (__quest_state["Highland Lord"].state_int["a-boo peak hauntedness"] > 2) {
                want_phylum_drop[$phylum[beast]] = true; //+5 cold res
                want_phylum_drop[$phylum[undead]] = true; //+5 spooky res
            }
        } else if (at_chasm_bridge)
            want_phylum_drop[$phylum[slime]] = true; //+5 sleaze res

        if (they_may_be_ninjas && !__quest_state["Trapper"].state_boolean["Groar defeated"] && numeric_modifier("cold resistance") < 3.0) //if they have 3 or 4, they don't need a plus-FIVE
            want_phylum_drop[$phylum[beast]] = true; //beast again; +5 cold res

        if (!lookupItem("Eight Days a Week Pill Keeper").have())
            want_phylum_drop[$phylum[elemental]] = true; //+50% MP, ~4MP regen

        if (__quest_state["Lair"].state_boolean["shadow will need to be defeated"])
            want_phylum_drop[$phylum[plant]] = true;
    } else if (__quest_state["Sea Monkees"].in_progress || __quest_state["Sea Temple"].in_progress || __quest_state["Sea Monkees"].state_string["skate park status"] == "war") {
        want_phylum_drop[$phylum[fish]] = true; //fishy
        want_phylum_drop[$phylum[mer-kin]] = true; //+30% underwater items (meh...)
    }

    if (in_ronin() && my_path_id() != PATH_NUCLEAR_AUTUMN) {
        if (fullness_limit() >= 3)
            want_phylum_drop[$phylum[goblin]] = true; //size 3 awesome food
        if (inebriety_limit() >= 3)
            want_phylum_drop[$phylum[orc]] = true; //size 3 awesome booze
    }


    boolean [phylum] current_location_phylums;
    foreach index, monstr in __last_adventure_location.get_monsters()
        current_location_phylums[monstr.phylum] = true;

    phylum current_snapper_phylum = get_property("redSnapperPhylum").to_phylum();

    //The selection presented to the player. The currently tracked phylum and those present in the current locations will always be in there
    //This is meant to inform the player on the DROPS they can get, NOT on which phylum they could track to help progress (at least it's not the focus here)
    boolean [phylum] phylum_display_list;
    string [phylum] [int] reachable_options;

    foreach phyl in $phylums[] {
        string [int] options = currentlyReachableInstancesOfPhylum(phyl);

        if (phyl == current_snapper_phylum) //obviously show the one they are tracking
            phylum_display_list[phyl] = true;
        else if (current_location_phylums contains phyl) //show those in the current location
            phylum_display_list[phyl] = true;
        else if (want_phylum_drop[phyl] && (options.count() > 0 || !__misc_state["in run"]) && options[0] != "Unreachable")
            phylum_display_list[phyl] = true;

        reachable_options[phyl] = options;
    }

    int progress = get_property_int("redSnapperProgress");

    string title = "Track monsters";
    if (current_snapper_phylum != $phylum[none])
        title = (11 - progress).pluralise(current_snapper_phylum + " kill", current_snapper_phylum + " kills") + " until next Snapper drop";

    string [int] description;

    if (progress > 0)
        description.listAppend("Changing phylum resets progress.");

    string [phylum] snapper_drop = {
        $phylum[beast]:"+5 " + "cold".HTMLGenerateSpanOfClass("r_element_cold") + " res (20 turns)",
        $phylum[bug]:"+100% HP, 8-10 HP regen (1 spleen, 60 turns)",
        $phylum[constellation]:"Yellow ray item (150 turns of Ev. Looks Yellow)",
        $phylum[construct]:"+150% init (1 spleen, 30 turns)",
        $phylum[demon]:"+5 " + "hot".HTMLGenerateSpanOfClass("r_element_hot") + " res (20 turns)",
        $phylum[dude]:"All-day free (3x/day) banish item",
        $phylum[elemental]:"+50% MP, 3-5 MP regen (1 spleen, 60 turns)",
        $phylum[elf]:"+50% candy (20 turns)",
        $phylum[fish]:"Fishy (1 spleen, 30 turns)",
        $phylum[goblin]:"3-size " + "awesome".HTMLGenerateSpanOfClass("r_element_awesome") + " food",
        $phylum[hippy]:"+5 " + "stench".HTMLGenerateSpanOfClass("r_element_stench") + " res (20 turns)",
        $phylum[hobo]:"+100% meat (1 spleen, 60 turns)",
        $phylum[horror]:"5x/day free kill item",
        $phylum[humanoid]:"+50% muscle stats (1 spleen, 30 turns)",
        $phylum[mer-kin]:"+30% underwater items (20 turns)",
        $phylum[orc]:"3-size " + "awesome".HTMLGenerateSpanOfClass("r_element_awesome") + " booze",
        $phylum[penguin]:"(500 + 500 * +meat%) meat item",
        $phylum[pirate]:"+50% moxie stats (1 spleen, 30 turns)",
        $phylum[plant]:"Full HP restore combat item",
        $phylum[slime]:"+5 " + "sleaze".HTMLGenerateSpanOfClass("r_element_sleaze") + " res (20 turns)",
        $phylum[undead]:"+5 " + "spooky".HTMLGenerateSpanOfClass("r_element_spooky") + " res (20 turns)",
        $phylum[weird]:"+50% myst stats (1 spleen, 30 turns)"
    };

    foreach phyl in phylum_display_list {
        string line;
        if (current_location_phylums contains phyl)
            line += "• ";
        if (current_snapper_phylum == phyl)
            line += __html_right_arrow_character;
        line += capitaliseFirstLetter(phyl + ": ").HTMLGenerateSpanOfClass("r_bold");
        line += snapper_drop[phyl];


        //FIXME Is there a "good" way to add reachable_options to this?

        //remember to add a string HTMLGenerateSimpleTableLines(string [int] lines) to page.ash if ending up using this
        /*if (reachable_options[phyl].count() > 0 && false) {
            buffer tooltip;
            tooltip.append(reachable_options[phyl].HTMLGenerateSimpleTableLines().HTMLGenerateSpanOfClass("r_tooltip_inner_class r_tooltip_inner_class_margin"));
            tooltip.append(line);
            line = tooltip.HTMLGenerateSpanOfClass("r_tooltip_outer_class");
        }*/

        description.listAppend(line);
    }

    resource_entries.listAppend(ChecklistEntryMake("__familiar red-nosed snapper", "familiar.php?action=guideme&pwd=" + my_hash(), ChecklistSubentryMake(title, "+1 item / 11 kills of tracked phylum", description)).ChecklistEntrySetIDTag("Red nosed snapper familiar tracking drops resource"));
}
