RegisterTaskGenerationFunction("PathShadowsOverLoathingGenerateTasks");
void PathShadowsOverLoathingGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if (lookupSkill("Free-For-All").have_skill()) {
        if ($effect[Everything Looks Red].have_effect() > 0) return;
        string [int] description;
        string main_title = HTMLGenerateSpanFont("Free-For-All castable", "red");
        description.listAppend("Free instakill (25 adv cooldown)");
        task_entries.listAppend(ChecklistEntryMake("__item orange boxing gloves", "", ChecklistSubentryMake(main_title, "", description), -11));
    }
    else if (lookupSkill("Fondeluge").have_skill()) {
        if ($effect[Everything Looks Yellow].have_effect() > 0) return;
        string [int] description;
        string main_title = HTMLGenerateSpanFont("Fondeluge castable", "orange");
        description.listAppend("Free YR (50 adv cooldown)");
        task_entries.listAppend(ChecklistEntryMake("__skill fondeluge", "", ChecklistSubentryMake(main_title, "", description), -11));
    }
    else if (lookupSkill("Motif").have_skill()) {
        if ($effect[Everything Looks Blue].have_effect() > 0) return;
        string [int] description;
        string main_title = HTMLGenerateSpanFont("Motif castable", "blue");
        description.listAppend("Olfact (25 adv cooldown)");
        task_entries.listAppend(ChecklistEntryMake("__skill Motif", "", ChecklistSubentryMake(main_title, "", description), -11));
    }
}
