//Roman Candelabra
RegisterTaskGenerationFunction("IOTMRomanCandelabraGenerateTasks");
void IOTMRomanCandelabraGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if ($item[roman candelabra].available_amount() == 0) return;

    string url = "inventory.php?ftext=Roman+Candelabra";

    // Extra runaway nag for spring shoes unhavers
    if ($effect[Everything Looks Green].have_effect() == 0 && $item[spring shoes].available_amount() == 0)
    {
        string [int] description;
        description.listAppend(HTMLGenerateSpanFont("Green candle runaway!", "green"));
        if (lookupItem("Roman Candelabra").equipped_amount() == 0) {
            description.listAppend(HTMLGenerateSpanFont("Equip the Roman Candelabra first.", "red"));
        }
        else {
            description.listAppend(HTMLGenerateSpanFont("Candelbra equipped", "green"));
        }
        task_entries.listAppend(ChecklistEntryMake("__item Roman Candelabra", url, ChecklistSubentryMake("Roman Candelabra runaway available!", "", description), -11));
    }

    // Purple people beater
    if ($effect[Everything Looks Purple].have_effect() == 0)
    {
        string [int] description;
        if (lookupItem("Roman Candelabra").equipped_amount() == 0)
        {
            description.listAppend(HTMLGenerateSpanFont("Equip the Roman Candelabra, for your purple ray.", "red"));
        }
        else
        {
            description.listAppend(HTMLGenerateSpanFont("Candelbra equipped, blow your purple candle!", "purple"));
        }
        task_entries.listAppend(ChecklistEntryMake("__item Roman Candelabra", url, ChecklistSubentryMake("Roman Candelabra monster chain ready", "", description), -11));
    }
}
