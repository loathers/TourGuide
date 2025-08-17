//cooler yeti
RegisterTaskGenerationFunction("IOTMCoolerYetiGenerateTasks");
void IOTMCoolerYetiGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if (!lookupFamiliar("Cooler Yeti").familiar_is_usable()) return;
	if (my_familiar() != lookupFamiliar("Cooler Yeti")) return;
	string url = "familiar.php";
	string [int] description;
	
	int yetiExperience = ($familiar[cooler yeti].experience);
	int famExpNeededFor400 = (400 - yetiExperience);
	string fightsForYeti;
	
	if (!get_property_boolean("_coolerYetiAdventures")) {
		if (yetiExperience >= 400) {
			description.listAppend("" + HTMLGenerateSpanFont("Doublebooze ready!", "blue"));
			string url = "main.php?talktoyeti=1";
			task_entries.listAppend(ChecklistEntryMake("__item dreadsylvanian cold-fashioned", url, ChecklistSubentryMake("Yeti booze time", description), -11).ChecklistEntrySetIDTag("cooler yeti booze time"));
		}
	}
}

RegisterResourceGenerationFunction("IOTMCoolerYetiGenerateResource");
void IOTMCoolerYetiGenerateResource(ChecklistEntry [int] resource_entries)
{
	if (!lookupFamiliar("Cooler Yeti").familiar_is_usable()) return;

	// Title
	int famExperienceGain = numeric_modifier("familiar experience") + 1;
	int yetiExperience = ($familiar[cooler yeti].experience);
	int famExpNeededFor400 = (400 - yetiExperience);
	string [int] description;
	string url = "familiar.php";
	string fightsForYeti;
	string title = HTMLGenerateSpanFont("Cooler Yeti fxp", "blue");
	if (famExperienceGain > 0) {
		fightsForYeti = pluralise(ceil(to_float(famExpNeededFor400) / famExperienceGain), "fight", "fights");
	}
	else {
		fightsForYeti = "cannot get";
	}
	if (!get_property_boolean("_coolerYetiAdventures")) {
		if (yetiExperience >= 400) {
			description.listAppend(HTMLGenerateSpanOfClass("Doubles next booze adv", "r_bold") + " costs 400 fxp.");
			url = "main.php?talktoyeti=1";
		}
	}
	if (yetiExperience >= 225) {
		description.listAppend(HTMLGenerateSpanOfClass("100 advs of +100% item/meat", "r_bold") + " costs 225 fxp.");
	}

	description.listAppend(`Currently have {HTMLGenerateSpanOfClass(yetiExperience, "r_bold")} experience, currently gain {HTMLGenerateSpanOfClass(famExperienceGain, "r_bold")} fam exp per fight.`);
	if (yetiExperience < 400) {
		description.listAppend(`Need {HTMLGenerateSpanOfClass(famExpNeededFor400, "r_bold")} more famxp for doublebooze. ({fightsForYeti})`);
	}
	
	resource_entries.listAppend(ChecklistEntryMake("__familiar cooler yeti", url, ChecklistSubentryMake(title, "", description), -1));
}