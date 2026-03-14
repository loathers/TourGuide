//cooler yeti
RegisterTaskGenerationFunction("IOTMCoolerYetiGenerateTasks");
void IOTMCoolerYetiGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if (!lookupFamiliar("Cooler Yeti").familiar_is_usable()) return;
	string url = "familiar.php";
	string [int] description;
	
	int yetiExperience = ($familiar[cooler yeti].experience);
	int famExpNeededFor400 = (400 - yetiExperience);
	string fightsForYeti400;
	
	if (get_property("coolerYetiMode") == "buff") {
		description.listAppend("" + HTMLGenerateSpanFont("Buffbooze primed!!!", "blue"));
		task_entries.listAppend(ChecklistEntryMake("__item oversized ice molecule", url, ChecklistSubentryMake("Yeti booze time", description), -11));
	}
	if (get_property("coolerYetiMode") == "adventures") {
		description.listAppend("" + HTMLGenerateSpanFont("Doublebooze primed!!!", "blue"));
		task_entries.listAppend(ChecklistEntryMake("__item dreadsylvanian cold-fashioned", url, ChecklistSubentryMake("Yeti booze time", description), -11));
	}
	if (my_familiar() == lookupFamiliar("Cooler Yeti") && !get_property_boolean("_coolerYetiAdventures") && yetiExperience >= 400) {
		description.listAppend("" + HTMLGenerateSpanFont("Doublebooze ready", "blue"));
		url = "main.php?talktoyeti=1";	
		task_entries.listAppend(ChecklistEntryMake("__item perfect ice cube", url, ChecklistSubentryMake("Yeti booze time", description), -11).ChecklistEntrySetIDTag("cooler yeti booze time"));
	}
}

RegisterResourceGenerationFunction("IOTMCoolerYetiGenerateResource");
void IOTMCoolerYetiGenerateResource(ChecklistEntry [int] resource_entries)
{
	if (!lookupFamiliar("Cooler Yeti").familiar_is_usable()) return;

	// Title
	int famExperienceGain = numeric_modifier("familiar experience") + 1;
	int yetiExperience = ($familiar[cooler yeti].experience);
	int famExpNeededFor225 = (225 - yetiExperience);
	int famExpNeededFor400 = (400 - yetiExperience);
	string [int] description;
	string url = "familiar.php";
	string fightsForYeti400;
	string fightsForYeti225;
	string title = HTMLGenerateSpanFont(yetiExperience + " Cooler Yeti fxp", "blue");
	if (famExperienceGain > 0) {
		fightsForYeti400 = pluralise(ceil(to_float(famExpNeededFor400) / famExperienceGain), "fight", "fights");
		fightsForYeti225 = pluralise(ceil(to_float(famExpNeededFor225) / famExperienceGain), "fight", "fights");
	}
	else {
		fightsForYeti400 = "cannot get";
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

	description.listAppend(`Currently gain {HTMLGenerateSpanOfClass(famExperienceGain, "r_bold")} fam exp per fight.`);
	if (yetiExperience < 225) {
		description.listAppend(`{HTMLGenerateSpanOfClass(famExpNeededFor225, "r_bold")} famxp for +100% meat/item. ({fightsForYeti225})`);
	}
	if (yetiExperience < 400) {
		description.listAppend(`{HTMLGenerateSpanOfClass(famExpNeededFor400, "r_bold")} famxp for doublebooze. ({fightsForYeti400})`);
	}
	if (get_property_boolean("_coolerYetiAdventures")) {
		description.listAppend(HTMLGenerateSpanFont("Doublebooze already used today.", "grey"));
	}
	if (my_familiar() == lookupFamiliar("Cooler Yeti")) {
		url = "main.php?talktoyeti=1";
	}
	resource_entries.listAppend(ChecklistEntryMake("__familiar cooler yeti", url, ChecklistSubentryMake(title, "", description), -1));
}
