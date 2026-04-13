string [int] luckyOptions(int cloversAvailable) {
	// Generate lucky suggestions from available options. Ordered in rough
	//   order according to which ones are available when. 
	string [int] allTheLuckyStuff;
	int cloversAdjusted = cloversAvailable;

	// Very basic protestors calculations with rough amounts for certain 
	//   weird paths. Assumption in standard/unrestricted is 3-clover mob.
	int protestorsRemaining = clampi(80 - get_property_int("zeppelinProtestors"), 0, 80);
	if (__quest_state["Level 11"].mafia_internal_step < 3) protestorsRemaining = 80;
	int protestorsPerClover = 27; // 3 clover mob
	
	switch (my_path()) {
		case $path[Legacy of Loathing]:
			protestorsPerClover = 20; // 4 clover mob
		case $path[Avatar of Boris]:
			protestorsPerClover = 16; // 5 clover mob
		case $path[G-Lover]:
			protestorsPerClover = 1; // cannot use clovers RIP
	}

	int projectedZeppClovers = ceil(protestorsRemaining.to_float()/protestorsPerClover.to_float());

	// Wand variable needed to ensure we know the # of letters remaining
	int lettersStillNeeded = __misc_state_int["ruby w needed"] + __misc_state_int["metallic a needed"] + __misc_state_int["lowercase n needed"] + __misc_state_int["heavy d needed"];

	// Variables needed for a-boo nonsense 
	int aBooHauntedness = __quest_state["Level 9"].state_int["a-boo peak hauntedness"];
    int cluesNeeded = ceil(MIN(aBooHauntedness, 100).to_float() / 30.0);
	int aBooCloversNeeded = ceil(cluesNeeded/2);

	// Desert ultrahydrated remaining
	int exploration = __quest_state["Level 11 Desert"].state_int["Desert Exploration"];
    int explorationRemaining = 100 - exploration;
	int roughUHTurnsNeeded = ceil(explorationRemaining.to_float()/2.0);
	
	// Append the lucky thing you can get, if you actually need it. Priority is because:

	//   - Ore is an early clover dump that (in modern meta) generally wants either an early MM or an 
	//       early clover. If you can't solve ore otherwise, this saves an absurd amount of turns
	//   - Zeppelin is the most important clover dump in-run traditionally; saves a good 5-6 turns 
	//       apiece, more in some paths
	//   - Wand is necessary in almost every path, and next-most-important after zepp/ore. Saves a
	//       good 3-ish turns on having to lose an NS fight and find the wand in the cemetary
	//   - Ultrahydrated saves 2-ish turns in some paths
	//   - Mick's saves about 2 turns in some paths as well, but less so generally
	//   - A-Boo clues save half a turn apiece because you save 1 turn on a two clover a-boo

	// Beyond these, there is a mild case for some of the elemental damage clovers, but I 
	//   don't think they warrant adding. Possibly worth adding to the actual tower test
	//   tile if you're at the tower test, but even then. Meh.
	
	if (!__quest_state["Level 8"].state_boolean["Past mine"] && $location[Itznotyerzitz Mine].locationAvailable()) 
		allTheLuckyStuff.listAppend("Ore");
	if (protestorsRemaining > 10 && protestorsPerClover > 15)
		allTheLuckyStuff.listAppend("Zeppelin Mob (x"+projectedZeppClovers+")");
		cloversAdjusted = MAX(cloversAdjusted - projectedZeppClovers, 3);
	if (my_path().id == 56) //adventurer meats world
		allTheLuckyStuff.listAppend("Knob Goblin Embezzler");
	if (__misc_state["wand of nagamar needed"] && lettersStillNeeded > 0)
		allTheLuckyStuff.listAppend("Wand of Nagamar");
	if (roughUHTurnsNeeded > 5)
		allTheLuckyStuff.listAppend("Ultrahydrated");
	if (!__quest_state["Level 12"].state_boolean["Nuns Finished"])
		allTheLuckyStuff.listAppend("Mick's Icyvapohotness Inhaler");
	if (aBooHauntedness > 0)
		allTheLuckyStuff.listAppend("A-Boo Clues (x"+aBooCloversNeeded+")");
		cloversAdjusted = MAX(cloversAdjusted - aBooCloversNeeded, 3);

	string [int] selectedOptions;

	foreach key, luckyStuff in allTheLuckyStuff {
		if (key < cloversAdjusted) selectedOptions.listAppend(luckyStuff);
	}

	return selectedOptions;
}


