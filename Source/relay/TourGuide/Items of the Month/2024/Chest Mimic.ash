//2024
//Chest Mimic
RegisterResourceGenerationFunction("IOTMChestMimicGenerateResource");
void IOTMChestMimicGenerateResource(ChecklistEntry [int] resource_entries)
{
	if (!lookupFamiliar("Chest Mimic").familiar_is_usable()) return;

	// Title
	int famExperienceGain = numeric_modifier("familiar experience") + 1;
	int chestExperience = ($familiar[chest mimic].experience);
	int famExpNeededForNextEgg = (50 - (chestExperience % 50));
	string fightsForNextEgg;
	if (famExperienceGain > 0) {
		fightsForNextEgg = pluralise(ceil(to_float(famExpNeededForNextEgg) / famExperienceGain), "fight", "fights");
	}
	else {
		fightsForNextEgg = "cannot get";
	}
	int mimicEggsLeft = clampi(11 - get_property_int("_mimicEggsObtained"), 0, 11);

	string [int] description;
	string url = "familiar.php";
	description.listAppend(`Currently have {HTMLGenerateSpanOfClass(chestExperience, "r_bold")} experience, currently gain {HTMLGenerateSpanOfClass(famExperienceGain, "r_bold")} fam exp per fight.`);
	description.listAppend(`Need {HTMLGenerateSpanOfClass(famExpNeededForNextEgg, "r_bold")} more famxp for next egg. ({fightsForNextEgg})`);
	description.listAppend(`Can lay {HTMLGenerateSpanOfClass(mimicEggsLeft, "r_bold")} more eggs today.`);

	resource_entries.listAppend(ChecklistEntryMake("__familiar chest mimic", url, ChecklistSubentryMake("Chest mimic fxp", "", description), -2));

	// Nice little tile to show what you've got in your mimic eggs
	if ($item[mimic egg].available_amount() > 0) {
		// Make sure the property is actually enumerated, might have an old mafia?
		if (get_property("mimicEggMonsters") != "") {
			string [int] eggEntries;
			foreach key,entry in get_property("mimicEggMonsters").split_string(",") {
				monster currMon = entry.split_string(":")[0].to_monster();
				int currAmt = entry.split_string(":")[1].to_int();
				string freeText = currMon.attributes.contains_text("FREE") ? " (free fight)" : "";
				eggEntries.listAppend(pluralise(currAmt, currMon+" egg", currMon+" eggs")+freeText);
			}

			string header = $item[mimic egg].pluralise().capitaliseFirstLetter();
			string url = `inv_use.php?pwd={my_hash()}&whichitem=11542`;
			string [int] description;
			description.listAppend("Fight some copies. Currently have: |*"+eggEntries.listJoinComponents("|*"));
			resource_entries.listAppend(ChecklistEntryMake("__item mimic egg", url, ChecklistSubentryMake(header, "", description), -1).ChecklistEntrySetCombinationTag("fax and copies"));
		}
	}
}
