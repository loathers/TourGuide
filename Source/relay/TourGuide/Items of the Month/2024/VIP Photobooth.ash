// Clan VIP Photo booth
RegisterResourceGenerationFunction("IOTMVIPPhotoBoothGenerateResource");
void IOTMVIPPhotoBoothGenerateResource(ChecklistEntry [int] resource_entries) {
	if (!__iotms_usable[lookupItem("photo booth sized crate")] || !(get_clan_lounge() contains lookupItem("photo booth sized crate"))) return;
	string url = "clan_viplounge.php?action=photobooth";
	int photosLeft = clampi(3 - get_property_int("_photoBoothEffects"), 0, 3);
	if (photosLeft > 0) {
		string [int] description;
		description.listAppend(HTMLGenerateSpanFont("photobooth west: +50% init, +noncom%", "black"));
		description.listAppend(HTMLGenerateSpanFont("photobooth tower: +com%", "black"));
		description.listAppend(HTMLGenerateSpanFont("photobooth space: this sucks", "black"));
		resource_entries.listAppend(ChecklistEntryMake("__item expensive camera", url, ChecklistSubentryMake(photosLeft + " clan photos takeable", description), 8).ChecklistEntrySetCombinationTag("daily buffs").ChecklistEntrySetIDTag("Clan Photobooth daily buffs"));
	}
	int equipmentLeft = clampi(3 - get_property_int("_photoBoothEquipment"), 0, 3);
	if (equipmentLeft > 0) {
		string [int] description;
		description.listAppend(HTMLGenerateSpanFont("3x Sheriff equipment - gives 3 free kills", "black"));
		// TODO: expand this for in-run choices.
		resource_entries.listAppend(ChecklistEntryMake("__item photo booth supply list", url, ChecklistSubentryMake(equipmentLeft + " props borrowable", description), 1).ChecklistEntrySetCombinationTag("daily equips").ChecklistEntrySetIDTag("Clan Photobooth daily equips"));
	}
}

RegisterResourceGenerationFunction("AssertAuthorityGenerateResource");
void AssertAuthorityGenerateResource(ChecklistEntry [int] resource_entries) {
	if (!lookupItem("sheriff badge").have() || !lookupItem("sheriff moustache").have() || !lookupItem("sheriff pistol").have()) return;
	// Need all 3 to get the skill.
	int authorityCasts = clampi(3 - get_property_int("_assertYourAuthorityCast"), 0, 3);
	if (authorityCasts > 0) {
		string url = "";
		string [int] description;
		description.listAppend("Win a fight without taking a turn.");
		if (!lookupItem("sheriff badge").equipped() && !lookupItem("sheriff moustache").equipped() && !lookupItem("sheriff pistol").equipped()) {
			description.listAppend(HTMLGenerateSpanFont("Equip your sheriff gear first.", "red"));
			url = "inventory.php?ftext=sheriff";
		}
		resource_entries.listAppend(ChecklistEntryMake("__item badge of authority", url, ChecklistSubentryMake(pluralise(authorityCasts, "Assert your Authority cast", "Assert your Authority casts"), description), 0).ChecklistEntrySetCombinationTag("free instakill").ChecklistEntrySetIDTag("Assert your authority free kills"));
	}
}
