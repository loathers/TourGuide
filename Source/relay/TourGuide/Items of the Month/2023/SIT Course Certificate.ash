boolean hasAnySkillOf(string [int] skillNames) {
    foreach i in skillNames {
        string skillName = skillNames[i];
        if (lookupSkill(skillName).have_skill()) {
            return true;
        }
    }
    return false;
}

RegisterTaskGenerationFunction("IOTMSITCertificateGenerateTasks");
void IOTMSITCertificateGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries) {
    // Don't generate a tile if the user doesn't have SIT.
    if (!lookupItem("S.I.T. Course Completion Certificate").have()) return;

    // Cannot use S.I.T. in G-Lover    
    if (my_path().id == PATH_G_LOVER) return;

    boolean completedSITToday = get_property_boolean("_sitCourseCompleted");

    // Don't generate a tile if the user has completed SIT already today.
    if (completedSITToday) return;

    string [int] description;
    string url = "inv_use.php?pwd=" + my_hash() + "&which=3&whichitem=11116";
    string main_title = "S.I.T. Course Enrollment";    
    string subtitle = "";

    string [int] miscPhrases = {
        "Don't play hooky!",
        "You already paid for it.",
        "This one time in college...",
        "Bright college days, oh, carefree days that fly.", // <3 tom lehrer
        "No child of mine is leaving here without a degree!",
        "Make like a tree and leaf (through your papers).",
    };

    string [int] skillNames = {"Psychogeologist", "Insectologist", "Cryptobotanist"};
    
    if (hasAnySkillOf(skillNames)) {    
        // If they already have a skill, generate an optional task or a less-shiny supernag
        if (lookupSkill("Psychogeologist").have_skill())    subtitle = "you have ML; consider <b>Insectology</b>, for meat?";
        if (lookupSkill("Insectologist").have_skill())      subtitle = "you have Meat; consider <b>Psychogeology</b>, for ML?";
        if (lookupSkill("Cryptobotanist").have_skill())     subtitle = "you have Init; consider <b>Insectology</b>, for meat?";
        
        if (__misc_state["in run"]) {
            // If in-run, generate a supernag
            description.listAppend("Try changing your S.I.T. course to accumulate different items.");
            task_entries.listAppend(ChecklistEntryMake("__item S.I.T. Course Completion Certificate", url, ChecklistSubentryMake(main_title, subtitle, description), -11).ChecklistEntrySetIDTag("S.I.T. Course Completion Certificate"));
        } 
        else {
            // If not, generate an optional task
            main_title = "Could change your S.I.T. skill, for new items...";
            optional_task_entries.listAppend(ChecklistEntryMake("__item S.I.T. Course Completion Certificate", url, ChecklistSubentryMake(main_title, subtitle, description), 1).ChecklistEntrySetIDTag("S.I.T. Course Completion Certificate"));
        }
    } 
    else {
        // If they don't have a skill, generate a supernag.
        string miscPhrase = miscPhrases[random(count(miscPhrases))];
        description.listAppend(HTMLGenerateSpanFont(miscPhrase + " Take your S.I.T. course!", "red"));
        task_entries.listAppend(ChecklistEntryMake("__item S.I.T. Course Completion Certificate", url, ChecklistSubentryMake(main_title, subtitle, description), -11).ChecklistEntrySetIDTag("S.I.T. Course Completion Certificate"));
    }

    }