
string [int] SFaxGeneratePotentialFaxes(boolean suggest_less_powerful_faxes, boolean [monster] blocked_monsters)
{
    string [int] potential_faxes;

    record potential_fax {
        monster target;
        string reason;
        // Faxes that will be useful, but not yet for some reason (i.e. quest not started).
        boolean unready;
        string unready_reason;
    };

    void add_fax(potential_fax it)
    {
        if (blocked_monsters[it.target]) {
            return;
        }

        string line = it.target.to_string().capitalisefirstletter() + " " + it.reason;
        if (it.unready)
        {
            if (it.unready_reason != "")
            {
                line += " (" + it.unready_reason + ")";
            }
            line = HTMLGenerateSpanFont(line, "gray");
        }
        potential_faxes.listAppend(line);
    }

    boolean can_arrow = false;
    if (get_property_int("_badlyRomanticArrows") == 0 && (familiar_is_usable($familiar[obtuse angel]) || familiar_is_usable($familiar[reanimated reanimator])))
        can_arrow = true;

    if (my_path().id == PATH_G_LOVER) can_arrow = false; // cannot use arrow skills/fams in g-lover
    
    if (get_auto_attack() != 0)
    {
        potential_faxes.listAppend("Auto attack is on, disable it?");
    }
    
    if (__misc_state["in run"])
    {
        //sleepy mariachi
        if (familiar_is_usable($familiar[fancypants scarecrow]) || familiar_is_usable($familiar[mad hatrack]))
        {
            if ($item[spangly mariachi pants].available_amount() == 0 && in_hardcore() && $item[li'l ninja costume].available_amount() == 0)
            {
                string fax = "";
                fax += ChecklistGenerateModifierSpan("yellow ray");
                
                if (familiar_is_usable($familiar[fancypants scarecrow]))
                {
                    fax += "Makes scarecrow into superfairy";
                    if (my_primestat() == $stat[moxie] && __misc_state["need to level"])
                    {
                        fax += " and +3 mainstat/turn hat";
                    }
                }
                else if (familiar_is_usable($familiar[mad hatrack]))
                    fax += "Makes hatrack into superfairy";
                fax += ".";
                
                add_fax(new potential_fax($monster[sleepy mariachi], HTMLGenerateIndentedText(fax)));
            }
        }
        
        //ninja snowman assassin (copy only)
        if (!__quest_state["Level 8"].state_boolean["Mountain climbed"] && !blocked_monsters[$monster[ninja snowman assassin]])
        {
            int equipment_missing_count = $items[ninja carabiner,ninja crampons,ninja rope].items_missing().count();
            if (equipment_missing_count > 0)
            {
                string fax = "";
                string modifier_text = "+150% init or more";
                if (equipment_missing_count == 3)
                    modifier_text += ", two copies";
                if (equipment_missing_count == 2)
                    modifier_text += ", one copy";
                fax += ChecklistGenerateModifierSpan(modifier_text);
                if (equipment_missing_count == 3)
                    fax += "Copy twice for recreational mountain climbing.<br>";
                else if (equipment_missing_count == 2)
                    fax += "Copy once for recreational mountain climbing.<br>";
                fax += generateNinjaSafetyGuide(false);
                if ($familiar[obtuse angel].familiar_is_usable() && $familiar[reanimated reanimator].familiar_is_usable())
                    fax += "<br>Make sure to copy with angel, not the reanimator.";
                
                add_fax(new potential_fax($monster[ninja snowman assassin], HTMLGenerateIndentedText(fax)));
            }
        }
        
        int missing_ore = MAX(0, 3 - __quest_state["Level 8"].state_string["ore needed"].to_item().available_amount());
        if (!__quest_state["Level 8"].state_boolean["Past mine"] && missing_ore > 0)// && !$skill[unaccompanied miner].skill_is_usable())
        {
            string line = "";
            line += ChecklistGenerateModifierSpan("+150% item or ideally YR");
            line += "Mining ores. Try to copy a few times.";
            if (__misc_state_string["obtuse angel name"] != "")
            {
                string arrow_text = " (arrow?)";
                if (get_property_int("_badlyRomanticArrows") > 0)
                    arrow_text = HTMLGenerateSpanFont(arrow_text, "gray");
                line += arrow_text;
            }
            add_fax(new potential_fax($monster[mountain man], HTMLGenerateIndentedText(line)));
        }
        
        
        if (!(__quest_state["Level 12"].finished || __quest_state["Level 12"].state_boolean["Lighthouse Finished"] || $item[barrel of gunpowder].available_amount() == 5))
        {
            string line = "(lighthouse quest";
            if ($item[barrel of gunpowder].available_amount() < 4)
            {
                    line += "; copy";
                if (can_arrow)
                    line += "/arrow";
            }
            line += ")";
            add_fax(new potential_fax($monster[Lobsterfrogman], line));
        }
        
        //orcish frat boy spy / war hippy
        if (!have_outfit_components("War Hippy Fatigues") && !have_outfit_components("Frat Warrior Fatigues") && !__quest_state["Level 12"].finished)
            potential_faxes.listAppend("Bailey's Beetle (YR) / Hippy spy (30% drop) / Orcish frat boy spy (30% drop) - war outfit");
        
        if (!__misc_state["can eat just about anything"]) //can't eat, can't fortune cookie
        {
            //Suggest kge, miner, baabaaburan:
            if (!dispensary_available() && !have_outfit_components("Knob Goblin Elite Guard Uniform"))
            {
                add_fax(new potential_fax($monster[Knob Goblin Elite Guard Captain], "- ???"));
            }
            if (!__quest_state["Level 8"].state_boolean["Past mine"] && !have_outfit_components("Mining Gear") && __misc_state["can equip just about any weapon"])
            {
                add_fax(new potential_fax($monster[7-Foot Dwarf Foreman], "- Mining gear for level 8 quest. Need YR or +234% items."));
            }
            if (!locationAvailable($location[the hidden park]) && $item[stone wool].available_amount() < ($item[the nostril of the serpent].available_amount() == 0 && !get_property_ascension("lastTempleButtonsUnlock") ? 2 : 1))
            {
                add_fax(new potential_fax($monster[Baa'baa'bu'ran], "- Stone wool for hidden city unlock. Need +100% items (or as much as you can get for extra wool)"));
            }
        }
        
        if (!__misc_state["can reasonably reach -25% combat"] && in_hardcore() && $item[Bram's choker].available_amount() == 0 && combat_rate_modifier() > -25.0 && !(__quest_state["Level 13"].in_progress || (__quest_state["Level 13"].finished && my_path().id != PATH_BUGBEAR_INVASION)))
        {
            string line = "- drops a -5% combat accessory.";
            if (my_basestat($stat[mysticality]) < 50)
                line += " (requires 50 myst)";
            add_fax(new potential_fax($monster[Bram the Stoker], line));
        }
        
        if (!in_hardcore() && $item[richard's star key].available_amount() + $item[richard's star key].creatable_amount() == 0 && !__quest_state["Level 13"].state_boolean["Richard's star key used"] && !($item[star].available_amount() >= 8 && $item[line].available_amount() >= 7))
        {
            string copy_type = "arrow";
            if (my_path().id == PATH_HEAVY_RAINS) //arrows mean washaway in flooded areas
                copy_type = "copy";
            add_fax(new potential_fax($monster[skinflute], "- +234% item, fight 4 times (" + copy_type + ") to skip HITS with pulls."));
        }
        
        if (suggest_less_powerful_faxes)
        {
            //giant swarm of ghuol whelps
            if (__quest_state["Level 7"].state_boolean["cranny needs speed tricks"] && !blocked_monsters[$monster[giant swarm of ghuol whelps]])
            {
                potential_fax fax = new potential_fax($monster[giant swarm of ghuol whelps], "- +ML - with a copy possibly");
                if (!__quest_state["Level 7"].started)
                {
                    fax.unready = true;
                    fax.unready_reason = "wait until quest started";
                }
                add_fax(fax);
            }
            //modern zmobie
            if (__quest_state["Level 7"].state_boolean["alcove needs speed tricks"] && !blocked_monsters[$monster[modern zmobie]])
            {
                potential_fax fax = new potential_fax($monster[modern zmobie], "- +ML - with a copy possibly");
                if (!__quest_state["Level 7"].started)
                {
                    fax.unready = true;
                    fax.unready_reason = "wait until quest started";
                }
                add_fax(fax);
            }
            
            //screambat for sonar replacement
            if ((3 - __quest_state["Level 4"].state_int["areas unlocked"]) > $item[sonar-in-a-biscuit].available_amount())
            {
                potential_fax fax = new potential_fax($monster[screambat], "- unlocks a single bat lair area");
                if (!__quest_state["Level 4"].in_progress)
                {
                    fax.unready = true;
                    fax.unready_reason = "quest not started";
                }
                add_fax(fax);
            }
            //monstrous boiler
            if (__quest_state["Level 11 Manor"].mafia_internal_step < 4 && $item[wine bomb].available_amount() == 0)
            {
                add_fax(new potential_fax($monster[monstrous boiler], "- charge up unstable fulminate.", $item[unstable fulminate].available_amount() == 0));
            }
            if (true) //not sure about this
            {
                //marginal stuff:
                //whitesnake, white lion
                if (in_hardcore() && $items[wet stunt nut stew,mega gem].available_amount() == 0 && !__quest_state["Level 11 Palindome"].finished)
                {
                    string [int] stew_source_monsters;
                    if ($item[bird rib].available_amount() == 0)
                    {
                        stew_source_monsters.listAppend("whitesnake");
                    }
                    if ($item[lion oil].available_amount() == 0)
                    {
                        stew_source_monsters.listAppend("white lion");
                    }
                    if (stew_source_monsters.count() > 0)
                    {
                        string description = stew_source_monsters.listJoinComponents("/").capitaliseFirstLetter() + " - run +300% item/food drops for wet stunt nut stew components. (marginal?)";
                        
                        potential_faxes.listAppend(description);
                    }
                }
            }
            //blur
            if (!__quest_state["Level 11 Desert"].state_boolean["Desert Explored"] && $item[drum machine].available_amount() == 0 && !__quest_state["Level 11 Desert"].state_boolean["Wormridden"] && in_hardcore())
            {
                add_fax(new potential_fax($monster[blur], "- +234% item " + (item_drop_modifier() >= 234 ? "(have) " : "(don't have) ") + "for drum machine for possible desert exploration route."));
            }
            
            if (in_hardcore() && knoll_available() && __quest_state["Level 11 Hidden City"].state_boolean["need machete for liana"] && $item[forest tears].available_amount() == 0)
            {
                add_fax(new potential_fax($monster[forest spirit], "- +234% item - forest tears can meatsmith into a muculent machete for dense liana" + (($familiar[intergnat].familiar_is_usable() && my_level() <= 11) ? " (or use intergnat summon)" : "")));
            }
            //green ops
            //baa'baa'bu'ran
            //grungy pirate - for guitar (need 400% item/YR)
            //harem girl
            
            //FIXME rest
            //f'c'le - cleanly pirate/curmudgeonly pirate/that other pirate (and insults)
            //KGE
            
            //dairy goat? mostly for early milk of magnesium (stunt runs)
            //possessed wine rack / cabinet
            //pygmy shaman / accountant - if you absolutely have to
            //barret / aerith for equipment
            //racecar bob to olfact
            
            //brainsweeper for chef-in-the-box / bartender-in-the-box?
            //gremlins?
            
            //FIXME handsome mariachi/etc?
        }
    }
    else
    {
        //aftercore:
        //potential_faxes.listAppend("Adventurer Echo - event chroner");
        add_fax(new potential_fax($monster[Clod Hopper], "(YR/+item) - floaty sand"));
        add_fax(new potential_fax($monster[swarm of fudgewasps], "- fudge"));
    }
    
    return potential_faxes;
}

string [int] SFaxGeneratePotentialFaxes(boolean suggest_less_powerful_faxes)
{
    boolean [monster] blank;
    return SFaxGeneratePotentialFaxes(suggest_less_powerful_faxes, blank);
}

void SFaxGenerateEntry(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries)
{
    if (my_path().id == PATH_G_LOVER) return; // cannot use fax machine in g-lover

    string url = "clan_viplounge.php?action=faxmachine";
    
    if (get_auto_attack() != 0)
    {
        url = "account.php?tab=combat";
    }
    
	if (__misc_state["fax available"] && $item[photocopied monster].available_amount() == 0)
        optional_task_entries.listAppend(ChecklistEntryMake("fax machine", url, ChecklistSubentryMake("Fax", "", listJoinComponents(SFaxGeneratePotentialFaxes(true), "|<hr>"))).ChecklistEntrySetIDTag("VIP fax machine suggestions"));
    if ($skill[Rain Man].skill_is_usable() && my_rain() >= 50)
    {
        ChecklistEntry entry = ChecklistEntryMake("__skill rain man", "skills.php", ChecklistSubentryMake("Rain man copy", "50 rain drops", listJoinComponents(SFaxGeneratePotentialFaxes(true), "<hr>")));
        entry.tags.id = "Heavy rains path rain man skill";
        
        if (my_rain() > 93)
        {
            entry.importance_level = -10;
            task_entries.listAppend(entry);
        }
        else
            optional_task_entries.listAppend(entry);
    }
}

void SFaxGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (__misc_state["in aftercore"])
        SFaxGenerateEntry(resource_entries, resource_entries);
}


void SFaxGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if (!__misc_state["in aftercore"])
        SFaxGenerateEntry(task_entries, optional_task_entries);
}
