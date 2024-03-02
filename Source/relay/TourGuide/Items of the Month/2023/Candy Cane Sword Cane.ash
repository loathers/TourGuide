//candy cane sword cane
RegisterTaskGenerationFunction("IOTMCandyCaneSwordGenerateTasks");
void IOTMCandyCaneSwordGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	// Initialization. Good use of "lookupItem" for backwards compatibility reasons.
	if (!__iotms_usable[lookupItem("candy cane sword cane")]) return;
	string [int] description;
	string [int] describeSupernag;
	string [int] options;

	// Added a check for all paths where you do not want the supernag:
	//   - Community Service & Grey Goo: irrelevant
	//   - Avatar of Boris: cannot wield a weapon other than trusty
	boolean pathCheck = true;
	pathCheck = my_path().id == PATH_COMMUNITY_SERVICE ? false : true;
	pathCheck = my_path().id == PATH_GREY_GOO ? false : true;
	pathCheck = my_path().id == PATH_AVATAR_OF_BORIS ? false : true;

	// __misc_state["in run"] && 
	if (pathCheck)
	{
		string url = "inventory.php?ftext=candy+cane+sword+cane";
		// This is the description for the supernag. The supernag is in the task_entries, buried within conditional ifs and only shows up if you're in the zone.
		describeSupernag.listAppend(HTMLGenerateSpanFont("You're", "red") + " " + HTMLGenerateSpanFont("in a", "green") + " " + HTMLGenerateSpanFont("candy", "red") + " " + HTMLGenerateSpanFont("cane", "green") + " " + HTMLGenerateSpanFont("sword", "red") + " " + HTMLGenerateSpanFont("cane", "green") + " " + HTMLGenerateSpanFont("noncom", "red") + " " + HTMLGenerateSpanFont("zone!", "green"));

		// This enumerates the useful CCSC adventures.

		if (!get_property_boolean("_candyCaneSwordLyle")) {
			options.listAppend(HTMLGenerateSpanOfClass("Bonus:", "r_bold") + " Lyle's Monorail Buff (+40% init)");
		}

		// Added a check for if they are past black forest
		if (!get_property_boolean("candyCaneSwordBlackForest") && __quest_state["Level 11"].mafia_internal_step < 2) {
			options.listAppend(HTMLGenerateSpanOfClass("Bonus:", "r_bold") + " The Black Forest (+8 exploration)");
			if (($locations[The Black Forest] contains __last_adventure_location)) {
				task_entries.listAppend(ChecklistEntryMake("__item candy cane sword cane", url, ChecklistSubentryMake("Equip the candy cane sword cane", "", describeSupernag), -11));
			}	
		}

		// Added a check for if they need the loot token.
		if (!get_property_boolean("candyCaneSwordDailyDungeon") && __misc_state_int["fat loot tokens needed"] > 0) {
			options.listAppend(HTMLGenerateSpanOfClass("Bonus:", "r_bold") + " Daily Dungeon (+1 fat loot token)");
			if (($locations[The Daily Dungeon] contains __last_adventure_location)) {
				task_entries.listAppend(ChecklistEntryMake("__item candy cane sword cane", url, ChecklistSubentryMake("Equip the candy cane sword cane", "", describeSupernag), -11));
			}
		}

		// Added a check for if they need a curse
		if (!get_property_boolean("candyCaneSwordApartmentBuilding") && get_property_int("hiddenApartmentProgress") < 8) {
			options.listAppend(HTMLGenerateSpanOfClass("Bonus:", "r_bold") + " Hidden Apartment (+1 Curse)");
			if (($locations[The Hidden Apartment Building] contains __last_adventure_location)) {
				task_entries.listAppend(ChecklistEntryMake("__item candy cane sword cane", url, ChecklistSubentryMake("Equip the candy cane sword cane", "", describeSupernag), -11));
			}
		}

		// Added a check for if they need bowling alley access by checking the bowling alley progress var
		if (!get_property_boolean("candyCaneSwordBowlingAlley") && get_property_int("hiddenBowlingAlleyProgress") < 7) {
			options.listAppend(HTMLGenerateSpanOfClass("Bonus:", "r_bold") + " Hidden Bowling Alley (+1 free bowl)");
			if (($locations[The Hidden Bowling Alley] contains __last_adventure_location)) {
				task_entries.listAppend(ChecklistEntryMake("__item candy cane sword cane", url, ChecklistSubentryMake("Equip the candy cane sword cane", "", describeSupernag), -11));
			}
		}

		// Added a check for if they need shore access
		if (!get_property_boolean("candyCaneSwordShore") && !__misc_state["mysterious island available"]) {
			options.listAppend(HTMLGenerateSpanOfClass("Alternate:", "r_bold") + " Shore (2 scrips for the price of 1)");
			if (($locations[The Shore\, Inc. Travel Agency] contains __last_adventure_location)) {
				task_entries.listAppend(ChecklistEntryMake("__item candy cane sword cane", url, ChecklistSubentryMake("Equip the candy cane sword cane", "", describeSupernag), -11));
			}
		}

		// Added a check for if war is finished
		if (locationAvailable($location[The Battlefield (Frat Uniform)]) == false && !__quest_state["Level 12"].finished) {
			options.listAppend(HTMLGenerateSpanOfClass("Alternate:", "r_bold") + " Hippy Camp (Redirect to the War Start NC)");
			if (($locations[Wartime Hippy Camp,Wartime Frat House] contains __last_adventure_location)) {
				task_entries.listAppend(ChecklistEntryMake("__item candy cane sword cane", url, ChecklistSubentryMake("Equip the candy cane sword cane", "", describeSupernag), -11));
			}
		}

		// Changed condition to <80 protestors check
		if (get_property_int("zeppelinProtestors") < 80) {
			options.listAppend(HTMLGenerateSpanOfClass("Alternate: ", "r_bold") + "Zeppelin Protesters " + HTMLGenerateSpanFont("(double Sleaze damage!)", "purple"));
			if (($locations[A Mob of Zeppelin Protesters] contains __last_adventure_location)) {
				task_entries.listAppend(ChecklistEntryMake("__item candy cane sword cane", url, ChecklistSubentryMake("Equip the candy cane sword cane", "", describeSupernag), -11));
			}
		}

		if (options.count() > 0) {
			description.listAppend("Ensure your CCSC is equipped for these useful NCs:" + options.listJoinComponents("<hr>").HTMLGenerateIndentedText());
		}
		
	if (lookupItem("candy cane sword cane").equipped_amount() == 0) {
		description.listAppend(HTMLGenerateSpanFont("(Equip the candy cane sword cane -- it's not equipped!)", "red"));
	}
	// Only generate the tile if there are actual options.
	if (options.count() > 0) {
		optional_task_entries.listAppend(ChecklistEntryMake("__item Candy cane sword cane", url, ChecklistSubentryMake("Candy cane sword cane noncombats", description)).ChecklistEntrySetCombinationTag("CCSC tasks").ChecklistEntrySetIDTag("CCSC"));
	}
	}
}
