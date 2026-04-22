//blood cubic zirconia
RegisterTaskGenerationFunction("IOTMBloodCubicZirconiaGenerateTasks");
void IOTMBloodCubicZirconiaGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    // TODO: reorganize/update tile; obvious changes include:
    //   - maybe update the cost matrix structure, seems a lil silly
    //   - add refract recommendation system
    //   - shorten resource tile by switching the less-useful uses into a hoverover
    //   - small wording tweaks 


	if (!__iotms_usable[lookupItem("blood cubic zirconia")]) return;
	string url = "inventory.php?ftext=blood+cubic+zirconia";
	string [int] description;
	int bczRefracts = get_property_int("_bczRefractedGazeCasts");
	int bczBullets = get_property_int("_bczSweatBulletsCasts");
	int bczEquitys = get_property_int("_bczSweatEquityCasts");
	
	int [int] bloodCast = {
        0:11, 1:23, 2:37, 3:110, 4:230, 
        5:370, 6:1100, 7:2300, 8:3700, 9:11000, 
        10:23000, 11:37000, 12:420000, 13:1100000, 14:2300000,
        15:3700000};
    int refractCost = bloodCast[min(bczRefracts, 15)];
	int bulletCost = bloodCast[min(bczBullets, 15)];
	int equityCost = bloodCast[min(bczEquitys, 15)];
	
	if (gemstoneInCodpiece(lookupItem("blood cubic zirconia"))) description.listAppend("Currently in <b>Eternity Codpiece</b>");
	
	if (gemstoneEquipped(lookupItem("blood cubic zirconia")))
	{
		if (bczRefracts < 13) {
			description.listAppend("Next Refract costs " + HTMLGenerateSpanFont(refractCost + "", "red") + " mys");
		}
		else if (bczRefracts >= 13) {
			description.listAppend(HTMLGenerateSpanFont("Next Refract costs " + refractCost + " mys. EXPENSIVE!", "red") + "");
		}
			if (lookupItem("monodent of the sea").equipped_amount() == 0)
			{
				description.listAppend(HTMLGenerateSpanFont("Seadent not equipped", "red"));		
			}
			else if (lookupItem("monodent of the sea").equipped_amount() > 0)
			{
				description.listAppend(HTMLGenerateSpanFont("Seadent FLEESH ok!", "blue"));		
			}
		if (bczBullets < 13) {
			description.listAppend("Next Bullet costs " + HTMLGenerateSpanFont(bulletCost + "", "red") + " mox");
		}
		else if (bczBullets >= 13) {
			description.listAppend(HTMLGenerateSpanFont("Next Bullet costs " + bulletCost + " mox. EXPENSIVE!", "red") + "");
		}
		if (bczEquitys < 13) {
			description.listAppend("Next Equity costs " + HTMLGenerateSpanFont(equityCost + "", "red") + " mox");
		}
		else if (bczEquitys >= 13) {
			description.listAppend(HTMLGenerateSpanFont("Next Equity costs " + equityCost + " mox. EXPENSIVE!", "red") + "");
		}
		// This was originally a supernag but I simply will not let this be -always- on my screen.	
		task_entries.listAppend(ChecklistEntryMake("__item blood cubic zirconia", url, ChecklistSubentryMake(HTMLGenerateSpanFont("BCZ: Blood Cubic Zirconia skills", "brown"), description), 11).ChecklistEntrySetIDTag("bcz important skills"));
	}
}

