//Everfull Dart Holster via TES
RegisterTaskGenerationFunction("IOTMEverfullDartsGenerateTasks");
void IOTMEverfullDartsGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if (!__iotms_usable[$item[everfull dart holster]]) return;

    string [int] description;
    string url = "inventory.php?ftext=everfull+dart_holster";

    if ($effect[everything looks red].have_effect() == 0)  {
        int dartCooldown = 50;
        if (get_property("everfullDartPerks").contains_text("You are less impressed by bullseyes")) {
            dartCooldown -= 10;
        }
        if (get_property("everfullDartPerks").contains_text("Bullseyes do not impress you much")) {
            dartCooldown -= 10;
        }
        description.listAppend(HTMLGenerateSpanFont(`Shoot a bullseye! ({dartCooldown} ELR)`, "red"));
        if (lookupItem("everfull dart holster").equipped_amount() == 0) {
            description.listAppend(HTMLGenerateSpanFont("Equip the dart holster first.", "red"));
        }
        else {
            description.listAppend(HTMLGenerateSpanFont("Dart holster equipped", "blue"));
        }
        task_entries.listAppend(ChecklistEntryMake("__item everfull dart holster", url, ChecklistSubentryMake("Everfull Darts free kill available!", "", description), -11));
    }
}

RegisterResourceGenerationFunction("IOTMEverfullDartsGenerateResource");
void IOTMEverfullDartsGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (!__iotms_usable[$item[everfull dart holster]] || !__misc_state["in run"]) return;

    string [int] description;
    string url = "inventory.php?ftext=everfull+dart_holster";

    int dartSkill = get_property_int("dartsThrown");
    if (dartSkill < 401) {
        int dartsNeededForNextPerk = floor(sqrt(dartSkill) + 1) ** 2 - dartSkill;
        description.listAppend(`Current dart skill: {dartSkill}`);
        description.listAppend(`{HTMLGenerateSpanFont(dartsNeededForNextPerk, "blue")} darts needed for next Perk`);
    
        if (lookupItem("everfull dart holster").equipped_amount() == 0) {
            description.listAppend(HTMLGenerateSpanFont("Equip the dart holster first.", "red"));
        }
        else {
            description.listAppend(HTMLGenerateSpanFont("Dart holster equipped", "blue"));
        }
        resource_entries.listAppend(ChecklistEntryMake("__item everfull dart holster", url, ChecklistSubentryMake("🍑🎯 Everfull Dart Holster charging", "", description), 11));
    }
}
