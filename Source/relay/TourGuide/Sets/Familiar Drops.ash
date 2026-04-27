// ===============================================================
// This is a big ol' megatile meant to replace & expand on the crown of thrones 
//   "normal fam drops" tile. The primary goal is to abstract all familiar drops 
//   into a combo tile that correctly describes:

//     - progress on how many drops you are from the fam's limit
//     - % chance of next drop, if applicable
//     - exact turns til next drop, if applicable

// Eventually I will probably remove many of the tinier fam tiles in favor of 
//   this combo tile (like peace turkey)
// ===============================================================

// ===============================================================
// ---------- EXACT DROP TURN CALCULATIONS (dropType == "precise int turn")
// ===============================================================
int bootsTurns;
if (get_property_boolean("bootsCharged")) bootsTurns = 0;
else if ($familiar[Stomping Boots].fights_today < 3) bootsTurns = clampi(3 - $familiar[Stomping Boots].fights_today,1,3);
else if ($familiar[Stomping Boots].fights_today < 7) bootsTurns = clampi(7 - $familiar[Stomping Boots].fights_today,1,4);
else if ($familiar[Stomping Boots].fights_today < 12) bootsTurns = clampi(12 - $familiar[Stomping Boots].fights_today,1,5);
else if ($familiar[Stomping Boots].fights_today < 18) bootsTurns = clampi(18 - $familiar[Stomping Boots].fights_today,1,6);
else if ($familiar[Stomping Boots].fights_today < 25) bootsTurns = clampi(25 - $familiar[Stomping Boots].fights_today,1,7);
else if ($familiar[Stomping Boots].fights_today < 33) bootsTurns = clampi(33 - $familiar[Stomping Boots].fights_today,1,8);
else if ($familiar[Stomping Boots].fights_today < 42) bootsTurns = clampi(42 - $familiar[Stomping Boots].fights_today,1,9);

