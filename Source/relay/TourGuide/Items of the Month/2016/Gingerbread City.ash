//Gingerbread City
RegisterTaskGenerationFunction("IOTMGingerbreadCityGenerateTasks");
void IOTMGingerbreadCityGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	#if (get_property_boolean("gingerbreadCityAvailable") == false) return;
	string [int] description;
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
	}
}

RegisterResourceGenerationFunction("IOTMGingerbreadCityGenerateResource");
void IOTMGingerbreadCityGenerateResource(ChecklistEntry [int] resource_entries)
{
    if ($skill[Ceci N'Est Pas Un Chapeau].have_skill() && !get_property_boolean("_ceciHatUsed") && my_basestat($stat[moxie]) >= 150 && __misc_state["in run"])
    {
        //Umm... I guess?
        //It doesn't seem amazing in aftercore, so we're not displaying it? Is that the right decision?
        //Almost all of its enchantments are better on other hats. And you can't choose which one you get, so it'd just be annoying the user.
        resource_entries.listAppend(ChecklistEntryMake("__skill Ceci N'Est Pas Un Chapeau", "skillz.php", ChecklistSubentryMake("Ceci N'Est Pas Un Chapeau", "", "Random enchantment hat, 300MP."), 10).ChecklistEntrySetIDTag("Gingerbread city not-a-chapeau skill"));
    }
    
    if ($skill[Gingerbread Mob Hit].skill_is_usable() && mafiaIsPastRevision(17566))
    {
        if (!get_property_boolean("_gingerbreadMobHitUsed"))
        {
            string [int] description;
            description.listAppend("Combat skill, win a fight without taking a turn.");
            //FIXME replace with a better image
            resource_entries.listAppend(ChecklistEntryMake("__item kneecapping stick", "", ChecklistSubentryMake("Gingerbread mob hit", "", description), 0).ChecklistEntrySetCombinationTag("free instakill").ChecklistEntrySetIDTag("Gingerbread city mob hit free kill"));
            
        }
    }
    
    //http://kol.coldfront.net/thekolwiki/index.php/A_GingerGuide_to_Gingerbread_City
    
    //Things to acquire/unlock:
    //Studying in the library, which lets you acquire the seven-day sugar raygun.
    //Unlocking various areas.
    //Chocolate puppy.
    //Moneybag
    //gingerbread pistol
    //chocolate pocketwatch
    //Two skills...?
    //Laying track (does this reset on ascension...?) for a briefcase with lots of sprinkles...?
    //Studying train schedules for ???
    //Gingerbread Best outfit components.
    //Um... candy crowbar -> breaking in? Do you ever do this in run? No, I think?
    //Counterfeit city to sell.
    //Gingerbread cigarette to sell.
    //Chocolate sculpture to sell.
    //Gingerbread gavel
    //More...?
    if ($locations[Gingerbread Civic Center,Gingerbread Industrial Zone,Gingerbread Train Station,Gingerbread Sewers,Gingerbread Upscale Retail District] contains __last_adventure_location)
    {
        //Show details:
        /*
        Unlocks:
            gingerAdvanceClockUnlocked
            gingerRetailUnlocked 
            gingerSewersUnlocked 
            gingerExtraAdventures - +10 adventures in area
        
        gingerSubwayLineUnlocked
        
        _gingerBiggerAlligators - a born liverpooler
        _gingerbreadMobHitUsed - used once/day free kill
        gingerNegativesDropped
        gingerTrainScheduleStudies - times studied the schedule
        gingerDigCount - times went digging at the train station
        gingerLawChoice - times studied law
        gingerMuscleChoice - times laid track
        */
        //There's no per-turn tracker for this area.
    }
}