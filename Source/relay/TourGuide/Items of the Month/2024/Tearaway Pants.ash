// Tearaway Pants
RegisterTaskGenerationFunction("IOTMTearawayPantsGenerateTask");
void IOTMTearawayPantsGenerateTask(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    // Don't show the tile if you don't have the pants.
	if (!__iotms_usable[lookupItem("tearaway pants")]) return;

    // Don't show the tile if you aren't a moxie class.
    if (!($classes[disco bandit,accordion thief] contains my_class())) return;

    // I can't believe I'm doing this. I have truly lost control of my life.
    QuestState base_quest_state = __quest_state["Guild"];
	if (base_quest_state.finished || !base_quest_state.startable || base_quest_state.mafia_internal_step == 2) return;

    // Do you have the stupid pants equipped?
    boolean havePantsEquipped = $slot[pants].equipped_item() == $item[tearaway pants];

	string [int] description;

    // If equipped, send user to the guild. If not, send them to the inventory.
	string url = havePantsEquipped ? "guild.php" : "inventory.php?ftext=tearaway+pants";
	string header = "Tear away your tearaway pants!";

    if (havePantsEquipped) description.listAppend(`Visit the Department of Shadowy Arts and Crafts to unlock the guild!`);
    if (!havePantsEquipped) description.listAppend(`Visit the Department of Shadowy Arts and Crafts with your pants equipped to unlock the guild!`);

	optional_task_entries.listAppend(ChecklistEntryMake("__item tearaway pants", url, ChecklistSubentryMake(header, "", description), 0));

}