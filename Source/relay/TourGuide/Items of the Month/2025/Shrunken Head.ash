//shrunken head
RegisterTaskGenerationFunction("IOTMShrunkenHeadGenerateTasks");
void IOTMShrunkenHeadGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    // TODO: last optional thing i don't really want to do rn but could do later:
    //   - convert current targets to hoverover recommendations w/ filtering
    
	if (!__iotms_usable[lookupItem("Shrunken Head")]) return;

    monster headZombie = get_property("shrunkenHeadZombieMonster").to_monster();
    int headZombieHP = get_property_int("shrunkenHeadZombieHP");

	string url = "inventory.php?ftext=shrunken+head";
	string [int] supernagDescription;
	
    // Generate a supernag task if head is equipped that inspires the user to toss it at a monster
	if (lookupItem("shrunken head").equipped_amount() > 0)
	{
		supernagDescription.listAppend("Throw it at a monster for a zombified friend!");
		task_entries.listAppend(ChecklistEntryMake("__item shrunken head", url, ChecklistSubentryMake(HTMLGenerateSpanFont("Shrunken Head equipped", "blue"), supernagDescription), -11).ChecklistEntrySetIDTag("shrunken head"));
	}

    string [int] description;
    string [int] itemList;
    string title;
    string subtitle;

    // Generate an optional task for killing your zombie
    if (headZombieHP > 0) {
        title = "Current Zombie: "+headZombie.name;
        subtitle = headZombieHP+" HP remaining";

        string headEffects = shrunken_Head_Zombie(headZombie).listJoinComponents(", ");
        string [string] abilityCompression = {
            "Item Drop Bonus":"item%",
            "Meat Drop Bonus":"meat%",
            "Physical Attack":"atk",
            "Hot Attack": HTMLGenerateSpanFont("atk","r_element_hot_desaturated"),
            "Cold Attack": HTMLGenerateSpanFont("atk","r_element_cold_desaturated"),
            "Sleaze Attack": HTMLGenerateSpanFont("atk","r_element_sleaze_desaturated"),
            "Stench Attack": HTMLGenerateSpanFont("atk","r_element_stench_desaturated"),
            "Spooky Attack": HTMLGenerateSpanFont("atk","r_element_spooky_desaturated"),
            "MP Regen": "mp",
            "HP Regen": "hp",
        };

        foreach key,value in abilityCompression
        {
              headEffects = headEffects.replace_string(key, value);
        }

        // parse through item drops array, only grabbing things that might drop
        foreach key, r in headZombie.item_drops_array() {
            item it = r.drop;
            int base_drop_rate = r.rate;

            // ignore items that are:
            //   n = not pickpocketable
            //   p = pickpocket-only
            //   b = bounty item
            //   a = accordion
            if (!r.type.contains_text("n") && !r.type.contains_text("p") && !r.type.contains_text("a") && !r.type.contains_text("b")) {
                string [int] item_drop_modifiers_to_display;
                if (base_drop_rate > 0 && base_drop_rate < 100) {
                    float effective_drop_rate = base_drop_rate;
                    float item_modifier = item_drop_modifier();
                    if (it.fullness > 0 || it.cookable) 
                    {
                        item_modifier += numeric_modifier("Food Drop");
                        item_drop_modifiers_to_display.listAppend("+food");
                    }
                    if (it.inebriety > 0 || it.mixable)
                    {
                        item_modifier += numeric_modifier("Booze Drop");
                        item_drop_modifiers_to_display.listAppend("+booze");
                    }
                    if (it.to_slot() == $slot[hat])
                    {
                        item_modifier += numeric_modifier("Hat Drop");
                        item_drop_modifiers_to_display.listAppend("+hat");
                    }
                    if (it.to_slot() == $slot[weapon])
                    {
                        item_modifier += numeric_modifier("Weapon Drop");
                        item_drop_modifiers_to_display.listAppend("+weapon");
                    }
                    if (it.to_slot() == $slot[off-hand])
                    {
                        item_modifier += numeric_modifier("Offhand Drop");
                        item_drop_modifiers_to_display.listAppend("+offhand");
                    }
                    if (it.to_slot() == $slot[shirt])
                    {
                        item_modifier += numeric_modifier("Shirt Drop");
                        item_drop_modifiers_to_display.listAppend("+shirt");
                    }
                    if (it.to_slot() == $slot[pants])
                    {
                        item_modifier += numeric_modifier("Pants Drop");
                        item_drop_modifiers_to_display.listAppend("+pants");
                    }
                    if ($slots[acc1,acc2,acc3] contains it.to_slot())
                    {
                        item_modifier += numeric_modifier("Accessory Drop");
                        item_drop_modifiers_to_display.listAppend("+accessory");
                    }
                    if (it.candy)
                    {
                        item_modifier += numeric_modifier("Candy Drop");
                        item_drop_modifiers_to_display.listAppend("+candy");
                    }
                    if ($slots[hat,weapon,off-hand,back,shirt,pants,acc1,acc2,acc3] contains it.to_slot()) //assuming familiar equipment isn't "gear"
                    {
                        item_modifier += numeric_modifier("Gear Drop");
                        item_drop_modifiers_to_display.listAppend("+gear");
                    }
                    if (it == $item[black picnic basket] && $skill[Bear Essence].have_skill())
                    {
                        item_modifier += 20.0 * MAX(1, get_property_int("skillLevel134"));
                    }

                    // subtract familiar item drop modifier because of reasons
                    int effective_familiar_weight = my_familiar().familiar_weight() + numeric_modifier("familiar weight");                
                    int familiar_weight_from_familiar_equipment = $slot[familiar].equipped_item().numeric_modifier("familiar weight"); //need to cancel it out
                    float familiar_item_drop = my_familiar().numeric_modifier("item drop", effective_familiar_weight - familiar_weight_from_familiar_equipment, $slot[familiar].equipped_item());

                    effective_drop_rate *= 1.0 + (item_modifier-familiar_item_drop) / 100.0;
                    effective_drop_rate = clampf(floor(effective_drop_rate), 0.0, 100.0);

                    itemList.listAppend(to_string(effective_drop_rate)+"% "+it.name+HTMLGenerateSpanFont(" ( "+to_string(to_int(base_drop_rate))+"% "+item_drop_modifiers_to_display.listJoinComponents(", ")+")","gray","0.8em"));
                }
            }
        }

        description.listAppend("<b>Active Effects</b>: "+headEffects);
        
        if (itemList.count() > 0) {
            description.listAppend("If your zombie dies next turn, here's the % chance you get each item in the drop table!");
	        description.listAppend("<hr>|*"+itemList.listJoinComponents("<hr>|*"));
        }

        optional_task_entries.listAppend(ChecklistEntryMake("__item shrunken head", url, ChecklistSubentryMake(title, subtitle, description), 9).ChecklistEntrySetIDTag("Shrunken Head zombie"));

    }
}


