//lucky gold ring
RegisterResourceGenerationFunction("LuckyGoldRingGenerateResource");
void LuckyGoldRingGenerateResource(ChecklistEntry [int] resource_entries)
{
	if ($item[lucky gold ring].available_amount() > 0) {
		int lgrBeachBuck = (get_property_int("_luckyGoldRingBeachBuck"));
		int lgrCyberBit = (get_property_int("_luckyGoldRingBit"));
		int lgrCoinspiracy = (get_property_int("_luckyGoldRingCoinspiracy"));
		int lgrFreddy = (get_property_int("_luckyGoldRingFreddy"));
		int lgrFunfund = (get_property_int("_luckyGoldRingFunFunds"));
		int lgrHoboNickel = (get_property_int("_luckyGoldRingHoboNickel"));
		int lgrMeat = (get_property_int("_luckyGoldRingMeat"));
		int lgrRubee = (get_property_int("_luckyGoldRingRubee"));
		int lgrSandDollar = (get_property_int("_luckyGoldRingSandDollar"));
		int lgrVolcoino = (get_property_int("_luckyGoldRingVolcoino"));
		int lgrWalMart = (get_property_int("_luckyGoldRingWalmart"));
		
		string url;
		string [int] description;
		
		if (lookupItem("lucky gold ring").equipped_amount() == 0)
		{
			description.listAppend(HTMLGenerateSpanFont("LGR not equipped.", "red"));
		} else if (lookupItem("lucky gold ring").equipped_amount() > 0)
		{
			description.listAppend(HTMLGenerateSpanFont("LGR equipped!", "blue"));
		}
		
		if (locationAvailable($location[the fun-guy mansion])) {
			if (lgrBeachBuck == 25) {
				description.listAppend(HTMLGenerateSpanFont(lgrBeachBuck + "/25 Beach Bucks", "grey"));
			} else {
				description.listAppend(HTMLGenerateSpanFont(lgrBeachBuck + "/25 Beach Bucks", "black"));
			}
		}
		if (locationAvailable($location[cyberzone 1])) {
			if (lgrCyberBit == 10) {
				description.listAppend(HTMLGenerateSpanFont(lgrCyberBit + "/10 Cyberrealm Bits", "grey"));
			} else {
				description.listAppend(HTMLGenerateSpanFont(lgrCyberBit + "/10 Cyberrealm Bits", "black"));
			}
		}
		if (locationAvailable($location[the deep dark jungle])) {		
			if (lgrCoinspiracy == 25) {
				description.listAppend(HTMLGenerateSpanFont(lgrCoinspiracy + "/25 Coins-spiracy", "grey"));
			} else {
				description.listAppend(HTMLGenerateSpanFont(lgrCoinspiracy + "/25 Coins-spiracy", "black"));
			}
		}
		if (locationAvailable($location[barf mountain])) {
			if (lgrFunfund == 15) {
				description.listAppend(HTMLGenerateSpanFont(lgrFunfund + "/15 FunFunds", "grey"));
			} else {
				description.listAppend(HTMLGenerateSpanFont(lgrFunfund + "/15 FunFunds", "black"));
			}
		}
		if (get_property_boolean("frAlways")) {
			if (lgrRubee == 10) {
				description.listAppend(HTMLGenerateSpanFont(lgrRubee + "/10 Rubees", "grey"));
			} else {
				description.listAppend(HTMLGenerateSpanFont(lgrRubee + "/10 Rubees", "black"));
			}
		}
		if (locationAvailable($location[the smooch army HQ])) {
			if (lgrVolcoino == 2) {
				description.listAppend(HTMLGenerateSpanFont(lgrVolcoino + "/2 Volcoinos", "grey"));
			} else {
				description.listAppend(HTMLGenerateSpanFont(lgrVolcoino + "/2 Volcoinos", "black"));
			}
		}
		if (locationAvailable($location[the ice hotel])) {
			if (lgrWalMart == 15) {
				description.listAppend(HTMLGenerateSpanFont(lgrWalMart + "/15 Wal-Mart GCs", "grey"));
			} else {
				description.listAppend(HTMLGenerateSpanFont(lgrWalMart + "/15 Wal-Mart GCs", "black"));
			}
		}
		if ($item[Freddy Kruegerand].available_amount() > 0) {
			description.listAppend(HTMLGenerateSpanFont(lgrFreddy + "x Freddy Kruegerands", "black"));
		}
		if ($item[hobo nickel].available_amount() > 0) {
			description.listAppend(HTMLGenerateSpanFont(lgrHoboNickel + "x Hobo Nickels", "black"));
			}
		if ($item[sand dollar].available_amount() > 0) {
			description.listAppend(HTMLGenerateSpanFont(lgrSandDollar + "x sand dollars", "black"));
		}
		description.listAppend(HTMLGenerateSpanFont(lgrMeat + "x meat", "black"));
		
		resource_entries.listAppend(ChecklistEntryMake("__item lucky gold ring", url, ChecklistSubentryMake("Lucky gold ring drops", description), 999));
	}
}
