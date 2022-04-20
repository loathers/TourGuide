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
		
		if (locketType == "beast") {
			locketEnchant = "+10% Crit Chance and +20 Muscle";
		}
		else if (locketType == "bug") {
			locketEnchant = "+25% Weapon Damage and +25% max MP";
		}
		else if (locketType == "constellation") {
			locketEnchant = "+10% Spell Crit and +20 Mysticality";
		}
		else if (locketType == "construct") {
			locketEnchant = "+3 Moxie exp and +25 Spell Damage";
		}
		else if (locketType == "demon") {
			locketEnchant = "+25 Hot and +50% Gear drops";
		}
		else if (locketType == "dude") {
			locketEnchant = "+25 Cold and +50% Moxie";
		}
		else if (locketType == "elemental") {
			locketEnchant = "+3 Hot res and +25 Stench Spell";
		}
		else if (locketType == "elf") {
			locketEnchant = "+5 exp and +75% Candy drops";
		}
		else if (locketType == "fish") {
			locketEnchant = "+50% Meat Drops and +25 Spooky Spell";
		}
		else if (locketType == "goblin") {
			locketEnchant = "+25 Stench and +50% Mysticality";
		}
		else if (locketType == "hippy") {
			locketEnchant = "+3 Stench res and +10 DR";
		}
		else if (locketType == "hobo") {
			locketEnchant = "+3 Mysticality exp and +25 Hot Spell";
		}
		else if (locketType == "horror") {
			locketEnchant = "+3 Spooky res and +50 HP";
		}
		else if (locketType == "humanoid") {
			locketEnchant = "+25% Spell Damage and +20 Moxie";
		}
		else if (locketType == "mer-kin") {
			locketEnchant = "+25% Item Drops and +25 Sleaze Spell";
		}
		else if (locketType == "orc") {
			locketEnchant = "+3 Sleaze res and +25 MP";
		}
		else if (locketType == "penguin") {
			locketEnchant = "+3 Muscle exp and +25 Cold Spell";
		}
		else if (locketType == "pirate") {
			locketEnchant = "+50% Booze Drops and +25 Sleaze";
		}
		else if (locketType == "plant") {
			locketEnchant = "+50% Initiative and +50% max HP";
		}
		else if (locketType == "slime") {
			locketEnchant = "+3 Cold res and +50 DA";
		}
		else if (locketType == "undead") {
			locketEnchant = "+25 Spooky and +50% Muscle";
		}
		else if (locketType == "weird") {
			locketEnchant = "+50% Food Drops and +25 Weapon Damage";
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