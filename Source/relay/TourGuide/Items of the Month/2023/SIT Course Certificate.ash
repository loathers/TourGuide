boolean hasAnySkillOf(string [int] skillNames) {
    foreach i in skillNames {
        string skillName = skillNames[i];
        if (lookupSkill(skillName).have_skill()) {
            return true;
        }
    }
    return false;
}

// Prompt to register which SIT course you took
RegisterTaskGenerationFunction("IOTMSITCertificateGenerateTasks");
void IOTMSITCertificateGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries) {
    if (!lookupItem("S.I.T. Course Completion Certificate").have())
        return;

    // Nag if we haven't picked a skill during this ascension    
    string [int] skillNames = {"Psychogeologist", "Insectologist", "Cryptobotanist"};
    if (hasAnySkillOf(skillNames)) {
        return;
    }

    string [int] description;
    string url = "inv_use.php?pwd=" + my_hash() + "&which=3&whichitem=11116";
    string main_title = "S.I.T. Course Enrollment";

    string [int] miscPhrases = {
        "Don't play hooky!",
        "You already paid for it.",
        "This one time in college...",
    };
    string miscPhrase = miscPhrases[random(count(miscPhrases))];
    description.listAppend(HTMLGenerateSpanFont(miscPhrase + " Take your S.I.T. course!", "red"));
    task_entries.listAppend(ChecklistEntryMake("__item S.I.T. Course Completion Certificate", url, ChecklistSubentryMake(main_title, description), -11).ChecklistEntrySetIDTag("S.I.T. Course Completion Certificate"));
}
