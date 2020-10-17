import "relay/Guide/Quests/Level 11.ash";

void QPirateInit()
{
    //questM12Pirate ?
    //lastPirateInsult1 through lastPirateInsult8
    QuestState state;
    QuestStateParseMafiaQuestProperty(state, "questM12Pirate");
    state.quest_name = "Pirate Quest";
    state.image_name = "pirate quest";
    
    state.state_boolean["valid"] = false; // now invalid by default since the 2020 change
    
    if (my_path_id() == PATH_LOW_KEY_SUMMER)
        state.state_boolean["valid"] = true;
    
    if (__misc_state["mysterious island available"] && state.state_boolean["valid"]) {
        state.startable = true;
        if (!state.in_progress && !state.finished) {
            QuestStateParseMafiaQuestPropertyValue(state, "started");
        }
    }
    
    
    boolean hot_wings_relevant = knoll_available() || $item[frilly skirt].available_amount() > 0 || !in_hardcore();
    if (state.mafia_internal_step >= 4) //done that already
        hot_wings_relevant = false;
    boolean need_more_hot_wings = $item[hot wing].available_amount() <3 && hot_wings_relevant;
    
    state.state_boolean["hot wings relevant"] = hot_wings_relevant;
    state.state_boolean["need more hot wings"] = need_more_hot_wings;
    
    
    int insult_count = 0;
    for i from 1 to 8 {
        if (get_property_boolean("lastPirateInsult" + i))
            insult_count += 1;
    }
    state.state_int["insult count"] = insult_count;
    
    if ($item[Orcish Frat House blueprints].available_amount() > 0 && state.mafia_internal_step <3 )
        QuestStateParseMafiaQuestPropertyValue(state, "step2");
    
    //Certain characters are in weird states, I think? (now obsolete; these two quests are no longer linked)
    /*if ($item[pirate fledges].available_amount() > 0 || $item[talisman o\' namsilat].available_amount() > 0)
        QuestStateParseMafiaQuestPropertyValue(state, "finished");*/
    __quest_state["Pirate Quest"] = state;
}


void QPirateCoveGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if (__quest_state["Island War"].state_boolean["War in progress"]) return;

    QuestState base_quest_state = __quest_state["Pirate Quest"];
    ChecklistSubentry subentry;
    subentry.header = base_quest_state.quest_name;
    string url = "";
    
    
    boolean have_outfit = have_outfit_components("Swashbuckling Getup");
    if ($item[pirate fledges].available_amount() > 0)
        have_outfit = true;
    boolean is_a_pirate = is_wearing_outfit("Swashbuckling Getup") || $item[pirate fledges].equipped_amount() > 0;
        
    int insult_count = base_quest_state.state_int["insult count"];
    
    float [int] insult_success_likelyhood;
    //haven't verified these numbers, need to double-check
    insult_success_likelyhood[0] = 0.0;
    insult_success_likelyhood[1] = 0.0;
    insult_success_likelyhood[2] = 0.0;
    insult_success_likelyhood[3] = 0.0179;
    insult_success_likelyhood[4] = 0.071;
    insult_success_likelyhood[5] = 0.1786;
    insult_success_likelyhood[6] = 0.357;
    insult_success_likelyhood[7] = 0.625;
    insult_success_likelyhood[8] = 1.0;
    
    boolean delay_for_future = false;
    boolean can_acquire_cocktail_napkins = false;
    
    if (in_ronin() && $item[Talisman o\' Namsilat].available_amount() == 0 && my_path_id() != PATH_LOW_KEY_SUMMER)
        subentry.entries.listAppend(HTMLGenerateSpanFont("Pirates won't help you in-run anymore.", "red"));
    
    if (!have_outfit) {
        url = "island.php";
        string line = "Acquire outfit.";
        
        item [int] outfit_pieces = outfit_pieces("Swashbuckling Getup");
        item [int] outfit_pieces_needed;
        foreach key in outfit_pieces {
            item piece = outfit_pieces[key];
            if (piece.available_amount() == 0)
                outfit_pieces_needed.listAppend(piece);
        }
        line += " Need " + outfit_pieces_needed.listJoinComponents(", ", "and") + ".";
        subentry.entries.listAppend(line);
        
        subentry.modifiers.listAppend("+item");
        subentry.modifiers.listAppend("-combat");
        
        if ($familiar[slimeling].familiar_is_usable())
            subentry.modifiers.listAppend("slimeling?");
        
        int ncs_relevant = 0; //out of six
        if ($item[stuffed shoulder parrot].available_amount() == 0 || $item[eyepatch].available_amount() == 0)
            ncs_relevant += 1;
        if ($item[eyepatch].available_amount() == 0 || $item[swashbuckling pants].available_amount() == 0)
            ncs_relevant += 1;
        if ($item[swashbuckling pants].available_amount() == 0 || $item[stuffed shoulder parrot].available_amount() == 0)
            ncs_relevant += 1;
        
        float average_combat_rate = clampNormalf(.6 + combat_rate_modifier() / 100.0);
        float average_nc_rate = 1.0 - average_combat_rate;
        
        float average_useful_nc_rate = average_nc_rate * (ncs_relevant.to_float() / 6.0);
        //FIXME make this more accurate
        float turns_remaining = -1.0;
        if (average_useful_nc_rate != 0.0)
            turns_remaining = outfit_pieces_needed.count().to_float() / average_useful_nc_rate;
        subentry.entries.listAppend("Run -combat in the obligatory pirate's cove." + "|~" + turns_remaining.roundForOutput(1) + " turns remain at " + combat_rate_modifier().floor() + "% combat.");
        
        if (!__quest_state["Manor Unlock"].state_boolean["ballroom song effectively set"]) {
            subentry.entries.listAppend(HTMLGenerateSpanOfClass("Wait until -combat ballroom song set.", "r_bold"));
            delay_for_future = true;
        }
    } else {
        url = "place.php?whichplace=cove";
        
        if (!is_a_pirate)
            url = "inventory.php?which=2";
            
        boolean have_all_fcle_items = false;
        
        if (base_quest_state.mafia_internal_step == 1) {
            can_acquire_cocktail_napkins = true;
            //caronch gave you a map
            if ($item[Cap'm Caronch's nasty booty].available_amount() == 0 && $item[Cap'm Caronch's Map].available_amount() > 0) {
                url = "inventory.php?ftext=cap'm+caronch's+map";
                subentry.entries.listAppend("Use Cap'm Caronch's Map, fight a booty crab.");
                subentry.entries.listAppend("Possibly run +meat. (300 base drop)");
                subentry.modifiers.listAppend("+meat");
            } else if (have_outfit) {
                subentry.modifiers.listAppend("-combat");
                subentry.entries.listAppend("Find Cap'm Caronch in Barrrney's Barrr.");
            }
        } else if (base_quest_state.mafia_internal_step == 2) {
            can_acquire_cocktail_napkins = true;
            //give booty back to caronch
            subentry.entries.listAppend("Find Cap'm Caronch in Barrrney's Barrr.");
        } else if (base_quest_state.mafia_internal_step == 3) {
            can_acquire_cocktail_napkins = true;
            //have blueprints, catburgle
            string line = "Use the Orcish Frat House blueprints";
            if (insult_count < 6) {
                subentry.modifiers.listAppend("+20% combat");
                line += ", once you have at least six insults"; //in certain situations five might be slightly faster? but that skips a lot of combats, so probably not
            }
            line += ".";
            
            string method;
            if (have_outfit_components("Frat Boy Ensemble") && __misc_state["can equip just about any weapon"]) {
                string [int] todo;
                if (!is_wearing_outfit("Frat Boy Ensemble"))
                    todo.listAppend("wear frat boy ensemble");
                todo.listAppend("attempt a frontal assault");
                method = todo.listJoinComponents(", ", "then").capitaliseFirstLetter() + ".";
            } else if ($item[mullet wig].available_amount() > 0 && $item[briefcase].available_amount() > 0) {
                string [int] todo;
                if ($item[mullet wig].equipped_amount() == 0)
                    todo.listAppend("wear mullet wig");
                todo.listAppend("go in through the side door");
                method = todo.listJoinComponents(", ", "then").capitaliseFirstLetter() + ".";
            } else if (knoll_available() || ($item[frilly skirt].available_amount() > 0 && $item[hot wing].available_amount() >= 3)) {
                string [int] todo;
                if (insult_count < 6)
                    todo.listAppend("acquire at least six insults");
                if ($item[hot wing].available_amount() <3 )
                    todo.listAppend("acquire " + pluralise((3 - $item[hot wing].available_amount()), "more hot wing", "more hot wings"));
                if ($item[frilly skirt].equipped_amount() == 0)
                    todo.listAppend("wear frilly skirt");
                todo.listAppend("catburgle");
                string line2 = todo.listJoinComponents(", ", "then").capitaliseFirstLetter() + ".";
                method = line2;
            } else {
                //Non-knoll sign.
                //I think the fastest method is frilly skirt?
                if ($item[hot wing].available_amount() >= 3 && my_familiar() != $familiar[black cat])
                    method = "Farm a frilly skirt in the knoll gym. (+300% item)";
                else {
                    method = "Acquire a frat boy outfit in the frat house? (-combat" + (my_level() < 9 ? " after level 9" : "") + ")";
                    if (!__quest_state["Level 6"].finished)
                        method += "|Or collect hot wings from the friar demons" + ($item[frilly skirt].available_amount() == 0 ? ", and frilly skirt from the knoll gym" : "") + ".";
                }
            }
            line += "|" + method;
            subentry.entries.listAppend(line);
        } else if (base_quest_state.mafia_internal_step == 4) {
            //acquired teeth, give them back
            subentry.entries.listAppend("Find Cap'm Caronch in Barrrney's Barrr. (next adventure)");
        } else if (base_quest_state.mafia_internal_step == 5) {
            //ricketing
            subentry.entries.listAppend("Play beer pong.");
            subentry.entries.listAppend("If you want more insults now, adventure in the Obligatory Pirate's Cove, not in the Barrr.");
        } else if (base_quest_state.mafia_internal_step == 6) {
            //f'c'le
            //We can't tell them which ones they need, precisely, since they may have already used them.
            //We can tell them which ones they have... but it's still unreliable. I guess a single message if they have all three?
            string line = "F'c'le.";
            string additional_line = "";
            
            item [int] missing_washing_items = $items[rigging shampoo,mizzenmast mop,ball polish].items_missing();
            
            if (missing_washing_items.count() == 0) {
                have_all_fcle_items = true;
                url = "inventory.php?which=3";
                line += " " + HTMLGenerateSpanFont("Use rigging shampoo, mizzenmast mop, and ball polish", "red") + ", then adventure to complete quest.";
            } else {
                subentry.modifiers.listAppend("+234% item");
                subentry.modifiers.listAppend("+20% combat");
                string [int] missing_washing_items_wordy;
                foreach key in missing_washing_items {
                    if (missing_washing_items [key] == $item[rigging shampoo])
                        missing_washing_items_wordy.listAppend("rigging shampoo (cleanly pirate)");
                    else if (missing_washing_items [key] == $item[mizzenmast mop])
                        missing_washing_items_wordy.listAppend("mizzenmast mop (curmudgeonly pirate)");
                    else if (missing_washing_items [key] == $item[ball polish])
                        missing_washing_items_wordy.listAppend("ball polish (creamy pirate)");
                }
                line += " Run +234% item, +combat, and collect " + missing_washing_items_wordy.listJoinComponents(", ", "and") + ".";
                if ($location[the f'c'le].item_drop_modifier_for_location() < 234.0)
                    additional_line = "This location can be a nightmare without +234% item.";
                    
                subentry.modifiers.listAppend("banish chatty/crusty pirate");
            }
            
            subentry.entries.listAppend(line);
            if (!have_all_fcle_items)
                subentry.entries.listAppend("Don't use the items right away: we can't tell if you did!");
            if (additional_line != "")
                subentry.entries.listAppend(additional_line);
            if (!($monster[clingy pirate (female)].is_banished() || $monster[clingy pirate (male)].is_banished()) && $item[cocktail napkin].available_amount() > 0 && !have_all_fcle_items) {
                subentry.entries.listAppend("Use cocktail napkin on clingy pirate to " + (__misc_state["free runs usable"] ? "free run/" : "") + "banish.");
            }
        } else if (base_quest_state.mafia_internal_step == 7) {
            //The Poop Deck
            if (__quest_state["Level 11"].mafia_internal_step < 3) {
                if (my_path_id() == PATH_COMMUNITY_SERVICE || __quest_state["Level 11"].mafia_internal_step == 0 && get_property_int("lastCouncilVisit") >= 11) { //They CANNOT get the password, and are only here for the zone itself
                    QuestStateParseMafiaQuestPropertyValue(base_quest_state, "finished");
                    subentry.entries.listAppend("Watch out for that recurring non-combat...");
                } else
                    subentry.entries.listAppend("Come back when you've read from your father's MacGuffin diary, or you'll keep getting beaten up by the recurring non-combat.");
            } else {
                subentry.modifiers.listAppend("-combat");
                subentry.entries.listAppend("Run -combat on the Poop Deck to unlock belowdecks.");
                subentry.entries.listAppend(generateTurnsToSeeNoncombat(80, 1, "unlock belowdecks"));
            }
        }
        
        if (base_quest_state.mafia_internal_step <= 3 && my_inebriety() > 0) {
            subentry.entries.listAppend("Could wait until rollover; one of the non-combats can become a combat at zero drunkenness.");
        }
        
        
        if (__misc_state["free runs available"] && !can_acquire_cocktail_napkins && !have_all_fcle_items)
            subentry.modifiers.listAppend("free runs");
    }
    boolean should_output_insult_data = false;
    if ($item[the big book of pirate insults].available_amount() > 0 || have_outfit)
        should_output_insult_data = true;
    if (base_quest_state.mafia_internal_step >= 6)
        should_output_insult_data = false;
        
    if (should_output_insult_data) {
        string line = "At " + pluralise(insult_count, "insult", "insults") + ". " + roundForOutput(insult_success_likelyhood[insult_count] * 100, 1) + "% chance of beer pong success.";
        if (insult_count < 8)
            line += "|Insult every pirate with the big book of pirate insults.";
        subentry.entries.listAppend(line);
    }
    if ($item[the big book of pirate insults].available_amount() == 0 && base_quest_state.mafia_internal_step < 6 && have_outfit)
        subentry.entries.listAppend(HTMLGenerateSpanFont("Buy the big book of pirate insults.", "red"));
    
    if (can_acquire_cocktail_napkins && $item[cocktail napkin].available_amount() == 0) {
        subentry.modifiers.listAppend("+item");
        subentry.entries.listAppend("Try to acquire a cocktail napkin to speed up F'c'le. (10% drop, marginal)");
    }
    
    if (have_outfit && !is_a_pirate) {
        string line;
        if ($item[pirate fledges].available_amount() > 0 && my_basestat($stat[mysticality]) >= 60) {
            line = "Wear pirate fledges.";
        } else if (!is_wearing_outfit("Swashbuckling Getup")) {
            string [int] stats_needed;
            if (my_basestat($stat[moxie]) < 25)
                stats_needed.listAppend("moxie");
            if (my_basestat($stat[mysticality]) < 25)
                stats_needed.listAppend("mysticality");
            line = "Wear swashbuckling getup.";
            
            if (stats_needed.count() > 0) {
                delay_for_future = true;
                line += HTMLGenerateSpanOfClass(" Need 25 " + stats_needed.listJoinComponents(", ", "and"), "r_bold") + ".";
            }
        }
        subentry.entries.listAppend(line);
    }

    ChecklistEntry entry = ChecklistEntryMake(base_quest_state.image_name, url, subentry, $locations[the obligatory pirate's cove, barrrney's barrr, the f'c'le,The Poop Deck]);
    entry.tags.id = "Island pirates quest";
    entry.tags.combination = "pirates";
    
    if (__misc_state["in run"] && base_quest_state.state_boolean["valid"]) {
        if (delay_for_future)
            future_task_entries.listAppend(entry);
        else
            task_entries.listAppend(entry);
    } else
        optional_task_entries.listAppend(entry);
}

void QPoopDeckGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    //O Cap'm, My Cap'm helper; the main feature of this section, now!
    ChecklistSubentry subentry;
    subentry.header = "Sail the sea";
    string url = "place.php?whichplace=cove";

    if ($item[pirate fledges].equipped_amount() == 0) {
        subentry.entries.listAppend("Wear pirate fledges.");
        url = "inventory.php?ftext=pirate+fledges";
    }

    if (true) { //for when the last o'cap'm, my cap'm property will be implemented (if)
        if (my_meat() < 977) {
            subentry.entries.listAppend(HTMLGenerateSpanOfClass("Start by acquiring 977 meat.", "r_bold") + (__misc_state["need to level"] ? ", to gain extra stats from the other NC" : "") + ".");
        } else {
            subentry.modifiers.listAppend("-combat");
            subentry.entries.listAppend("Adventure on the Poop Deck until you get O Cap'm, My Cap'm.");
        }
    } else {
        //how many turns they'll need to burn in the zone to get the adventure again
    }

    subentry.entries.listAppend("*Sail to (48,47) to get an El Vibrato power sphere (or buy from mall).");
    if (item_amount_almost_everywhere(lookupItem("El Vibrato trapezoid")) == 0 && $location[El Vibrato Island].turns_spent == 0 && __campground[lookupItem("El Vibrato trapezoid")] == 0) { //mafia only registers the trapezoid in the campground from revisiton 20267 and onward
        string line = "*Sail to (63,29) to get an El Vibrato trapezoid.";
        if (!mafiaIsPastRevision(20267)) //Means that we can't trust "__campground[lookupItem("El Vibrato trapezoid")] == 0" to be accurate
            line += HTMLGenerateSpanFont(" Don't do this if you've already set up a portal at your campground.", "red");

        if (lookupItem("El Vibrato power sphere").item_amount() == 0)
            line += "|*Need an El Vibrato power sphere in inventory. Buy from mall?";
        line += "|*Gives an item that creates a portal to El Vibrato Island at your campground (will need to keep it charged with more power spheres).";
        subentry.entries.listAppend(line);
    }
    subentry.entries.listAppend("*Or sail to (1,1) to get a random ancient cursed key/chest.");
    if (__misc_state["need to level"]) {
        string coordinates;
        if (my_primestat() == $stat[muscle])
            coordinates = "(56, 14)";
        else if (my_primestat() == $stat[mysticality])
            coordinates = "(3, 35)";
        else if (my_primestat() == $stat[moxie])
            coordinates = "(5, 39)";
        if (coordinates != "")
            subentry.entries.listAppend("Could sail to " + coordinates + " for stats?");
    }

    ChecklistEntry entry = ChecklistEntryMake("ship wheel", url, subentry, $locations[The Poop Deck]);
    entry.tags.id = "Island pirates poop deck sailing";
    entry.tags.combination = "pirates";

    if (__misc_state["in run"] && __quest_state["Pirate Quest"].state_boolean["valid"] && __quest_state["Pirate Quest"].in_progress) //To match if QPirateCoveGenerateTasks is being displayed in task or optional_task
        task_entries.listAppend(entry);
    else
        optional_task_entries.listAppend(entry);
}

void QPirateGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    //Show the tile IF: they started the quest, and the quest is valid in this path, OR, they started the quest, and are adventuring in the relevant locations, OR, they started the quest, and are out of run.
    if (__quest_state["Pirate Quest"].in_progress && (__quest_state["Pirate Quest"].state_boolean["valid"] || $locations[the obligatory pirate's cove, barrrney's barrr, the f'c'le, the poop deck] contains __last_adventure_location || !__misc_state["in run"]))
        QPirateCoveGenerateTasks(task_entries, optional_task_entries, future_task_entries);

    if ($location[The Poop Deck] == __last_adventure_location || __quest_state["Pirate Quest"].mafia_internal_step == 7)
        QPoopDeckGenerateTasks(task_entries, optional_task_entries, future_task_entries);
}
