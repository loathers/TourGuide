//Emotion Chip
RegisterResourceGenerationFunction("IOTMEmotionChipGenerateResource");
void IOTMEmotionChipGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (!lookupSkill("Emotionally Chipped").have_skill())
    return;
    ChecklistSubentry getEmotions() {
        // Title
        string main_title = "Emotion chip feelings";
        // Entries
		string [int] description;
		string [int] emotions;
				
        int emotionEnvy = clampi(3 - get_property_int("_feelEnvyUsed"), 0, 3);
        if (emotionEnvy > 0 && $skill[Feel Envy].skill_is_usable())
			{
            emotions.listAppend(emotionEnvy + " Envys left. Forces the monster to drop all items, but leaves killing it up to you.");
			}
        int emotionExcitement = clampi(3 - get_property_int("_feelExcitementUsed"), 0, 3);
        if (emotionExcitement > 0 && $skill[Feel Excitement].skill_is_usable())
			{
            emotions.listAppend(emotionExcitement + " Excitement left. 20 advs of +25 Mus/Mys/Mox.");
			}
        int emotionHatred = clampi(3 - get_property_int("_feelHatredUsed"), 0, 3);
        if (emotionHatred > 0 && $skill[Feel Hatred].skill_is_usable())
			{
            emotions.listAppend(emotionHatred + " Hatreds left. 50-turn banish.");
			
			resource_entries.listAppend(ChecklistEntryMake("__skill feel hatred", "", ChecklistSubentryMake(pluralise(emotionHatred, "Feel Hatred", "Feels Hatreds"), "", "Cast Feel Hatred. Free run/banish.")).ChecklistEntrySetCombinationTag("banish").ChecklistEntrySetIDTag("Emotion chip feel hatred banish"));
			}
        int emotionLonely = clampi(3 - get_property_int("_feelLonelyUsed"), 0, 3);
        if (emotionLonely > 0 && $skill[Feel Lonely].skill_is_usable())
			{
            emotions.listAppend(emotionLonely + " Lonelys left. 20 advs of -5% Combat.");
			}
        int emotionLost = clampi(3 - get_property_int("_feelLostUsed"), 0, 3);
        if (emotionLost > 0 && $skill[Feel Lost].skill_is_usable())
			{
            emotions.listAppend(emotionLost + " Losts left. 20 advs of a weird Teleportitis buff.");
			}
        int emotionNervous = clampi(3 - get_property_int("_feelNervousUsed"), 0, 3);
        if (emotionNervous > 0 && $skill[Feel Nervous].skill_is_usable())
			{
            emotions.listAppend(emotionNervous + " Nervouses left. 20 advs of passive damage.");
			}
        int emotionNostalgic = clampi(3 - get_property_int("_feelNostalgicUsed"), 0, 3);
		monster nostalgicMonster = (get_property_monster("lastCopyableMonster"));
        if (emotionNostalgic > 0 && $skill[Feel Nostalgic].skill_is_usable())
			{
            emotions.listAppend(emotionNostalgic + " Nostalgias left. Copy a drop table. Can currently feel nostalgic for: " + HTMLGenerateSpanFont(nostalgicMonster, "blue"));
			}
        int emotionPeaceful = clampi(3 - get_property_int("_feelPeacefulUsed"), 0, 3);
        if (emotionPeaceful > 0 && $skill[Feel Peaceful].skill_is_usable())
			{
            emotions.listAppend(emotionPeaceful + " Peacefuls left. 20 advs of +2 elemental resist.");
			}
        int emotionPride = clampi(3 - get_property_int("_feelPrideUsed"), 0, 3);
        if (emotionPride > 0 && $skill[Feel Pride].skill_is_usable())
			{
            emotions.listAppend(emotionPride + " Prides left. Triple stat gain from current fight.");
			}
        int emotionSuperior = clampi(3 - get_property_int("_feelSuperiorUsed"), 0, 3);
        if (emotionSuperior > 0 && $skill[Feel Superior].skill_is_usable())
			{
            emotions.listAppend(emotionSuperior + " Superiors left. +1 PvP Fight if used as killshot.");
			}   		
        int emotionDisappointed = clampi(3 - get_property_int("_feelDisappointedUsed"), 0, 3);
        if (emotionDisappointed > 0 && $skill[Feel Disappointed].skill_is_usable())
			{
            emotions.listAppend(emotionDisappointed + " Disappointments left. Your therapist has a lot of feelings about this one.");
			}
        return ChecklistSubentryMake(main_title, description, emotions);
    }

	ChecklistEntry entry;
    entry.image_lookup_name = "__item emotion chip";
    entry.tags.id = "emotion chip resource";

    ChecklistSubentry emotions = getEmotions();
    if (emotions.entries.count() > 0) {
        entry.subentries.listAppend(emotions);
    }
    
    if (entry.subentries.count() > 0) {
        resource_entries.listAppend(entry);
    }
}
