//Jurassic parka
RegisterTaskGenerationFunction("IOTMJurassicParkaGenerateTasks");
void IOTMJurassicParkaGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	// Task-based nag for using the parka. Instruct the user to swap modes or equip parka if needed.
	if (!__iotms_usable[$item[Jurassic Parka]]) return;

	// Fondeluge is the only skill strictly better than Jurassic acid; don't show this tile if you happen to have it
	if (lookupSkill("Fondeluge").have_skill()) return;
    if (__misc_state["in run"] && available_amount($item[jurassic parka]) > 0 && my_path().id != PATH_COMMUNITY_SERVICE)
	{
		string [int] description;
		string url = "inventory.php?ftext=jurassic+parka";
		
		// TODO: Perhaps a centralized YR supernag would be better? Not sure, tbh.
		if ($effect[everything looks yellow].have_effect() == 0) 
		{
			if (lookupItem("jurassic parka").equipped_amount() == 0)
			{
				description.listAppend(HTMLGenerateSpanFont("Equip your Jurassic Parka!", "red"));
			}
			else description.listAppend(HTMLGenerateSpanFont("Parka equipped.", "orange"));
			if (get_property("parkaMode") != "dilophosaur")
			{
				description.listAppend(HTMLGenerateSpanFont("Change your parka to dilophosaur mode!", "red"));
			}
			else description.listAppend(HTMLGenerateSpanFont("Dilophosaur mode enabled.", "orange"));			
			task_entries.listAppend(ChecklistEntryMake("__item jurassic parka", url, ChecklistSubentryMake("Parka yellow ray is ready; spit some acid!", "", description), -11));
		}
	}
}

RegisterResourceGenerationFunction("IOTMJurassicParkaGenerateResource");
void IOTMJurassicParkaGenerateResource(ChecklistEntry [int] resource_entries)
{
	if (!__iotms_usable[$item[Jurassic Parka]]) return;
	if (!__misc_state["in run"]) return; 
	if (my_path().id == PATH_G_LOVER) return; // cannot use parka in g-lover

	string url;
	string parkaMode = get_property("parkaMode");
	string parkaEnchant;
	string [int] description;

	url = invSearch("jurassic parka");

	int spikos_left = clampi(5 - get_property_int("_spikolodonSpikeUses"), 0, 5);
	
	// Title
		string main_title = "Jurassic Parka";
		description.listAppend("You're the dinosaur now, dawg.");
		
		switch (get_property("parkaMode"))			
		{
			case "kachungasaur":
				parkaEnchant = "+100% HP, +50% meat, +2 Cold res."; break;
			case "dilophosaur":
				parkaEnchant = "+20 Sleaze and Sleaze Spell, +2 Stench res, YR free kill."; break;
			case "spikolodon":
				parkaEnchant = "+ML, +2 Sleaze res, NC forcing ability."; break;
			case "ghostasaurus":
				parkaEnchant = "+10 DR, +50 MP, +2 Spooky res."; break;
			case "pterodactyl":
				parkaEnchant = "-5% Combat Frequency, +50% Initiative, +2 Hot res."; break;
		}
		description.listAppend(HTMLGenerateSpanOfClass("Current enchantment: ", "r_bold") + parkaMode);
		description.listAppend(HTMLGenerateSpanFont(parkaEnchant, "blue") + "");
		description.listAppend(HTMLGenerateSpanOfClass(spikos_left, "r_bold") + " spikolodon spikes available.");
		resource_entries.listAppend(ChecklistEntryMake("__item jurassic parka", "inventory.php?action=jparka", ChecklistSubentryMake(main_title, "", description)));
}
