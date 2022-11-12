//Underground Fireworks Shop
RegisterTaskGenerationFunction("IOTMUndergroundFireworksShopGenerateTasks");
void IOTMUndergroundFireworksShopGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	if (__misc_state["in run"] && __misc_state["can eat just about anything"] && available_amount($item[Clan VIP Lounge key]) > 0 && get_property("_fireworksShop").to_boolean())
	{
		if ($effect[Ready to Eat].have_effect() > 0) 
		{
			string [int] description;
			description.listAppend(HTMLGenerateSpanFont("5x food statgain on the next thing you eat!", "red"));
			description.listAppend(HTMLGenerateSpanFont("Don't waste it on fire crackers!", "red"));
			task_entries.listAppend(ChecklistEntryMake("__effect Ready to Eat", "", ChecklistSubentryMake("Ready to Eat!", "", description), -11));
		}
		if ($effect[Everything Looks Red].have_effect() == 0)
		{
			string [int] description;
			string url = "clan_viplounge.php?action=fwshop&whichfloor=2";
			description.listAppend(HTMLGenerateSpanFont("5x food statgain on the next thing you eat.", "red"));
			optional_task_entries.listAppend(ChecklistEntryMake("__item red rocket", url, ChecklistSubentryMake("Fire a red rocket", "", description), 8));
		}		
		if ($effect[Everything Looks Blue].have_effect() == 0)
		{
			string [int] description;
			string url = "clan_viplounge.php?action=fwshop&whichfloor=2";
			description.listAppend(HTMLGenerateSpanFont("More MP than your body has room for!", "blue"));
			optional_task_entries.listAppend(ChecklistEntryMake("__item blue rocket", url, ChecklistSubentryMake("Fire a blue rocket", "", description), 8));
		}
		if ($effect[Everything Looks Yellow].have_effect() == 0)
		{
			string [int] description;
			string url = "clan_viplounge.php?action=fwshop&whichfloor=2";
			description.listAppend(HTMLGenerateSpanFont("Best yellow ray!", "orange"));
			optional_task_entries.listAppend(ChecklistEntryMake("__item yellow rocket", url, ChecklistSubentryMake("Fire a yellow rocket", "", description), 8));
		}
	}
}

//FIXME: these do not track properly and will remain even when purchased, may fix eventually

RegisterResourceGenerationFunction("IOTMUndergroundFireworksShopGenerateResource");
void IOTMUndergroundFireworksShopGenerateResource(ChecklistEntry [int] resource_entries)
{
	if (!get_property_boolean("_fireworksShopEquipmentBought") && my_path().id != PATH_G_LOVER && available_amount($item[Clan VIP Lounge key]) > 0 && get_property("_fireworksShop").to_boolean())
		{
			string [int] description;
			description.listAppend("Can buy one of the following (1000 meat):");
			description.listAppend("Catherine Wheel: +3 exp back item");
			description.listAppend("Oversized sparkler: +20% item drop club");
			description.listAppend("Rocket boots: +100% initiative accessory");
			resource_entries.listAppend(ChecklistEntryMake("__item oversized sparkler", "clan_viplounge.php?action=fwshop&whichfloor=2", ChecklistSubentryMake("Explosive equipment", description), 8).ChecklistEntrySetIDTag("Clan fireworks equipment resource"));
		}
	if (!get_property_boolean("_fireworksShopHatBought") && my_path().id != PATH_G_LOVER && available_amount($item[Clan VIP Lounge key]) > 0)
		{
			string [int] description;
			description.listAppend("Can buy one of the following (500 meat):");
			description.listAppend("Fedora-mounted mountain: +20 ML hat");
			description.listAppend("Sombrero-mounted sparkler: +5% combat hat");
			description.listAppend("Porkpie-mounted popper: -5% combat hat");
			resource_entries.listAppend(ChecklistEntryMake("__item fedora-mounted mountain", "clan_viplounge.php?action=fwshop&whichfloor=2", ChecklistSubentryMake("Dangerous hats", description), 8).ChecklistEntrySetIDTag("Clan fireworks hat resource"));
		}
}
