//Daylight Shavings Helmet

string [int, string] dshBuffOrder = {
	{"Spectacle": "+50% item and +5 " + HTMLGenerateSpanFont("Spooky", "grey") + " resist"},
	{"Toiletbrush": "+25 ML and +5 " + HTMLGenerateSpanFont("Stench", "green") + " resist"},
	{"Barbell": "+25 Muscle and +50% Gear drops"},
	{"Grizzly": "+25-50 MP regen and +5 " + HTMLGenerateSpanFont("Cold", "blue") + " resist"},
	{"Surrealist": "+25 Mysticality and +50% Food drops"},
	{"Musician": "+25 Moxie and +50% Booze drops"},
	{"Gull-Wing": "+100% init and +5 " + HTMLGenerateSpanFont("Hot", "red") + " resist"},
	{"Warlord": "+25 Weapon damage and +10% Crit"},
	{"Wizard": "+25 Spell damage and +10% Spell Crit"},
	{"Cowboy": "+25 Ranged damage and +50 maximum HP"},
	{"Friendly": "+100% meat and +5 " + HTMLGenerateSpanFont("Sleaze", "purple") + " resist"}
};

string [string] getNthClassBuff(int n) {
	int classInt = my_class().to_int();
	int buffIndex;
	if (classInt < 7)
	{
		buffIndex = ((classInt * n) % 11);
	}
	else if (classInt > 6)
	{
		buffIndex = ((((classInt % 6 + 1) * n) % 11));
	}
	return dshBuffOrder[buffIndex];
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
	int shavingBuffCounter;
	if (beardBuff == 0)
	{
		shavingBuffCounter = 0;
	}
	else {
		shavingBuffCounter = beardBuff - 2665;
	}

	// Shaving buff prediction
	string [string] nextBeardBuff = getNthClassBuff(shavingBuffCounter + 1);

	string nextBeardBuffDescription;
	string nextBeardBuffEffect;
	foreach nextBeardBuffName in nextBeardBuff {
		nextBeardBuffDescription = nextBeardBuff[nextBeardBuffName];
		nextBeardBuffEffect = nextBeardBuffName + ", " + nextBeardBuffDescription;
	}
	description.listAppend(HTMLGenerateSpanOfClass("Next shavings effect: ", "r_bold") + nextBeardBuffEffect);

	string [int][int] tooltip_table;
	for i from shavingBuffCounter + 1 to shavingBuffCounter + 11 {
		string [string] buff = getNthClassBuff(i);
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