RegisterTaskGenerationFunction("IOTMComprehensiveCartographyGenerateTasks");
void IOTMComprehensiveCartographyGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if (!$skill[Map the Monsters].have_skill()) return;
    if (get_property_boolean("mappingMonsters")) {
        task_entries.listAppend(ChecklistEntryMake("__skill Map the Monsters", "", ChecklistSubentryMake("Mapping the Monsters now!", "", "Fight a chosen monster in the next zone."), -11).ChecklistEntrySetIDTag("Map the Monsters"));
    }
}

RegisterResourceGenerationFunction("IOTMComprehensiveCartographyGenerateResource");
void IOTMComprehensiveCartographyGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (!$skill[Map the Monsters].have_skill()) return;
    int casts_remaining = 3 - get_property_int("_monstersMapped");
    if (casts_remaining > 0) {
        resource_entries.listAppend(ChecklistEntryMake("__skill Map the Monsters", "skillz.php", ChecklistSubentryMake(casts_remaining  + " monster maps remaining", "", "Cast Map the Monsters, for anything on the olfaction list.")).ChecklistEntrySetIDTag("Map the Monsters"));
    }
}
