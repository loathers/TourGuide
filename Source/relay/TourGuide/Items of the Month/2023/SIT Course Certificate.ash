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

    boolean completedSITToday = get_property_boolean("_sitCourseCompleted");

    // Nag if we haven't picked a skill during this ascension. Adding a daycount
    //   piece to the nag that ensures this shows up on D2, prompting users to
    //   change out their skill on D2. Not prompting on D3 or later, because
    //   there's really only two good ones.
    string [int] skillNames = {"Psychogeologist", "Insectologist", "Cryptobotanist"};
    if (hasAnySkillOf(skillNames) && my_daycount() >= 3) {
        return;
    }

    // Don't generate a tile if the user has completed SIT already today
    if (completedSITToday) return;

    string [int] description;
    string url = "inv_use.php?pwd=" + my_hash() + "&which=3&whichitem=11116";
    string main_title = "S.I.T. Course Enrollment";

    string [int] miscPhrases = {
        "Don't play hooky!",
        "You already paid for it.",
        "This one time in college...",
        "Bright college days, oh, carefree days that fly.", // <3 tom lehrer
        "No child of mine is leaving here without a degree!",
        "Make like a tree and leaf (through your papers)",
    };

    string miscPhrase = miscPhrases[random(count(miscPhrases))];
    description.listAppend(HTMLGenerateSpanFont(miscPhrase + " Take your S.I.T. course!", "red"));

    string subtitle = "";

    if (hasAnySkillOf(skillNames)) {
        if (lookupSkill("Psychogeologist").have_skill())    subtitle = "you have ML; consider <b>Insectology</b>, for meat?";
        if (lookupSkill("Insectologist").have_skill())      subtitle = "you have Meat; consider <b>Psychogeology</b>, for ML?";
        if (lookupSkill("Cryptobotanist").have_skill())     subtitle = "you have Init; consider <b>Insectology</b>, for meat?";
    }

    task_entries.listAppend(ChecklistEntryMake("__item S.I.T. Course Completion Certificate", url, ChecklistSubentryMake(main_title, subtitle, description), -11).ChecklistEntrySetIDTag("S.I.T. Course Completion Certificate"));
}
