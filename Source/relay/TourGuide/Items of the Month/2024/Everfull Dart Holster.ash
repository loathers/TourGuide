//Everfull Dart Holster
RegisterTaskGenerationFunction("IOTMEverfullDartsGenerateTasks");
void IOTMEverfullDartsGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	#if (__misc_state["in run"] && available_amount($item[everfull dart holster]) > 0 && my_path().id != PATH_COMMUNITY_SERVICE)
	if (!__iotms_usable[$item[everfull dart holster]]) return;
	
	// Do not show if you're a pig-skinner with the only better freekill red-ray skill
	if (lookupSkill("Free-For-All").have_skill()) return;

	// Gotta have one!
	if (available_amount($item[everfull dart holster]) > 0)
	{
		string [int] description;
		string url = "inventory.php?ftext=everfull+dart_holster";
			
			if ($effect[everything looks red].have_effect() == 0) 
		{
			int dartCooldown = 50;
			if (get_property("everfullDartPerks").contains_text("You are less impressed by bullseyes")) {
				dartCooldown -= 10;
			}
			if (get_property("everfullDartPerks").contains_text("Bullseyes do not impress you much")) {
				dartCooldown -= 10;
			}
			description.listAppend(HTMLGenerateSpanFont("Shoot a bullseye! (" + dartCooldown + " ELR)", "red"));
			if (lookupItem("everfull dart holster").equipped_amount() == 0)
			{
				description.listAppend(HTMLGenerateSpanFont("Equip the dart holster first.", "red"));
			}
			else description.listAppend(HTMLGenerateSpanFont("Dart holster equipped", "blue"));
			task_entries.listAppend(ChecklistEntryMake("__item everfull dart holster", url, ChecklistSubentryMake("Everfull Darts free kill available!", "", description), -11));
		}
	}
}

RegisterResourceGenerationFunction("IOTMEverfullDartsGenerateResource");
void IOTMEverfullDartsGenerateResource(ChecklistEntry [int] resource_entries)
{
	// Don't generate this tile if you have all perks. I added 20 extra because of the way 
	//   degenerate weirdness in zones like ShadowRealm can let you do more turns on accident,
	//   but if you're 20+ over the mark, you absolutely are just doing silly stuff.
	if (get_property_int("dartsThrown") > 420) return;

	// Otherwise, you want the item in hand + in-run flags to exist
	if (__misc_state["in run"] && available_amount($item[everfull dart holster]) > 0)
	{
		// aren't we using dartLevel (ie, square root of dartsThrown, # of perks) colloquially? 
		//   don't really care, this should work fine, just a random thing 
		int dartSkill = get_property_int("dartsThrown");
		string [int] description;
		string url = "inventory.php?ftext=everfull+dart_holster";
			
		if (dartSkill < 401) {
			int dartsNeededForNextPerk = (floor(sqrt(dartSkill)+1) **2 - dartSkill);
			description.listAppend("Current dart skill: " + dartSkill);
			description.listAppend(HTMLGenerateSpanFont(dartsNeededForNextPerk, "blue") + " darts needed for next Perk");

			// TODO: add a list of the high priority perks that aren't there yet. only add in a hoverover tho.
			//   - 5 bullseye perks
			//   - butts perks
			//   - combat perks, in weak paths
		
			if (lookupItem("everfull dart holster").equipped_amount() == 0)
			{
				description.listAppend(HTMLGenerateSpanFont("Equip the dart holster first.", "red"));
			}

			// emojis are fun i will not remove them 🎯
			resource_entries.listAppend(ChecklistEntryMake("__item everfull dart holster", url, ChecklistSubentryMake("🍑🎯 Everfull Dart Holster charging", "", description), 11));
		}
	}
}
