//CyberRealm
RegisterTaskGenerationFunction("IOTYCyberRealmGenerateTasks");
void IOTYCyberRealmGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries) {

	if (!__iotms_usable[$item[CyberRealm keycode]]) return;
	
	int CyberFree = get_property_int("_cyberFreeFights");
	int zone1Turns = get_property_int("_cyberZone1Turns");
	int zone2Turns = get_property_int("_cyberZone2Turns");
	int zone3Turns = get_property_int("_cyberZone3Turns");
	int CyberZoneLeft = zone1turns + zone2turns + zone3turns;
	string [int] description;
	string url = "place.php?whichplace=CyberRealm";
	string image_name = "__skill stats+++";
		
	if (lookupItem("familiar-in-the-middle wrapper").have() && !lookupItem("familiar-in-the-middle wrapper").equipped()) {
		description.listAppend(HTMLGenerateSpanFont("Equip your FITMW for an extra 1 per fight.", "red"));
	}
	
	if (zone1Turns < 9) {
		description.listAppend(9 - zone1Turns + " combats until Zone 1 Eleres test.");
	}	else if (zone1Turns == 9) {
		description.listAppend(HTMLGenerateSpanFont("Get 11 eleres for the Cyberzone 1 test", "blue"));
		image_name = "__skill overclock(10)";
	}	else if (zone1Turns < 19) {
		description.listAppend(19 - zone1Turns + " combats until Zone 1 reward.");
	}	else if (zone1Turns == 19) {
		description.listAppend(HTMLGenerateSpanFont("Cyberzone 1 reward!", "green"));
		image_name = "__skill sleep(5)";
	}	else if (zone1Turns > 19) {
		description.listAppend(HTMLGenerateSpanFont("Cyberzone 1 finished.", "grey"));
	}

	if (zone2Turns < 9) {
		description.listAppend(9 - zone2Turns + " combats until Zone 2 Eleres test.");
	}	else if (zone2Turns == 9)	{
		description.listAppend(HTMLGenerateSpanFont("Get 11 eleres for the Cyberzone 2 test", "blue"));
		image_name = "__skill overclock(10)";
	}	else if (zone2Turns < 19) {
		description.listAppend(19 - zone2Turns + " combats until Zone 2 reward.");
	}	else if (zone2Turns == 19) {
		description.listAppend(HTMLGenerateSpanFont("Cyberzone 2 reward!", "green"));
		image_name = "__skill sleep(5)";
	} else if (zone2Turns > 19) {
		description.listAppend(HTMLGenerateSpanFont("Cyberzone 2 finished.", "grey"));
	}

	if (zone3Turns < 9) {
		description.listAppend(9 - zone3Turns + " combats until Zone 3 Eleres test.");
	}	else if (zone3Turns == 9)	{
		description.listAppend(HTMLGenerateSpanFont("Get 11 eleres for the Cyberzone 3 test", "blue"));
		image_name = "__skill overclock(10)";
	}	else if (zone3Turns < 19) {
		description.listAppend(19 - zone3Turns + " combats until Zone 3 reward.");
	}	else if (zone3Turns == 19) {
		description.listAppend(HTMLGenerateSpanFont("Cyberzone 3 reward!", "green"));
		image_name = "__skill sleep(5)";
	}	else if (zone3Turns > 19) {
		description.listAppend(HTMLGenerateSpanFont("Cyberzone 3 finished.", "grey"));
	}

	if ($locations[Cyberzone 1,Cyberzone 2,Cyberzone 3] contains __last_adventure_location) {
		description.listAppend(HTMLGenerateSpanFont("Have " + (10 - CyberFree) + " free fights left!", "green"));
		task_entries.listAppend(ChecklistEntryMake(image_name, url, ChecklistSubentryMake(60 - CyberZoneLeft + " CyberRealm adventures!", "", description), -11));
	}	else {
		if (get_property_int("_cyberFreeFights") < 10 && lookupSkill("OVERCLOCK(10)").have_skill()) {
			description.listAppend(HTMLGenerateSpanFont("Have " + (10 - CyberFree) + " free fights left!", "green"));
		} else {
			description.listAppend(HTMLGenerateSpanFont("No free fights left", "red"));
		}
		optional_task_entries.listAppend(ChecklistEntryMake(image_name, url, ChecklistSubentryMake(60 - CyberZoneLeft + " CyberRealm adventures!", "", description), 10));
	}
}

RegisterResourceGenerationFunction("IOTYCyberRealmFreeFightsGenerateResource");
void IOTYCyberRealmFreeFightsGenerateResource(ChecklistEntry [int] resource_entries) {

	if (!__iotms_usable[$item[CyberRealm keycode]]) return;
	
	int CyberFree = clampi(10 - get_property_int("_cyberFreeFights"), 0, 10);
	string url;
	string [int] description;

	if (CyberFree > 0 && lookupSkill("OVERCLOCK(10)").skill_is_usable()) {
		string url = "place.php?whichplace=CyberRealm";
		description.listAppend("Hack into the system!");
		resource_entries.listAppend(ChecklistEntryMake("__skill stats+++", url, ChecklistSubentryMake(pluralise(CyberFree, "CyberRealm fight", "CyberRealm fights"), "", description), 8).ChecklistEntrySetCombinationTag("daily free fight").ChecklistEntrySetIDTag("CyberRealm free fight"));
	}
}
