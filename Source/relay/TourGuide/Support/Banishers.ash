
import "relay/TourGuide/Support/Library.ash"

Record Banish
{
    monster banished_monster;
    string banish_source;
    int turn_banished;
    int banish_turn_length;
    string custom_reset_conditions;
};

Record BanishedPhylum
{
    monster banished_phylum;
    string banish_source;
    int turn_banished;
    int banish_turn_length;
    string custom_reset_conditions;
};

void listAppend(Banish [int] list, Banish entry)
{
    int position = list.count();
    while (list contains position)
        position += 1;
    list[position] = entry;
}

// It is annoying that I have to re-add this for the new record lol
void listAppend(BanishedPhylum [int] list, BanishedPhylum entry)
{
    int position = list.count();
    while (list contains position)
        position += 1;
    list[position] = entry;
}

int BanishTurnsLeft(Banish b)
{
    if (b.banish_turn_length == -1)
        return 2147483647;
    return b.turn_banished + b.banish_turn_length - my_turncount();
}

static
{
    int [string] __banish_source_length;
    //FIXME request this be exposed in ASH?
    //all of these must be lowercase. because.
    __banish_source_length["banishing shout"] = -1;
    __banish_source_length["batter up!"] = -1;
    __banish_source_length["chatterboxing"] = 20;
    __banish_source_length["classy monkey"] = 20;
    __banish_source_length["cocktail napkin"] = 20;
    __banish_source_length["crystal skull"] = 20;
    __banish_source_length["deathchucks"] = -1;
    __banish_source_length["dirty stinkbomb"] = -1;
    __banish_source_length["divine champagne popper"] = 5;
    __banish_source_length["harold's bell"] = 20;
    __banish_source_length["howl of the alpha"] = -1;
    __banish_source_length["ice house"] = -1;
    __banish_source_length["louder than bomb"] = 20;
    __banish_source_length["nanorhino"] = -1;
    __banish_source_length["pantsgiving"] = 30;
    __banish_source_length["peel out"] = -1;
    __banish_source_length["pulled indigo taffy"] = 40;
    __banish_source_length["smoke grenade"] = 20;
    __banish_source_length["spooky music box mechanism"] = -1;
    __banish_source_length["staff of the standalone cheese"] = -1;
    __banish_source_length["stinky cheese eye"] = 10;
    __banish_source_length["thunder clap"] = 40;
    __banish_source_length["v for vivala mask"] = 10;
    __banish_source_length["replica v for vivala mask"] = 10;
    __banish_source_length["walk away from explosion"] = 30;
    __banish_source_length["tennis ball"] = 30;
    __banish_source_length["curse of vacation"] = -1;
    __banish_source_length["ice hotel bell"] = -1;
    __banish_source_length["bundle of &quot;fragrant&quot; herbs"] = -1;
    __banish_source_length["snokebomb"] = 30;
    __banish_source_length["beancannon"] = -1;
    __banish_source_length["licorice rope"] = -1;
    __banish_source_length["kgb tranquilizer dart"] = 20;
    __banish_source_length["breathe out"] = 20; // is it listed as hot jelly, breathe out or space jellyfish ?
    __banish_source_length["daily affirmation: be a mind master"] = 80; // how long does it last, exactly? is it still unknown?
    __banish_source_length["spring-loaded front bumper"] = 30;
    __banish_source_length["mafia middle finger ring"] = 60;
    __banish_source_length["throw latte on opponent"] = 30;
    __banish_source_length["tryptophan dart"] = -1;
    __banish_source_length["baleful howl"] = -1;
    __banish_source_length["reflex hammer"] = 30;
    __banish_source_length["saber force"] = 30;
    __banish_source_length["human musk"] = -1;
    __banish_source_length["ultra smash"] = -1; // is it the right name?
    __banish_source_length["b. l. a. r. t. spray (wide)"] = -1;
	__banish_source_length["system sweep"] = -1;
	__banish_source_length["feel hatred"] = 50;
	__banish_source_length["show your boring familiar pictures"] = 100;
	__banish_source_length["patriotic screech"] = 100;
    
    int [string] __banish_simultaneous_limit;
    __banish_simultaneous_limit["beancannon"] = 5;
    __banish_simultaneous_limit["banishing shout"] = 3;
    __banish_simultaneous_limit["howl of the alpha"] = 3;
    __banish_simultaneous_limit["staff of the standalone cheese"] = 5;
}

