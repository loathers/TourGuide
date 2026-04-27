// baseball diamond
// helper function to generate monster lineup
monster [int] baseballBuddies() {
    monster [int] finalTeam;
    string [int] rawTeam = get_property("baseballTeam").split_string(",");

    foreach i, playerID in rawTeam {
        finalTeam[i] = to_monster(to_int(playerID));
    }

    return finalTeam;
}

// Currently, most of what I wanted to do in tasks is already handled in the resource tiles. I may someday add some task coverage but for right now this is just a TODO.
// RegisterTaskGenerationFunction("IOTMBaseballDiamondGenerateTasks");
// void IOTMBaseballDiamondGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries) 
// {
//     // tasks should include
//     //   - recruit monsters for your baseball lineup if < 9 
//     //   - current lineup hoverover
//     //   - maybe a supernag if you have a useful freekill + YR in the last 3 monsters?
//     //   - supernag up top w/ what the pitch sequences do 

    
// 	if (!__iotms_usable[lookupItem("Baseball Diamond")]) return;
//     monster [int] myTeam = baseballBuddies(); 
//     int inningsPlayed = get_property_int("_baseballInnings");
//     monster curveballMonster = to_monster(get_property("_curveballMonster"));
//     int curveballFightsLeft = get_property_int("_curveballFightsLeft");
//     boolean baseballEquipped = lookupItem("Baseball Diamond").equipped_amount() > 0;
//     boolean currentlyPlayingBaseball = get_property("lastEncounter") == "Play Ball!" && get_property("baseballTeam") != "";
// }

RegisterResourceGenerationFunction("IOTMBaseballDiamondGenerateResource");
void IOTMBaseballDiamondGenerateResource(ChecklistEntry [int] resource_entries)
{ 
    // resource should include
    //   - number of ball games remaining
    //   - monsters to consider 
    //       => use shrunken head for YR
    //       => repeated nonfree monsters for freekill
    //       => feesh for ML
    
    if (!__iotms_usable[lookupItem("Baseball Diamond")]) return;

    ChecklistSubentry [int] subentries;

    boolean baseballEquipped = gemstoneEquipped(lookupItem("Baseball Diamond"));
    string url = baseballEquipped ? "inventory.php?which=2" : "inventory.php?ftext=baseball+diamond";
    if (gemstoneInCodpiece(lookupItem("baseball diamond"))) url = baseballEquipped ?  "inventory.php?which=2" : "inventory.php?ftext=eternity+codpiece";
    int inningsPlayed = get_property_int("_baseballInnings");
    monster [int] myTeam = baseballBuddies();
    int monstersNeededToPlayBall = clampi(9-myTeam.count(),0,9);
    if (get_property("baseballTeam") == "") monstersNeededToPlayBall = 9;

    // For this tile, we'll start with an overall "what should you use your remaining ballgames on" and transition into "what -have- you used these things on, currently"

    // Generate recommendations with your upcoming innings
    if (inningsPlayed < 3) {
        string title = "Play "+pluralise(clampi(3-inningsPlayed, 0, 3),"more inning","more innings")+" of Baseball";
        string [int] description;
        if (gemstoneInCodpiece(lookupItem("Baseball Diamond"))) description.listAppend("Currently in <b>Eternity Codpiece</b>");
        if (myTeam.count() < 9) {
            if (baseballEquipped) description.listAppend("Find "+pluralise(monstersNeededToPlayBall,"more monster","more monsters")+" to play ball!");
            if (!baseballEquipped) description.listAppend(HTMLGenerateSpanOfClass("Equip your Baseball Diamond","r_element_hot")+" to find "+pluralise(monstersNeededToPlayBall,"more monster","more monsters")+" to play ball!");
        }

        if (myTeam.count() == 9) {
            description.listAppend("You've collected enough monsters -- you can play your next inning whenever you want. Remember, try to have your curveball and scorcher targets in the last 3-4 monster slots!");
        }
        buffer tooltip;
        tooltip.append(HTMLGenerateTagWrap("div","Baseball Diamond Lineup",mapMake("class","r_bold r_centre", "style", "padding-bottom:0.25em;")));
        
        foreach key, mon in baseballBuddies() {
            tooltip.append("<b>#"+(key+1)+":</b> "+mon.name+"<br>");
        }

        string fullTooltip = HTMLGenerateSpanOfClass(HTMLGenerateSpanOfClass(tooltip,"r_tooltip_inner_class r_tooltip_inner_class_margin")+"View your current lineup.","r_tooltip_outer_class");
        description.listAppend(fullTooltip);


        subentries.listAppend(ChecklistSubentryMake(title, description));
    }
    
    // Non-Euclidian Curveball sub-tile
    monster curveballMonster = to_monster(get_property("_curveballMonster"));
    int curveballFightsLeft = get_property_int("_curveballFightsLeft");

    if (curveballMonster != $monster[none]) {
        subentries.listAppend(ChecklistSubentryMake(pluralise(curveballFightsLeft, "free copy of", "free copies of") + " "+HTMLGenerateSpanOfClass(curveballMonster.name, "r_element_epic")+" remaining", "naturally free fights!",""));
    }

    // Some Cheddar sub-tile; annoying because I've never abstracted tracked monsters...
    // TODO: make a tracked monster olfaction management tile lol
    monster cheddarMonster = $monster[none];
    string [int] trackedMonstersSplit = get_property("trackedMonsters").split_string(":");
    foreach key, str in trackedMonstersSplit {
        if (str == "Baseball Diamond") cheddarMonster = to_monster(trackedMonstersSplit[key-1]);
    }
    if (cheddarMonster != $monster[none]) {
        subentries.listAppend(ChecklistSubentryMake(HTMLGenerateSpanOfClass(cheddarMonster.name,"r_element_stench")+" tracked by a Cheddarball", "an olfaction-esque tracker!",""));
    }

    // Minor monster tracking sub-tile
    // Currently commented out because we don't really need it
    // monster screwballMonster = to_monster(get_property("_screwballMonster"));
    // monster beanballMonster = to_monster(get_property("_beanballMonster"));
    // monster skullballMonster = to_monster(get_property("_skullballMonster"));

    // string [int] minorTracking;
    // string minorSize = "0.9em";

    // if (screwballMonster != $monster[none]) {
    //     minorTracking.listAppend(HTMLGenerateSpanFont("<b>+ML: </b>"+screwballMonster+")", "r_element_sleaze_desaturated", minorSize));
    // }

    // if (beanballMonster != $monster[none]) {
    //     minorTracking.listAppend(HTMLGenerateSpanFont("<b>Passive Stench: </b>"+beanballMonster, "r_element_stench_desaturated", minorSize));
    // }

    // if (skullballMonster != $monster[none]) {
    //     minorTracking.listAppend(HTMLGenerateSpanFont("<b>Deleveled: </b>"+skullballMonster, "r_element_spooky_desaturated", minorSize));
        
    // }

    // if (minorTracking.count() > 0) subentries.listAppend(ChecklistSubentryMake("Baseball Modified Monsters","",minorTracking));

    // The iceball banish is tracked in the banish combo tile.

    if (subentries.count() > 0)
        resource_entries.listAppend(ChecklistEntryMake("__item baseball diamond", url, subentries, 12).ChecklistEntrySetIDTag("Baseball Diamond resource"));
}