QuestState parseRufusQuestState() {
    /*
    Below description from Veracity's PR introducing Rufus quest tracking:
    https://github.com/kolmafia/kolmafia/pull/1613
    > "unstarted" -> we have not accepted a quest
    > "started" -> we have accepted a quest but not yet fulfilled the requirement
    > "step1" -> we have fulfilled the requirement but not called Rufus back yet to report our success
    > (Calling Rufus back and fulfilling the quest sends us back to "unstarted".)

    This works nicely with TourGuide's QuestState tracking so we can parse right out of it.
    */
    QuestState state = QuestState("questRufus");

    // Because mafia_internal_step tracking is confusing, and the quest never actually gets
    // marked as finished, let's add a boolean to track whether we've done the objective
    // (but not yet called Rufus back)
    state.state_boolean["quest objective fulfilled"] = state.mafia_internal_step == 2;

    return state;
}

record ShadowBrickLocation {
    string zoneName;
    string extraItems;
    boolean canAccess;
};

string getShadowBrickLocationTooltip() {
    ShadowBrickLocation [int] shadowBrickLocations = {
        new ShadowBrickLocation(
            "Cemetary",
            "(also has bread, stick)",
            can_adventure($location[Shadow Rift (The Misspelled Cemetary)])
        ),
        new ShadowBrickLocation(
            "Hidden City",
            "(also has sinew, nectar)",
            can_adventure($location[Shadow Rift (The Hidden City)])
        ),
        new ShadowBrickLocation(
            "Pyramid",
            "(also has sausage, sinew)",
            can_adventure($location[Shadow Rift (The Ancient Buried Pyramid)])
        )
    };

    string [int][int] shadowBricksTable;
    foreach index, brickLocation in shadowBrickLocations {
        string formattedLocationName = brickLocation.canAccess ?
            HTMLGenerateSpanOfClass(brickLocation.zoneName, "r_bold") :
            HTMLGenerateSpanOfClass(HTMLGenerateSpanFont(brickLocation.zoneName, "gray"), "r_bold");
        shadowBricksTable.listAppend(listMake(formattedLocationName, brickLocation.extraItems));
    }

    string shadowBricksTooltip = HTMLGenerateSimpleTableLines(shadowBricksTable);
    return HTMLGenerateSpanOfClass(HTMLGenerateSpanOfClass(shadowBricksTooltip, "r_tooltip_inner_class") + "Shadow Brick locations", "r_tooltip_outer_class");
}