Banish [int] __banishes_active_cache;
string __banishes_active_cache_cached_monsters_string;

Banish [int] BanishesActive()
{
    //banishedMonsters(user, now 'a.m.c. gremlin:ice house:2890', default )
    
    string banished_monsters_string = get_property("banishedMonsters");
    
    if (banished_monsters_string == __banishes_active_cache_cached_monsters_string && __banishes_active_cache_cached_monsters_string != "")
        return __banishes_active_cache;
    
    __banishes_active_cache_cached_monsters_string = ""; //invalidate the cache
    
    Banish [int] result;
    
    string [int] banished_monsters_string_split = banished_monsters_string.split_string(":");

    foreach key, s in banished_monsters_string_split {
        if (s.length() == 0)
            continue;
        if (key % 3 != 0)
            continue;
        //string [int] entry = s.split_string(":");
        
        //if (entry.count() != 3)
            //continue;
        if (!(banished_monsters_string_split contains (key + 1)) || !(banished_monsters_string_split contains (key + 2)))
            continue;
        
        Banish b;
        b.banished_monster = banished_monsters_string_split[key + 0].to_monster();
        b.banish_source = banished_monsters_string_split[key + 1];
        b.turn_banished = banished_monsters_string_split[key + 2].to_int();
        b.banish_turn_length = 0;
        if (__banish_source_length contains b.banish_source.to_lower_case())
            b.banish_turn_length = __banish_source_length[b.banish_source.to_lower_case()];
        if (b.banish_source == "batter up!" || b.banish_source == "deathchucks" || b.banish_source == "dirty stinkbomb" || b.banish_source == "nanorhino" || b.banish_source == "spooky music box mechanism" || b.banish_source == "ice hotel bell" || b.banish_source == "beancannon" || b.banish_source == "monkey slap")
            b.custom_reset_conditions = "rollover";
        if (b.banish_source == "ice house" && (!$item[ice house].is_unrestricted() || in_bad_moon())) //not relevant
            continue;
        result.listAppend(b);
    }
    
    __banishes_active_cache_cached_monsters_string = banished_monsters_string;
    __banishes_active_cache = result;
    
    return result;
}


Banish [int] BanishesActiveInLocation(location l)
{
    boolean [monster] location_monsters;
    foreach key, m in l.get_monsters()
        location_monsters[m] = true;
    Banish [int] banishes_active = BanishesActive();
    Banish [int] result;
    foreach key, b in banishes_active {
        if (location_monsters contains b.banished_monster)
            result.listAppend(b);
    }
    return result;
}

int BanishShortestBanishForLocation(location l)
{
    Banish [int] active_banishes = BanishesActiveInLocation(l);
    int minimum = 2147483647;
    foreach key, b in active_banishes {
        minimum = MIN(minimum, b.BanishTurnsLeft());
    }
    return minimum;
}

Banish BanishForMonster(monster m)
{
    foreach key, b in BanishesActive() {
        if (b.banished_monster == m)
            return b;
    }
    Banish blank;
    return blank;
}

string BanishSourceForMonster(monster m)
{
    return BanishForMonster(m).banish_source;
}

int [string] activeBanishNameCountsForLocation(location l)
{
    Banish [int] banishes_active = BanishesActive();
    
    string [monster] names;
    foreach key, banish in banishes_active {
        if (banish.banished_monster.is_banished()) { //zuko wrote this code
            names[banish.banished_monster] = banish.banish_source;
        }
    }
    
    int [string] banish_name_counts;
    foreach key, m in l.get_monsters() {
        if (names contains m)
            banish_name_counts[names[m]] += 1;
        if (my_path().id == PATH_ONE_CRAZY_RANDOM_SUMMER) {
            foreach m2 in names {
                if (m2.to_string().to_lower_case().contains_text(m.to_string().to_lower_case())) //FIXME complete hack, wrong, substrings, 1337, etc
                    banish_name_counts[names[m2]] += 1;
            }
        }
    }
    return banish_name_counts;
}

