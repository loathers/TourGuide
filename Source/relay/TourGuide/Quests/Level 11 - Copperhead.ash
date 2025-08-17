//Our strategy for the copperhead quest is probably not very good. Largely because it looks complicated and I (Ezandora) made a few guesses.

void QLevel11CopperheadInit()
{
    if (true) {
        QuestState state;
        QuestStateParseMafiaQuestProperty(state, "questL11Ron");
            
        // Finish the quest state in paths that don't need the tile.
        if (my_path().id == PATH_COMMUNITY_SERVICE) QuestStateParseMafiaQuestPropertyValue(state, "finished");
        if (my_path().id == PATH_GREY_GOO) state.finished = true; 
        if (my_path().id == PATH_SEA) state.finished = true;
        
        state.quest_name = "Zeppelin Quest"; //"Merry-Go-Ron";
        state.image_name = "__item copperhead charm (rampant)"; //__item bitchin ford anglia
        
        state.state_int["protestors remaining"] = clampi(80 - get_property_int("zeppelinProtestors"), 0, 80);
        
        state.state_boolean["need protestor speed tricks"] = true;
        if (state.mafia_internal_step >= 3)
            state.state_int["protestors remaining"] = 0;
        if (state.state_int["protestors remaining"] <= 1)
            state.state_boolean["need protestor speed tricks"] = false;
        
        state.state_boolean["should output"] = state.in_progress && __quest_state["Level 11"].state_boolean["have diary"] && (__misc_state["in run"] || $location[the red zeppelin].turns_spent > 0 || __last_adventure_location == $location[a mob of zeppelin protesters]);
        
        __quest_state["Level 11 Ron"] = state;
    }
    if (true) {
        QuestState state;
        QuestStateParseMafiaQuestProperty(state, "questL11Shen");
        
        // Finish the quest state in paths that don't need the tile.
        if (my_path().id == PATH_COMMUNITY_SERVICE) QuestStateParseMafiaQuestPropertyValue(state, "finished");
        if (my_path().id == PATH_GREY_GOO) state.finished = true; 
        if (my_path().id == PATH_SEA) state.finished = true;

        state.quest_name = "Copperhead Club Quest"; //"Of Mice and Shen";
        state.image_name = "__item copperhead charm"; //"__effect Ancient Annoying Serpent Poison";
        
        state.state_boolean["should output"] = state.in_progress && __quest_state["Level 11"].state_boolean["have diary"] && (__misc_state["in run"] || $location[the copperhead club].turns_spent > 0);
        
        
        //other than in exploathing, if mafia_internal_step == 1, we haven't "locked" which items are going to be asked
        if (state.state_boolean["should output"] && (state.mafia_internal_step > 1 || my_path().id == PATH_KINGDOM_OF_EXPLOATHING)) {
            state.state_int["Shen meetings"] = state.mafia_internal_step / 2;
            state.state_int["snakes slain"] = (state.mafia_internal_step - 1) / 2;
            
            
            static boolean have_wrong_predictions;
            
            int daycount_when_first_met_Shen = get_property_int("shenInitiationDay");
            
            //If we are currently looking for a snake
            if (state.mafia_internal_step % 2 == 0) { //2, 4 or 6
                state.state_boolean["on an assignment"] = true;
                
                //Verify if mafia's quest item matches the predicted one. If it doesn't, stop predicting assignments for the rest of the session
                if (my_path().id != PATH_KINGDOM_OF_EXPLOATHING) { //we know this path has a hardcoded set of requests
                    item quest_item = get_property_item("shenQuestItem");
                    item predicted_quest_item = __shen_start_day_to_assignments[daycount_when_first_met_Shen] [state.state_int["Shen meetings"]];
                    if (quest_item != predicted_quest_item)
                        have_wrong_predictions = true;
                }
            }
            state.state_int["Shen initiation day"] = have_wrong_predictions ? 0 : daycount_when_first_met_Shen;
        }
        
        __quest_state["Level 11 Shen"] = state;
    }
}

