//peridot of peril
RegisterTaskGenerationFunction("IOTMPeridotGenerateTasks");
void IOTMPeridotGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	// TODO: tile additions 
	//   - add a resource tile outlining useful monsters currently accessible w/ peridot
	//   - not a tile addition, but add a peridot icon to location bar if you can use peridot in the zone

	if (!__iotms_usable[lookupItem("Peridot of Peril")]) return;
	string url = "inventory.php?ftext=peridot+of+peril";
	string [int] description;
	
	if (lookupItem("peridot of peril").equipped_amount() == 1)
	{
		description.listAppend(HTMLGenerateSpanFont("PERIDOT POWER!", "green"));
		string main_title = HTMLGenerateSpanFont("Peridot picking power", "green");
		task_entries.listAppend(ChecklistEntryMake("__item peridot of peril", "", ChecklistSubentryMake(main_title, description), -11).ChecklistEntrySetIDTag("peridot task"));
	}
	else if (lookupItem("peridot of peril").equipped_amount() == 0 && (__misc_state["in run"]))
	{
		description.listAppend(HTMLGenerateSpanFont("Equip the peridot to map monsters", "red"));
		optional_task_entries.listAppend(ChecklistEntryMake("__item peridot of peril", "", ChecklistSubentryMake("Peridot picking power", description), 10).ChecklistEntrySetIDTag("peridot task"));
	}
}

Record PeriFight 
{
    location zone;
    monster target;
    boolean useful;
    boolean canAdv;
	boolean periUsed;
};

PeriFight makePeriFight(string z, string mon, boolean useful) {
	PeriFight final;

	final.zone = lookupLocation(z);
	final.target = lookupMonster(mon);
	final.useful = useful;
	final.canAdv = can_adventure(final.zone);
	final.periUsed = false;

	foreach key,place in get_property("_perilLocations").split_string(",") {
		if (place.to_int() == final.zone.to_int()) final.periUsed = true;
	}

	return final;
}

void listAppend(PeriFight [int] list, PeriFight entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

string stringPeriFight (PeriFight entry) {
	return entry.target.to_string()+" "+HTMLGenerateSpanFont("("+entry.zone.to_string()+")", "0.5em");
}

RegisterResourceGenerationFunction("IOTMPeridotGenerateResource");
void IOTMPeridotGenerateResource(ChecklistEntry [int] resource_entries) {
	if (!__iotms_usable[lookupItem("Peridot of Peril")]) return;
    
	boolean peridotEquipped = lookupItem("peridot of peril").equipped_amount() > 0;
	string [int] perilLocations = get_property("_perilLocations").split_string(",");

	string title = "Use your Peridot of Peril";
	string subtitle = "once a day in every zone";
    string url = peridotEquipped ? "main.php" : "inventory.php?ftext=peridot+of+peril";
    string [int] description;
    PeriFight [int] periFolks;
	string [int] peridotPicks;
	string pp = HTMLGenerateSpanFont("❖ ","green");

	// Populate periFolks, level by level...
	// Level 5 (none for 2, 3, 4...)
	periFolks.listAppend(makePeriFight("Cobb's Knob Harem","Knob Goblin Harem Girl",!have_outfit_components("Knob Goblin Harem Girl Disguise")));
	// Level 7 (none for 6...)
	periFolks.listAppend(makePeriFight("The Defiled Niche","dirty old lihc",!__quest_state["Cyrpt"].state_boolean["niche finished"]));
	periFolks.listAppend(makePeriFight("The Defiled Nook","toothy sklelton",!__quest_state["Cyrpt"].state_boolean["nook finished"]));
	// Level 9 (none for 8...)
	periFolks.listAppend(makePeriFight("Twin Peak","bearpig topiary animal",get_property_int("twinPeakProgress") < 14));
	// Level 10
	periFolks.listAppend(makePeriFight("The Beanbat Chamber","beanbat",!__quest_state["Level 10"].state_boolean["beanstalk grown"] && $item[enchanted bean].available_amount() == 0));
	periFolks.listAppend(makePeriFight("The Penultimate Fantasy Airship","quiet healer",__quest_state["Castle"].mafia_internal_step < 7));
	// Level 11 (unlocks)
	periFolks.listAppend(makePeriFight("The Hidden Temple","baa-relief sheep",!get_property_ascension("lastTempleUnlock")));
	// Level 11 (spookyraven)
	periFolks.listAppend(makePeriFight("The Haunted Library","writing desk",!get_property_ascension("lastSecondFloorUnlock")));
	periFolks.listAppend(makePeriFight("The Haunted Bedroom","animated ornate nightstand",$location[the haunted ballroom].turnsAttemptedInLocation() == 0 && $item[Lady Spookyraven's finest gown].available_amount() == 0));
	periFolks.listAppend(makePeriFight("The Haunted Wine Cellar","possessed wine rack",__quest_state["Level 11 Manor"].mafia_internal_step < 4 && $items[wine bomb, unstable fulminate, bottle of Chateau de Vinegar].available_amount() == 0));
	periFolks.listAppend(makePeriFight("The Haunted Laundry Room","cabinet of Dr. Limpieza",__quest_state["Level 11 Manor"].mafia_internal_step < 4 && $items[wine bomb, unstable fulminate, blasting soda].available_amount() == 0));
	periFolks.listAppend(makePeriFight("The Haunted Boiler Room","monstrous boiler",__quest_state["Level 11 Manor"].mafia_internal_step < 4 && $item[wine bomb].available_amount() != 0));
	// Level 11 (hidden city)
	periFolks.listAppend(makePeriFight("The Hidden Bowling Alley","pygmy bowler",get_property_int("hiddenBowlingAlleyProgress") < 6));
	periFolks.listAppend(makePeriFight("The Hidden Hospital","pygmy witch surgeon",get_property_int("hiddenHospitalProgress") < 6));
	periFolks.listAppend(makePeriFight("The Hidden Office Building","pygmy witch accountant",get_property_int("hiddenOfficeProgress") < 6));
	// Level 11 (zeppelin)
    // todo: red butler
	// Level 11 (palindome)
	periFolks.listAppend(makePeriFight("Inside the Palindome","racecar bob",!__quest_state["Level 11 Palindome"].finished));
	// Level 12 
    // todo: gremlins

	foreach key,entry in periFolks {
		if (entry.useful && entry.canadv) {
			string color = entry.periUsed ? "gray" : "black";
			peridotPicks.listAppend(HTMLGenerateSpanFont(stringPeriFight(entry),color, "0.9em"));
		}
	}

	// If no Peridot Picks, no resource tile
	if (peridotPicks.count() == 0) return;

	description.listAppend("Select relevant, available monsters!");
	if (!peridotEquipped) description.listAppend(HTMLGenerateSpanFont("Equip your Peridot of Peril","red"));
	description.listAppend("<hr>|*"+pp+peridotPicks.listJoinComponents("<hr>|*"+pp));

	resource_entries.listAppend(ChecklistEntryMake("__item Peridot of Peril", url, ChecklistSubentryMake(title, subtitle, description), 14).ChecklistEntrySetIDTag("peridot picking helper"));

}