// Setting a static converter of phyla to monsters for (mostly bad) reasons.

static
{
    string [phylum] __phylum_to_monster;
    // I am crazy for this one, dogg.
    __phylum_to_monster[$phylum[beast]]         = "__monster "+$monster[fluffy bunny].to_string().to_lower_case();
	__phylum_to_monster[$phylum[bug]]           = "__monster "+$monster[Spant soldier].to_string().to_lower_case();
	__phylum_to_monster[$phylum[constellation]] = "__monster "+$monster[Astrologer of Shub-Jigguwatt].to_string().to_lower_case();
	__phylum_to_monster[$phylum[construct]]     = "__monster "+$monster[Luggage-Handling Trainbot].to_string().to_lower_case();
	__phylum_to_monster[$phylum[demon]]         = "__monster "+$monster[W imp].to_string().to_lower_case();
	__phylum_to_monster[$phylum[dude]]          = "__monster "+$monster[dirty thieving brigand].to_string().to_lower_case();
	__phylum_to_monster[$phylum[elemental]]     = "__monster "+$monster[BASIC Elemental].to_string().to_lower_case();
	__phylum_to_monster[$phylum[elf]]           = "__monster "+$monster[wire-crossin' elf].to_string().to_lower_case();
	__phylum_to_monster[$phylum[fish]]          = "__monster "+$monster[sea cowboy].to_string().to_lower_case();
	__phylum_to_monster[$phylum[goblin]]        = "__monster "+$monster[Knob Goblin Very Mad Scientist].to_string().to_lower_case();
	__phylum_to_monster[$phylum[hippy]]         = "__monster "+$monster[Neil].to_string().to_lower_case();
	__phylum_to_monster[$phylum[humanoid]]      = "__monster "+$monster[yeti].to_string().to_lower_case();
	__phylum_to_monster[$phylum[horror]]        = "__monster "+$monster[Guy Made Of Bees].to_string().to_lower_case();
	__phylum_to_monster[$phylum[mer-kin]]       = "__monster "+$monster[Ringogeorge, the Bladeswitcher].to_string().to_lower_case();
	__phylum_to_monster[$phylum[orc]]           = "__monster "+$monster[Danglin' Chad].to_string().to_lower_case();
	__phylum_to_monster[$phylum[penguin]]       = "__monster "+$monster[Mob Penguin Arsonist].to_string().to_lower_case();
	__phylum_to_monster[$phylum[pirate]]        = "__monster "+$monster[grungy pirate].to_string().to_lower_case();
	__phylum_to_monster[$phylum[plant]]         = "__monster "+$monster[man-eating plant].to_string().to_lower_case();
	__phylum_to_monster[$phylum[slime]]         = "__monster "+$monster[fan slime].to_string().to_lower_case();
	__phylum_to_monster[$phylum[undead]]        = "__monster "+$monster[the ghost of Phil Bunion].to_string().to_lower_case();
	__phylum_to_monster[$phylum[weird]]         = "__monster "+$monster[loaf of Bread of Wonder].to_string().to_lower_case();
}

// In order to make the for loop a bit nicer, generate the string in a helper function.
string DescribeThisBanish(Banish b) {

    string banishedMon = b.banished_monster.to_string();
    string source = b.banish_source;
    int banishTurn = b.turn_banished;
    int banishLength = b.banish_turn_length;
    string banishLengthString = "";


    if (b.custom_reset_conditions == "rollover") {
        banishLength = 1234567;   
    }

    int turnsSinceBanish = my_turncount() - banishTurn;
    int turnsOfBanishLeft = banishLength - turnsSinceBanish;

    if (turnsOfBanishLeft < 0) {
        return "";
    }

    if (turnsOfBanishLeft >= 300) banishLengthString = " until rollover.";
    if (turnsOfBanishLeft <= 300) banishLengthString = ` for {pluralise(turnsOfBanishLeft,"more turn","more turns")}.`;

    string textReturn = "<b>"+banishedMon+"</b> is banished by "+source+banishLengthString;

    return textReturn;

}

// Due to the world being the way it is, need to enumerate this twice to handle both record types.
string DescribeThisBanish(BanishedPhylum b) {

    string banishedPhy = b.banished_phylum.to_string().to_upper_case();
    string source = b.banish_source;
    int banishTurn = b.turn_banished;
    int banishLength = b.banish_turn_length;
    string banishLengthString = "";


    if (b.custom_reset_conditions == "rollover") {
        banishLength = 1234567;   
    }

    int turnsSinceBanish = my_turncount() - banishTurn;
    int turnsOfBanishLeft = banishLength - turnsSinceBanish;

    if (turnsOfBanishLeft < 0) {
        return "";
    }

    if (turnsOfBanishLeft >= 300) banishLengthString = " until rollover.";
    if (turnsOfBanishLeft <= 300) banishLengthString = ` for {pluralise(turnsOfBanishLeft,"more turn","more turns")}!`;

    // If a new source is introduced, just add "by "+source" as in the above monster example. 

    string textReturn = "The entire <b>"+banishedPhy+"</b> phylum is banished"+banishLengthString;
    
    return textReturn;
    
}

// I think there are better ways to do this. However, I am tired. So, I'm instead doing... whatever the fuck this is, I guess.
RegisterResourceGenerationFunction("ActiveBanishesList");
void ActiveBanishesList(ChecklistEntry [int] resource_entries)
{
    // Read in the banisher preferences
    string banishedMonstersUnparsed = get_property("banishedMonsters");
    string banishedPhylumUnparsed = get_property("banishedPhyla");
    
    Banish [int] monsterResult;
    BanishedPhylum [int] phylaResult;

    // Banishes are in the format "thing:source:###" where # is turncount of banished. This splits it.    
    string [int] banishedMonstersParsed = banishedMonstersUnparsed.split_string(":");    
    string [int] banishedPhylumParsed = banishedPhylumUnparsed.split_string(":");

    // ... then this reads it.
    foreach key, parsedString in banishedMonstersParsed {
        if (parsedString.length() == 0)
            continue;        // This bypasses if there is no result.
        if (key % 3 != 0)
            continue;        // This bypasses when you aren't at a divisible-by-three key.

        // Populate a banish object by referencing the three relevant entries.
        Banish b;
        b.banished_monster = banishedMonstersParsed[key + 0].to_monster();
        b.banish_source = banishedMonstersParsed[key + 1];
        b.turn_banished = banishedMonstersParsed[key + 2].to_int();

        // Populate the turn length by referencing the source above.
        b.banish_turn_length = 0;
        if (__banish_source_length contains b.banish_source.to_lower_case())
            b.banish_turn_length = __banish_source_length[b.banish_source.to_lower_case()];
        if (b.banish_source == "batter up!" || b.banish_source == "deathchucks" || b.banish_source == "dirty stinkbomb" || b.banish_source == "nanorhino" || b.banish_source == "spooky music box mechanism" || b.banish_source == "ice hotel bell" || b.banish_source == "beancannon" || b.banish_source == "monkey slap")
            b.custom_reset_conditions = "rollover";
        if (b.banish_source == "ice house" && (!$item[ice house].is_unrestricted() || in_bad_moon())) //not relevant
            continue;
        monsterResult.listAppend(b);
    }

    // Now that you've addressed "normal" banishes, address the phylum banish.
    
    foreach key, parsedString in banishedPhylumParsed {
        if (parsedString.length() == 0)
            continue;        // This bypasses if there is no result
        if (key % 3 != 0)
            continue;        // This bypasses when you aren't at a divisible-by-three key.
        
        BanishedPhylum b;
        b.banished_phylum = banishedPhylumParsed[key + 0].to_phylum();
        b.banish_source = banishedPhylumParsed[key + 1];
        b.turn_banished = banishedPhylumParsed[key + 2].to_int();
        b.banish_turn_length = 0;
        if (__banish_source_length contains b.banish_source.to_lower_case())
            b.banish_turn_length = __banish_source_length[b.banish_source.to_lower_case()];

        phylaResult.listAppend(b);
    }
    
    // Now, make a resource entry for this whole thing
	ChecklistSubentry [int] subentries;
	string name;
	string description;
    string monsterIcon;
    string subtitle;
    string banishDescribed;
    int monsterCount = 0;

	if (phylaResult.length() > 0) {
		name = "Current Phyla Banished";

        int screechCharge = get_property_int("screechCombats");
        if (screechCharge == 0) subtitle = "can clear with your patriotic eagle";
        if (screechCharge > 0) subtitle = `spend {pluralise(screechCharge,"turn/run","turns/runs")} with your eagle to clear this banish`;
        
        foreach key, banish in phylaResult {
            banishDescribed = DescribeThisBanish(banish);
            if (banishDescribed != "") {
                description += "|*"+banishDescribed+"<hr>|*";
                monsterIcon = __phylum_to_monster[banish.banished_phylum];
            }
        }
		subentries.listAppend(ChecklistSubentryMake(name,subtitle,description+"|*<hr>"));
	}

	if (monsterResult.length() > 0) {
		
		name = "Current Monsters Banished";
        foreach key, banish in monsterResult {
            banishDescribed = DescribeThisBanish(banish);
            if (banishDescribed != "") {
                description += "|*"+banishDescribed+"|*";
                monsterIcon = "__monster "+banish.banished_monster.to_string().to_lower_case();
                monsterCount += 1;
            }
        }
        name += " ("+monsterCount+")";
		subentries.listAppend(ChecklistSubentryMake(name,"",description));

	}
	
	if (subentries.count() > 0) {

        // Want this atop resources for testing. Also, maybe just want it there period?
        int priority = -69; 
        ChecklistEntry entry = ChecklistEntryMake(monsterIcon, "", subentries, priority);
		entry.tags.id = "Active banishes";
        resource_entries.listAppend(entry);
	}
}