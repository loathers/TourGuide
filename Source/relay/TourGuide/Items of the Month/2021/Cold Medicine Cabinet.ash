//Cold Medicine Cabinet
RegisterTaskGenerationFunction("IOTMColdMedicineCabinetGenerateTasks");
void IOTMColdMedicineCabinetGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    monster gregarious_monster = get_property_monster("beGregariousMonster");
    int fights_left = clampi(get_property_int("beGregariousFightsLeft"), 0, 3);
	string [int] description;
	
	if (gregarious_monster != $monster[none] && fights_left > 0) 
	{
        description.listAppend("Neaaaar, faaaaaaar, wherever you spaaaaaaar, I believe that the heart does go onnnnn.");
		description.listAppend("Will appear in any zone, so try to find a zone with few monsters.");
		optional_task_entries.listAppend(ChecklistEntryMake("__monster " + gregarious_monster, "url", ChecklistSubentryMake("Fight " + pluralise(fights_left, "more gregarious " + gregarious_monster, "more gregarious " + gregarious_monster + "s"), "", description), -1));
    }
	if (!__iotms_usable[lookupItem("cold medicine cabinet")]) return;

	// Parsing the lastCombatEnvironments for a count of CMC combats.
	string cmcCombatString = get_property("lastCombatEnvironments");
	string[int] splitCMC = split_string(cmcCombatString, "");
    int uTurns;
	int iTurns;
	int oTurns;

	foreach turn in splitCMC {
		if (splitCMC[turn] == "i") {iTurns +=1;}
		if (splitCMC[turn] == "u") {uTurns +=1;}
		if (splitCMC[turn] == "o") {oTurns +=1;}
	}

	string expectedSpleenItem = "Fleshazole";

	if (uTurns > 10) expectedSpleenItem = "Breathitin";
	if (iTurns > 10) expectedSpleenItem = "Extrovermectin";
	if (oTurns > 10) expectedSpleenItem = "Homebodyl";

	int CMC_consults = clampi(5 - get_property_int("_coldMedicineConsults"), 0, 5);
	if (CMC_consults > 0) 
	{
		int next_CMC_Turn = get_property_int("_nextColdMedicineConsult");
		int next_CMC_Timer = (next_CMC_Turn - total_turns_played());
		string [int] description;
		string url = "campground.php?action=workshed";
			
		if (next_CMC_Turn -1 == total_turns_played())
		{
			description.listAppend(HTMLGenerateSpanFont("Consultation ready next turn!", "red"));
			description.listAppend("You'll be prescribed " + HTMLGenerateSpanOfClass(expectedSpleenItem, "r_bold"));
			description.listAppend("You have " + CMC_consults + " consultations remaining.");
			task_entries.listAppend(ChecklistEntryMake("__item snow suit", url, ChecklistSubentryMake("The cold medicine cabinet is almost in session", "", description), -11));
		}
		else if (next_CMC_Turn <= total_turns_played())
		{
			description.listAppend(HTMLGenerateSpanFont("Just what the doctor ordered!", "blue"));
			description.listAppend("You'll be prescribed " + HTMLGenerateSpanOfClass(expectedSpleenItem, "r_bold"));
			description.listAppend("You have " + CMC_consults + " consultations remaining.");
			task_entries.listAppend(ChecklistEntryMake("__item snow suit", url, ChecklistSubentryMake("The cold medicine cabinet is in session", "", description), -11));
		}
	}
}

