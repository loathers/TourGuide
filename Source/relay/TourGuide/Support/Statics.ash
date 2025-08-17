import "relay/TourGuide/Support/List.ash";
import "relay/TourGuide/Support/Ingredients.ash"

static {
    int PATH_UNKNOWN = -1;
    int PATH_NONE = 0;
    int PATH_BOOZETAFARIAN = 1;
    int PATH_TEETOTALER = 2;
    int PATH_OXYGENARIAN = 3;

    int PATH_BEES_HATE_YOU = 4;
    int PATH_WAY_OF_THE_SURPRISING_FIST = 6;
    int PATH_TRENDY = 7;
    int PATH_AVATAR_OF_BORIS = 8;
    int PATH_BUGBEAR_INVASION = 9;
    int PATH_ZOMBIE_SLAYER = 10;
    int PATH_CLASS_ACT = 11;
    int PATH_AVATAR_OF_JARLSBERG = 12;
    int PATH_BIG = 14;
    int PATH_KOLHS = 15;
    int PATH_CLASS_ACT_2 = 16;
    int PATH_AVATAR_OF_SNEAKY_PETE = 17;
    int PATH_SLOW_AND_STEADY = 18;
    int PATH_HEAVY_RAINS = 19;
    int PATH_PICKY = 21;
    int PATH_STANDARD = 22;
    int PATH_ACTUALLY_ED_THE_UNDYING = 23;
    int PATH_ONE_CRAZY_RANDOM_SUMMER = 24;
    int PATH_COMMUNITY_SERVICE = 25;
    int PATH_AVATAR_OF_WEST_OF_LOATHING = 26;
    int PATH_THE_SOURCE = 27;
    int PATH_NUCLEAR_AUTUMN = 28;
    int PATH_GELATINOUS_NOOB = 29;
    int PATH_LICENSE_TO_ADVENTURE = 30;
    int PATH_LIVE_ASCEND_REPEAT = 31;
    int PATH_POCKET_FAMILIARS = 32;
    int PATH_G_LOVER = 33;
    int PATH_DISGUISES_DELIMIT = 34;
    int PATH_DEMIGUISE = 34;
    int PATH_DARK_GYFFTE = 35;
    int PATH_DARK_GIFT = 35;
    int PATH_VAMPIRE = 35;
    int PATH_2CRS = 36;
    int PATH_KINGDOM_OF_EXPLOATHING = 37;
    int PATH_EXPLOSION = 37;
    int PATH_EXPLOSIONS = 37;
    int PATH_EXPLODING = 37;
    int PATH_EXPLODED = 37;
    int PATH_OF_THE_PLUMBER = 38;
    int PATH_LOW_KEY_SUMMER = 39;
    int PATH_GREY_GOO = 40;
    int PATH_YOU_ROBOT = 41;
    int PATH_QUANTUM_TERRARIUM = 42;
    int PATH_WILDFIRE = 43;
    int PATH_GREY_YOU = 44;
    int PATH_JOURNEYMAN = 45;
    int PATH_FALL_OF_THE_DINOSAURS = 46;
    int PATH_AVATAR_OF_SHADOWS_OVER_LOATHING = 47;
    int PATH_LEGACY_OF_LOATHING = 48;
    int PATH_SMOL = 49; // easier to type
    int PATH_A_SHRUNKEN_ADVENTURER_AM_I = 49;
    int PATH_WEREPROFESSOR = 50;
    int PATH_SEA = 55;
}

float numeric_modifier_replacement(item it, string modifier_string) {
    string modifier_lowercase = modifier_string.to_lower_case();
    float additional = 0;
    if (my_path().id == PATH_G_LOVER && !it.contains_text("g") && !it.contains_text("G"))
    	return 0.0;
    if (it == $item[your cowboy boots])
    {
        if (modifier_lowercase == "monster level" && $slot[bootskin].equipped_item() == $item[diamondback skin])
        {
            return 20.0;
        }
        if (modifier_lowercase == "initiative" && $slot[bootspur].equipped_item() == $item[quicksilver spurs])
            return 30;
        if (modifier_lowercase == "item drop" && $slot[bootspur].equipped_item() == $item[nicksilver spurs])
            return 30;
        if (modifier_lowercase == "muscle percent" && $slot[bootskin].equipped_item() == $item[grizzled bearskin])
            return 50.0;
        if (modifier_lowercase == "mysticality percent" && $slot[bootskin].equipped_item() == $item[frontwinder skin])
            return 50.0;
        if (modifier_lowercase == "moxie percent" && $slot[bootskin].equipped_item() == $item[mountain lion skin])
            return 50.0;
        //FIXME deal with rest (resistance, etc)
    }
    //so, when we don't have the smithsness items equipped, they have a numeric modifier of zero.
    //but, they always have an inherent value of five. so give them that.
    //FIXME do other smithsness items
    if (it == $item[a light that never goes out] && modifier_lowercase == "item drop")
    {
    	if (it.equipped_amount() == 0)
     	   additional += 5;
    }
    return numeric_modifier(it, modifier_string) + additional;
}


