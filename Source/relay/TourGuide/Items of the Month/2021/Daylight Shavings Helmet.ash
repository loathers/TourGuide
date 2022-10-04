//Daylight Shavings Helmet
RegisterTaskGenerationFunction("IOTMDaylightShavingsHelmetGenerateTasks");
void IOTMDaylightShavingsHelmetGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if (!__misc_state["in run"]) return;
	if (!lookupItem("daylight shavings helmet").have()) return;
		
		string [int] description;
		int beardBuff = get_property_int("lastBeardBuff");
		string nextBeardBuffEffect;
		int nextBeardBuff = 0;
		string url = "inventory.php?ftext=daylight+shavings+helmet";
		description.listAppend("Shave turns off of your sanity!");
		
		int shavingBuffCounter;
		for i from 2666 to 2676 { 
			shavingBuffCounter = get_property_int("lastBeardBuff")-2665;
		}
		if (beardBuff == 0)
		{
			shavingBuffCounter = 0;
        } 
		// Shaving buff prediction
		if (my_class().to_int() < 7)
		{	
			nextBeardBuff = ((my_class().to_int() + shavingBuffCounter) % 11);
		}	
		else if (my_class().to_int() > 6)
		{	
			nextBeardBuff = ((((my_class().to_int() % 6 +1 + shavingBuffCounter) % 11)));
		}	
		
		string [int][int] tooltip_table;
		tooltip_table.listAppend(listMake("Toiletbrush", "+25 ML and +5 " + HTMLGenerateSpanFont("Stench", "green") + " resist"));
		tooltip_table.listAppend(listMake("Barbell", "+25 Muscle and +50% Gear drops"));
		tooltip_table.listAppend(listMake("Grizzly", "+25-50 MP regen and +5 " + HTMLGenerateSpanFont("Cold", "blue") + " resist"));
		tooltip_table.listAppend(listMake("Surrealist", "+25 Mysticality and +50% Food drops"));
		tooltip_table.listAppend(listMake("Musician", "+25 Moxie and +50% Booze drops"));
		tooltip_table.listAppend(listMake("Gull-Wing", "+100% init and +5 " + HTMLGenerateSpanFont("Hot", "red") + " resist"));
		tooltip_table.listAppend(listMake("Warlord", "+25 Weapon damage and +10% Crit"));
		tooltip_table.listAppend(listMake("Wizard", "+25 Spell damage and +10% Spell Crit"));
		tooltip_table.listAppend(listMake("Cowboy", "+25 Ranged damage and +50 maximum HP"));
		tooltip_table.listAppend(listMake("Friendly", "+100% meat and +5 " + HTMLGenerateSpanFont("Sleaze", "purple") + " resist"));
		tooltip_table.listAppend(listMake("Spectacle", "+50% item and +5 " + HTMLGenerateSpanFont("Spooky", "grey") + " resist"));
			
		// Map buff number to buff result
		switch (nextBeardBuff)			
		{
			case 1:
				nextBeardBuffEffect = "Toiletbrush, +25 ML and +5 " + HTMLGenerateSpanFont("Stench", "green") + " resist"; break;
			case 2:
				nextBeardBuffEffect = "Barbell, +25 Muscle and +50% Gear drops"; break;
			case 3:
				nextBeardBuffEffect = "Grizzly, +25-50 MP regen and +5 " + HTMLGenerateSpanFont("Cold", "blue") + " resist"; break;
			case 4:
				nextBeardBuffEffect = "Surrealist, +25 Mysticality and +50% Food drops"; break;
			case 5:
				nextBeardBuffEffect = "Musician, +25 Moxie and +50% Booze drops"; break;
			case 6:
				nextBeardBuffEffect = "Gull-Wing, +100% init and +5 " + HTMLGenerateSpanFont("Hot", "red") + " resist"; break;
			case 7:
				nextBeardBuffEffect = "Space Warlord, +25 Weapon damage and +10% Crit"; break;
			case 8:
				nextBeardBuffEffect = "Pointy Wizard, +25 Spell damage and +10% Spell Crit"; break;
			case 9:
				nextBeardBuffEffect = "Cowboy, +25 Ranged damage and +50 maximum HP"; break;
			case 10:
				nextBeardBuffEffect = "Friendly, +100% meat and +5 " + HTMLGenerateSpanFont("Sleaze", "purple") + " resist"; break;
			case 0:
				nextBeardBuffEffect = "Spectacle, +50% item and +5 " + HTMLGenerateSpanFont("Spooky", "grey") + " resist"; break;
		}

		buffer tooltip_text;
		tooltip_text.append(HTMLGenerateTagWrap("div", "DSH beard cycle", mapMake("class", "r_bold r_centre", "style", "padding-bottom:0.25em;")));
		tooltip_text.append(HTMLGenerateSimpleTableLines(tooltip_table));
			
		string beardCycleList = HTMLGenerateSpanOfClass(HTMLGenerateSpanOfClass(tooltip_text, "r_tooltip_inner_class r_tooltip_inner_class_margin") + "Full beard cycle", "r_tooltip_outer_class");
		
		if (!lookupItem("daylight shavings helmet").equipped())
			description.listAppend(HTMLGenerateSpanFont("Equip the helmet first.", "red"));
		else
			description.listAppend(HTMLGenerateSpanFont("Your equipped helmet will buff you.", "blue"));
	if ($effect[Toiletbrush Moustache].have_effect() < 2 && $effect[Barbell Moustache].have_effect() < 2 && $effect[Grizzly Beard].have_effect() < 2 && $effect[Surrealist's Moustache].have_effect() < 2 && $effect[Musician's Musician's Moustache].have_effect() < 2 && $effect[Gull-Wing Moustache].have_effect() < 2 && $effect[Space Warlord's Beard].have_effect() < 2 && $effect[Pointy Wizard Beard].have_effect() < 2 && $effect[Cowboy Stache].have_effect() < 2 && $effect[Friendly Chops].have_effect() < 2 && $effect[Spectacle Moustache].have_effect() < 2) {
		description.listAppend(HTMLGenerateSpanOfClass("Next shavings effect: ", "r_bold") + nextBeardBuffEffect);
		description.listAppend(beardCycleList);
		task_entries.listAppend(ChecklistEntryMake("__item daylight shavings helmet", url, ChecklistSubentryMake("Daylight Shavings Helmet buff available", "", description), -11));
	}
	else {
		description.listAppend(HTMLGenerateSpanOfClass("Next shavings effect: ", "r_bold") + nextBeardBuffEffect);
		description.listAppend(beardCycleList);
		optional_task_entries.listAppend(ChecklistEntryMake("__item daylight shavings helmet", url, ChecklistSubentryMake("Daylight Shavings Helmet buff charging", "", description), 8));
	}
}