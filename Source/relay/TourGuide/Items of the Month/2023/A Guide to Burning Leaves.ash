// TILE SPEC:
//    - Remind the user to spend their leaves.
//    - Advise the user of top leafy options.
//    - Add leafy free fights to the freefightcombinationtag

Record LeafyFight 
{
    int leafCost;
    monster summonedMonster;
    string scaling;
    int leavesDropped;
    string extraDrops;
};

LeafyFight LeafyFightMake(int cost, monster summonedMonster, string scaling, int leavesDropped, string itemDropped)
{
    LeafyFight summon;

    summon.leafCost = cost;
    summon.summonedMonster = summonedMonster;
    summon.scaling = scaling;
    summon.leavesDropped = leavesDropped;
    summon.extraDrops = itemDropped;
    
    return summon;
}

Record LeafySummon
{
    int leafCost;
    item summonedItem;
    string description;
    boolean meltingStatus;
    string prefName;
};

LeafySummon LeafySummonMake(int cost, item summonedItem, string desc, boolean melts, string prefName)
{
    LeafySummon summon;

    summon.leafCost = cost;
    summon.summonedItem = summonedItem;
    summon.description = desc;
    summon.meltingStatus = melts;
    summon.prefName = prefName;
    
    return summon;
}

void listAppend(LeafyFight [int] list, LeafyFight entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listAppend(LeafySummon [int] list, LeafySummon entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

RegisterResourceGenerationFunction("IOTMBurningLeavesGenerateResource");
void IOTMBurningLeavesGenerateResource(ChecklistEntry [int] resource_entries)
{
    // Don't generate these tiles if they cannot actually use their leaves
    if (!__iotms_usable[$item[A Guide to Burning Leaves]]) return;

    string url = "campground.php?preaction=leaves";

    // Make two tiles for spending leaves
    int leafCount = $item[inflammable leaf].item_amount();
    string [int] itemsDescription;
    string [int] monstersDescription;

    // To use these, if you do "aftercoreStuff[##]" it'll return true if it's in the list or false if not
    boolean [int] aftercoreStuff = $ints[99,222,1111,6666,11111];
    boolean [int] inRunStuff = $ints[42,43,44,66];

    if ($item[inflammable leaf].have()) {

        LeafySummon [int] leafySummons;
        // leafySummons.listAppend(LeafySummonMake(#leafcost, $item[leafsummon], "tile desc", t/f(melts), "name of summon check pref"));
        leafySummons.listAppend(LeafySummonMake(37, $item[autumnic bomb], "potion; prismatic stinging (25 turns)", false, ""));
        leafySummons.listAppend(LeafySummonMake(42, $item[impromptu torch], "weapon; +2 mus/fight", true, ""));
        leafySummons.listAppend(LeafySummonMake(43, $item[flaming fig leaf], "pants; +2 mox/fight", true, ""));
        leafySummons.listAppend(LeafySummonMake(44, $item[smoldering drape], "cape; +2 mys/fight, +20% stat", true, ""));
        leafySummons.listAppend(LeafySummonMake(50, $item[distilled resin], "potion; generate +1 leaf/fight (100 turns)", false, ""));
        leafySummons.listAppend(LeafySummonMake(66, $item[autumnal aegis], "shield; +250 DA, +2 all res", false, ""));
        leafySummons.listAppend(LeafySummonMake(69, $item[lit leaf lasso], "combat item; lasso leaf freebies for extra end-of-combat triggers", false, "_leafLassosCrafted"));
        leafySummons.listAppend(LeafySummonMake(74, $item[forest canopy bed], "bed; +5 free rests, stats via rests", false, ""));
        leafySummons.listAppend(LeafySummonMake(99, $item[autumnic balm], "potion; +2 all res (100 turns)", false, ""));
        leafySummons.listAppend(LeafySummonMake(222, $item[day shortener], "spend 5 turns for a +turn item", false, "_leafDayShortenerCrafted"));
        leafySummons.listAppend(LeafySummonMake(1111, $item[coping juice], "copium for the masses", false, ""));
        leafySummons.listAppend(LeafySummonMake(6666, $item[smoldering leafcutter ant egg], "mosquito & leaves familiar", false, "_leafAntEggCrafted"));
        leafySummons.listAppend(LeafySummonMake(11111, $item[super-heated leaf], "burn leaves into your skiiiin", false, "_leafTattooCrafted"));

        // Make a big summons table for a leaf summoning tile 
        string [int][int] summonOptions;

        // Header for the item summons table
        if (true) 
        {
            string [int] option;
            option.listAppend("cost");
            option.listAppend("item");
            option.listAppend("description");
            foreach key, s in option
            {
                option[key] = HTMLGenerateSpanOfClass(s, "r_bold");
            }
            summonOptions.listAppend(option);
        }

        // Populate the table
        foreach key, summon in leafySummons 
        {
            // Adding some skip conditions for aftercore/in-run options
            // if (__misc_state["in run"] && aftercoreStuff[summon.leafCost]) continue; 
            // if (!__misc_state["in run"] && inRunStuff[summon.leafCost]) continue;

            // Run pref checks & do not generate a row if you cannot summon it anymore
            boolean userCanSummon = true;

            if (summon.prefName == "")
                userCanSummon = true;
            else if (summon.prefName == "_leafLassosCrafted")
                userCanSummon = get_property_int("_leafLassosCrafted") < 3; // can make a lasso if you've made <3
            else
                userCanSummon = !get_property_boolean(summon.prefName); // prefs are false if non-summoned, true if summoned and you're locked out

            if (!userCanSummon) continue;

            // A handful of conditional exclusions. Enumerated reasons in the comments!

            // The bomb is useful if you aren't able to use crab or short-order cook. Otherwise, not particularly useful.
            boolean canUseShorty = lookupFamiliar("Shorter-Order Cook").familiar_is_usable();
            boolean canUseCrab = lookupFamiliar("Imitation Crab").familiar_is_usable();

            if (canUseShorty || canUseCrab) {
                if (summon.leafCost == 37) continue;  
            }

            // If the user is level 12 or higher, no reason to show fig or torch. Going to still
            //   show drape if they don't have it, as 20% stat might be useful slot-filler for some
            //   weird user somewhere.
            if (my_level() > 11) {
                if ($ints[42,43] contains summon.leafCost) continue;
            }

            // If the user has Tao of the Terrapin available, they probably don't need the aegis
            if (lookupSkill("Tao of the Terrapin").have_skill()) {
                if (summon.leafCost == 66) continue;
            }

            // Do not get 2 of any of the equips or other one-use items
            if (summon.summonedItem.available_amount() > 0) {
                if ($ints[42,43,44,66,74] contains summon.leafCost) continue;
            }

            // Do not show the bed if it is already installed either
            if (get_campground() contains $item[forest canopy bed]) {
                if (summon.leafCost == 74) continue;
            }

            // Set the color to gray if you don't have enough leaves
            boolean hasEnoughLeaves = leafCount >= summon.leafCost;
            string rowColor = hasEnoughLeaves ? "black" : "gray";

            // Add smaller melting tag to description, if it's melting
            string summonDesc = summon.description;
            if (summon.meltingStatus) 
                summonDesc += HTMLGenerateSpanFont(" (melting)", "gray", "0.7em");

            // Hide aftercore stuff while in-run, and visa versa
            if (__misc_state["in run"]) {
                if (aftercoreStuff[summon.leafCost]) continue;
            } 
            
            if (!__misc_state["in run"]) {
                if (inRunStuff[summon.leafCost]) continue;
            }

            string [int] option;
            // add cost
            option.listAppend(summon.leafCost);
            option.listAppend(summon.summonedItem.to_string());
            option.listAppend(summonDesc);
            foreach key, s in option 
            {
                option[key] = HTMLGenerateSpanFont(s, rowColor);
            }
            summonOptions.listAppend(option);
        }
        itemsDescription.listAppend(HTMLGenerateSimpleTableLines(summonOptions));
        resource_entries.listAppend(ChecklistEntryMake("__item inflammable leaf", url, ChecklistSubentryMake(pluralise(leafCount, "leaf to burn for items", "leaves to burn for items"), "", itemsDescription), 14).ChecklistEntrySetIDTag("Burning leaf item summons"));

        // With item summons done, make a seal-esque fights tile
        
        int fightsRemaining = clampi(5 - get_property_int("_leafMonstersFought"), 0, 5);

        if (fightsRemaining > 0) {
            LeafyFight [int] leafyFights;
            // leafyFights.listAppend(LeafyFightMake(#leafcost, $monster[leafmonster], "scaling desc", #leafdrops, "extra drops"));
            leafyFights.listAppend(LeafyFightMake(11, $monster[flaming leaflet], "11/11/11", 4, ""));
            leafyFights.listAppend(LeafyFightMake(111, $monster[flaming monstera], "scaling", 7, "leafy browns"));

            // No particular need to fight leaviathan over monstera in run if the user owns the crown already
            if (!(__misc_state["in run"] && $item[flaming leaf crown].have())) {
                leafyFights.listAppend(LeafyFightMake(666, $monster[leaviathan], "scaling boss (hard!)", 125, "flaming leaf crown"));
            }

            string [int][int] fightOptions;

            // Header for the fight summons table
            if (true)
            {
                string [int] option;
                option.listAppend("cost");
                option.listAppend("monster");
                option.listAppend("stats & info");
                foreach key, s in option
                {
                    option[key] = HTMLGenerateSpanOfClass(s, "r_bold");
                }
                fightOptions.listAppend(option);
            }

            foreach key, summon in leafyFights
            {
                boolean hasEnoughLeaves = leafCount >= summon.leafCost;
                string rowColor = hasEnoughLeaves ? "black" : "gray";

                // Add smaller melting tag to description, if it's melting
                string summonDesc = summon.scaling + "; ~"+summon.leavesDropped+" leaves dropped ";
                if (summon.extraDrops != "") 
                    summonDesc += HTMLGenerateSpanFont("(also, drops "+summon.extraDrops+")", "gray", "0.7em");

                string [int] option;
                // add cost
                option.listAppend(summon.leafCost);
                option.listAppend(summon.summonedMonster.to_string());
                option.listAppend(summonDesc);
                foreach key, s in option 
                {
                    option[key] = HTMLGenerateSpanFont(s, rowColor);
                }
                fightOptions.listAppend(option);
            }

            int leafletsUserCanSummon = leafCount/11;

            monstersDescription.listAppend(HTMLGenerateSimpleTableLines(fightOptions));
            if (leafCount > 111*fightsRemaining) {
                monstersDescription.listAppend("With your "+pluralise(leafCount, "leaf", "leaves")+", you can summon <b>"+fightsRemaining+" monstera</b>, for scaling fights");
            }
            else if (leafCount > 11*fightsRemaining) {
                monstersDescription.listAppend("With your "+pluralise(leafCount, "leaf", "leaves")+", you can summon <b>"+fightsRemaining+" leaflets</b>, for familiar turns");
            }
            else if (leafCount > 11) {
                monstersDescription.listAppend("With your "+pluralise(leafCount, "leaf", "leaves")+", you can currently summon "+pluralise(leafletsUserCanSummon,"leaflet","leaflets")+"; save leaves for more!");
            }
            else {
                monstersDescription.listAppend("With your "+pluralise(leafCount, "leaf", "leaves")+", you cannot currently summon a free fight; save leaves for more!");
            }

            resource_entries.listAppend(ChecklistEntryMake("__monster flaming leaflet", url, ChecklistSubentryMake(pluralise(fightsRemaining, "remaining free burned leaf fight", "remaining free burned leaf fights"), "remember to lasso for +1 fight!", monstersDescription), 13).ChecklistEntrySetIDTag("Burning leaf fight summons"));

        }
        
    }
    
    // Make a free fights combo tag for available free leaf fights
    int fightsRemaining = clampi(5 - get_property_int("_leafMonstersFought"), 0, 5);
    int leafletsUserCanSummon = leafCount/11;
    
    string [int] description;
    ChecklistSubentry [int] subentries;

    if (fightsRemaining > 0) {
        
        if (leafCount >= 111*fightsRemaining) {
            description.listAppend("Have enough leaves for "+fightsRemaining+" flaming monstera");
        }
        else if (leafCount >= 11*fightsRemaining) {
            description.listAppend("Have enough leaves for "+fightsRemaining+" leaflets");
        }
        else if (leafCount >= 8*fightsRemaining) {
            description.listAppend("Have enough leaves, if you let the leaflets drop their bounty!");
        }
        else {
            description.listAppend("Can summon "+leafletsUserCanSummon+" of your "+fightsRemaining+" leaflets... "+HTMLGenerateSpanFont("get more leaves!", "orange"));
        }

        subentries.listAppend(ChecklistSubentryMake(pluralise(fightsRemaining, "free flaming leaflet fight", "free flaming leaflet fights"), "", description));
        TagGroup tags;
        tags.id = "Burning Leaves free fights";
        tags.combination = "daily free fight";
        resource_entries.listAppend(ChecklistEntryMake("__item tied-up flaming leaflet", url, subentries, tags, 0));
    }
}

RegisterTaskGenerationFunction("BurningLeavesRakeReminder");
void SneakActiveTask(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    // Don't generate this tile if they cannot actually use their leaves
    if (!__iotms_usable[$item[A Guide to Burning Leaves]]) return;

    string url = "campground.php?preaction=burningleaves";
    // Use the new preference to tell if there's an NC forcer active
    if ($item[rake].available_amount() > 0) return;
    
    // If they don't have a rake, remind them to get one
    ChecklistEntry entry;
    
	entry.url = "campground.php?preaction=leaves";
	entry.image_lookup_name = "__item Inflammable leaf";
    entry.tags.id = "Rake and Tiny Rake reminder";
    entry.importance_level = 7;

    entry.subentries.listAppend(ChecklistSubentryMake("It's mulch madness -- go get your rakes","","Visit your pile of burning leaves for rakes... for more leaves!")); 

    optional_task_entries.listAppend(entry);
}