static {
    skill [class][int] __skills_by_class;
    
    void initialiseSkillsByClass() {
        if (__skills_by_class.count() > 0) return;
        foreach s in $skills[] {
            if (s.class != $class[none]) {
                if (!(__skills_by_class contains s.class)) {
                    skill [int] blank;
                    __skills_by_class[s.class] = blank;
                }
                __skills_by_class[s.class].listAppend(s);
            }
        }
    }
    initialiseSkillsByClass();
}


static {
    boolean [skill] __libram_skills;
    
    void initialiseLibramSkills() {
        foreach s in $skills[] {
            if (s.libram)
                __libram_skills[s] = true;
        }
    }
    initialiseLibramSkills();
}


static {
    boolean [item] __items_that_craft_food;
    boolean [item] __minus_combat_equipment;
    boolean [item] __equipment;
    boolean [item] __items_in_outfits;
    boolean [string][item] __equipment_by_numeric_modifier;
    void initialiseItems() {
        foreach it in $items[] {
            //Crafting:
            string craft_type = it.craft_type();
            if (craft_type.contains_text("Cooking")) {
                foreach ingredient in it.get_ingredients_fast() {
                    __items_that_craft_food[ingredient] = true;
                }
            }
            
            //Equipment:
            if ($slots[hat,weapon,off-hand,back,shirt,pants,acc1,acc2,acc3,familiar] contains it.to_slot()) {
                __equipment[it] = true;
                if (it.numeric_modifier("combat rate") < 0) {
                    __minus_combat_equipment[it] = true;
                }
            }
        }
        foreach key, outfit_name in all_normal_outfits() {
            foreach key, it in outfit_pieces(outfit_name)
                __items_in_outfits[it] = true;
        }
    }
    initialiseItems();
}

boolean [item] equipmentWithNumericModifier(string modifier_string)
{
	modifier_string = modifier_string.to_lower_case();
    boolean [item] dynamic_items;
    dynamic_items[to_item("kremlin's greatest briefcase")] = true;
    dynamic_items[$item[your cowboy boots]] = true;
    dynamic_items[$item[a light that never goes out]] = true; //FIXME all smithsness items
    if (!(__equipment_by_numeric_modifier contains modifier_string))
    {
        //Build it:
        boolean [item] blank;
        __equipment_by_numeric_modifier[modifier_string] = blank;
        foreach it in __equipment
        {
            if (dynamic_items contains it) continue;
            if (it.numeric_modifier(modifier_string) != 0.0)
                __equipment_by_numeric_modifier[modifier_string][it] = true;
        }
    }
    //Certain equipment is dynamic. Inspect them dynamically:
    boolean [item] extra_results;
    foreach it in dynamic_items
    {
        if (it.numeric_modifier_replacement(modifier_string) != 0.0)
        {
            extra_results[it] = true;
        }
    }
    //damage + spell damage is basically the same for most things
    string secondary_modifier = "";
    foreach e in $elements[hot,cold,spooky,stench,sleaze]
    {
        if (modifier_string == e + " damage")
            secondary_modifier = e + " spell damage";
    }
    if (secondary_modifier != "")
    {
    	foreach it in equipmentWithNumericModifier(secondary_modifier)
        	extra_results[it] = true;
    }
    
    if (extra_results.count() == 0)
        return __equipment_by_numeric_modifier[modifier_string];
    else
    {
        //Add extras:
        foreach it in __equipment_by_numeric_modifier[modifier_string]
        {
            extra_results[it] = true;
        }
        return extra_results;
    }
}

static
{
    boolean [item] __beancannon_source_items = $items[Heimz Fortified Kidney Beans,Hellfire Spicy Beans,Mixed Garbanzos and Chickpeas,Pork 'n' Pork 'n' Pork 'n' Beans,Shrub's Premium Baked Beans,Tesla's Electroplated Beans,Frigid Northern Beans,Trader Olaf's Exotic Stinkbeans,World's Blackest-Eyed Peas];
}