RegisterTaskGenerationFunction("IOTMClosedCircuitPayPhoneGenerateTasks");
void IOTMClosedCircuitPayPhoneGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries) {
    if (!lookupItem("closed-circuit pay phone").have())
        return;

    string url = "inv_use.php?pwd=" + my_hash() + "&which=3&whichitem=11169";
    QuestState state = parseRufusQuestState();

    ChecklistEntry [int] whereToAddRufusQuestTile;
    string rufusImage = "__item closed-circuit pay phone";
    string rufusQuestTitle;
    string [int] rufusQuestDescription;
    int rufusQuestPriority;
    
    int shadowLodestones = available_amount($item[Rufus's shadow lodestone]);
    if (shadowLodestones > 0) {
        rufusQuestDescription.listAppend(HTMLGenerateSpanFont("Have " + pluralise($item[Rufus's shadow lodestone]) + ".", "purple"));
    }

    int riftAdvsUntilNC = get_property_int("encountersUntilSRChoice");
    rufusQuestDescription.listAppend(HTMLGenerateSpanFont(riftAdvsUntilNC + " encounters until NC/boss.", "black"));

    if (state.state_boolean["quest objective fulfilled"]) {
        // We've fulfilled the quest objective but still need to call Rufus
        rufusQuestDescription.listAppend(HTMLGenerateSpanFont("Call Rufus and get a lodestone", "black"));
        rufusQuestTitle = "Rufus quest done";
        rufusQuestPriority = -11;
        whereToAddRufusQuestTile = task_entries;
    }
    else if (state.started && riftAdvsUntilNC == 0) {
        rufusQuestDescription.listAppend(HTMLGenerateSpanFont("Fight a boss or get an artifact", "black"));
        rufusQuestTitle = "Shadow Rift NC up next";
        rufusQuestPriority = -11;
        rufusImage = "__item shadow bucket";
        whereToAddRufusQuestTile = task_entries;
    }
    else if (state.started) {
        rufusQuestTitle = "Rufus quest in progress";
        rufusQuestPriority = 11;
        whereToAddRufusQuestTile = optional_task_entries;
    }
    else if (!state.started) {
        boolean calledRufusToday = get_property_boolean("_shadowAffinityToday");
        string textColor = calledRufusToday ? "black" : "blue";
        string callRufusMessage = calledRufusToday ? "Optionally call Rufus again for another (turn-taking) quest." : "Haven't called Rufus yet today.";
        rufusQuestDescription.listAppend(HTMLGenerateSpanFont(callRufusMessage, textColor));
        rufusQuestTitle = "Rufus quest doable now";
        rufusQuestPriority = 11;
        whereToAddRufusQuestTile = optional_task_entries;
    }

    rufusQuestDescription.listAppend(getShadowBrickLocationTooltip());

    whereToAddRufusQuestTile.listAppend(ChecklistEntryMake(rufusImage, url, ChecklistSubentryMake(rufusQuestTitle, "", rufusQuestDescription), rufusQuestPriority));

    if ($effect[Shadow Affinity].have_effect() > 0) {
        int shadowRiftFightsDoableRightNow = $effect[Shadow Affinity].have_effect();
        string [int] affinityDescription;
        affinityDescription.listAppend(HTMLGenerateSpanFont("Shadow Rift fights are free!", "purple"));
        affinityDescription.listAppend(HTMLGenerateSpanFont("(don't use other free kills in there)", "black"));
        task_entries.listAppend(ChecklistEntryMake("__effect Shadow Affinity", url, ChecklistSubentryMake(shadowRiftFightsDoableRightNow + " Shadow Rift free fights", "", affinityDescription), -11));
    }
}

void showShadowBrickFreeKills(ChecklistEntry [int] resource_entries) {
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
}

RegisterResourceGenerationFunction("IOTMClosedCircuitPayPhoneGenerateResource");
void IOTMClosedCircuitPayPhoneGenerateResource(ChecklistEntry [int] resource_entries) {
    // Shadow bricks don't depend on having the IOTM
    showShadowBrickFreeKills(resource_entries);

    if (!lookupItem("closed-circuit pay phone").have())
        return;

    string url = "inv_use.php?pwd=" + my_hash() + "&which=3&whichitem=11169";

    int shadowLodestones = available_amount($item[Rufus's shadow lodestone]);

    if (shadowLodestones > 0) {
        string [int] lodestoneDescription;
        lodestoneDescription.listAppend("30 advs of +100% init, +100% item, +200% meat, -10% combat.");
        lodestoneDescription.listAppend("Triggers on next visit to any Shadow Rift.");
        resource_entries.listAppend(ChecklistEntryMake("__item Rufus's shadow lodestone", url, ChecklistSubentryMake(shadowLodestones + " Rufus's shadow lodestones", lodestoneDescription), 5));
    }

    if (!get_property_boolean("_shadowAffinityToday")) {
        string [int] affinityDescription;
        affinityDescription.listAppend("Call Rufus to get 11+ free Shadow Rift combats.");
        resource_entries.listAppend(ChecklistEntryMake("__effect Shadow Affinity", url, ChecklistSubentryMake("Shadow Affinity free fights", "", affinityDescription), 5).ChecklistEntrySetCombinationTag("daily free fight").ChecklistEntrySetIDTag("Shadow affinity free fights"));
    }
}