boolean [string] activeBanishNamesForLocation(location l)
{
    boolean [string] result;
    
    foreach banish_name, count in l.activeBanishNameCountsForLocation()
        result[banish_name] = (count > 0);
    return result;
}

Banish BanishByName(string name)
{
    foreach key, banish in BanishesActive() {
        if (banish.banish_source == name)
            return banish;
    }
    Banish blank;
    return blank;
}

int BanishLength(string banish_name)
{
    int length = __banish_source_length[banish_name.to_lower_case()];
    if (length < 0)
        length = 2147483647;
    return length;
}

boolean BanishIsActive(string name)
{
    foreach key, banish in BanishesActive() {
        if (banish.banish_source == name)
            return true;
    }
    return false;
}

// ========================================================================
// All code below this line is crappy code written by Scotch. Sorry Ezan.
// ========================================================================

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
	__phylum_to_monster[$phylum[horror]]        = "__monster "+$monster[The Guy Made Of Bees].to_string().to_lower_case();
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
    int turnsOfBanishLeft = turnsSinceBanish - banishLength;

    if (turnsOfBanishLeft < 0) {
        return "";
    }

    if (turnsOfBanishLeft >= 300) banishLengthString = " until rollover.";
    if (turnsOfBanishLeft <= 300) banishLengthString = ` for {pluralise(turnsOfBanishLeft,"more turn","more turns")}.`;

    string textReturn = "<b>"+banishedMon+"</b> is banished by "+source+banishLengthString;

    return textReturn;

}

string DescribeThisBanish(BanishedPhylum b) {

    phylum banishedPhy = b.banished_phylum.to_string();
    string source = b.banish_source;
    int banishTurn = b.turn_banished;
    int banishLength = b.banish_turn_length;
    string banishLengthString = "";


    if (b.custom_reset_conditions == "rollover") {
        banishLength = 1234567;   
    }

    int turnsSinceBanish = my_turncount() - banishTurn;
    int turnsOfBanishLeft = turnsSinceBanish - banishLength;

    if (turnsOfBanishLeft < 0) {
        return "";
    }

    if (turnsOfBanishLeft >= 300) banishLengthString = " until rollover.";
    if (turnsOfBanishLeft <= 300) banishLengthString = ` for {pluralise(turnsOfBanishLeft,"more turn","more turns")}.`;

    string textReturn = "<b>"+banishedPhy+"</b> is banished by "+source+banishLengthString;
    
    return textReturn;
    
}

// I think there are better ways to do this. However, I am tired. So, I'm not doing that.

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
    
    foreach key, parsedString in banishedMonstersParsed {
        if (parsedString.length() == 0)
            continue;        // This bypasses if there is no result; don't need the key thing right now, as only one source exists.
        
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
        if (screechCharge > 0) subtitle = `spend {pluralise(screechCharge),"turn/run","turns/runs"} with your eagle to clear this banish`;
        
        foreach key, banish in phylaResult {
            if (banishDescribed != "") {
                description += "|*"+DescribeThisBanish(banish)+"<hr>|*";
                monsterIcon = __phylum_to_monster[banish.banished_phylum];
            }
        }
		subentries.listAppend(ChecklistSubentryMake(name,subtitle,description));
	}

	if (monsterResult.length() > 0) {
		
		name = "Current Monsters Banished";
        foreach key, banish in monsterResult {
            if (banishDescribed != "") {
                description += "|*"+DescribeThisBanish(banish)+"<hr>|*";
                monsterIcon = "__monster "+banish.banished_monster.to_string().to_lower_case();
                monsterCount += 1;
            }
        }
        name += "("+monsterCount+")";
		subentries.listAppend(ChecklistSubentryMake(name,subtitle,description));

	}
	
	if (subentries.count() > 0) {

        // want this atop resources for testing 
        int priority = -69; 
        ChecklistEntry entry = ChecklistEntryMake(monsterIcon, "", subentries, priority);
		entry.tags.id = "Active banishes";
        resource_entries.listAppend(entry);
	}
}