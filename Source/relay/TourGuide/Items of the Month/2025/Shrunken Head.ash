//shrunken head
RegisterTaskGenerationFunction("IOTMShrunkenHeadGenerateTasks");
void IOTMShrunkenHeadGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    // TODO: improve task tile for shrunken head. items to make include:
    //   - if active monster, item drop chance for the active items on your head monster
    //   - if head equipped, what enchantment the monster you're fighting gives you
    //   - convert current targets to hoverover recommendations w/ filtering
    //   - add shrunken head combo to location bar
    
	if (!__iotms_usable[lookupItem("Shrunken Head")]) return;

    monster headZombie = get_property("shrunkenHeadZombieMonster").to_monster();
    int headZombieHP = get_property_int("shrunkenHeadZombieHP");

	string url = "inventory.php?ftext=shrunken+head";
	string [int] description;
	
    // Generate a task if head is equipped that shares possible good reanimations
	if (lookupItem("shrunken head").equipped_amount() > 0)
	{
		description.listAppend("Consider reanimating one of the following foes:");
        description.listAppend("|*dairy goat"+HTMLGenerateSpanFont("(40%)", "gray", "0.9em"));
        description.listAppend("|*pygmy bowler"+HTMLGenerateSpanFont("(40%)", "gray", "0.9em"));
        description.listAppend("|*baa-relief sheep"+HTMLGenerateSpanFont("(25%)", "gray", "0.9em"));
        description.listAppend("|*pygmy janitor"+HTMLGenerateSpanFont("(20%)", "gray", "0.9em"));
        description.listAppend("|*Spiny or Toothy skeletons"+HTMLGenerateSpanFont("(20%)", "gray", "0.9em"));
        description.listAppend("|*banshee librarian"+HTMLGenerateSpanFont("(10%)", "gray", "0.9em"));
        description.listAppend("|*mountain man"+HTMLGenerateSpanFont("(10%)", "gray", "0.9em"));
        description.listAppend("|*One of the Smut Orcs"+HTMLGenerateSpanFont("(10%)", "gray", "0.9em"));

		task_entries.listAppend(ChecklistEntryMake("__item shrunken head", url, ChecklistSubentryMake(HTMLGenerateSpanFont("Shrunken head equipped", "blue"), description), -11).ChecklistEntrySetIDTag("shrunken head"));
	}
}