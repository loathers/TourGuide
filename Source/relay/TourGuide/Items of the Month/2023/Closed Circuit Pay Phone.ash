RegisterTaskGenerationFunction("IOTMClosedCircuitPayPhoneGenerateTasks");
void IOTMClosedCircuitPayPhoneGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if (!lookupItem("closed-circuit pay phone").have())
        return;

    string [int] affinityDescription;
    string [int] questDescription;
    string url = "inv_use.php?pwd=" + my_hash() + "&which=3&whichitem=11169";

    int shadowLodestones = available_amount($item[Rufus's shadow lodestone]);
    if (shadowLodestones > 0) {
        questDescription.listAppend(HTMLGenerateSpanFont("Have " + shadowLodestones + " " + pluralise($item[Rufus's shadow lodestone]) + ".", "purple"));
    }

    int riftAdvsUntilNC = get_property_int("encountersUntilSRChoice");
    questDescription.listAppend(HTMLGenerateSpanFont(riftAdvsUntilNC + " encounters until NC/boss.", "black"));

    if (get_property("questRufus").contains_text("step1")) {
        questDescription.listAppend(HTMLGenerateSpanFont("Call Rufus and get a lodestone", "black"));
        task_entries.listAppend(ChecklistEntryMake("__item closed-circuit pay phone", url, ChecklistSubentryMake("Rufus quest done", "", questDescription), -11));
    }
    else if (get_property("questRufus").contains_text("unstarted")) {
        questDescription.listAppend(HTMLGenerateSpanFont("Have no quest accepted.", "red"));
        optional_task_entries.listAppend(ChecklistEntryMake("__item closed-circuit pay phone", url, ChecklistSubentryMake("Rufus quest doable now", "", questDescription), 11));
    }
    else if (get_property("questRufus").contains_text("started")) {
        optional_task_entries.listAppend(ChecklistEntryMake("__item closed-circuit pay phone", url, ChecklistSubentryMake("Rufus quest in progress", "", questDescription), 11));
    }

    if (riftAdvsUntilNC == 0) {
        questDescription.listAppend(HTMLGenerateSpanFont("Fight a boss or get an artifact", "black"));
        task_entries.listAppend(ChecklistEntryMake("__item shadow bucket", url, ChecklistSubentryMake("Shadow Rift NC up next", "", questDescription), -11));
    }

    if ($effect[Shadow Affinity].have_effect() > 0) {
        int shadowRiftFightsDoableRightNow = $effect[Shadow Affinity].have_effect();
        affinityDescription.listAppend(HTMLGenerateSpanFont("Shadow Rift fights are free!", "purple"));
        affinityDescription.listAppend(HTMLGenerateSpanFont("(don't use other free kills in there)", "black"));
        task_entries.listAppend(ChecklistEntryMake("__effect Shadow Affinity", "", ChecklistSubentryMake(shadowRiftFightsDoableRightNow + " Shadow Rift free fights", "", affinityDescription), -11));
    }
}

RegisterResourceGenerationFunction("IOTMClosedCircuitPayPhoneGenerateResource");
void IOTMClosedCircuitPayPhoneGenerateResource(ChecklistEntry [int] resource_entries)
{
    int shadowBricks = available_amount($item[shadow brick]);
    int shadowBrickUsesLeft = clampi(13 - get_property_int("_shadowBricksUsed"), 0, 13);
    if ($item[shadow brick].available_amount() > 0) {
        string header = $item[shadow brick].pluralise().capitaliseFirstLetter();
        if (shadowBrickUsesLeft < shadowBricks) {
            if (shadowBrickUsesLeft == 0)
                header += " (not usable today)";
            else
                header += " (" + shadowBrickUsesLeft + " usable today)";
        }
        resource_entries.listAppend(ChecklistEntryMake("__item shadow brick", "", ChecklistSubentryMake(header, "", "Win a fight without taking a turn.")).ChecklistEntrySetCombinationTag("free instakill"));
    }

    if (!lookupItem("closed-circuit pay phone").have())
        return;

    string [int] affinityDescription;
    string [int] lodestoneDescription;
    int shadowLodestones = available_amount($item[Rufus's shadow lodestone]);
    
    int rufusQuestItems;
    string url = "inv_use.php?pwd=" + my_hash() + "&which=3&whichitem=11169";

    int artifactCount = get_property("rufusDesiredArtifact").to_item().available_amount();
    
    if (shadowLodestones > 0) {
        lodestoneDescription.listAppend("30 advs of +100% init, +100% item, +200% meat, -10% combat.");
        lodestoneDescription.listAppend("Triggers on next visit to any Shadow Rift.");
        resource_entries.listAppend(ChecklistEntryMake("__item Rufus's shadow lodestone", url, ChecklistSubentryMake(shadowLodestones + " Rufus's shadow lodestones", lodestoneDescription), 5));
    } else if (artifactCount > 0) {
        lodestoneDescription.listAppend(HTMLGenerateSpanFont("Give Rufus that shadow quest item to get a lodestone!", "blue") + "");
        resource_entries.listAppend(ChecklistEntryMake("__item closed-circuit pay phone", url, ChecklistSubentryMake("Rufus's shadow lodestone noncom", lodestoneDescription), 5));
    }
    
    if (!get_property_boolean("_shadowAffinityToday")) {
        affinityDescription.listAppend("Call Rufus to get 11+ free Shadow Rift combats.");
        resource_entries.listAppend(ChecklistEntryMake("__effect Shadow Affinity", url, ChecklistSubentryMake("Shadow Affinity free fights", "", affinityDescription), 5).ChecklistEntrySetCombinationTag("daily free fight").ChecklistEntrySetIDTag("Shadow affinity free fights"));
    }


}