static
{
    //This would be a good mafia proxy value. Feature request?
    boolean [skill] __combat_skills_that_are_spells;
    void initialiseCombatSkillsThatAreSpells()
    {
    	//Saucecicle,Surge of Icing are guesses
        foreach s in $skills[Awesome Balls of Fire,Bake,Blend,Blinding Flash,Boil,Candyblast,Cannelloni Cannon,Carbohydrate Cudgel,Chop,CLEESH,Conjure Relaxing Campfire,Creepy Lullaby,Curdle,Doubt Shackles,Eggsplosion,Fear Vapor,Fearful Fettucini,Freeze,Fry,Grease Lightning,Grill,Haggis Kick,Inappropriate Backrub,K&auml;seso&szlig;esturm,Mudbath,Noodles of Fire,Rage Flame,Raise Backup Dancer,Ravioli Shurikens,Salsaball,Saucegeyser,Saucemageddon,Saucestorm,Saucy Salve,Shrap,Slice,Snowclone,Spaghetti Spear,Stream of Sauce,Stringozzi Serpent,Stuffed Mortar Shell,Tear Wave,Toynado,Volcanometeor Showeruption,Wassail,Wave of Sauce,Weapon of the Pastalord,Saucecicle,Surge of Icing]
        {
            __combat_skills_that_are_spells[s] = true;
        }
        foreach s in $skills[Lavafava,Pungent Mung,Beanstorm] //FIXME cowcall? snakewhip?
            __combat_skills_that_are_spells[s] = true;
    }
    initialiseCombatSkillsThatAreSpells();
}

