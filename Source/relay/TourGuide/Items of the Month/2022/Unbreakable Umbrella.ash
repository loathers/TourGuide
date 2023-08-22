//Unbreakable Umbrella
RegisterResourceGenerationFunction("IOTMUnbreakableUmbrellaGenerateResource");
void IOTMUnbreakableUmbrellaGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (my_path().id == PATH_G_LOVER) return; // no umbrella in glover
	item unbrella = lookupItem("unbreakable umbrella");
    if (!unbrella.have()) return;
    if (!__misc_state["in run"] && $item[unbreakable umbrella].equipped_amount() == 0) return; 
    string url;
	string unbrellaMode = get_property("umbrellaState");
	string unbrellaEnchant;
	string [int] description;
    url = invSearch("unbreakable umbrella");
    // Title
        string main_title = "Umbrella machine " + HTMLGenerateSpanFont("B", "red") + "roke";
        description.listAppend("Understanda" + HTMLGenerateSpanFont("B", "red") + "le have a nice day.");
		
		switch (get_property("umbrellaState"))
		{
			case "broken":
				int modifiedML = round(numeric_modifier("monster level") * 1.25,0);
				unbrellaEnchant = "+25% ML. Unbrella-boosted ML will be " + modifiedML + "."; break;
			case "forward-facing":
				unbrellaEnchant = "+25 DR shield"; break;
			case "bucket style":
				unbrellaEnchant = "+25% item drops"; break;
			case "pitchfork style":
				unbrellaEnchant = "+25 Weapon Damage"; break;
			case "constantly twirling":
				unbrellaEnchant = "+25 Spell Damage"; break;
			case "cocoon":
				unbrellaEnchant = "-10% Combat Frequency"; break;
		}
		description.listAppend(HTMLGenerateSpanOfClass("Current enchantment: ", "r_bold") + unbrellaMode);
		description.listAppend(HTMLGenerateSpanFont(unbrellaEnchant, "blue") + "");
		resource_entries.listAppend(ChecklistEntryMake("__item unbreakable umbrella", "inventory.php?action=useumbrella&pwd=" + my_hash(), ChecklistSubentryMake(main_title, "", description)));
}