RegisterResourceGenerationFunction("IOTMBloodCubicZirconiaGenerateResource");
void IOTMBloodCubicZirconiaGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (!__iotms_usable[lookupItem("blood cubic zirconia")]) return;
	string url = "inventory.php?ftext=blood+cubic+zirconia";
	string [int] description;
	int bczBaths = get_property_int("_bczBloodBathCasts");
	int bczThinners = get_property_int("_bczBloodThinnerCasts");
	int bczDials = get_property_int("_bczDialitupCasts");
	int bczPheromones = get_property_int("_bczPheromoneCocktailCasts");
	int bczSpinalTapas = get_property_int("_bczSpinalTapasCasts");
	int bczGeysers = get_property_int("_bczBloodGeyserCasts");
	int bczRefracts = get_property_int("_bczRefractedGazeCasts");
	int bczBullets = get_property_int("_bczSweatBulletsCasts");
	int bczEquitys = get_property_int("_bczSweatEquityCasts");

	int [int] bloodCast = {
        0:11, 1:23, 2:37, 3:110, 4:230, 
        5:370, 6:1100, 7:2300, 8:3700, 9:11000, 
        10:23000, 11:37000, 12:420000, 13:1100000, 14:2300000,
        15:3700000};
    int bathCost = bloodCast[min(bczBaths, 15)];
	int thinnerCost = bloodCast[min(bczThinners, 15)];
	int dialCost = bloodCast[min(bczDials, 15)];
	int pheromoneCost = bloodCast[min(bczPheromones, 15)];
	int tapasCost = bloodCast[min(bczSpinalTapas, 15)];
	int geyserCost = bloodCast[min(bczGeysers, 15)];
	int refractCost = bloodCast[min(bczRefracts, 15)];
	int bulletCost = bloodCast[min(bczBullets, 15)];
	int equityCost = bloodCast[min(bczEquitys, 15)];
	
	if (gemstoneInCodpiece(lookupItem("blood cubic zirconia"))) description.listAppend("Currently in <b>Eternity Codpiece</b>");
	
	description.listAppend("Next Refract costs " + HTMLGenerateSpanFont(refractCost + "", "red") + " mys");
	description.listAppend("Next Bullet costs " + HTMLGenerateSpanFont(bulletCost + "", "red") + " mox");
	description.listAppend("Next Equity costs " + HTMLGenerateSpanFont(equityCost + "", "red") + " mox");
	
	description.listAppend("Next Geyser costs " + HTMLGenerateSpanFont(geyserCost + "", "brown") + " mus");
	description.listAppend("Next Bath costs " + HTMLGenerateSpanFont(bathCost + "", "brown") + " mus");
	description.listAppend("Next Dial costs " + HTMLGenerateSpanFont(dialCost + "", "brown") + " mys");
	description.listAppend("Next Thinner costs " + HTMLGenerateSpanFont(thinnerCost + "", "brown") + " mus");
	description.listAppend("Next Tapas costs " + HTMLGenerateSpanFont(tapasCost + "", "brown") + " mys");
	description.listAppend("Next Pheromone costs " + HTMLGenerateSpanFont(pheromoneCost + "", "brown") + " mox");
		
	resource_entries.listAppend(ChecklistEntryMake("__item blood cubic zirconia", url, ChecklistSubentryMake(HTMLGenerateSpanFont("BCZ: Blood Cubic Zirconia skills", "brown"), description), 11).ChecklistEntrySetIDTag("bcz important skills"));
	
	int pheromoneBlasts = get_property_int("markYourTerritoryCharges");
	if (pheromoneBlasts > 0)
    {
		resource_entries.listAppend(ChecklistEntryMake("__skill mark your territory", "", ChecklistSubentryMake(pluralise(pheromoneBlasts, "cast of Mark Your Territory", "casts of Mark Your Territory"), "drink pheromone cocktails for more charges!", "Turn-taking item-destroying kill, all-day banish."), 0).ChecklistEntrySetCombinationTag("banish").ChecklistEntrySetIDTag("BCZ pheromone banish"));
    }

	// Freekill combination tile entry.
	string header = "BCZ: Sweat Bullets";
	string subtitle;
	string [int] bulletDesc;

	if (bczBullets > 0) subtitle= "have used "+pluralise(bczBullets,"bullet","bullets")+" today";

	bulletDesc.listAppend("Win a fight without taking a turn.");
	bulletDesc.listAppend("Next bullet costs "+bulletCost+" moxie substats");
	if (!gemstoneEquipped(lookupItem("blood cubic zirconia"))) 
		bulletDesc.listAppend(HTMLGenerateSpanFont("Equip the Blood Cubic Zirconia first", "red"));

	resource_entries.listAppend(ChecklistEntryMake("__item blood cubic zirconia", url, ChecklistSubentryMake(header,subtitle,bulletDesc)).ChecklistEntrySetCombinationTag("free instakill"));

	// void showShadowBrickFreeKills(ChecklistEntry [int] resource_entries) {
	// 	int shadowBricks = available_amount($item[shadow brick]);
	// 	int shadowBrickUsesLeft = clampi(13 - get_property_int("_shadowBricksUsed"), 0, 13);
	// 	if ($item[shadow brick].available_amount() > 0) {
	// 		string header = $item[shadow brick].pluralise().capitaliseFirstLetter();
	// 		if (shadowBrickUsesLeft < shadowBricks) {
	// 			if (shadowBrickUsesLeft == 0)
	// 				header += " (not usable today)";
	// 			else
	// 				header += " (" + shadowBrickUsesLeft + " usable today)";
	// 		}
	// 	resource_entries.listAppend(ChecklistEntryMake("__item shadow brick", "", ChecklistSubentryMake(header, "", "Win a fight without taking a turn.")).ChecklistEntrySetCombinationTag("free instakill"));
    // 	}
	// }
}