static
{
    location [item] __shen_items_to_locations = {
        $item[Murphy's Rancid Black Flag]:$location[The Castle in the Clouds in the Sky (Top Floor)],
        $item[The Stankara Stone]:$location[The Batrat and Ratbat Burrow],
        $item[The First Pizza]:$location[Lair of the Ninja Snowmen],
        $item[The Eye of the Stars]:$location[The Hole in the Sky],
        $item[The Lacrosse Stick of Lacoronado]:$location[The Smut Orc Logging Camp],
        $item[The Shield of Brook]:$location[The VERY Unquiet Garves]};
    
    item [int] [int] __shen_start_day_to_assignments = {
        //Shen's demands are seeded based on what day you're at when first meeting him.
        1:{1:$item[The Stankara Stone], 2:$item[The First Pizza], 3:$item[Murphy's Rancid Black Flag]},
        2:{1:$item[The Lacrosse Stick of Lacoronado], 2:$item[The Shield of Brook], 3:$item[The Eye of the Stars]},
        3:{1:$item[The First Pizza], 2:$item[The Stankara Stone], 3:$item[The Shield of Brook]},
        4:{1:$item[The Lacrosse Stick of Lacoronado], 2:$item[The Stankara Stone], 3:$item[The Shield of Brook]},
        5:{1:$item[Murphy's Rancid Black Flag], 2:$item[The Lacrosse Stick of Lacoronado], 3:$item[The Eye of the Stars]},
        6:{1:$item[Murphy's Rancid Black Flag], 2:$item[The Stankara Stone], 3:$item[The Eye of the Stars]},
        7:{1:$item[The Lacrosse Stick of Lacoronado], 2:$item[The Shield of Brook], 3:$item[The Eye of the Stars]},
        8:{1:$item[The Shield of Brook], 2:$item[Murphy's Rancid Black Flag], 3:$item[The Lacrosse Stick of Lacoronado]},
        9:{1:$item[The Shield of Brook], 2:$item[The Lacrosse Stick of Lacoronado], 3:$item[The Eye of the Stars]},
        10:{1:$item[The Eye of the Stars], 2:$item[The Stankara Stone], 3:$item[Murphy's Rancid Black Flag]},
        11:{1:$item[The First Pizza], 2:$item[The Stankara Stone], 3:$item[Murphy's Rancid Black Flag]}};

    item [int] __shen_exploathing_assignments = {1:$item[The Eye of the Stars], 2:$item[The Lacrosse Stick of Lacoronado], 3:$item[The First Pizza]};
    //tried to develop in case there's more paths with fixed assignments in the future, but gave up. Not worth it without knowing if it'll really happen and how they'll work.
}
location [int] shenAssignmentsJoinLocationsStartingAfter(item [int] assignments, int index) { //messy/ugly, but saves a lot of time
    location [int] destinations;

    //ignores the <index> first elements
    foreach position, assignment in assignments {
        if (position > index)
            destinations.listAppend(__shen_items_to_locations[assignment]);
    }
    return destinations;
}
location [int] shenAssignmentsJoinLocations(item [int] assignments) {
    return shenAssignmentsJoinLocationsStartingAfter(assignments, 0);
}
location [int] getFutureShenAssignments(int [string] level_11_state_ints) { //QuestState's haven't been set yet, so instead, pass the whole __quest_state["Level 11 Shen"].state_int to the function (this is sooooo stupid, I know, but still simpler than passing the two values every single call)
    item [int] assignments;
    if (my_path().id == PATH_KINGDOM_OF_EXPLOATHING)
        assignments = __shen_exploathing_assignments;
    else
        assignments = __shen_start_day_to_assignments[level_11_state_ints["Shen initiation day"]];
    
    //Will, by nature, only return something if you've talked to Shen at least once (unless in Exploathing)
    return assignments.shenAssignmentsJoinLocationsStartingAfter(level_11_state_ints["Shen meetings"]);
}

static
{
    boolean [monster] __snakes;
    void initialiseSnakes()
    {
        __snakes = $monsters[aggressive grass snake,Bacon snake,Batsnake,Black adder,Burning Snake of Fire,Coal snake,Diamondback rattler,Frontwinder,Frozen Solid Snake,King snake,Licorice snake,Mutant rattlesnake,Prince snake,Sewer snake with a sewer snake in it,Snakeleton,The Snake With Like Ten Heads,Tomb asp,Trouser Snake,Whitesnake];
    }
    initialiseSnakes();
}

item lookupAWOLOilForMonster(monster m)
{
    if (__snakes contains m)
        return $item[snake oil];
    else if ($phylums[beast,dude,hippy,humanoid,orc,pirate] contains m.phylum)
        return $item[skin oil];
    else if ($phylums[bug,construct,constellation,demon,elemental,elf,fish,goblin,hobo,horror,mer-kin,penguin,plant,slime,weird] contains m.phylum)
        return $item[unusual oil];
    else if ($phylums[undead] contains m.phylum)
        return $item[eldritch oil];
    return $item[none];
}

static
{
    boolean [item] __ns_tower_door_base_keys = $items[Boris\'s key,Jarlsberg\'s key,Sneaky Pete\'s key,Richard\'s star key,skeleton key,digital key];
}

static
{
    record Key {
        item it;
        location zone;
        string enchantment;
        string condition_for_unlock;
        string pre_unlock_url;
        boolean was_used;
    };

    Key [int] LKS_keys;
    if (my_path().id == PATH_LOW_KEY_SUMMER) {
        Key KeyMake(string name, location zone, string enchantment, string condition_for_unlock, string pre_unlock_url) {
            Key result;
            result.it = name.to_item();
            result.zone = zone;
            result.enchantment = enchantment;
            result.condition_for_unlock = condition_for_unlock;
            result.pre_unlock_url = pre_unlock_url;
            return result;
        }
        Key KeyMake(string name, location zone, string enchantment, string condition_for_unlock) {
            return KeyMake(name, zone, enchantment, condition_for_unlock, "");
        }
        Key KeyMake(string name, location zone, string enchantment) {
            return KeyMake(name, zone, enchantment, "", "");
        }
        void listAppend(Key [int] list, Key entry) {
            int position = list.count();
            while (list contains position)
                position += 1;
            list[position] = entry;
        }

        LKS_keys.listAppend(KeyMake("actual skeleton key", $location[The Skeleton Store], "+100 Damage Absorption, +10 Damage Reduction", "accepting the meathsmith\'s quest", "shop.php?whichshop=meatsmith"));
        LKS_keys.listAppend(KeyMake("anchovy can key", $location[The Haunted Pantry], "+100% Food Drops"));
        LKS_keys.listAppend(KeyMake("aqu&iacute;", $location[South of the Border], "+3 Hot Res, +15 Hot Damage, +30 Hot Spell Damage", "getting access to the desert beach"));
        LKS_keys.listAppend(KeyMake("batting cage key", $location[The Bat Hole Entrance], "+3 Stench Res, +15 Stench Damage, +30 Stench Spell Damage", "starting the boss bat quest"));
        LKS_keys.listAppend(KeyMake("black rose key", $location[The Haunted Conservatory], "+5 Familiar Weight, +2 Familiar Exp"));
        LKS_keys.listAppend(KeyMake("cactus key", $location[The Arid, Extra-Dry Desert], "Regen HP, Max HP +20", "reading the diary in the McGuffin quest"));
        LKS_keys.listAppend(KeyMake("clown car key", $location[The \"Fun\" House], "+10 Prismatic Damage, +10 ML", "doing the nemesis quest"));
        LKS_keys.listAppend(KeyMake("deep-fried key", $location[Madness Bakery], "+3 Sleaze Res, +15 Sleaze Damage, +30 Sleaze Spell Damage", "accepting the Armorer and Leggerer\'s quest", "shop.php?whichshop=armory"));
        LKS_keys.listAppend(KeyMake("demonic key", $location[Pandamonium Slums], "+20% Myst Gains, Myst +5, -1 MP Skills", "finishing the Friars quest"));
        LKS_keys.listAppend(KeyMake("discarded bike lock key", $location[The Overgrown Lot], "Max MP + 10, Regen MP", "accepting Doc Galaktik\'s quest", "shop.php?whichshop=doc"));
        LKS_keys.listAppend(KeyMake("f'c'le sh'c'le k'y", $location[The F\'c\'le], "+20 ML", "doing the pirate\'s quest"));
        LKS_keys.listAppend(KeyMake("ice key", $location[The Icy Peak], "+3 Cold Res, +15 Cold Damage, +30 Cold Spell Damage", "doing the trapper quest"));
        LKS_keys.listAppend(KeyMake("kekekey", $location[The Valley of Rof L\'m Fao], "+50% Meat", "finishing the chasm quest"));
        LKS_keys.listAppend(KeyMake("key sausage", $location[Cobb\'s Knob Kitchens], "-10% Combat", "doing the Cobb\'s Knob quest"));
        LKS_keys.listAppend(KeyMake("knob labinet key", $location[Cobb\'s Knob Laboratory], "+20% Muscle Gains, Muscle +5, -1 MP Skills", "finding the Cobb's Knob lab key during the Cobb\'s Knob quest"));
        LKS_keys.listAppend(KeyMake("knob shaft skate key", $location[The Knob Shaft], "Regen HP/MP, +3 Adventures", "finding the Cobb's Knob lab key during the Cobb\'s Knob quest"));
        LKS_keys.listAppend(KeyMake("knob treasury key", $location[Cobb\'s Knob Treasury], "+50% Meat, +20% Pickpocket", "doing the Cobb\'s Knob quest"));
        LKS_keys.listAppend(KeyMake("music Box Key", $location[The Haunted Nursery], "+10% Combat", "doing the Spookyraven quest"));
        LKS_keys.listAppend(KeyMake("peg key", $location[The Obligatory Pirate\'s Cove], "+5 Stats", "doing the pirate\'s quest"));
        LKS_keys.listAppend(KeyMake("rabbit\'s foot key", $location[The Dire Warren], "All Attributes +10"));
        LKS_keys.listAppend(KeyMake("scrap metal key", $location[The Old Landfill], "+20% Moxie Gains, Moxie +5, -1MP Skills", "starting the Old Landfill quest"));
        LKS_keys.listAppend(KeyMake("treasure chest key", $location[Belowdecks], "+30% Item, +30% Meat", "doing the pirate\'s quest"));
        LKS_keys.listAppend(KeyMake("weremoose key", $location[Cobb\'s Knob Menagerie, Level 2], "+3 Spooky Res, +15 Spooky Damage, +30 Spooky Spell Damage", "finding the  Cobb\'s Knob Menagerie key in the Cobb\'s Knob lab" + ($item[Cobb's Knob Menagerie key].available_amount() == 0 ? ", accessed by doing the Cobb\'s Knob quest" : "")));
    }
}

static
{
    monster [location] __protonic_monster_for_location {$location[Cobb\'s Knob Treasury]:$monster[The ghost of Ebenoozer Screege], $location[The Haunted Conservatory]:$monster[The ghost of Lord Montague Spookyraven], $location[The Haunted Gallery]:$monster[The ghost of Waldo the Carpathian], $location[The Haunted Kitchen]:$monster[The Icewoman], $location[The Haunted Wine Cellar]:$monster[The ghost of Jim Unfortunato], $location[The Icy Peak]:$monster[The ghost of Sam McGee], $location[Inside the Palindome]:$monster[Emily Koops, a spooky lime], $location[Madness Bakery]:$monster[the ghost of Monsieur Baguelle], $location[The Old Landfill]:$monster[The ghost of Vanillica "Trashblossom" Gorton], $location[The Overgrown Lot]:$monster[the ghost of Oily McBindle], $location[The Skeleton Store]:$monster[boneless blobghost], $location[The Smut Orc Logging Camp]:$monster[The ghost of Richard Cockingham], $location[The Spooky Forest]:$monster[The Headless Horseman]};
}


static
{
	boolean [monster][location] __monsters_natural_habitats;
}
boolean [location] getPossibleLocationsMonsterCanAppearInNaturally(monster m)
{
	if (__monsters_natural_habitats.count() == 0)
	{
		//initialise:
        foreach l in $locations[]
        {
        	foreach key, m in l.get_monsters()
            	__monsters_natural_habitats[m][l] = true;
        }
	}
	return __monsters_natural_habitats[m];
}
