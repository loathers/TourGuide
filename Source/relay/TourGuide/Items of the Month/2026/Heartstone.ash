// heartstone 

RegisterTaskGenerationFunction("IOTMHeartstoneGenerateTasks");
void IOTMHeartstoneGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries) 
{
	// This is a TAPE-helper optional task tile.
	if (!__iotms_usable[lookupItem("Heartstone")]) return;

    // What are the heartstone's letters?
    string heartLetters = get_property("heartstoneLetters");
    if (heartLetters.length() > 3) heartLetters = "";
    string hackerToday = "";

    // Is the heartstone equipped?
    boolean heartstoneEquipped = gemstoneEquipped(lookupItem("Heartstone"));

    // Generate boolean flags for accessibility of each monster
    // --- T MONSTERS ----------------
    boolean nightstandsDone = $item[Lady Spookyraven's finest gown].available_amount() > 0 || get_property("questM21Dance") == "finished";
    string eightBitColor = get_property("8BitColor"); // and A/E
    boolean fratGearDone = have_outfit_components("Frat Warrior Fatigues");
    int shenDay = get_property_int("shenInitiationDay");
    boolean hospitalDone = get_property("questL11Doctor") == "finished";
    if ($item[server room key].available_amount() > 0 && get_property_int("_cyberFreeFights") < 10 && lookupSkill("OVERCLOCK(10)").have_skill()) hackerToday = get_property("_cyberZone1Hacker");
    // --- A MONSTERS ----------------
    boolean forestDone = get_property_ascension("lastTempleUnlock") && get_property("questL02Larva") == "finished";
    boolean oilPeakDone = get_property_boolean("oilPeakLit");
    boolean tombRatsDone = "step3,finished".contains_text(get_property("questL11Pyramid"));
    boolean oresDone = __quest_state["Level 8"].state_boolean["Past mine"];
    // --- P MONSTERS ----------------
    boolean warDone = __quest_state["Level 12"].finished;
    // --- E MONSTERS ----------------
    boolean castleDone = __quest_state["Castle"].mafia_internal_step > 8;
    boolean zeppelinDone = __quest_state["Level 11 Ron"].mafia_internal_step > 4;
    boolean copperheadDone = get_property("questL11Shen") == "finished";
    boolean haveMobiusRing = $item[M&ouml;bius ring].available_amount() > 0;
    // --- MISCELLANEOUS -------------
    boolean chestMimicAccessible = lookupFamiliar("Chest Mimic").familiar_is_usable();

    // Only generate tile if TAPE is achievable in this cycle
    string nextLetter;
    string title;
    string subtitle;
    string url;
    string [int] description;
    string [int] monsterList;

    if (heartLetters == "") { 
        nextLetter = "T"; 
        title = "Heartstone: Spell TAPE";
        subtitle = "give me a T!";
        monsterList.listAppend(HTMLGreyOutTextUnlessTrue("elegant animated nightstand", !nightstandsDone));
        monsterList.listAppend(HTMLGreyOutTextUnlessTrue("tektite", eightBitColor == "green"));
        monsterList.listAppend(HTMLGreyOutTextUnlessTrue("War Frat 151st Infantryman", !fratGearDone));
        monsterList.listAppend(HTMLGreyOutTextUnlessTrue("The Frattlesnake", shenDay == 2));
        monsterList.listAppend(HTMLGreyOutTextUnlessTrue("Pygmy Witch Nurse", !hospitalDone));
        if (hackerToday.contains_text("blue")) monsterList.listAppend("Bluehat Hacker (zone 1!)");
        if (hackerToday.contains_text("grey")) monsterList.listAppend("Greyhat Hacker (zone 1!)");
    } else if (heartLetters == "T") { 
        nextLetter = "A"; 
        title = "Heartstone: Spell "+HTMLGenerateSpanFont("T","r_element_stench")+"APE";
        subtitle = "give me an A!";
        monsterList.listAppend(HTMLGreyOutTextUnlessTrue("bar", !forestDone));
        monsterList.listAppend(HTMLGreyOutTextUnlessTrue("fleaman", eightBitColor == "black"));
        monsterList.listAppend(HTMLGreyOutTextUnlessTrue("oil cartel", !oilPeakDone));
        monsterList.listAppend(HTMLGreyOutTextUnlessTrue("tomb rat king", !tombRatsDone));
        monsterList.listAppend(HTMLGreyOutTextUnlessTrue("mountain man", !oresDone));
        monsterList.listAppend(HTMLGreyOutTextUnlessTrue("Black Crayon Fish", chestMimicAccessible));
        
    } else if (heartLetters == "TA") { 
        nextLetter = "P"; 
        title = "Heartstone: Spell "+HTMLGenerateSpanFont("TA","r_element_stench")+"PE";
        subtitle = "give me a P!";
        monsterList.listAppend(HTMLGreyOutTextUnlessTrue("War Hippy Baker", !warDone));
        monsterList.listAppend(HTMLGreyOutTextUnlessTrue("War Hippy Naturopathic Homeopath", !warDone));
        monsterList.listAppend(HTMLGreyOutTextUnlessTrue("Black Crayon Spiraling Shape", chestMimicAccessible));
    } else if (heartLetters == "TAP") { 
        nextLetter = "E"; 
        title = "Heartstone: Spell "+HTMLGenerateSpanFont("TAP","r_element_stench")+"E";
        subtitle = "give me an E!";
        monsterList.listAppend(HTMLGreyOutTextUnlessTrue("met", eightBitColor == "blue"));
        monsterList.listAppend(HTMLGreyOutTextUnlessTrue("Foodie Giant", !castleDone));
        monsterList.listAppend(HTMLGreyOutTextUnlessTrue("red skeleton", !zeppelinDone));
        monsterList.listAppend(HTMLGreyOutTextUnlessTrue("tomb servant", !tombRatsDone));
        monsterList.listAppend(HTMLGreyOutTextUnlessTrue("Keese", eightBitColor == "green"));
        monsterList.listAppend(HTMLGreyOutTextUnlessTrue("ninja dressed as a waiter", !copperheadDone));
        monsterList.listAppend(HTMLGreyOutTextUnlessTrue("Mobile Armored Sweat Lodge", !warDone));
        monsterList.listAppend(HTMLGreyOutTextUnlessTrue("time cop", haveMobiusRing));
    } else {
        return;
    }

    // If unequipped, go to heartstone in inventory. Else, no URL.
    if (!heartstoneEquipped) url = invSearch("heartstone");

    // Generate tile description
    description.listAppend("You need "+nextLetter+"; look for these monsters:|*");
    description.listAppend("<hr>|*"+monsterList.listJoinComponents("<hr>|*"));
    if (!heartstoneEquipped) description.listAppend(HTMLGenerateSpanFont("Equip your Heartstone!","red"));

    optional_task_entries.listAppend(ChecklistEntryMake("__item heartstone", url, ChecklistSubentryMake(title, subtitle, description)).ChecklistEntrySetIDTag("Heartstone spell TAPE"));

}

RegisterResourceGenerationFunction("IOTMHeartstoneGenerateResource");
void IOTMHeartstoneGenerateResource(ChecklistEntry [int] resource_entries)
{ 
	// the heart must go on
	if (!__iotms_usable[lookupItem("Heartstone")]) return;
    boolean heartstoneEquipped = gemstoneEquipped(lookupItem("Heartstone"));

    // What are the heartstone's letters?
    string heartLetters = get_property("heartstoneLetters");
    if (heartLetters.length() > 3) heartLetters = "";
    string url = heartstoneEquipped ? "" : invSearch("heartstone");
    string [int] description;
    string title = heartLetters != "" ? "Heartstone ("+heartLetters.to_upper_case()+")" : "Heartstone (no letters!)";

    // resource should include
    //   - better VHS tape tile; banishes will be in banish zone, but VHS tapes should get its own tile outside of 2002 now
    //   - skills tile for the useful skills; include banish as resource in banishes combination tag

    // Can the user access the skills?
    boolean accessBOOM = get_property_boolean("heartstoneKillUnlocked");
    boolean accessGONE = get_property_boolean("heartstoneBanishUnlocked");
    boolean accessSTUN = get_property_boolean("heartstoneStunUnlocked");
    boolean accessBUDS = get_property_boolean("heartstonePalsUnlocked");
    boolean accessBUFF = get_property_boolean("heartstoneBuffUnlocked");
    boolean accessLUCK = get_property_boolean("heartstoneLuckUnlocked");

    // How many times has the user used the skills?
    int usesBOOM = get_property_int("_heartstoneKillUsed");
    int usesGONE = get_property_int("_heartstoneBanishUsed");
    int usesSTUN = get_property_int("_heartstoneStunUsed");
    int usesBUDS = get_property_int("_heartstonePalsUsed");
    int usesBUFF = get_property_int("_heartstoneBuffUsed");
    int usesLUCK = get_property_boolean("_heartstoneLuckUsed").to_int();

    // Banish combination tag for GONE.
    if (accessGONE && usesGONE < 5) {
        string [int] banishDesc;
        banishDesc.listAppend("Turn-taking item-destroying kill, 50-turn banish.");
        if (!heartstoneEquipped) banishDesc.listAppend("Equip your Heartstone.");
        resource_entries.listAppend(ChecklistEntryMake("__item Heartstone", url, ChecklistSubentryMake(pluralise(5-usesGONE,"cast","casts")+" of Heartstone: GONE", "", banishDesc), 0).ChecklistEntrySetCombinationTag("banish").ChecklistEntrySetIDTag("Heartstone banish"));
    }

    description.listAppend("Steal Monster Hearts for useful items.");
    if (usesLUCK + usesBUDS + usesGONE + usesBOOM < 16) {
        description.listAppend("Also, use some cool skills:");
        if (accessBOOM && usesBOOM < 5) description.listAppend("|*<b>"+pluralise(5-usesBOOM,"BOOM","BOOMs")+":</b> Instakill with ~150 substats");
        if (accessGONE && usesGONE < 5) description.listAppend("|*<b>"+pluralise(5-usesGONE,"GONE","GONEs")+":</b> Turn-taking banish");
        if (accessBUDS && usesBUDS < 5) description.listAppend("|*<b>"+pluralise(5-usesBUDS,"BUDS","BUDS")+":</b> 25 turns of +5 famwt, +1 famxp");
        if (accessLUCK && usesLUCK < 1) description.listAppend("|*<b>"+pluralise(1-usesLUCK,"LUCK","LUCK")+":</b> A shot of "+HTMLGenerateSpanFont("Lucky!","green"));

        // Remind user to pick up new heartstone skills if needed 
        if (!accessBOOM || !accessGONE || !accessSTUN || !accessBUDS || !accessBUFF || !accessLUCK) {    
            string [int] skillsNeeded;
            if (!accessBOOM) skillsNeeded.listAppend("BOOM");
            if (!accessGONE) skillsNeeded.listAppend("GONE");
            if (!accessSTUN) skillsNeeded.listAppend("STUN");
            if (!accessBUDS) skillsNeeded.listAppend("BUDS");
            if (!accessBUFF) skillsNeeded.listAppend("BUFF");
            if (!accessLUCK) skillsNeeded.listAppend("LUCK");

            description.listAppend("Consider spelling the following words to unlock new skills: "+listJoinComponents(skillsNeeded, ", "));
        }
    
    if (!heartstoneEquipped) description.listAppend(HTMLGenerateSpanFont("Equip your Heartstone!","red"));
	if (gemstoneInCodpiece(lookupItem("heartstone"))) description.listAppend("Currently in <b>Eternity Codpiece</b>");
    
    resource_entries.listAppend(ChecklistEntryMake("__item Heartstone", url, ChecklistSubentryMake(title, "", description)).ChecklistEntrySetIDTag("Heartstone skills"));
            

    }

}