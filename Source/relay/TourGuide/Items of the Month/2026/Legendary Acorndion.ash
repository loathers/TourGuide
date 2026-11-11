//legendary acorndion
RegisterTaskGenerationFunction("IOTMLegendaryAcorndionGenerateTasks");
void IOTMLegendaryAcorndionGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	if (available_amount($item[legendary acorndion]) > 0) {
		string url = "inventory.php?ftext=legendary+acorndion";
		string [int] description;
		string title;
		int acornsLeft = clampi(12 - get_property_int("_legendaryAcornsUsed"), 0, 12);
		
		if (lookupItem("legendary acorndion").equipped_amount() > 0 && (acornsLeft > 0)) {
			
			//indoor zone chart
			string [int][int] tooltip_table2;
			tooltip_table2.listAppend(listMake("Haunted Kitchen", "7+ wins"));
			tooltip_table2.listAppend(listMake("Haunted Library", "5+ wins"));
			tooltip_table2.listAppend(listMake("Haunted Bedroom", "3+ wins"));
			tooltip_table2.listAppend(listMake("Haunted Bathroom", "<5 fights"));
			tooltip_table2.listAppend(listMake("Haunted Gallery", "<5 fights"));
			tooltip_table2.listAppend(listMake("Haunted Ballroom", "<4 fights"));
			tooltip_table2.listAppend(listMake("Ninja Snowmen", "4+ wins"));
			tooltip_table2.listAppend(listMake("Castle Ground Floor", "<10 fights"));
			tooltip_table2.listAppend(listMake("Copperhead Club", "<12 fights"));
			tooltip_table2.listAppend(listMake("The Red Zeppelin", "7+ wins"));
				
			buffer tooltip_text2;
			tooltip_text2.append(HTMLGenerateTagWrap("div", "Indoor Bawdy zones", mapMake("class", "r_bold r_centre", "style", "padding-bottom:0.25em;")));
			tooltip_text2.append(HTMLGenerateSimpleTableLines(tooltip_table2));
				
			string bawdyTooltip = HTMLGenerateSpanOfClass(HTMLGenerateSpanOfClass(tooltip_text2, "r_tooltip_inner_class r_tooltip_inner_class_margin") + HTMLGenerateSpanFont("Indoor + Bawdy = bridge parts (#)", "blue"), "r_tooltip_outer_class");
			description.listAppend(bawdyTooltip);
			
			description.listAppend(HTMLGenerateSpanFont("Indoor + Bash = banish", "blue"));
			description.listAppend(HTMLGenerateSpanFont("Underground + Concerto = sniff", "brown"));
			description.listAppend(HTMLGenerateSpanFont("Outdoor + Cadenza = NC% buff", "green"));
			description.listAppend(HTMLGenerateSpanFont("Underwater + Bash = NC% buff", "purple"));
			description.listAppend(HTMLGenerateSpanFont("Underwater + Concerto = banish", "purple"));
			task_entries.listAppend(ChecklistEntryMake("__item legendary acorndion", url, ChecklistSubentryMake(HTMLGenerateSpanFont(acornsLeft +" Legendary acorndion acorns", "orange"), description), -11).ChecklistEntrySetIDTag("LAD skills"));
		}
	}
}

RegisterResourceGenerationFunction("IOTMLegendaryAcorndionGenerateResource");
void IOTMLegendaryAcorndionGenerateResource(ChecklistEntry [int] resource_entries)
{
	if (available_amount($item[legendary acorndion]) > 0) {
		string url = "inventory.php?ftext=legendary+acorndion";
		string [int] description;
		string title;
		
		int acornsLeft = clampi(12 - get_property_int("_legendaryAcornsUsed"), 0, 12);
		
		if (acornsLeft > 0) {
			
			//indoor zone chart
			string [int][int] tooltip_table2;
			tooltip_table2.listAppend(listMake("Haunted Kitchen", "7+ wins"));
			tooltip_table2.listAppend(listMake("Haunted Library", "5+ wins"));
			tooltip_table2.listAppend(listMake("Haunted Bedroom", "3+ wins"));
			tooltip_table2.listAppend(listMake("Haunted Bathroom", "<5 fights"));
			tooltip_table2.listAppend(listMake("Haunted Gallery", "<5 fights"));
			tooltip_table2.listAppend(listMake("Haunted Ballroom", "<4 fights"));
			tooltip_table2.listAppend(listMake("Ninja Snowmen", "4+ wins"));
			tooltip_table2.listAppend(listMake("Castle Ground Floor", "<10 fights"));
			tooltip_table2.listAppend(listMake("Copperhead Club", "<12 fights"));
			tooltip_table2.listAppend(listMake("The Red Zeppelin", "7+ wins"));
				
			buffer tooltip_text2;
			tooltip_text2.append(HTMLGenerateTagWrap("div", "Indoor Bawdy zones", mapMake("class", "r_bold r_centre", "style", "padding-bottom:0.25em;")));
			tooltip_text2.append(HTMLGenerateSimpleTableLines(tooltip_table2));
				
			string bawdyTooltip = HTMLGenerateSpanOfClass(HTMLGenerateSpanOfClass(tooltip_text2, "r_tooltip_inner_class r_tooltip_inner_class_margin") + HTMLGenerateSpanFont("Indoor + Bawdy = bridge parts (#)", "blue"), "r_tooltip_outer_class");
			description.listAppend(bawdyTooltip);
			
			description.listAppend(HTMLGenerateSpanFont("Indoor + Bash = banish", "blue"));
			description.listAppend(HTMLGenerateSpanFont("Underground + Concerto = sniff", "brown"));
			description.listAppend(HTMLGenerateSpanFont("Underground + Bawdy = MP regen", "brown"));
			description.listAppend(HTMLGenerateSpanFont("Underground + Riff = +15% statgain", "brown"));
			description.listAppend(HTMLGenerateSpanFont("Underground + Cadenza = +100% stats", "brown"));
			description.listAppend(HTMLGenerateSpanFont("Outdoor + Cadenza = NC% buff", "green"));
			description.listAppend(HTMLGenerateSpanFont("Outdoor + Cone of Z = +30% items", "green"));
			description.listAppend(HTMLGenerateSpanFont("Underwater + Bash = NC% buff", "purple"));
			description.listAppend(HTMLGenerateSpanFont("Underwater + Concerto = banish", "purple"));
			resource_entries.listAppend(ChecklistEntryMake("__item legendary acorndion", url, ChecklistSubentryMake(HTMLGenerateSpanFont(acornsLeft +" Legendary acorndion acorns", "orange"), description), 1).ChecklistEntrySetIDTag("LAD skills"));
		}
	}
}
