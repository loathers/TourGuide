//Daylight Shavings Helmet

string [int, string] dshBuffOrder = {
	{"Spectacle Moustache": "+50% item and +5 " + HTMLGenerateSpanFont("Spooky", "grey") + " resist"},
	{"Toiletbrush Moustache": "+25 ML and +5 " + HTMLGenerateSpanFont("Stench", "green") + " resist"},
	{"Barbell Moustache": "+25 Muscle and +50% Gear drops"},
	{"Grizzly Beard": "+25-50 MP regen and +5 " + HTMLGenerateSpanFont("Cold", "blue") + " resist"},
	{"Surrealist's Moustache": "+25 Mysticality and +50% Food drops"},
	{"Musician's Musician's Moustache": "+25 Moxie and +50% Booze drops"},
	{"Gull-Wing Moustache": "+100% init and +5 " + HTMLGenerateSpanFont("Hot", "red") + " resist"},
	{"Space Warlord's Beard": "+25 Weapon damage and +10% Crit"},
	{"Pointy Wizard Beard": "+25 Spell damage and +10% Spell Crit"},
	{"Cowboy Stache": "+25 Ranged damage and +50 maximum HP"},
	{"Friendly Chops": "+100% meat and +5 " + HTMLGenerateSpanFont("Sleaze", "purple") + " resist"}
};

// Reorder the default list based on our class
string [int, string] currentClassBuffOrder() {
	string [int, string] beardOrder;
	int classId = my_class().to_int();
	int classIdMod = (classId <= 6) ? classId : (classId % 6 + 1);
	for i from 0 to 10 {
		int nextBeard = (classIdMod * i) % 11;
		beardOrder[i] = dshBuffOrder[nextBeard];
	}
	return beardOrder;
}

// Get our last beard buff and map it into the order for our class
int lastBeardIndex() {
	string lastBeardBuffName = get_property_int("lastBeardBuff").to_effect().name;
	if (lastBeardBuffName == "") {
		return 0;
	}

	foreach i, name in currentClassBuffOrder() {
		if (name == lastBeardBuffName) {
			return i;
		}
	}
	return 0;
}

RegisterTaskGenerationFunction("IOTMDaylightShavingsHelmetGenerateTasks");
void IOTMDaylightShavingsHelmetGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	if (!__misc_state["in run"]) return;
	if (!lookupItem("daylight shavings helmet").have()) return;

	string [int] description;
	string url = "inventory.php?ftext=daylight+shavings+helmet";
	description.listAppend("Shave turns off of your sanity!");

	int beardBuff = get_property_int("lastBeardBuff");

	// Shaving buff prediction
	string [int, string] buffOrder = currentClassBuffOrder();
	string [string] nextBeardBuff = buffOrder[(lastBeardIndex() + 1) % 11];
	string nextBeardBuffDescription;
	string nextBeardBuffEffect;
	foreach nextBeardBuffName in nextBeardBuff {
		nextBeardBuffDescription = nextBeardBuff[nextBeardBuffName];
		nextBeardBuffEffect = nextBeardBuffName + ", " + nextBeardBuffDescription;
	}
	description.listAppend(HTMLGenerateSpanOfClass("Next shavings effect: ", "r_bold") + nextBeardBuffEffect);

	string [int][int] tooltip_table;
	for i from lastBeardIndex() + 1 to lastBeardIndex() + 11 {
		string [string] buff = currentClassBuffOrder()[i % 11];
		string buffDescription;
		foreach buffName in buff {
			buffDescription = buff[buffName];
			tooltip_table.listAppend(listMake(buffName, buffDescription));
		}
	}

	buffer tooltip_text;
	tooltip_text.append(HTMLGenerateTagWrap("div", "DSH beard cycle", mapMake("class", "r_bold r_centre", "style", "padding-bottom:0.25em;")));
	tooltip_text.append(HTMLGenerateSimpleTableLines(tooltip_table));

	if (!lookupItem("daylight shavings helmet").equipped())
		description.listAppend(HTMLGenerateSpanFont("Equip the helmet first.", "red"));
	else
		description.listAppend(HTMLGenerateSpanFont("Your equipped helmet will buff you.", "blue"));

	string beardCycleList = HTMLGenerateSpanOfClass(HTMLGenerateSpanOfClass(tooltip_text, "r_tooltip_inner_class r_tooltip_inner_class_margin") + "Full beard cycle", "r_tooltip_outer_class");
	description.listAppend(beardCycleList);

	if ($effect[Toiletbrush Moustache].have_effect() < 2 && $effect[Barbell Moustache].have_effect() < 2 && $effect[Grizzly Beard].have_effect() < 2 && $effect[Surrealist's Moustache].have_effect() < 2 && $effect[Musician's Musician's Moustache].have_effect() < 2 && $effect[Gull-Wing Moustache].have_effect() < 2 && $effect[Space Warlord's Beard].have_effect() < 2 && $effect[Pointy Wizard Beard].have_effect() < 2 && $effect[Cowboy Stache].have_effect() < 2 && $effect[Friendly Chops].have_effect() < 2 && $effect[Spectacle Moustache].have_effect() < 2) {
		task_entries.listAppend(ChecklistEntryMake("__item daylight shavings helmet", url, ChecklistSubentryMake("Daylight Shavings Helmet buff available", "", description), -11));
	}
	else {
		optional_task_entries.listAppend(ChecklistEntryMake("__item daylight shavings helmet", url, ChecklistSubentryMake("Daylight Shavings Helmet buff charging", "", description), 8));
	}
}