int sheepTurns = $familiar[Hobo in Sheep's Clothing].fights_today;
if (sheepTurns < 11) sheepTurns = 10 - sheepTurns;
else if (sheepTurns < 31) sheepTurns = 30 - sheepTurns;
else if (sheepTurns < 61) sheepTurns = 60 - sheepTurns;
else if (sheepTurns < 101) sheepTurns = 100 - sheepTurns;
else if (sheepTurns < 151) sheepTurns = 150 - sheepTurns;
else if (sheepTurns > 150) sheepTurns = 999; // not technically true but i don't want to enumerate more

int [familiar] dropTurnsLeft;
dropTurnsLeft[$familiar[Stomping Boots]] = bootsTurns;
dropTurnsLeft[$familiar[Rockin' Robin]] = 30 - get_property_int("rockinRobinProgress"); 
dropTurnsLeft[$familiar[Optimistic Candle]] = 30 - get_property_int("optimisticCandleProgress");
dropTurnsLeft[$familiar[Garbage Fire]] = 30 - get_property_int("garbageFireProgress");
dropTurnsLeft[$familiar[Cookbookbat]] = 11 - get_property_int("cookbookbatIngredientsCharge");
dropTurnsLeft[$familiar[Hobo in Sheep's Clothing]] = sheepTurns;

// ===============================================================
// ---------- FLOAT DROP TURN CALCULATION (dropType == "approx float turn")
// ===============================================================

float[int] puckTurnLookup = {10:3.9,11:3.3,12:2.8,13:2.3,14:1.9,15:1.6,16:1.4,17:1.2,18:1,19:1};

float pucksTurns;
if (get_property_int("powerPillProgress") < 10) pucksTurns = to_float(10 - get_property_int("powerPillProgress"))+3.9;
if (get_property_int("powerPillProgress") > 9) pucksTurns = puckTurnLookup[get_property_int("powerPillProgress")];

float [familiar] dropApproxTurnsLeft;
dropApproxTurnsLeft[$familiar[puck man]] = pucksTurns;
dropApproxTurnsLeft[$familiar[ms. puck man]] = pucksTurns;

// ===============================================================
// ---------- PERCENT DROP ARRAYS (dropType == "percent")
// ===============================================================
// Important note: these don't include the "5% per turn without a drop" increase for the oldies.
//   That isn't currently trackable via mafia, though. These are referenced for dropType == "percent"

float [familiar][int] dropPercentArrays;
dropPercentArrays[$familiar[Green Pixie]] = {1:20.0, 2:15.0, 3:10.0, 4:5.0, 5:5.0, 6:0.0};
dropPercentArrays[$familiar[Baby Sandworm]] = {1:20.0, 2:15.0, 3:10.0, 4:5.0, 5:5.0, 6:0.0};
dropPercentArrays[$familiar[Astral Badger]] = {1:25.0, 2:20.0, 3:15.0, 4:10.0, 5:5.0, 6:0.0};
dropPercentArrays[$familiar[Blavious Kloop]] = {1:25.0, 2:20.0, 3:15.0, 4:10.0, 5:5.0, 6:0.0};
dropPercentArrays[$familiar[Llama lama]] = {1:20.0, 2:15.0, 3:10.0, 4:5.0, 5:5.0, 6:0.0};
dropPercentArrays[$familiar[Bloovian Groose]] = {1:25.0, 2:20.0, 3:15.0, 4:10.0, 5:5.0, 6:0.0};
dropPercentArrays[$familiar[Rogue Program]] = {1:25.0, 2:20.0, 3:15.0, 4:10.0, 5:5.0, 6:0.0};
dropPercentArrays[$familiar[Li'l Xenomorph]] = {1:25.0, 2:20.0, 3:15.0, 4:10.0, 5:5.0, 6:0.0};
dropPercentArrays[$familiar[Unconscious Collective]] = {1:25.0, 2:20.0, 3:15.0, 4:10.0, 5:5.0, 6:0.0};
dropPercentArrays[$familiar[Grim Brother]] = {1:25.0, 2:20.0, 3:15.0, 4:10.0, 5:5.0, 6:0.0}; // guess, not on wiki & i don't have one
dropPercentArrays[$familiar[Galloping Grill]] = {1:8.0, 2:8.0, 3:8.0, 4:8.0, 5:8.0, 6:0.0}; // guess, not on wiki & i don't have one
dropPercentArrays[$familiar[Fist Turkey]] = {1:8.0, 2:8.0, 3:8.0, 4:8.0, 5:8.0, 6:0.0}; // guess, not on wiki & i don't have one
dropPercentArrays[$familiar[Golden Monkey]] = {1:25.0, 2:20.0, 3:15.0, 4:10.0, 5:5.0, 6:0.0}; // guess, not on wiki & i don't have one
dropPercentArrays[$familiar[Adventurous Spelunker]] = {1:15.0, 2:0.0};
dropPercentArrays[$familiar[Miniature Sword & Martini Guy]] = {1:30.0, 2:25.0, 3:20.0, 4:15.0, 5:10.0, 6:5.0, 7:0.0};
dropPercentArrays[$familiar[Machine Elf]] = {1:10.0, 2:0.0}; // guess-ish, this looks right
dropPercentArrays[$familiar[Jill-of-All-Trades]] = {1:35.0, 2:2.0, 3:0.1, 4:0.0} //technically, last is 0.0043% but mehhhh

// ===============================================================
// ---------- PERCENT DROP CALCULATIONS (dropType == "percent calc")
// ===============================================================

float kiwiWeight = effective_familiar_weight($familiar[Mini Kiwi]) + weight_adjustment();
float kiwiModifier = $item[aviator goggles].available_amount() > 0 ? 0.75 : 0.50;
float kiwiChance = min(kiwiWeight * kiwiModifier,100.0);

// These are familiars where you are just exporting a conditional probability.
float [familiar] dropPercentCalc;
dropPercentCalc[$familiar[mini kiwi]] = kiwiChance;
dropPercentCalc[$familiar[Skeleton of Crimbo Past]] = -100.0; //no good way to do this so just overriding in tile builder
dropPercentCalc[$familiar[Peace Turkey]] = clampf(24.0 + square_root(effective_familiar_weight($familiar[peace turkey]) + weight_adjustment()), 0.0, 100.0);

// ===============================================================
// ---------- TURNS TO DROP ARRAYS (dropType == "turn")
// ===============================================================

// These familiars drop their goodies after a certain amount of turns spent with the fam
int [familiar][int] dropTurnArrays;
dropTurnArrays[$familiar[Angry Jung Man]] = {1:30, 2:0};
dropTurnArrays[$familiar[Grimstone Golem]] = {1:45, 2:0};


record FamDrop {
    familiar fam; // familiar that drops a thing
    item drop; // item dropped by the familiar
    string dropText; // a shortened string
    string prop; // prop used to get dropsdropped
    int limit; // max drops per day
    string dropType; // valid values: "percent", "turn", "approx float turn", "precise int turn", "percent calc"
    boolean haveFam; // does user have this fam
    boolean activeFam; // is this fam equipped
    int currDrops; // how many drops have dropped
    float dropFloat; // valid outputs: % chance, approx float turn, % calculated
    int dropInt; // valid outputs: turns 
};

void generateFamDrop(string fam, string drop, string dropsmall, string prop, int limit, string dropType) {
    FamDrop out;

    // initialize things
    out.fam = lookupFamiliar(fam);
    out.drop = $item[none];
    out.dropText = dropsmall;
    out.prop = prop;
    out.limit = limit;
    out.dropType = dropType;
    out.dropFloat = 0.0;
    out.dropInt = 0;

    out.haveFam = out.fam.have_familiar();
    // if (!out.haveFam) return out; // exit if you don't have fam
    if (drop != "") out.drop = lookupItem(drop);

    out.activeFam = my_familiar() == thisFam;

    if (prop != "") out.currDrops = get_property_int(prop);
    if (prop == "") return out;

    // valid values: "percent", "turn", "approx float turn", "precise int turn", "percent calc"
    if (dropType == "percent") out.dropFloat = grabClampedFloat(currentDrops+1, dropPercentArrays[thisFam]);
    if (dropType == "approx float turn") out.dropFloat = dropApproxTurnsLeft[thisFam];
    if (dropType == "turn") out.dropInt = grabClampedInt(currentDrops+1, dropTurnArrays[thisFam]);
    if (dropType == "precise int turn") out.dropInt = dropTurnsLeft[thisFam];
    if (dropType == "percent calc") out.dropFloat = dropPercentCalc[thisFam];

    return out;
}

FamDrop [int] __fam_drops;
// format ===========> generateFamDrop(string fam, string drop, string dropsmall, string prop, int limit, string dropType)
__fam_drops.listAppend(generateFamDrop("Green Pixie", "tiny bottle of absinthe", "absinthe bottles", "_absintheDrops", 5, "percent"));
__fam_drops.listAppend(generateFamDrop("Baby Sandworm", "agua de vida", "agua bottles", "_aguaDrops", 5, "percent"));
__fam_drops.listAppend(generateFamDrop("Astral Badger", "astral mushroom", "astral shrooms", "_astralDrops", 5, "percent"));
__fam_drops.listAppend(generateFamDrop("Blavious Kloop", "devilish folio", "folios", "_kloopDrops", 5, "percent"));
__fam_drops.listAppend(generateFamDrop("Llama Lama", "llama lama gong", "gongs", "_gongDrops", 5, "percent"));
__fam_drops.listAppend(generateFamDrop("Bloovian Groose", "groose grease", "greases", "_grooseDrops", 5, "percent"));
__fam_drops.listAppend(generateFamDrop("Rogue Program", "game grid token", "tokens", "_tokenDrops", 5, "percent"));
__fam_drops.listAppend(generateFamDrop("Li'l Xenomorph","transporter transponder","transponders","_transponderDrops",5, "percent"));
__fam_drops.listAppend(generateFamDrop("Unconscious Collective","Unconscious Collective dream jar","dream jars","_dreamJarDrops",5, "percent"));
__fam_drops.listAppend(generateFamDrop("Angry Jung Man","psychoanalytic jar","psycho jar","_jungDrops",1, "turn"));
__fam_drops.listAppend(generateFamDrop("Grim Brother","grim fairy tale","fairy tales","_grimFairyTaleDrops",5, "percent"));
__fam_drops.listAppend(generateFamDrop("Grimstone Golem","grimstone mask","grim mask","_grimstoneMaskDrops",1, "turn"));
__fam_drops.listAppend(generateFamDrop("Galloping Grill", "hot ashes", "hot ashes", "_hotAshesDrops", 5, "percent"));
__fam_drops.listAppend(generateFamDrop("Fist Turkey", (my_level() < 5 ? "friendly turkey" : (my_level() < 7 ? "agitated turkey" : "ambitious turkey")), "turkey boozes", "_turkeyBooze", 5, "percent"));
__fam_drops.listAppend(generateFamDrop("Golden Monkey","powdered gold","powdered golds","_powderedGoldDrops",5, "percent"));
__fam_drops.listAppend(generateFamDrop("Adventurous Spelunker","tales of spelunking","tales","_spelunkingTalesDrops",1, "percent"));
// __fam_drops.listAppend(generateFamDrop("Cotton Candy Carnie", -1, "cotton candy", "_carnieCandyDrops", 10, "percent")); // not including, pretty useless
__fam_drops.listAppend(generateFamDrop("Stomping Boots","","paste","_bootStomps",7,"precise int turn"));
__fam_drops.listAppend(generateFamDrop("Puck Man","power pill","power pills","_powerPillDrops", MIN(11, my_daycount() + 1), "approx float turn"));
__fam_drops.listAppend(generateFamDrop("Ms. Puck Man","power pill","power pills","_powerPillDrops", MIN(11, my_daycount() + 1), "approx float turn"));
__fam_drops.listAppend(generateFamDrop("Miniature Sword & Martini Guy","mini-martini","mini-martinis","_miniMartiniDrops",6, "percent"));
__fam_drops.listAppend(generateFamDrop("Machine Elf","Deep Machine Tunnels snowglobe","snowglobe","_snowglobeDrops",1,"percent"));
__fam_drops.listAppend(generateFamDrop("Rockin' Robin", "robin's egg", "robin's egg", "_robinEggDrops", -1, "precise int turn"));
__fam_drops.listAppend(generateFamDrop("Optimistic Candle", "wax glob", "wax glob", "_waxGlobDrops", -1, "precise int turn"));
__fam_drops.listAppend(generateFamDrop("Garbage Fire", "burning newspaper", "burning item", "_garbageFireDrops", -1, "precise int turn"));
__fam_drops.listAppend(generateFamDrop("Cookbookbat", "yeast of boris", "cookbookbat ingredient", "_cookbookbatRecipeDrops", -1, "precise int turn"));
__fam_drops.listAppend(generateFamDrop("Hobo in Sheep's Clothing","grubby wool","grubby wools","_grubbyWoolDrops",5, "precise int turn")); // technically unlimited but setting at limit 5 bc nobody should get >5
__fam_drops.listAppend(generateFamDrop("Jill-of-All-Trades","map to a candy-rich block","candy block map","_mapToACandyRichBlockDrops",-1,"percent"));
__fam_drops.listAppend(generateFamDrop("Mini Kiwi", "mini kiwi", "mini kiwi", "_miniKiwiDrops", -1, "percent calc"));
__fam_drops.listAppend(generateFamDrop("Peace Turkey","whirled peas","pea boon","_knuckleboneDrops", -1, "percent calc"));
__fam_drops.listAppend(generateFamDrop("Skeleton of Crimbo Past","knucklebone","knucklebone","_knuckleboneDrops",100, "percent calc"));

// TODO: this includes almost all drop familiars. it's missing a small handful: 
//   - xo skeleton (xs & os; xoSkeleltonOProgress & xoSkeleltonXProgress)
//   - mechanical songbird (mechanicalSongbirdProgress)
//   - cubeling (cubelingProgress)
//   - space jellyfish (_spaceJellyfishDrops)
// 

record FamDrop {
    familiar fam; // familiar that drops a thing
    item drop; // item dropped by the familiar
    string dropText; // a shortened string
    string prop; // prop used to get dropsdropped
    int limit; // max drops per day
    string dropType; // valid values: "percent", "turn", "approx float turn", "precise int turn", "percent calc"
    boolean haveFam; // does user have this fam
    boolean activeFam; // is this fam equipped
    int currDrops; // how many drops have dropped
    float dropFloat; // valid outputs: % chance, approx float turn, % calculated
    int dropInt; // valid outputs: turns 
};

string [string] dropFamTile(FamDrop currFamDrop) {
    // Generate empty starting output
    string [string] output;
    output["title"] = "";
    output["subtitle"] = "";
    output["desc"] = "";
    output["limitLine"] = "";

    string limitString = "";
    if (currFamDrop.limit > 0) {
        limitString = "("currFamDrop.currDrops+"/"+currFamDrop.limit+")";
    }


    // Generate a limited line and return
    if (currFamDrop.dropFloat == 0.0 && currFamDrop.dropInt == 0 && currFamDrop.limit > 0) {
        output["limitLine"] = to_string(currFamDrop.fam)+": "+currFamDrop.limit+"/"+currFamDrop.limit+" "+currFamDrop.dropText;
        return output;
    }

    string famText = to_string(currFamDrop.fam);
    if (currFamDrop.activeFam) famText = HTMLGenerateSpanFont(to_string(currFamDrop.fam),"blue");


    string textNumber = "";
    if (dropType == "percent") {
        textNumber = to_string(roundFloat(currFamDrop.dropFloat,1))+"%";
        output["title"] = famText+": "+textNumber+"chance of "+currFamDrop.dropText+limitString;
    }
    if (dropType == "approx float turn") {
        textNumber = "~"+to_string(roundFloat(currFamDrop.dropFloat,1));
        output["title"] = famText+": "+to_string(currFamDrop.drop)+" in "+pluralise(textNumber,"turn ","turns ")+limitString;
    }
    if (dropType == "turn") {
        int turnsSpentWithFam = currFamDrop.fam.fights_today;
        textNumber = to_string(clampi(currFamDrop.dropInt - turnsSpentWithFam,0,50));
        output["title"] = famText+": "+to_string(currFamDrop.drop)+" in "+pluralise(textNumber,"turn ","turns ")+limitString;
    }
    if (dropType == "precise int turn") {
        textNumber = to_string(currFamDrop.dropInt);
        output["title"] = famText+": "+to_string(currFamDrop.drop)+" in "+pluralise(textNumber,"turn ","turns ")+limitString;
    }
    if (dropType == "percent calc") = {
        textNumber = "~"+to_string(roundFloat(currFamDrop.dropFloat,1))+"%";
        output["title"] = famText+": "+textNumber+"chance of "+currFamDrop.dropText+limitString;
    }

    // Adding special desclines for special fam drop conditions & extras
    if (thisFam == lookupFamiliar("Golden Monkey")) output["desc"] = "Also, 100 meat autosell vs. meatless monsters";
    if (thisFam == lookupFamiliar("Peace Turkey")) {
        string [int] peaceMap = {0:"whirled peas",1:"olive",2:"hp/mp restore",3:"weap% buff",4:"whirled peas",5:"piece of cake",6:"booze",7:"peace shooter"}
        output["desc"] = "Next pea boon: "+peaceMap[get_property_int("peaceTurkeyIndex")];
    }

    return output;

    // string txtclr = "";
    // // if    ( fam.index_of("Stomping") > -1 ) {
    // //     txtclr = (get_property_boolean("bootsCharged"))?"blue":"black";
    // // }
    // if    ( currentDrops == limit ) { txtclr = "gray"; }

}

void SFamiliarDropsGenerateResource(ChecklistEntry [int] resource_entries)
{
    // New 2026 tile enumerating the TES Crown of Thrones thing into a general famdrop helper
    ChecklistEntry entry;

    entry.url = "";
    entry.image_lookup_name = "__familiar Floating Eye"; // TODO: pick better image lol
    entry.tags.id = "Familiar Drops Megatile";
    entry.importance_level = 8;

    string [int] description;
    string [int] completedDrops;
    string [string] tileComponents;

    foreach i, famDropRecord in __fam_drops {
        if (true) { // used to test tile display
        // if (famDropRecord.haveFam) {
            tileComponents = dropFamTile(famDropRecord);
            if (tileComponents["title"] == "" && tileComponents["limitLine"] != "") {
                completedDrops.listAppend(tileComponents["limitLine"]);
            }
            if (tileComponents["title"] != "") {
                description.listAppend(tileComponents["title"]);
            }
        }
    }

    string title = "testing famdrops";
    string subtitle = "testing <b>famdrops</b>?????????"

    return ChecklistEntryMake("__familiar floating eye", "", ChecklistSubentryMake(title, subtitle, description), 8).ChecklistEntrySetCombinationTag("familiar drops").ChecklistEntrySetIDTag(fam+" drops combo");

}