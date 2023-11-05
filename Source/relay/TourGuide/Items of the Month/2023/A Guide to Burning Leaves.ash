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
}

LeafyFight LeafyFightMake(int cost, monster summonedMonster, string scaling, int leavesDropped, item itemDropped)
{
    LeafyFight summon;

    summon.leafCost = cost;
    summon.summonedMonster = summonedMonster;
    summon.scaling = scaling;
    summon.leavesDropped = leavesDropped;
    summon.itemDropped = itemDropped;
    
    return summon;
}

Record LeafySummon
{
    int leafCost;
    item summonedItem;
    string description;
    boolean meltingStatus;
    string prefName;
}

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

RegisterResourceGenerationFunction("IOTMBurningLeavesGenerateResource");
void IOTMBurningLeavesGenerateResource(ChecklistEntry [int] resource_entries)
{
    // Don't generate these tiles if they cannot actually use their leaves
    if (!__iotms_usable[$item[A Guide to Burning Leaves]]) return;

    string url = "campground.php?preaction=burningleaves";

    // Make two tiles for spending leaves
    item leaf = $item[inflammable leaf];
    int leafCount = leaf.item_amount();
    string [int] itemsDescription;
    string [int] monstersDescription;

    // To use these, if you do "aftercoreStuff[##]" it'll return true if it's in the list or false if not
    boolean [int] aftercoreStuff = [222,1111,6666,11111];
    boolean [int] inRunStuff = [42,43,44,66];

    // Disabling in-run condition for testing
    // if (leaf.have() && __misc_state["in run"]) {
    if (leaf.have()) {

        LeafyFight [int] leafyFights;
        // leafyFights.listAppend(LeafyFightMake(#leafcost, $monster[leafmonster], "scaling desc", #leafdrops, "extra drops"));
        leafyFights.listAppend(LeafyFightMake(11, $monster[flaming leaflet], "11/11/11", 4, ""));
        leafyFights.listAppend(LeafyFightMake(111, $monster[flaming monstera], "scaling", 7, "leafy browns"));
        leafyFights.listAppend(LeafyFightMake(666, $monster[leaviathan], "scaling boss (hard!)", 125, "leafy browns"));

        LeafySummon [int] leafySummons;
        // leafySummons.listAppend(LeafySummonMake(#leafcost, $item[leafsummon], "tile desc", t/f(melts), "name of summon check pref"));
        leafySummons.listAppend(LeafySummonMake(37, $item[autumnic bomb], "potion; prismatic stinging (25 turns)", false, ""));
        leafySummons.listAppend(LeafySummonMake(42, $item[impromptu torch], "weapon; +2 mus/fight", true, ""));
        leafySummons.listAppend(LeafySummonMake(43, $item[flaming fig leaf], "pants; +2 mox/fight", true, ""));
        leafySummons.listAppend(LeafySummonMake(44, $item[smoldering drape], "cape; +2 mys/fight, +20% stat", true, ""));
        leafySummons.listAppend(LeafySummonMake(50, $item[distilled resin], "potion; generate +1 leaf/fight (100 turns)", false, ""));
        leafySummons.listAppend(LeafySummonMake(66, $item[autumnal aegis], "shield; +250 DA, +2 all res", false, ""));
        leafySummons.listAppend(LeafySummonMake(69, $item[lit leaf lasso], "combat item; lasso leaf freebies for +1 free fight", false, "_leafLassosCrafted"));
        leafySummons.listAppend(LeafySummonMake(74, $item[forest canopy bed], "bed; +5 free rests, stats via rests", false, ""));
        leafySummons.listAppend(LeafySummonMake(99, $item[autumnic balm], "potion; +2 all res (100 turns)", false, ""));
        leafySummons.listAppend(LeafySummonMake(222, $item[day shortener], "spend 5 turns for a +turn item", false, "_leafDayShortenerCrafted"));
        leafySummons.listAppend(LeafySummonMake(1111, $item[coping juice], "copium for the masses", false, ""));
        leafySummons.listAppend(LeafySummonMake(6666, $item[smoldering leafcutter ant egg], "mosquito & leaves familiar", false, "_leafAntEggCrafted"));
        leafySummons.listAppend(LeafySummonMake(11111, $item[super-heated leaf], "burn leaves into your skiiiin", false, ""));

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
            // Adding some skip conditions for certain stuff
            if (__misc_state["in run"] && aftercoreStuff[summon.leafCost]) continue; 
            if (!__misc_state["in run"] && inRunStuff[summon.leafCost]) continue;

            // Run pref checks & do not generate a row if you can't summon it
            boolean userCanSummon;

            switch (summon.prefName) {
                case "":
                    userCanSummon = true;
                case "_leafLassosCrafted":
                    userCanSummon = get_property_int("_leafLassosCrafted") < 3;
                default:
                    userCanSummon = get_property_boolean(summon.prefName);
            }

            if (!userCanSummon) continue;

            // Set the color to gray if you don't have enough leaves
            boolean hasEnoughLeaves = leafCount > summon.leafCost;
            string rowColor = hasEnoughLeaves ? "black" : "gray";

            // Add smaller melting tag to description, if it's melting
            string summonDesc = summon.description;
            if (summon.meltingStatus) 
                summonDesc += HTMLGenerateSpanFont("(melting)", "0.9em");

            string [int] option;
            // add cost
            option.listAppend(summon.leafCost);
            option.listAppend(summon.summonedItem.to_string())
            option.listAppend(summonDesc)
            foreach key, s in option 
            {
                option[key] = HTMLGenerateSpanFont(s, rowColor);
            }
            summonOptions.listAppend(options);
        }
        itemsDescription.listPrepend(HTMLGenerateSimpleTableLines(summonOptions));

        resource_entries.listAppend(ChecklistEntryMake("__item inflammable leaf", url, ChecklistSubentryMake(pluralise(leafCount, "leaf to spend", "leaves to spend"), "", itemsDescription), 13).ChecklistEntrySetIDTag("Burning leaf item summons"));

    }
    
    // Make a free fights tile for available free leaf fights
    int fightsRemaining = clampi(5 - get_property_int("_leafMonstersFought"), 0, 5);
    
    string [int] description;
    ChecklistSubentry [int] subentries;

    if (fightsRemaining > 0) {
        
        if (leafCount > 111*fightsRemaining) {
            description.listAppend("Have enough leaves for "+fightsRemaining+" flaming monstera");
        }
        else if (leafCount > 11*fightsRemaining) {
            description.listAppend("Have enough leaves for "+fightsRemaining+" leaflets");
        }
        else if (leafCount > 8*fightsRemaining) {
            description.listAppend("Have enough leaves, if you let the leaflets drop their bounty!");
        }
        else {
            description.listAppend(HTMLGenerateSpanFont("Don't have enough leaves to fight your leaflets... get more!", "red"))
        }

        subentries.listAppend(ChecklistSubentryMake(pluralise(fightsRemaining, "free flaming leaflet fight", "free flaming leaflet fights"), "", description));
        TagGroup tags;
        tags.id = "Burning Leaves free fights";
        tags.combination = "daily free fight";
        resource_entries.listAppend(ChecklistEntryMake("__item tied-up flaming leaflet", url, subentries, tags, 0));
    }
}