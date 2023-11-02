//Gingerbread City
RegisterTaskGenerationFunction("IOTMGingerbreadCityGenerateTasks");
void IOTMGingerbreadCityGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	if (!__iotms_usable[$item[Build-a-City Gingerbread kit]]) return;
	
	string [int] description;
	string [int] GCTurnsLeftdescription;
	string [int] trainOptions;
	string [int] civicOptions;
	string [int] industrialOptions;
	string [int] retailOptions;
	string url = "place.php?whichplace=gingerbreadcity";
	{
		int GingerCityTimer = get_property_int("_gingerbreadCityTurns");
		if (get_property_boolean("_gingerbreadClockAdvanced") == true) {
            GingerCityTimer += 5;
			//increment gingercity timer by 5 if clock is used
        }
		
		if (GingerCityTimer < 30)
		{
			if (GingerCityTimer < 9) {			
				GCTurnsLeftdescription.listAppend(9 - GingerCityTimer + " combats until Noon.");
			}
			if (GingerCityTimer == 9)
			{
				trainOptions.listAppend("Look for candy.");
				civicOptions.listAppend("Knock over a sprinkle column (+50 sprinkles).");
				if ($item[gingerbread blackmail photos].available_amount() == 1) {
					civicOptions.listAppend("Use the photos to blackmail a politician.");
				}
				if (get_property_int("gingerLawChoice") >= 3) {
					industrialOptions.listAppend("Buy a teethpick (1000 sprinkles).");
				}
				if (get_property_boolean("gingerRetailUnlocked") == false) {
					civicOptions.listAppend("Build a retail district.");
				}
				if (get_property_boolean("gingerSewersUnlocked") == false) {
					civicOptions.listAppend("Build a sewer... district.");
				}
				if (get_property_boolean("gingerRetailUnlocked") == true) {
					retailOptions.listAppend("Buy some stuff (50-500 sprinkles).");
				}
				if ($item[fruit-leather negatives].available_amount() == 1) {
					retailOptions.listAppend("Develop your fruit-leather negatives.");
				}
				if (get_property_boolean("gingerNegativesDropped") == true) {
					retailOptions.listAppend("Pick up your blackmail photos.");
				}
				if (trainOptions.count() > 0) {
					description.listAppend(HTMLGenerateSpanOfClass("Train Station:", "r_bold") + "|*" + trainOptions.listJoinComponents("|*"));
				}
				if (civicOptions.count() > 0) {
					description.listAppend(HTMLGenerateSpanOfClass("Civic Center:", "r_bold") + "|*" + civicOptions.listJoinComponents("|*"));
				}
				if (industrialOptions.count() > 0) {
					description.listAppend(HTMLGenerateSpanOfClass("Industrial District:", "r_bold") + "|*" + industrialOptions.listJoinComponents("|*"));
				}
				if (retailOptions.count() > 0) {
					description.listAppend(HTMLGenerateSpanOfClass("Retail District:", "r_bold") + "|*" + retailOptions.listJoinComponents("|*"));
				}
				task_entries.listAppend(ChecklistEntryMake("__item gingerbread house", url, ChecklistSubentryMake("Gingerbread City Noon noncom available!", "", description), -11));
			}
			if (GingerCityTimer < 19) {			
				GCTurnsLeftdescription.listAppend(19 - GingerCityTimer + " combats until Midnight.");
			}
			if (GingerCityTimer == 19)
			{
				if (get_property_int("gingerMuscleChoice") < 3) {
					int gingerTracksLeft = clampi(3 - get_property_int("gingerMuscleChoice"), 0, 3);
					trainOptions.listAppend("Lay some track (" + gingerTracksLeft + " remaining).");
				}
				if (get_property_boolean("gingerSubwayLineUnlocked") == true && !get_property_boolean("gingerBlackmailAccomplished") == true) {
					trainOptions.listAppend("Get some fruit-leather negatives.");
				}
				if ($item[teethpick].available_amount() == 1) {
					int gingerDigsLeft = clampi(7 - get_property_int("gingerDigCount"), 0, 7);
					if (gingerDigsLeft > 4) {
						trainOptions.listAppend("Dig up " + pluralise(gingerDigsLeft -4, " green-iced sweet roll", "green-iced sweet rolls") + ".");
					}
					else if (gingerDigsLeft > 1) {
						trainOptions.listAppend("Dig up " + pluralise(gingerDigsLeft -1, " green rock candy", "green rock candies") + ".");
					}
					else if (gingerDigsLeft == 1) {
						trainOptions.listAppend("Dig up a sugar raygun (final).");
					}
				}
				if (get_property_boolean("_gingerbreadColumnDestroyed") == true) {
					civicOptions.listAppend("Fight Judge Fudge to take his gavel " + HTMLGenerateSpanFont("(no other Civic options available)", "red"));
				}
				if (get_property_boolean("_gingerbreadColumnDestroyed") == false) {
					civicOptions.listAppend("Buy some cigarettes (5 sprinkles).");
					civicOptions.listAppend("Buy a counterfeit city (300 sprinkles).");
					if (get_property_int("gingerLawChoice") < 3) {
						int gingerStudiesLeft = clampi(3 - get_property_int("gingerLawChoice"), 0, 3);
						civicOptions.listAppend("Study digging laws (" + gingerStudiesLeft + " remaining).");
					}
				}
				if (have_outfit_components("Gingerbread Best")) {
					retailOptions.listAppend("Get some ginger wine (free)");
					retailOptions.listAppend("Buy a chocolate sculpture (300 sprinkles)");
					if (!is_wearing_outfit("Gingerbread Best")) {
						retailOptions.listAppend(HTMLGenerateSpanFont("Retail District options require Gingerbread Best equipped", "red"));
					}
					else {
						retailOptions.listAppend(HTMLGenerateSpanFont("Gingerbread Best equipped for Retail District options", "blue"));
					}
				}
				if (trainOptions.count() > 0) {
					description.listAppend(HTMLGenerateSpanOfClass("Train Station:", "r_bold") + "|*" + trainOptions.listJoinComponents("|*"));
				}
				if (civicOptions.count() > 0) {
					description.listAppend(HTMLGenerateSpanOfClass("Civic Center:", "r_bold") + "|*" + civicOptions.listJoinComponents("|*"));
				}
				if (industrialOptions.count() > 0) {
					description.listAppend(HTMLGenerateSpanOfClass("Industrial District:", "r_bold") + "|*" + industrialOptions.listJoinComponents("|*"));
				}
				if (retailOptions.count() > 0) {
					description.listAppend(HTMLGenerateSpanOfClass("Retail District:", "r_bold") + "|*" + retailOptions.listJoinComponents("|*"));
				}

				task_entries.listAppend(ChecklistEntryMake("__item gingerbread house", url, ChecklistSubentryMake("Gingerbread City Midnight noncom available!", "", description), -11));
			}
			if (GingerCityTimer > 19) {			
				GCTurnsLeftdescription.listAppend("No NCs left.");
			}
			
			if (($locations[Gingerbread Train Station,Gingerbread Civic Center,Gingerbread Industrial Zone,Gingerbread Upscale Retail District,Gingerbread Sewers] contains __last_adventure_location) && GingerCityTimer != 9 && GingerCityTimer != 19)
				task_entries.listAppend(ChecklistEntryMake("__item gingerbread house", url, ChecklistSubentryMake(30 - GingerCityTimer + " Gingerbread City turns remaining", "", GCTurnsLeftdescription), -11));
			else
				if (gingercitytimer == 9) {
					GCTurnsLeftdescription.listAppend("Noon NC now!");
					}
				if (gingercitytimer == 19) {
					GCTurnsLeftdescription.listAppend("Midnight NC now!");
				}
			optional_task_entries.listAppend(ChecklistEntryMake("__item gingerbread house", url, ChecklistSubentryMake(30 - GingerCityTimer + " Gingerbread City turns remaining", "", GCTurnsLeftdescription), 10));
		}
	}
}
