//prismatic beret
RegisterResourceGenerationFunction("IOTMPrismaticBeretGenerateResource");
void IOTMPrismaticBeretGenerateResource(ChecklistEntry [int] resource_entries)
{
    if ($item[prismatic beret].available_amount() == 0) return;
	
    string url = "inventory.php?ftext=prismatic+beret";
	int busksLeft = clampi(5 - get_property_int("_beretBuskingUses"), 0, 5);
	string [int] description;
	string title = HTMLGenerateSpanFont(busksLeft + " Prismatic Beret Busks", "purple");
	
	int total;
	int shartpower;
	item thing;
	item shart2;
	foreach shart in $slots[shirt] {
		shart2 = equipped_item(shart);
		if (shart2 != $item[none])
		shartpower += get_power(shart2);
	}
	foreach it in $slots[hat, pants] {
		thing = equipped_item(it);
		if (thing != $item[none])
		total += get_power(thing);
	}
	
	if (busksLeft > 0) 
	{
		if (lookupSkill("tao of the terrapin").have_skill()) {
			total = total*2;
		}
		description.listAppend("Gain buffs based on current equipment Power");
		description.listAppend("Currently " + (HTMLGenerateSpanFont(shartpower+total, "blue")) + " Power");
		
		if (lookupItem("prismatic beret").equipped_amount() == 0) {
			description.listAppend(HTMLGenerateSpanFont("Equip the beret to busk!", "red"));
		}
		if (lookupFamiliar("mad hatrack").familiar_is_usable()); {
			description.listAppend(HTMLGenerateSpanFont("(You can put it on your hatrack)", "blue"));
		}
		
		resource_entries.listAppend(ChecklistEntryMake("__item prismatic beret", url, ChecklistSubentryMake(title, "", description)));
	}
}