void QLevel11RonGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    /*
    questL11Ron
        Merry-Go-Ron
        started - Search for Ron Copperhead on the Red Zeppelin.
        step1 - Fight your way through the mob of zeppelin protesters.
        step2 - All aboard! All aboard the Red Zeppelin!
        step3 - Search the Red Zeppelin for Ron Copperhead.
        step4 - Barge into Ron Copperhead's cabin in the Red Zeppelin and beat him up!
        finshed - You recovered half of the Talisman o' Nam from Ron Copperhead. Brilliant!
    */
    QuestState base_quest_state = __quest_state["Level 11 Ron"];
    if (!base_quest_state.state_boolean["should output"])
        return;
    
    ChecklistSubentry subentry;
    subentry.header = base_quest_state.quest_name;
    
    string url = $location[A Mob of Zeppelin Protesters].getClickableURLForLocation();
    
    
    if (base_quest_state.mafia_internal_step <= 2 && base_quest_state.state_int["protestors remaining"] <= 1) {
        subentry.entries.listAppend("Adventure in the mob of protestors.");
    } else if (base_quest_state.mafia_internal_step <= 2) {
        //Fight your way through the mob of zeppelin protesters.
        subentry.entries.listAppend("Scare away " + pluraliseWordy(base_quest_state.state_int["protestors remaining"], "more protestor", "more protestors") + ".");
        subentry.modifiers.listAppend("-combat");
        subentry.modifiers.listAppend("+567% item");
        if (__misc_state["have olfaction equivalent"])
            subentry.modifiers.listAppend("olfact cultists");
        subentry.modifiers.listAppend(HTMLGenerateSpanOfClass("sleaze damage", "r_element_sleaze"));
        subentry.modifiers.listAppend(HTMLGenerateSpanOfClass("sleaze spell damage", "r_element_sleaze"));
        //Two olfaction targets here seem to be cultists or lynyrd skinner.
        //Cultists seem much better.
        //Cigarette lighter is a 15% drop. when used in combat against protestors, removes quite a few
        
        boolean [item] relevant_lynyrdskin_items;
        relevant_lynyrdskin_items[$item[lynyrdskin cap]] = true;
        relevant_lynyrdskin_items[$item[lynyrdskin breeches]] = true;
        if (__misc_state["Torso aware"])
            relevant_lynyrdskin_items[$item[lynyrdskin tunic]] = true;
        
        if ($item[lynyrd musk].available_amount() > 0 && $effect[Musky].have_effect() == 0 && $item[lynyrd musk].item_is_usable()) {
            subentry.entries.listAppend(HTMLGenerateSpanFont("Use lynyrd musk.", "red"));
            url = "inventory.php?ftext=lynyrd+musk";
        }
        if ($item[cigarette lighter].available_amount() > 0 && base_quest_state.state_boolean["need protestor speed tricks"] && my_path().id != PATH_POCKET_FAMILIARS) {
            subentry.entries.listAppend(HTMLGenerateSpanFont("Use cigarette lighter in-combat.", "red"));
        }
        if ($item[lynyrd snare].available_amount() > 0 && $items[lynyrdskin cap,lynyrdskin tunic,lynyrdskin breeches].items_missing().count() > 0 && $item[lynyrd snare].item_is_usable() && get_property_int("_lynyrdSnareUses") < 3 && $item[lynyrd snare].item_is_usable()) {
            subentry.entries.listAppend("Possibly use the lynyrd snare. (free combat)");
        }
        string [int] what_not_not_to_wear;
        foreach it in relevant_lynyrdskin_items {
            if (it.available_amount() == 0)
                continue;
            if (it.equipped_amount() > 0)
                continue;
            what_not_not_to_wear.listAppend(it.to_string().replace_string("lynyrdskin ", ""));
        }
        
        if ($item[pocket wish].have() || ($item[genie bottle].have() && get_property_int("_genieWishesUsed") < 3)) {
            int current_sleaze_damage = numeric_modifier("sleaze damage") + numeric_modifier("sleaze spell damage");
            string [int] options;
            if ($effect[Fifty Ways to Bereave Your Lover].have_effect() == 0)
                options.listAppend("Fifty Ways to Bereave Your Lover for +100 sleaze damage");
            if ($effect[Dirty Pear].have_effect() == 0)
                options.listAppend("Dirty Pear for 2x sleaze damage; currently +" + current_sleaze_damage + " total damage");
            string line = "Could wish for sleaze damage";
            if (options.count() > 0)
                line += ", like " + options.listJoinComponents(", ", "or");
            line += ".";
            subentry.entries.listAppend(line);
        }
        float sleaze_protestors_cleared = MAX(3.0, sqrt(numeric_modifier("sleaze damage") + numeric_modifier("sleaze spell damage")));
        if (sleaze_protestors_cleared > 3)
            subentry.entries.listAppend(HTMLGenerateSpanOfClass("Sleaze", "r_element_sleaze") + " damage will clear " + sleaze_protestors_cleared.roundForOutput(1) + " protestors."); //FIXME do we want to list the amount they'll need to increase that?
        
        if (what_not_not_to_wear.count() > 0) {
            subentry.entries.listAppend("Equip your lynyrdskin " + what_not_not_to_wear.listJoinComponents(", ", "and") + "?");
            url = "inventory.php?ftext=lynyrd";
        }
        
        if ($skill[Transcendent Olfaction].skill_is_usable() && !(get_property_monster("olfactedMonster") == $monster[Blue Oyster cultist]) && base_quest_state.state_boolean["need protestor speed tricks"])
            subentry.entries.listAppend("Olfact blue oyster cultists for protestor-skipping lighters.");
        
        if ($item[lynyrd skin].available_amount() > 0 && $skill[armorcraftiness].skill_is_usable()) {
            item [int] missing_equipment = relevant_lynyrdskin_items.items_missing();
            if (missing_equipment.count() > 0) {
                string [int] missing_equipment_output_string;
                foreach key, it in missing_equipment {
                    missing_equipment_output_string.listAppend(it.to_string().replace_string("lynyrdskin ", ""));
                }
                string joining_string = "or";
                if (missing_equipment.count() <= $item[lynyrd skin].available_amount())
                    joining_string = "and";
                string line = "Craft lynyrdskin " + missing_equipment_output_string.listJoinComponents(", ", joining_string);
                
                line += ".";
                boolean can_likely_freecraft = false;
                if ($effect[inigo's incantation of inspiration].have_effect() >= 5)
                    can_likely_freecraft = true;
                if ($item[thor's pliers].available_amount() > 0 && get_property_int("_thorsPliersCrafting") < 10) //FIXME is _thorsPliersCrafting correct? suspect mafia tracks it incorrectly, I saw it at 9 after a run. smithing, probably
                    can_likely_freecraft = true;
                if (get_property_int("homebodylCharges") > 0)
                    can_likely_freecraft = true;
                
                //_legionJackhammerCrafting <3
                if ($items[Loathing Legion abacus,Loathing Legion can opener,Loathing Legion chainsaw,Loathing Legion corkscrew,Loathing Legion defibrillator,Loathing Legion double prism,Loathing Legion electric knife,Loathing Legion flamethrower,Loathing Legion hammer,Loathing Legion helicopter,Loathing Legion jackhammer,Loathing Legion kitchen sink,Loathing Legion knife,Loathing Legion many-purpose hook,Loathing Legion moondial,Loathing Legion necktie,Loathing Legion pizza stone,Loathing Legion rollerblades,Loathing Legion tape measure,Loathing Legion tattoo needle,Loathing Legion universal screwdriver,Loathing Legion Knife].available_amount() > 0 && get_property_int("_legionJackhammerCrafting") < 3) {
                    if ($item[Loathing Legion jackhammer].available_amount() == 0 && !can_likely_freecraft) {
                        line += " (fold loathing legion knife into jackhammer first)";
                    }
                    can_likely_freecraft = true;
                }
                
                if (!can_likely_freecraft)
                    line += " (1 adventure, not worth it?)";
                
                subentry.entries.listAppend(line);
                
            }
        }
        if (!__quest_state["Level 11 Shen"].finished && $item[Flamin' Whatshisname].available_amount() == 0)
            subentry.entries.listAppend("Could adventure in the Copperhead Club first for Flamin' Whatshisnames.");
    } else if (base_quest_state.mafia_internal_step <= 4) {
        //All aboard! All aboard the Red Zeppelin!
        subentry.entries.listAppend("Search for Ron in the zeppelin.");
        //possibly 50% chance of no progress without a ticket (unconfirmed chat rumour)
        
        if (my_path().id != PATH_POCKET_FAMILIARS) {
            subentry.modifiers.listAppend("+234% item");
            foreach m in $monsters[Red Herring,Red Snapper] {
                if (!m.is_banished())
                    subentry.modifiers.listAppend("banish " + m);
            }
            
            if (__misc_state["have olfaction equivalent"])
                subentry.modifiers.listAppend("olfact red butler");
        }
        
        if ($item[red zeppelin ticket].available_amount() == 0) {
            if ($item[priceless diamond].available_amount() > 0 && black_market_available())
                subentry.entries.listAppend("Trade in your priceless diamond for a red zeppelin ticket.");
            else if (my_meat() >= $item[red zeppelin ticket].npc_price() && my_meat() >= 4000 && black_market_available())
                subentry.entries.listAppend("Purchase a red zeppelin ticket in the black market.");
            else if (!__quest_state["Level 11 Shen"].finished && black_market_available())
                subentry.entries.listAppend("Could adventure in the Copperhead Club first for a ticket. (greatly speeds up area)");
            else
                subentry.entries.listAppend("No ticket.");
        }
        
        if (my_path().id != PATH_POCKET_FAMILIARS) {
            if (get_property_int("_glarkCableUses") < 5) {
                if ($skill[Transcendent Olfaction].skill_is_usable() && !(get_property_monster("olfactedMonster") == $monster[red butler]))
                    subentry.entries.listAppend("Olfact red butlers for glark cables.");
                
                if ($item[glark cable].available_amount() > 0) {
                    subentry.entries.listAppend(HTMLGenerateSpanFont("Use glark cable in-combat.", "red"));
                }
                subentry.entries.listAppend(get_property_int("_glarkCableUses") + " / 5 glark cables used today (free kills).");
            } else {
                subentry.entries.listAppend("Already used all 5 glark cables for the day.");
            }
        }
        
        if ($item[priceless diamond].available_amount() > 0 && $item[red zeppelin ticket].available_amount() == 0) {
            subentry.modifiers.listClear();
            subentry.entries.listClear();
            subentry.entries.listAppend("Acquire a Red Zeppelin ticket from the black market.");
            url = "shop.php?whichshop=blackmarket";
        }
    } else if (base_quest_state.mafia_internal_step == 5) {
        //Barge into Ron Copperhead's cabin in the Red Zeppelin and beat him up!
        subentry.entries.listAppend("Defeat Ron in the zeppelin.");
    }
    
    
    
    
    ChecklistEntry entry = ChecklistEntryMake(base_quest_state.image_name, url, subentry, $locations[A Mob of Zeppelin Protesters,The Red Zeppelin]);
    entry.tags.id = "Council L11 quest copperhead Ron";
    
    if (!__misc_state["in run"] || $item[talisman o' namsilat].available_amount() > 0)
        optional_task_entries.listAppend(entry);
    else
        task_entries.listAppend(entry);
}

void QLevel11ShenGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    /*
    questL11Shen
        Of Mice and Shen
        started - Go to the Copperhead Club and find Shen, the man mentioned in your father's diary.
        step1 - (no unique message)
        step2 - (no unique message)
        step3 - (no unique message)
        step4 - (no unique message)
        step5 - (no unique message)
        step6 - (no unique message)
        finished - You retrieved half of the Talisman o' Nam from Shen Copperhead. Nice!
        
    Guesses:
        1 - Need to meet shen for the first time.
        2 - shen met the first time, go do as he asks
        3 - monster done, now go find shen
        4 - shen met second time, go do as he asks
        5 - second monster done, go now find shen
        6 - shen found, go find the third monster
        7 - third monster defeated, shen find go
        finished*/
    
    QuestState base_quest_state = __quest_state["Level 11 Shen"];
    if (!base_quest_state.state_boolean["should output"])
        return;
    
    ChecklistEntry entry;
    entry.url = $location[the copperhead club].getClickableURLForLocation();
    entry.image_lookup_name = base_quest_state.image_name;
    entry.tags.id = "Council L11 quest copperhead Shen";
    entry.should_highlight = $locations[the copperhead club] contains __last_adventure_location;
    
    ChecklistSubentry subentry;
    entry.subentries.listAppend(subentry); //changes made to subentry past this line will still appear. Done now to make sure this one is above the club subentry.
    subentry.header = base_quest_state.quest_name;
    
    item [int] current_assignments;
    if (my_path().id == PATH_EXPLOSIONS)
        current_assignments = __shen_exploathing_assignments;
    else if (__shen_start_day_to_assignments contains base_quest_state.state_int["Shen initiation day"])
        current_assignments = __shen_start_day_to_assignments[base_quest_state.state_int["Shen initiation day"]];
    
    entry.should_highlight = entry.should_highlight || current_assignments.shenAssignmentsJoinLocationsStartingAfter(base_quest_state.state_int["snakes slain"]).listInvert() contains __last_adventure_location;
    
    
    if (base_quest_state.mafia_internal_step <= 1) { //Need to meet shen for the first time.
        subentry.entries.listAppend("Adventure in the Copperhead Club and meet Shen.");
        subentry.entries.listAppend("This will give you unremovable -5 stat poison.");
        if (my_path().id == PATH_EXPLOSIONS)
            subentry.entries.listAppend("On this path, he'll always ask for: |*• " + current_assignments.shenAssignmentsJoinLocations().listJoinComponents("|*• "));
        else {
            int daycount = my_daycount();
            if (__shen_start_day_to_assignments contains daycount)
                subentry.entries.listAppend("If you meet him today, he'll send you to:|*• " + __shen_start_day_to_assignments[daycount].shenAssignmentsJoinLocations().listJoinComponents("|*• "));
            if (__shen_start_day_to_assignments contains ++daycount)
                subentry.entries.listAppend("Tomorrow will instead be:|*• " + __shen_start_day_to_assignments[daycount].shenAssignmentsJoinLocations().listJoinComponents("|*• "));
        }
        // This used to be true in old metas, but hasn't been true for a while. Commenting it out.
        // if (my_daycount() == 1 && my_path().id != PATH_EXPLOSIONS)
        //     subentry.entries.listAppend("Perhaps wait until tomorrow before starting this; day 2's shen bosses are more favourable.");
    } else {
        int club_turns_spent = $location[the copperhead club].turns_spent;
        int next_guaranteed_meeting = base_quest_state.state_int["Shen meetings"] * 5;
        int total_delay_remaining = 15 - (3 - base_quest_state.state_int["Shen meetings"]) - club_turns_spent;
        boolean is_disguised = $effect[Crappily Disguised as a Waiter].have_effect() > 0;
        string club_hazard = get_property("copperheadClubHazard"); //none, gong, fire, ice
        boolean need_diamond = $items[priceless diamond,Red Zeppelin ticket].available_amount() == 0 && __quest_state["Level 11 Ron"].mafia_internal_step < 5 && my_meat() < 5000 && my_path().id != PATH_NUCLEAR_AUTUMN;
        boolean need_flaming_whatshisname = __quest_state["Level 11 Ron"].state_boolean["need protestor speed tricks"];
        
        string [int] club_modifiers;
        club_modifiers.listAppend("+234% item");
        club_modifiers.listAppend("olfact ninja dressed as a waiter");
        if (club_hazard != "gong")
            club_modifiers.listAppend("-ML"); //hail of bullets damage is ~9 + your +ML

        string [int] club_entries;
        //unnamed cocktail is 15%
        //ninja dressed as a waiter has 30% disguise
        //waiter dressed as a ninja has 20% disguise
        //Behind the 'Stache can have a single state: gong, ice, or lanterns on fire
        //ice -> priceless diamond
        //fire -> setting unnamed cocktail on fire
        //gong -> prevents damage taken (not speed relevant)
        //and averages 0.64285714285714 unnamed cocktails per attempt (which takes a turn?)
        //so let's see...
        //you first want the priceless diamond for the ticket, otherwise you have the 50% chance(?) of losing progress
        //soo... run 234% item for the disguise?
        //after that, you theoretically want to upgrade cocktails, but...
        //to do that, you need a second disguise, which means possibly olfacting? then olfacting the bartender.
        
        //alternatively, olfact the ninja, then use disguises to collect cocktails
        //each one saves up to seven protestors if you see the NC (at -25% combat, the likelyhood is 11.6% per turn)
        
        string line = "Use crappy waiter disguise (have " + $item[crappy waiter disguise].available_amount() + ") for a free NC (doesn't burn delay).";
        if (club_hazard == "" || club_hazard == "none" || club_hazard == "fire" && !need_flaming_whatshisname || club_hazard == "ice" && !need_diamond) {
            if (need_diamond)
                line += "|*<strong>Bucket:</strong> fights may give a priceless diamond.";
            else if (need_flaming_whatshisname)
                line += "|*<strong>Lanterns:</strong> fights turn Unnamed cocktails in inventory into Flaming whatshisname.";
            else
                line += "|*<strong>Gong:</strong> prevents the start of fight damage.";
        } else if (club_hazard == "ice")
            club_entries.listAppend("Fight club monsters (not wanderers) for a chance at a priceless diamond.");
        else if (club_hazard == "fire")
            club_entries.listAppend("Fight club monsters (not wanderers) with an Unnamed cocktail in inventory to turn it into a Flaming Whatshisname.");
        line += "|*<strong>Steal:</strong> gain 1 Unnamed cocktail + 3-4 other things";
        if (club_hazard == "fire" && need_flaming_whatshisname)
            line += " (have " + $item[Flamin' Whatshisname].item_amount() + ")";
        line += ".";
        club_entries.listAppend(line);
        club_entries.listAppend("Potentially save some disguises until the end to maybe save a turn.");
        
        
        
        if (base_quest_state.state_boolean["on an assignment"]) { //2, 4 or 6
            location assignment_location = __shen_items_to_locations[get_property_item("shenQuestItem")];
            
            if (assignment_location != $location[none]) {
                entry.url = assignment_location.getClickableURLForLocation();
                subentry.entries.listAppend("Adventure in " + assignment_location + (assignment_location == $location[The VERY Unquiet Garves] ? " (or the Unquiet Garves, but make a choice and stick to it)" : "") + ".");
            } else {
                subentry.entries.listAppend("Fight the " + base_quest_state.state_int["Shen meetings"].int_to_position_wordy() + " monster wherever Shen told you to go.");
            }
            
            if (total_delay_remaining - 1 > 0) {
                ChecklistSubentry club_subentry;
                club_subentry.header = "Back at the club";
                club_subentry.modifiers.listAppendList(club_modifiers);
                
                if (club_turns_spent < next_guaranteed_meeting)
                    club_subentry.entries.listAppend("Delay for " + pluralise(next_guaranteed_meeting - club_turns_spent, "more turn", "more turns") + " in  the Copperhead Club.");
                club_subentry.entries.listAppend((total_delay_remaining - 1) + "-" + total_delay_remaining + " total delay remaining in the club.");
                club_subentry.entries.listAppendList(club_entries);
                
                entry.subentries.listAppend(club_subentry);
            }
        } else if (club_turns_spent >= next_guaranteed_meeting) {
            subentry.entries.listAppend("Meet Shen in the Copperhead Club.|Will meet him next turn.");
        } else {
            subentry.entries.listAppend("Find Shen in the Copperhead Club.");
            if (club_turns_spent == next_guaranteed_meeting - 1) {
                subentry.entries.listAppend((is_disguised ? "~25" : "50") + "% chance of finding him next turn.");
                if (base_quest_state.state_int["Shen meetings"] == 3) {
                    if ($item[crappy waiter disguise].item_amount() > 0)
                        subentry.entries.listAppend("Use waiter disguises to have a chance at getting it early.").HTMLGenerateSpanFont(is_disguised ? "red" : "dark");
                    if (is_disguised)
                        subentry.entries.listAppend("Have a disguise on; give it a go.");
                }
            } else {
                subentry.modifiers.listAppendList(club_modifiers);
                
                string line;
                line += "Can show up in " + (next_guaranteed_meeting - club_turns_spent - 1).pluralise("more turn", "more turns") + ";";
                line += " ensured in " + (next_guaranteed_meeting - club_turns_spent) + ".";
                line += "|" + (total_delay_remaining - 1) + "-" + total_delay_remaining + " total delay remaining.";
                subentry.entries.listAppend(line);
            }
            subentry.entries.listAppendList(club_entries);
        }
    }
    
    
    if (!__misc_state["in run"] || $item[talisman o' namsilat].available_amount() > 0)
        optional_task_entries.listAppend(entry);
    else
        task_entries.listAppend(entry);
}