RegisterResourceGenerationFunction("IOTMShrunkenHeadGenerateResource");
void IOTMShrunkenHeadGenerateResource(ChecklistEntry [int] resource_entries)
{
	if (!__iotms_usable[lookupItem("Shrunken Head")]) return;

    monster headZombie = get_property("shrunkenHeadZombieMonster").to_monster();
    int headZombieHP = get_property_int("shrunkenHeadZombieHP");
    
    string title = "Shrunken Head targets";
	string url = "inventory.php?ftext=shrunken+head";
    string [int] description;

    description.listAppend("Consider reanimating these monsters for their items:");
    description.listAppend("|*dairy goat"+HTMLGenerateSpanFont(" (40%)", "gray", "0.8em"));
    description.listAppend("|*pygmy bowler"+HTMLGenerateSpanFont(" (40%)", "gray", "0.8em"));
    description.listAppend("|*baa-relief sheep"+HTMLGenerateSpanFont(" (25%)", "gray", "0.8em"));
    description.listAppend("|*pygmy janitor"+HTMLGenerateSpanFont(" (20%)", "gray", "0.8em"));
    description.listAppend("|*spiny or toothy skeletons"+HTMLGenerateSpanFont(" (20%)", "gray", "0.8em"));
    description.listAppend("|*banshee librarian"+HTMLGenerateSpanFont(" (10%)", "gray", "0.8em"));
    description.listAppend("|*mountain man"+HTMLGenerateSpanFont(" (10%)", "gray", "0.8em"));
    description.listAppend("|*Any ol' Smut Orc"+HTMLGenerateSpanFont(" (10%)", "gray", "0.8em"));
    
    resource_entries.listAppend(ChecklistEntryMake("__item shrunken head", url, ChecklistSubentryMake(title, "", description), 9).ChecklistEntrySetIDTag("Shrunken Head Targets"));
}