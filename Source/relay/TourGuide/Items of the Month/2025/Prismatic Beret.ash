//prismatic beret

string [string] modifierMapping;


modifierMapping["Item Drop"] = "% item";
modifierMapping["Meat Drop"] = "% meat";
modifierMapping["Initiative"] = "% init";
modifierMapping["Familiar Weight"] = " fam wt";
modifierMapping["Familiar Experience"] = " fam xp";

string generateBuffDescription(effect currEffect) {
	string output = "<b>"+currEffect.name+"</b>";
	string [int] relevantMods;
	int modLevel = 0;
	foreach modifier, shortmod in modifierMapping {
		modLevel = numeric_modifier(currEffect, modifier).to_int();
		if (modLevel > 0) relevantMods.listAppend(modLevel+shortmod);
	}
	if (relevantMods.count() > 0) output += ": "+listJoinComponents(relevantMods,", ");

	return output;
}

string [int] generateBuskDescription(int [effect] currentBusks) {
	string [int] output;

	foreach busk,turns in currentBusks {
		if (busk == $effect[none]) {
			output.listAppend("Busk now for "+turns+" meat, and these effects:");
		} else if (busk == $effect[dirty pear]) {
			output.listAppend("|*<b>Dirty Pear</b>: Doubles "+HTMLGenerateSpanFont("sleaze damage", "r_element_sleaze"));
		} else {
			string color = have_effect(busk) > 0 ? "gray" : "black";
			output.listAppend("|*"+generateBuffDescription(busk));
		}

	}

	return output;
}

RegisterResourceGenerationFunction("IOTMPrismaticBeretGenerateResource");
void IOTMPrismaticBeretGenerateResource(ChecklistEntry [int] resource_entries)
{
	// TODO: tile additions 
	//   - maybe add easily accessible hats/pants too

	if (!__iotms_usable[lookupItem("prismatic beret")]) return;
	
    string url = "inventory.php?ftext=prismatic+beret";
	int busksLeft = clampi(5 - get_property_int("_beretBuskingUses"), 0, 5);
	string title = HTMLGenerateSpanFont(busksLeft + " Prismatic Beret busks!", "purple");

	int [effect] currentBusks = beret_busking_effects();

	string [int] description = generateBuffDescription(currentBusks);
	
	int hatpower;
    int pantspower;
	int shartpower;
    int total = 0;
	item thing;
	item shart2;
	foreach shart in $slots[shirt] {
		shart2 = equipped_item(shart);
		if (shart2 != $item[none])
		shartpower += get_power(shart2);
	}
	foreach it in $slots[hat] {
		thing = equipped_item(it);
		if (thing != $item[none])
		hatpower += get_power(thing);
	}

    foreach it in $slots[pants] {
		thing = equipped_item(it);
		if (thing != $item[none])
		pantspower += get_power(thing);
	}
	
	if (busksLeft > 0) 
	{
		if (lookupSkill("tao of the terrapin").have_skill()) total += hatpower*2 + pantspower*2;
        if ($effect[Hammertime].have_effect() > 0) total += pantspower*3;
		description.listAppend("Currently " + (HTMLGenerateSpanFont(shartpower+total, "blue")) + " Power");
		
		if (lookupItem("prismatic beret").equipped_amount() == 0) {
			description.listAppend(HTMLGenerateSpanFont("Equip the beret to busk!", "red"));
		}
		if (lookupFamiliar("mad hatrack").familiar_is_usable() && $item[sane hatrack].is_unrestricted()) {
			description.listAppend(HTMLGenerateSpanFont("|*(You can put it on your hatrack)", "blue"));
		}
		
		resource_entries.listAppend(ChecklistEntryMake("__item prismatic beret", url, ChecklistSubentryMake(title, "", description)));
	}
}