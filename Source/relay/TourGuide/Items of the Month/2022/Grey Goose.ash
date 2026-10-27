//Grey Goose
RegisterTaskGenerationFunction("IOTMGreyGooseGenerateTasks");
void IOTMGreyGooseGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    // This tile just posts up a task if your Goose is hefty enough to snag adventures, and you have it equipped.
    int gooseDrones = get_property_int("gooseDronesRemaining");
    int gooseWeight = min(floor(sqrt($familiar[Grey Goose].experience)),20);
    int gooseExperience = ($familiar[Grey Goose].experience);
    string [int] description;
    description.listAppend("GOOSO IS LIT.");

    // Originally this was designed to only pop up when goose was equipped, but TES changed that by adding the duping stuff.
    // if (my_familiar() != lookupFamiliar("Grey Goose")) return;

    if (gooseDrones > 0) 
    {
        string main_title = HTMLGenerateSpanFont(gooseDrones, "brown") + HTMLGenerateSpanFont(" GOOSO drones deployed", "grey");
        description.listAppend("Automatically duplicates non-conditional drops.");
        task_entries.listAppend(ChecklistEntryMake("__familiar grey goose", "", ChecklistSubentryMake(main_title,"",description),-11));
    }

    // Surprisingly, the "class" is called Grey Goo even if the path is Grey You. This is not a typo!
    if (my_class() == $class[grey goo] && gooseWeight > 5) 
    {
        string main_title = HTMLGenerateSpanFont("GOOSO is " + gooseWeight + " pounds (" + gooseExperience + " exp)", "grey");
        description.listAppend("Re-Process a bunch of matter to gain a bunch of adventures in Grey You.");
        task_entries.listAppend(ChecklistEntryMake("__familiar grey goose", "", ChecklistSubentryMake(main_title, "", description), -11));
    }
}