//Clovers and Lucky
RegisterResourceGenerationFunction("LuckyGenerateResource");
void LuckyGenerateResource(ChecklistEntry [int] resource_entries)
{

	// SYNTAX FOR NEW LUCKY SOURCES
	//   In order to centralize, we are using the SneakSource concept from the sneaks megatile.

	record LuckySource {
		string sourceName;
		string url;
		string imageLookupName;
		boolean luckyCondition;
		int luckyCount;
		string tileDescription;
	};

	// Refactoring lucky to reflect/use TES megatile suggestion
    // if (!__misc_state["in run"]) return;

	// useful state variables
    int spleenRemaining = spleen_limit() - my_spleen_use();
    int stomachLeft = availableFullness();

	// Build out all the lucky sources.

	// EVERGREEN: 11-leaf clovers
	LuckySource getClovers() {
		LuckySource final;
		final.sourceName = "clover";
		final.url = invSearch("11-leaf clover");
		final.imageLookupName = "__item 11-leaf clover";
		
		// # of clovers available
		int cloversAvailable = clampi(3 - get_property_int("_cloversPurchased"), 0, 3);
		if (my_path().id == PATH_ZOMBIE_SLAYER) cloversAvailable = 0;
		if (my_path().id == PATH_NUCLEAR_AUTUMN) cloversAvailable = 0;
		int cloversPossible = $item[11-leaf clover].available_amount() + cloversAvailable;
	
		// usable if we have any clovers available/possible
		final.luckyCondition = cloversPossible > 0;

		final.luckyCount = cloversPossible;
		final.tileDescription = `<b>{cloversPossible}x clovers</b> left`;
		final.tileDescription = cloversAvailable > 0 ? final.tileDescription + `, with {cloversAvailable}x at the Hermit` : final.tileDescription;

		return final;
	}

	// EVERGREEN: Astral Energy Drinks
	LuckySource getAEDs() {
		LuckySource final;
		final.sourceName = "astral energy drink";
		final.url = invSearch("astral energy");
		final.imageLookupName = "__item astral energy drink";
		
		// # of AEDs available or possible
		int availableAEDs = available_amount($item[[10883]astral energy drink]) + available_amount($item[[10882]carton of astral energy drinks])*6;
		int spleenFitsThisManyAEDs = min(floor(spleenRemaining / 5),availableAEDs);

		// usable if we have any clovers available/possible
		final.luckyCondition = availableAEDs > 0 && spleenFitsThisManyAEDs > 0;

		final.luckyCount = spleenFitsThisManyAEDs;
		final.tileDescription = `<b>{spleenFitsThisManyAEDs}x AEDs</b> to consume`;
		final.tileDescription = availableAEDs - spleenFitsThisManyAEDs > 0 ? final.tileDescription + `, with {availableAEDs - spleenFitsThisManyAEDs}x ready for tomorrow` : final.tileDescription;

		return final;
	}

	// 2026: Cast 1x "Heartstone: LUCK"
	LuckySource getHeartstone() {
        LuckySource final;

        final.sourceName = `august scepter`;
        final.url = 'skillz.php';
        final.imageLookupName = "__item heartstone";

        final.luckyCondition = __iotms_usable[$item[August Scepter]];
        final.luckyCount = get_property_boolean("_aug2Cast") ? 0 : 1; 
        final.tileDescription = `<b>{final.luckyCount}x August Scepter</b> cast left (Aug. 2)`;

        return final;
    }

	// 2024: 3x plays of the apriling band saxophone 
	LuckySource getSaxophones() {
        LuckySource final;

        final.sourceName = 'apriling tuba';
        final.url = "inventory.php?ftext=apriling+band+tuba";
        final.imageLookupName = "__item Apriling band tuba";

        int aprilingBandSaxUsesLeft = clampi(3 - get_property_int("_aprilBandSaxUses"), 0, 3);
        
        final.luckyCondition = (aprilingBandSaxUsesLeft > 0 && available_amount($item[apriling band tuba]) > 0);
        final.luckyCount = aprilingBandSaxUsesLeft;
        final.tileDescription = `<b>{aprilingBandSaxUsesLeft}x apriling sax solos</b> left`;
        return final;

    }
	// 2024: moai statues (cool); no clovermint tho, no thank you
	LuckySource getMoaiStatues() {
        LuckySource final;

        final.sourceName = `moai statuette`;
        final.url = invSearch("lucky moai statuette");
        final.imageLookupName = "__item lucky moai statuette";

        final.luckyCondition = available_amount($item[lucky moai statuette]) > 0;
        final.luckyCount = available_amount($item[lucky moai statuette])*3; 
        final.tileDescription = `<b>{final.luckyCount}x clovers</b> via lucky moai`;

        return final;
    }

	// 2023: Cast 1x "Aug. 2nd: Find an Eleven-Leaf Clover Day"
    LuckySource getScepter() {
        LuckySource final;

        final.sourceName = `august scepter`;
        final.url = 'skillz.php';
        final.imageLookupName = "__item august scepter";

        final.luckyCondition = __iotms_usable[$item[August Scepter]];
        final.luckyCount = get_property_boolean("_aug2Cast") ? 0 : 1; 
        final.tileDescription = `<b>{final.luckyCount}x August Scepter</b> cast left (Aug. 2)`;

        return final;
    }

	// 2019: Select "Surprise Me" from the Eight Days a Week Pill Keeper
	LuckySource getPillkeeper() {
        LuckySource final;

        final.sourceName = "pillkeeper";
        final.url = "main.php?eowkeeper=1";
        final.imageLookupName = "__item Eight Days a Week Pill Keeper";

        // see # of free pillkeeepers remaining
        int freeLuckLeft = get_property_boolean("_freePillKeeperUsed") ? 0 : 1;

        // calculate possible spleen-based lucky
        int spleenLucks = floor(spleenRemaining / 3);

        // usable if we have pill keeper plus free lucky or spleen lucky available
        final.luckyCondition = __iotms_usable[lookupItem("Eight Days a Week Pill Keeper")] && (freeLuckLeft + spleenLucks > 0);

        // never noticed I didn't explicitly say this was pillkeeper in the tile lol
        final.luckyCount = freeLuckLeft + spleenLucks;
        final.tileDescription = get_property_boolean("_freePillKeeperUsed") ? "" : `<b>1x PillKeeper</b> free lucky, `;
        final.tileDescription = final.tileDescription + `and <b>{spleenLucks}x</b> more for 3 spleen each`;
        return final;
    }

	// 2014: 1x Lucky Lindy -- not including to start, too old
	// 2013: 1x optimal dog -- not including to start, too old

	// Populate a list of lucky sources with our cool functions
	LuckySource [string] luckySources;

	luckySources["clovo"] = getClovers();
	luckySources["astro"] = getAEDs();
	luckySources["stono"] = getHeartstone();
	luckySources["saxxo"] = getSaxophones();
	luckySources["mohio"] = getMoaiStatues();
	luckySources["scepo"] = getScepter();
	luckySources["pillo"] = getPillkeeper();

	// For order, I am starting from things that are daily refresh -> can be saved
	string [int] luckyOrder = listMake("stono","scepo","saxxo","pillo","clovo","astro","mohio");

    ChecklistEntry entry;
    
	entry.url = "";
	entry.image_lookup_name = "__item 11-leaf clover";
    entry.tags.id = "Lucky sources available";
    entry.importance_level = -1;

    string [int] description;
    int totalLuckyCharges = 0;
	string line = HTMLGenerateSpanOfClass("Get a Lucky! adventure", "r_bold r_element_stench_desaturated");
	string ll = HTMLGenerateSpanOfClass("✾", "r_element_stench");
	string luckyText = HTMLGenerateSpanOfClass("Lucky!", "r_element_stench_desaturated");

	foreach it, luckyType in luckyOrder
    {
        LuckySource lucko = luckySources[luckyType];
        if (lucko.luckyCount > 0 && lucko.luckyCondition) {
			if (totalLuckyCharges == 0) entry.url = lucko.url;
            totalLuckyCharges += lucko.luckyCount;

            line += "|*"+ll+lucko.tileDescription;
        }

    }

    if (totalLuckyCharges == 0) return;

    // Append all the lines to a description
    description.listAppend(line);
	
    // Add a description that falls away when you hoverover
    entry.subentries.listAppend(ChecklistSubentryMake(pluralise(totalLuckyCharges, luckyText+" charge available", luckyText+" charges available"), "", description));

	if (entry.subentries.count() > 0) resource_entries.listAppend(entry);

	// do not run old tile
	if (false)
	{
		
		// Add a reminder to buy clovers if you haven't yet
		string [int] hermitDescription;
		int cloversAvailable = clampi(3 - get_property_int("_cloversPurchased"), 0, 3);
        if (cloversAvailable > 0)
        {
			string url = "hermit.php";
            string title = HTMLGenerateSpanFont("Hey! You! GRAB YOUR CLOVERS!", "green");
            hermitDescription.listAppend(cloversAvailable + " in stock at the Hermit");
            resource_entries.listAppend(ChecklistEntryMake("__item 11-leaf clover", url, ChecklistSubentryMake(title, hermitDescription), -11).ChecklistEntrySetIDTag("Clover resource"));    
        }
	}
}

RegisterTaskGenerationFunction("LuckyGenerateTasks");
void LuckyGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if ($effect[lucky!].have_effect() > 0) {
        string [int] description;
		string main_title = HTMLGenerateSpanFont("You feel lucky, punk!", "green") + "";
		
		// Figure out how many clovers you have available/possible and join the needed components
		int cloversAvailable = clampi(3 - get_property_int("_cloversPurchased"), 0, 3);
		int cloversPossible = $item[11-leaf clover].available_amount() + cloversAvailable;
		
		if (__misc_state["in run"] && my_path().id == 44) { // path is grey you lol
			description.listAppend("1x ore, 1x freezerburned ice cube, 1x full-length mirror.");
		}
		else if (__misc_state["in run"]) {
			description.listAppend(luckyOptions(cloversPossible).listJoinComponents(", "));
		}
		else {
			description.listAppend("I dunno. Full-length mirror?");
		}
		task_entries.listAppend(ChecklistEntryMake("__item 11-leaf clover", "", ChecklistSubentryMake(main_title, description), -11).ChecklistEntrySetIDTag("Fortune adventure now"));
    }
}