RegisterResourceGenerationFunction("IOTMColdMedicineCabinetGenerateResource");
void IOTMColdMedicineCabinetGenerateResource(ChecklistEntry [int] resource_entries)
{
    //gregariousness
	int uses_remaining = get_property_int("beGregariousCharges");
	if (uses_remaining > 0) 
	{
        if (true) 
		{
            //The section that will be sent as a stand-alone resource
            string url;
            
            string [int] description;
            description.listAppend("Be gregarious in combat, which lets you turn foes into friends!");
			string [int] gregfriends;
			gregfriends.listAppend("Bob Racecar, or his brother Racecar Bob");
			gregfriends.listAppend("dirty old lihc (cyrpt progress)");
			gregfriends.listAppend("lobsterfrogman (gunpowder)");
			gregfriends.listAppend("modern zmobie (cyrpt progress)");
			gregfriends.listAppend("dense liana (free fight)");
			gregfriends.listAppend("drunk pygmy (free fight)");
			gregfriends.listAppend("eldritch tentacle (free fight, difficult)");
			gregfriends.listAppend("lynyrd (free fight)");
			gregfriends.listAppend("[degenerate aftercore farming target]");
			description.listAppend("Potentially good friendships:|*" + gregfriends.listJoinComponents("|*"));
            resource_entries.listAppend(ChecklistEntryMake("__effect Good Karma", url, ChecklistSubentryMake(uses_remaining.pluralise("gregarious handshake", "gregarious handshakes"), "", description)).ChecklistEntrySetIDTag("gregarious wanderer resource")); 
        }
    }
	
	//breathitin
	int breaths_remaining = get_property_int("breathitinCharges");
	if (breaths_remaining > 0) 
	{
        string [int] description;
        description.listAppend("Outdoor fights become free.");
        resource_entries.listAppend(ChecklistEntryMake("__item beefy pill", "", ChecklistSubentryMake(pluralise(breaths_remaining, "breathitin breath", "breathitin breaths"), "", description), -2));
    }

	//homebodyl
	int homebodyls_remaining = get_property_int("homebodylCharges");
	if (homebodyls_remaining > 0) 
	{
        string [int] description;
        description.listAppend("Free crafting.");
		description.listAppend("Lynyrd equipment, potions, and more.");
        resource_entries.listAppend(ChecklistEntryMake("__item excitement pill", "", ChecklistSubentryMake(pluralise(homebodyls_remaining, "homebodyl free craft", "homebodyl free crafts"), "", description)));
    }
	
	//consultation counter
	int CMC_consults = clampi(5 - get_property_int("_coldMedicineConsults"), 0, 5);
	if (CMC_consults > 0 && __misc_state["in run"] && __iotms_usable[lookupItem("cold medicine cabinet")]) 
	{
		// Tracking tile; gives the user information about the last turn-taking combats per the pref.
		int next_CMC_Turn = get_property_int("_nextColdMedicineConsult");
		int next_CMC_Timer = (next_CMC_Turn - total_turns_played());
        int fleshazoleMeat = clampi(my_level(),0,11)*1000;
       
        // Parsing the lastCombatEnvironments for a count of CMC combats.
        string cmcCombatString = get_property("lastCombatEnvironments");
        string[int] splitCMC = split_string(cmcCombatString, "");
        int uTurns;
        int iTurns;
        int oTurns;
		string dotMatrix = '';

        foreach turn in splitCMC {
            if (splitCMC[turn] == "i") {iTurns +=1; dotMatrix = dotMatrix+'<span style="color:Salmon">•</span>'}
            if (splitCMC[turn] == "u") {uTurns +=1; dotMatrix = dotMatrix+'<span style="color:Indigo">•</span>'}
            if (splitCMC[turn] == "o") {oTurns +=1; dotMatrix = dotMatrix+'<span style="color:Wheat">•</span>'}
        }
        
    	string expectedSpleenItem = "Fleshazole";

    	if (uTurns > 10) expectedSpleenItem = "Breathitin";
    	if (iTurns > 10) expectedSpleenItem = "Extrovermectin";
    	if (oTurns > 10) expectedSpleenItem = "Homebodyl";

		string [int] description;
		string url = "campground.php?action=workshed";
			
		description.listAppend(HTMLGenerateSpanFont("Route turn-taking combats into the correct environments for a helpful spleen item!", "blue"));
		description.listAppend(dotMatrix);
            
        string uFormat = uTurns > 10 ? "black" : "grey";
        string iFormat = iTurns > 10 ? "black" : "grey";
        string oFormat = oTurns > 10 ? "black" : "grey";

        string [int] currentState;
        currentState.listAppend(HTMLGenerateSpanOfClass("Currently Expected Spleener: ", "r_bold")+ expectedSpleenItem);
        currentState.listAppend(HTMLGenerateSpanFont(uTurns.to_string() + " Underground turns", uFormat));
        currentState.listAppend(HTMLGenerateSpanFont(iTurns.to_string() + " Indoor turns", iFormat));
        currentState.listAppend(HTMLGenerateSpanFont(oTurns.to_string() + " Outdoor turns", oFormat));
        description.listAppend(currentState.listJoinComponents("|*"));

        string [int][int] spleeners;
        // Generates a reference table for the user of the spleener effects.
        spleeners.listAppend(listMake("<strong>Spleen Item</strong>", "<strong>Environment</strong>", "<strong>Effect</strong>"));
        spleeners.listAppend(listMake("Extrovermectin","Indoors","+3 Wandering Monsters"));
        spleeners.listAppend(listMake("Breathitin","Underground","+5 Outdoor Free Kills"));
        spleeners.listAppend(listMake("Homebodyl","Outdoors","+11 Free Crafts"));
        spleeners.listAppend(listMake("Fleshazole","N/A","+"+fleshazoleMeat.to_string()+" meat"));
        description.listAppend(HTMLGenerateSimpleTableLines(spleeners));

        resource_entries.listAppend(ChecklistEntryMake("__item snow suit", url, ChecklistSubentryMake(CMC_consults.pluralise("CMC consultation", "CMC consultations" + " remaining"), "", description)).ChecklistEntrySetIDTag("cold medicine cabinet resource")); 
	}
}