//Combat lover's locket
RegisterResourceGenerationFunction("IOTMCombatLoversLocketGenerateResource");
void IOTMCombatLoversLocketGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (!lookupItem("combat lover's locket").have()) return;
	{
		// Title
        string title = "Combat lover's locket reminiscence";
		string [int] options;
		string [int] description;
        string url = "inventory.php?reminisce=1";
		string locketType = (get_property("locketPhylum"));
		string locketEnchant;
		switch (get_property("locketPhylum"))
		{
			case "beast":
				locketEnchant = "+10% Crit Chance and +20 Muscle"; break;
			case "bug":
				locketEnchant = "+25% Weapon Damage and +25% max MP"; break;
			case "constellation":
				locketEnchant = "+10% Spell Crit and +20 Mysticality"; break;
			case "construct":
				locketEnchant = "+3 Moxie exp and +25 Spell Damage"; break;
			case "demon":
				locketEnchant = HTMLGenerateSpanFont("+25 Hot", "red") + " and  +50% Gear drops"; break;
			case "dude":
				locketEnchant = HTMLGenerateSpanFont("+25 Cold", "cold") + " and  +50% Moxie"; break;
			case "elemental":
				locketEnchant = HTMLGenerateSpanFont("+3 Hot res", "red") + " and " + HTMLGenerateSpanFont("+25 Stench Spell", "dark green"); break;
			case "elf":
				locketEnchant = "+5 exp and +75% Candy drops"; break;
			case "fish":
				locketEnchant = "+50% Meat Drops and " + HTMLGenerateSpanFont("+25 Spooky Spell", "grey"); break;
			case "goblin":
				locketEnchant = HTMLGenerateSpanFont("+25 Stench", "dark green") + " and  +50% Mysticality"; break;
			case "hippy":
				locketEnchant = HTMLGenerateSpanFont("+3 Stench res", "dark green") + " and  +10 DR"; break;
			case "hobo":
				locketEnchant = "+3 Mysticality exp and " + HTMLGenerateSpanFont("+25 Hot Spell", "red"); break;
			case "horror":
				locketEnchant = HTMLGenerateSpanFont("+3 Spooky res", "grey") + " and  +50 HP"; break;
			case "humanoid":
				locketEnchant = "+25% Spell Damage and +20 Moxie"; break;
			case "mer-kin":
				locketEnchant = "+25% Item Drops and " + HTMLGenerateSpanFont("+25 Sleaze Spell", "purple"); break;
			case "orc":
				locketEnchant = HTMLGenerateSpanFont("+3 Sleaze res", "purple") + " and +25 MP"; break;
			case "penguin":
				locketEnchant = "+3 Muscle exp and " + HTMLGenerateSpanFont("+25 Cold Spell", "blue"); break;
			case "pirate":
				locketEnchant = "+50% Booze Drops and " + HTMLGenerateSpanFont("+25 Sleaze", "purple"); break;
			case "plant":
				locketEnchant = "+50% Initiative and +50% max HP"; break;
			case "slime":
				locketEnchant = HTMLGenerateSpanFont("+3 Cold res", "cold") + " and  +50 DA"; break;
			case "undead":
				locketEnchant = HTMLGenerateSpanFont("+25 Spooky", "grey") + " and  +50% Muscle"; break;
			case "weird":
				locketEnchant = "+50% Food Drops and +25 Weapon Damage"; break;
		}
		
		description.listAppend(HTMLGenerateSpanOfClass("Current enchantment: ", "r_bold") + locketType);
		description.listAppend(HTMLGenerateSpanFont(locketEnchant, "blue") + "");
		
		// Entries
		int monstersReminisced = clampi(3 - count(split_string(get_property("_locketMonstersFought"), ",")), 0, 3);
		if (get_property("_locketMonstersFought") == "") {
			resource_entries.listAppend(ChecklistEntryMake("__item combat lover's locket", url, ChecklistSubentryMake("" + "3 Combat lover's locket reminiscences", "", description)).ChecklistEntrySetIDTag("Locket fax resource"));
		}
		else {
			if (monstersReminisced > 0) 
			{
				if (__misc_state["in run"] && my_path_id() != PATH_COMMUNITY_SERVICE) {
					options.listAppend(HTMLGenerateSpanOfClass("Fax replacements", "r_bold") + "");
					options.listAppend("Black crayon scalers, any phylum");
					options.listAppend("Frat warrior outfit, if no numberology");
					options.listAppend("Mountain man");
					options.listAppend("Ninja snowman assassin");
					options.listAppend("Swarm of ghuol whelps");
					options.listAppend("Sausage goblin");
					options.listAppend("Baa'baa'bu'ran");
					options.listAppend("Forest spirit (for a machete, with some free crafts)");
					options.listAppend(HTMLGenerateSpanOfClass("Map replacements:", "r_bold") + "");
					options.listAppend("Astronomer OR camel's toe OR skinflute");
					options.listAppend("Lobsterfrogman");
					options.listAppend("Beanbat");
					options.listAppend("Dairy goat");
					options.listAppend("Blur");
					options.listAppend("Lynyrd skinner");
				}
				if (options.count() > 0) {
					description.listAppend("Rain Man the IotM:|*" + options.listJoinComponents("|*"));
				}
				resource_entries.listAppend(ChecklistEntryMake("__item combat lover's locket", url, ChecklistSubentryMake(pluralise(monstersReminisced, "Combat lover's locket reminiscence", "Combat lover's locket reminiscences"), "", description), 5).ChecklistEntrySetIDTag("Locket fax resource"));
			}
		}
	}
}