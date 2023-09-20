// Setting a static converter of phyla to monsters for (mostly bad) reasons.

static
{
    string [phylum] __phylum_to_monster;
    // This is my best attempt to associate a funny monster with each phylum. Some are better than others.
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

    int turnsOfBanishLeft = BanishTurnsLeft(b);

    if (source == "Bowl a Curveball") {
        turnsOfBanishLeft = get_property_int("cosmicBowlingBallReturnCombats");
    }

    if (source == "Roar like a Lion") {
        turnsOfBanishLeft = have_effect($effect[Hear Me Roar]);
    }

    if (turnsOfBanishLeft <= 0) {
        return "";
    }

    if (turnsOfBanishLeft >= 300) banishLengthString = " until rollover.";
    if (turnsOfBanishLeft <= 300) banishLengthString = ` for {pluralise(turnsOfBanishLeft,"more turn","more turns")}.`;
    if (source == "ice house") banishLengthString = " forever.";

    string textReturn = "<b>"+banishedMon+"</b>, via "+source+banishLengthString+"<hr>|*";

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
    
    Banish [int] monsterResult = BanishesActive();
    BanishedPhylum [int] phylaResult;

    // Save the banished monsters to compare later for snapper/eagle checks, with snapper phylum.
    monster [int] banishedMonsterList;
    phylum snapperPhylum = get_property("redSnapperPhylum").to_phylum();

    // Banishes are in the format "thing:source:###" where # is turncount of banished. This splits it.    
    string [int] banishedMonstersParsed = banishedMonstersUnparsed.split_string(":");    
    string [int] banishedPhylumParsed = banishedPhylumUnparsed.split_string(":");

    // ... then this reads it.
    foreach key, banish in monsterResult {
        // Add the banished monster to the banishedMonsterList
        banishedMonsterList.listAppend(banish.banished_monster);
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
    string phylaSubtitle;
    string monsterSubtitle;
    string monsterSymbol; // 🠞 for normal monster, 🞮 for un-banished monster
    string banishDescribed;
    phylum phylumBanished = $phylum[none];
    int monsterCount = 0;

	if (phylaResult.count() > 0) {
		name = "Current Phyla Banished";

        int screechCharge = get_property_int("screechCombats");
        if (screechCharge == 0) phylaSubtitle = "can clear with your patriotic eagle";
        if (screechCharge > 0) phylaSubtitle = `spend {pluralise(screechCharge,"turn/run","turns/runs")} with your eagle to cast screech again`;
        
        foreach key, banish in phylaResult {
            banishDescribed = DescribeThisBanish(banish);
            if (banishDescribed != "") {
                description += "|*"+banishDescribed+"<hr>|*";
                monsterIcon = __phylum_to_monster[banish.banished_phylum];
                phylumBanished = banish.banished_phylum;
            }
        }
		subentries.listAppend(ChecklistSubentryMake(name,phylaSubtitle,description));
	}

	if (monsterResult.length() > 0) {
        description = "";
        monsterSubtitle = "";

        // If your snapper is active, show the snapper phylum.
        phylum snapperTarget = my_familiar() == lookupFamiliar("Red Nosed Snapper") ? get_property("redSnapperPhylum").to_phylum() : $phylum[none];

        if (snapperTarget != $phylum[none]) {
            monsterSubtitle = `your snapper is un-banishing {snapperTarget.to_string()} targets, marked with <span style="color:red;font-size:0.8em">🞮</span>`;
        }
		
        foreach key, banish in monsterResult {
            banishDescribed = DescribeThisBanish(banish);
            monsterSymbol = "🠞 ";
            if (banishDescribed != "") {
                // add an icon for snapper unbanishing the monster
                if (banish.banished_monster.phylum == snapperTarget) {
                    monsterSymbol = `<span style="color:red;font-size:0.8em">🞮 </span>`;
                }
                description += "|*"+monsterSymbol+banishDescribed;
                monsterIcon = "__monster "+banish.banished_monster.to_string().to_lower_case();
                monsterCount += 1;
            }
        }
        name = `{pluralise(monsterCount,"monster banished", "monsters banished")}`;
		subentries.listAppend(ChecklistSubentryMake(name,monsterSubtitle,description));

	}
	
	if (subentries.count() > 0) {

        // Want this atop resources for testing. Also, maybe just want it there period?
        int priority = -69; 
        ChecklistEntry entry = ChecklistEntryMake(monsterIcon, "", subentries, priority);
		entry.tags.id = "Active banishes";
        resource_entries.listAppend(entry);
	}
}