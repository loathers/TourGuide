//legendary seal-clubbing club
RegisterTaskGenerationFunction("IOTMLegendaryClubGenerateTasks");

// TODO: this is totally fine for now but two small notes i may address in the future:
//   - overall wanderer logic is kind of janky on all tiles and maybe could stand to be managed in one central spot
//   - probably decrease colors ever-so-slightly

void IOTMLegendaryClubGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	if (!__iotms_usable[lookupItem("legendary seal-clubbing club")]) return;
	string url = "inventory.php?ftext=legendary+seal-clubbing+club";
	string [int] description;
	string title;

    {	int nextWeekTurn = get_property_int("clubEmNextWeekMonsterTurn") + 8;
		int nextWeekTimer = (nextWeekTurn - total_turns_played());

		string image_name = get_property("clubEmNextWeekMonster");
		string [int] description;
		string [int] warnings;

		// Adding a few warnings for the sake of it
		boolean [string] holidayTracker = getHolidaysToday(); 

		if (holidayTracker["El Dia de Los Muertos Borrachos"] == true || holidayTracker["Feast of Boris"] == true) {
			warnings[1] = 'Be careful -- Borrachos & Feast of Boris wanderers can show up instead of your Legendary club wanderer!';
		}
		
		if (nextWeekTurn <= total_turns_played() && (image_name != ""))
		{
			description.listAppend(HTMLGenerateSpanFont("Wandering monster", "orange"));

			// Only show warnings if it's right about to happen
			foreach i, warning in warnings {
				description.listAppend(HTMLGenerateSpanFont("|* ➾ "+warning, "red"));
			}
			task_entries.listAppend(ChecklistEntryMake("__monster " + image_name, "", ChecklistSubentryMake("Legendary club: " + get_property("clubEmNextWeekMonster") + HTMLGenerateSpanFont(" now", "red"), "", description), -11));
		}
		else if (nextWeekTurn -1 == total_turns_played() && (image_name != ""))
		{
			description.listAppend(HTMLGenerateSpanFont("Wandering monster", "orange"));
			task_entries.listAppend(ChecklistEntryMake("__monster " + image_name, "", ChecklistSubentryMake("Legendary club: " + get_property("clubEmNextWeekMonster") + HTMLGenerateSpanFont(" in 1 more adv", "blue"), "", description), -11));
		}	
		else if (image_name != "")
		{
			description.listAppend(nextWeekTimer + " advs until Next Week fight.");
			optional_task_entries.listAppend(ChecklistEntryMake("__monster " + image_name, "", ChecklistSubentryMake("Legendary club: " + get_property("clubEmNextWeekMonster") + "", "", description), 10));
		}
	}	
	
	if (lookupItem("legendary seal-clubbing club").equipped_amount() > 0)
	{
		int clubBattlefieldsLeft = clampi(5 - get_property_int("_clubEmBattlefieldUsed"), 0, 5);
		int clubNextWeeksLeft = clampi(5 - get_property_int("_clubEmNextWeekUsed"), 0, 5);
		int clubBackwardsLeft = clampi(5 - get_property_int("_clubEmTimeUsed"), 0, 5);
	
		if (clubBattlefieldsLeft == 0) {
			description.listAppend(HTMLGenerateSpanFont("No Battlefield Clubs left.", "red"));
		} else {
			description.listAppend(clubBattlefieldsLeft + " Battlefield Clubs. Weird Saber Force.");
		}
		if (clubNextWeeksLeft == 0) {
			description.listAppend(HTMLGenerateSpanFont("No Next Week Clubs left.", "red"));
		} else {
			description.listAppend(clubNextWeeksLeft + " Next Week Clubs. 7-turn Wanderer.");
		}		
		if (clubBackwardsLeft == 0) {
			description.listAppend(HTMLGenerateSpanFont("No Backwards Clubs left.", "red"));
		} else {
			description.listAppend(clubBackwardsLeft + " Backwards Clubs. Free kill NO ITEMS.");
		}
		task_entries.listAppend(ChecklistEntryMake("__item legendary seal-clubbing club", url, ChecklistSubentryMake(HTMLGenerateSpanFont("Legendary seal-clubbing club skills", "orange"), description), -11).ChecklistEntrySetIDTag("LSSC skills"));
	}
}

RegisterResourceGenerationFunction("IOTMLegendaryClubGenerateResource");
void IOTMLegendaryClubGenerateResource(ChecklistEntry [int] resource_entries)
{
	if ($item[legendary seal-clubbing club].available_amount() == 0) return;
	string url = "inventory.php?ftext=legendary+seal-clubbing+club";
	string [int] description;
	string title;
	
		int clubBattlefieldsLeft = clampi(5 - get_property_int("_clubEmBattlefieldUsed"), 0, 5);
		int clubNextWeeksLeft = clampi(5 - get_property_int("_clubEmNextWeekUsed"), 0, 5);
		int clubBackwardsLeft = clampi(5 - get_property_int("_clubEmTimeUsed"), 0, 5);
	
		if (clubBattlefieldsLeft == 0) {
			description.listAppend(HTMLGenerateSpanFont("No Battlefield Clubs left.", "red"));
		} else {
			description.listAppend(clubBattlefieldsLeft + " Battlefield Clubs. Weird Saber Force.");
		}
		if (clubNextWeeksLeft == 0) {
			description.listAppend(HTMLGenerateSpanFont("No Next Week Clubs left.", "red"));
		} else {
			description.listAppend(clubNextWeeksLeft + " Next Week Clubs. 7-turn Wanderer.");
		}		
		if (clubBackwardsLeft == 0) {
			description.listAppend(HTMLGenerateSpanFont("No Backwards Clubs left.", "red"));
		} else {
			description.listAppend(clubBackwardsLeft + " Backwards Clubs. Free kill NO ITEMS.");
		}
	
	resource_entries.listAppend(ChecklistEntryMake("__item legendary seal-clubbing club", url, ChecklistSubentryMake(HTMLGenerateSpanFont("Legendary seal-clubbing club skills", "orange"), description), 1).ChecklistEntrySetIDTag("LSSC skills"));
}