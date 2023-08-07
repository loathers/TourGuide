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
    if (!__misc_state["in run"]) return;
	{
		string [int] description;
		string url;
		description.listAppend(HTMLGenerateSpanFont("Have a Lucky adventure!", "green"));

		// Figure out how many clovers you have available/possible and join the needed components
		int cloversAvailable = clampi(3 - get_property_int("_cloversPurchased"), 0, 3);
		int cloversPossible = $item[11-leaf clover].available_amount() + cloversAvailable;
		description.listAppend(luckyOptions(cloversPossible).listJoinComponents(", "));

		
		
		if ($item[11-leaf clover].available_amount() > 0)
		{
			url = invSearch("11-leaf clover");
			resource_entries.listAppend(ChecklistEntryMake("__item 11-leaf clover", url, ChecklistSubentryMake(pluralise($item[11-leaf clover]), "Inhale leaves for good luck", description), 2).ChecklistEntrySetCombinationTag("fortune"));
		}
		if ($item[[10883]astral energy drink].available_amount() > 0 && $item[11-leaf clover].available_amount() == 0)
		{
			url = invSearch("astral energy drink");
			resource_entries.listAppend(ChecklistEntryMake("__item [10883]astral energy drink", url, ChecklistSubentryMake(pluralise(available_amount($item[[10883]astral energy drink]),"astral energy drink", "astral energy drinks"), "Costs 5 spleen each", description), 2).ChecklistEntrySetCombinationTag("fortune"));
		}
		else if ($item[[10883]astral energy drink].available_amount() > 0 && $item[11-leaf clover].available_amount() > 0)
		{
			url = invSearch("astral energy drink");
			resource_entries.listAppend(ChecklistEntryMake("__item [10883]astral energy drink", url, ChecklistSubentryMake(pluralise(available_amount($item[[10883]astral energy drink]),"astral energy drink", "astral energy drinks"), "Costs 5 spleen each", ""), 2).ChecklistEntrySetCombinationTag("fortune"));
		}

		// Add a reminder to buy clovers if you haven't yet
		string [int] hermitDescription;
        if (cloversAvailable > 0)
        {
			url = "hermit.php";
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