RegisterResourceGenerationFunction("IOTMGreyGooseGenerateResource");
void IOTMGreyGooseGenerateResource(ChecklistEntry [int] resource_entries)
{
	// Properly avoid a goose tile if the user has no familiar
    if (!lookupFamiliar("Grey Goose").familiar_is_usable()) return;

	// Title
    int gooseWeight = floor(sqrt($familiar[Grey Goose].experience));
	int gooseExperience = ($familiar[Grey Goose].experience);
	int famExperienceGain = numeric_modifier("familiar experience") +1;
	int famExpNeededForNextPound = ((gooseWeight +1) ** 2 - gooseExperience);
	int famExpNeededForTwoPounds = ((gooseWeight +2) ** 2 - gooseExperience);
	int horribleFamExpCalculation = ceil((36 - gooseExperience) / famExperienceGain);
	int horribleFamExpCalculationForGreyYou = ceil((196 - gooseExperience) / famExperienceGain);
	int horribleFamExpCalculationForStandard = ceil((400 - gooseExperience) / famExperienceGain);
	int newGooseExp = gooseExperience + famExperienceGain;
	string [int] description;
	string [int] stathelp;
	string url = "familiar.php";
	if (gooseWeight < 6)
	{
		if ((gooseWeight +1) **2 > newGooseExp)
		{
			description.listAppend("Currently have " + HTMLGenerateSpanOfClass(gooseWeight, "r_bold") + " weight (" + HTMLGenerateSpanOfClass(gooseExperience, "r_bold") + " experience), currently gain " + HTMLGenerateSpanOfClass(famExperienceGain, "r_bold") + " fam exp per fight. (Will become " + HTMLGenerateSpanFont(newGooseExp, "red") +")");
		}
		else
		{
			description.listAppend("Currently have " + HTMLGenerateSpanOfClass(gooseWeight, "r_bold") + " weight (" + HTMLGenerateSpanOfClass(gooseExperience, "r_bold") + " experience), currently gain " + HTMLGenerateSpanOfClass(famExperienceGain, "r_bold") + " fam exp per fight. (Will become " + HTMLGenerateSpanFont(newGooseExp, "blue") +")");
		}
		description.listAppend("" + HTMLGenerateSpanOfClass((CEIL(famExpNeededForNextPound / famExperienceGain)), "r_bold") + " combats until next pound, or " + HTMLGenerateSpanOfClass((CEIL(horribleFamExpCalculation)), "r_bold") + " combats for 6 weight.");
		resource_entries.listAppend(ChecklistEntryMake("__familiar Grey Goose", url, ChecklistSubentryMake(HTMLGenerateSpanFont("Grey goose skills charging", "grey"), "", description), -2));
	}
	if (gooseWeight >= 6)
	{
		if ((gooseWeight +1) **2 > newGooseExp)
		{
			description.listAppend("Currently have " + HTMLGenerateSpanOfClass(gooseWeight, "r_bold") + " weight (" + HTMLGenerateSpanOfClass(gooseExperience, "r_bold") + " experience), currently gain " + HTMLGenerateSpanOfClass(famExperienceGain, "r_bold") + " fam exp per fight. (Will become " + HTMLGenerateSpanFont(newGooseExp, "red") +")");
		}
		else
		{
			description.listAppend("Currently have " + HTMLGenerateSpanOfClass(gooseWeight, "r_bold") + " weight (" + HTMLGenerateSpanOfClass(gooseExperience, "r_bold") + " experience), currently gain " + HTMLGenerateSpanOfClass(famExperienceGain, "r_bold") + " fam exp per fight. (Will become " + HTMLGenerateSpanFont(newGooseExp, "blue") +")");
		}
		description.listAppend("" + HTMLGenerateSpanOfClass(famExpNeededForNextPound, "r_bold") + " famxp needed for next pound or " + HTMLGenerateSpanOfClass(famExpNeededForTwoPounds, "r_bold") + " for the one after that.");
		if (famExperienceGain < famExpNeededForNextPound)
			description.listAppend(HTMLGenerateSpanFont("Insufficient famxp for next fight.", "red") + "");
		description.listAppend("Can emit " + HTMLGenerateSpanOfClass(gooseWeight -5, "r_bold") + " drones to duplicate items.");
		
		//boring in-run nonsense
		if (__misc_state["in run"] && gooseWeight > 5) 
		{ 
			if (my_class() == $class[grey goo] && gooseWeight > 5 && my_level() < 11) 
			{
				description.listAppend("Can generate " + HTMLGenerateSpanOfClass((gooseWeight -5) ** 2, "r_bold") + " mainstat.");
				description.listAppend("" + HTMLGenerateSpanOfClass("GREY YOU: " + (CEIL(famExpNeededForNextPound / famExperienceGain)), "r_bold") + " combats until next pound, or " + HTMLGenerateSpanOfClass((CEIL(horribleFamExpCalculationForGreyYou)), "r_bold") + " combats for 14 weight.");
			}
			else if (__misc_state["in run"] && gooseWeight > 5 && my_level() < 11) 
			{
				#description.listAppend("Can generate " + HTMLGenerateSpanOfClass((gooseWeight -5) ** 3, "r_bold") + " substats.");
				float mainstat_gain = ((gooseWeight -5) ** 3) * (1.0 + numeric_modifier(my_primestat().to_string() + " Experience Percent") / 100.0);
				float mainstat_gain_for_four_hundred = ((15) ** 3) * (1.0 + numeric_modifier(my_primestat().to_string() + " Experience Percent") / 100.0);
				description.listAppend("Can generate " + HTMLGenerateSpanOfClass(mainstat_gain.roundForOutput(0), "r_bold") + " substats. (" + HTMLGenerateSpanOfClass((gooseWeight -5) ** 3, "r_bold") +" base).");
				description.listAppend("" + HTMLGenerateSpanOfClass("STAT GOOSO: " + (CEIL(famExpNeededForNextPound / famExperienceGain)), "r_bold") + " combats until next pound, or " + HTMLGenerateSpanOfClass((CEIL(horribleFamExpCalculationForStandard)), "r_bold") + " combats for 20 weight.");
			}
			#resource_entries.listAppend(ChecklistEntryMake("__familiar grey goose", url, ChecklistSubentryMake(HTMLGenerateSpanFont("Grey goose skills ready!", "grey"), "", stathelp)));
		}
		if (!get_property_boolean("_meatifyMatterUsed")) {
			description.listAppend("Can meatify matter for " + HTMLGenerateSpanOfClass((gooseWeight -5) ** 4, "r_bold") +  " meat.");
		}
		if (!__misc_state["in run"])
		{
			if (famExperienceGain >= 39) //from 25 to 64
				description.listAppend(HTMLGenerateSpanFont("Can GOOSO 3 drops per fight!", "green") + "");
			else if (famExperienceGain >= 24) //from 25 to 49
				description.listAppend(HTMLGenerateSpanFont("Can GOOSO 2 drops per fight!", "blue") + "");
			else if (famExperienceGain >= 11) //from 25 to 36
				description.listAppend(HTMLGenerateSpanFont("Can GOOSO 1 drop per fight!", "purple") + "");
			else if (famExperienceGain < 11) //cannot gooso
				description.listAppend(HTMLGenerateSpanFont("Cannot GOOSO any drops per fight!", "red") + "");
		}
		resource_entries.listAppend(ChecklistEntryMake("__familiar Grey Goose", url, ChecklistSubentryMake(HTMLGenerateSpanFont("Grey goose skills ready!", "grey"), "", description), -2));
	}
}