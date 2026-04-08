// Clan VIP Photo booth
RegisterResourceGenerationFunction("IOTMVIPPhotoBoothGenerateResource");
void IOTMVIPPhotoBoothGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (available_amount($item[Clan VIP Lounge key]) < 1)
        return;

    string [int] description;
	string url = "clan_viplounge.php?action=photobooth";
	
    int photosLeft = clampi(3 - get_property_int("_photoBoothEffects"), 0, 3);
	if (photosLeft > 0)
	{
		description.listAppend(HTMLGenerateSpanFont("Get your photo taken:", "black"));
		description.listAppend(HTMLGenerateSpanFont("|*photobooth west: +50% init, +noncom%", "black"));
		description.listAppend(HTMLGenerateSpanFont("|*photobooth tower: +com%", "black"));
		description.listAppend(HTMLGenerateSpanFont("|*photobooth space: this sucks", "black"));
		
		resource_entries.listAppend(ChecklistEntryMake("__item expensive camera", url, ChecklistSubentryMake(photosLeft + " clan photos takeable", description), 8));
	}

	//Assert Your Authority: item-crunching instakill
	//  "this here town ain't big enough for the two of us"

    int sheriffings_left = clampi(3 - get_property_int("_assertYourAuthorityCast"), 0, 3);
    boolean you_are_the_sheriff = (lookupItem("sheriff badge").available_amount() > 0 && lookupItem("sheriff moustache").available_amount() > 0 && lookupItem("sheriff pistol").available_amount() > 0);
    boolean instakills_usable = my_path().id != PATH_G_LOVER && my_path().id != PATH_POCKET_FAMILIARS && my_path().id != 52; // avant guard

    if (sheriffings_left > 0 && instakills_usable && you_are_the_sheriff)
    {
        string [int] authorityDescription;
        authorityDescription.listAppend("Assert Your Authority for a no-drop freekill.");
        
		if (lookupItem("sheriff badge").equipped_amount() != 1 && lookupItem("sheriff moustache").equipped_amount() != 1 && lookupItem("sheriff pistol").equipped_amount() != 1)
        {
        	authorityDescription.listAppend(HTMLGenerateSpanFont("Equip your sheriff gear first.", "red"));
            url = "inventory.php?ftext=sheriff";
        }
        resource_entries.listAppend(ChecklistEntryMake("__item badge of authority", url, ChecklistSubentryMake(pluralise(sheriffings_left, "authority assertion", "authority assertions"), "", authorityDescription), 0).ChecklistEntrySetCombinationTag("free instakill").ChecklistEntrySetIDTag("assert your authority free kill"));
        
    }
}