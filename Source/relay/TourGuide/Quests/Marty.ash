void QMartyInit()
{
    //questM03Bugbear
    QuestState state;

    QuestStateParseMafiaQuestProperty(state, "questM18Swamp");

    state.quest_name = "Marty's Quest";
    state.image_name = "__item maple leaf";

    state.startable = canadia_available();

    __quest_state["Marty"] = state;
}

void QMartyGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    QuestState base_quest_state = __quest_state["Marty"];
    if (!base_quest_state.in_progress)
        return;
    if (!canadia_available())
        return;
    if (__misc_state["in run"] && $location[The Edge of the Swamp].turnsAttemptedInLocation() == 0)
        return;

    string url = "place.php?whichplace=marais";

    ChecklistSubentry subentry;

    subentry.header = base_quest_state.quest_name;

    boolean minus_combat_relevant = false;
    string [int] missing_fork_ncs;
    if (!$location[The Dark and Spooky Swamp].locationAvailable())
        missing_fork_ncs.listAppend("left");
    else {
        string [int] missing_sophie_ncs;
        if (!$location[The Corpse Bog].locationAvailable())
            missing_sophie_ncs.listAppend("the bog");
        else if ($item[Phil Bunion's axe].available_amount() == 0)
            subentry.entries.listAppend("Adventure in the Corpse Bog to defeat the ghost of Phil Bunion.");

        if (!$location[The Ruined Wizard Tower].locationAvailable())
            missing_sophie_ncs.listAppend("the stone tower");
        else if ($item[shrunken navigator head].available_amount() == 0 && $item[branch from the Great Tree].available_amount() == 0) {
            subentry.entries.listAppend("Adventure in the Ruined Wizard Tower to find a shrunken navigator head.");
            minus_combat_relevant = true;
        }

        if (missing_sophie_ncs.count() > 0) {
            minus_combat_relevant = true;
            subentry.entries.listAppend("Adventure in the Dark and Spooky Swamp, go towards " + missing_sophie_ncs.listJoinComponents(" and ") + " in Sophie's Choice.");
        }
    }

    if (!$location[The Wildlife Sanctuarrrrrgh].locationAvailable())
        missing_fork_ncs.listAppend("right");
    else {
        string [int] missing_bad_to_worst_ncs;
        if (!$location[Swamp Beaver Territory].locationAvailable())
            missing_bad_to_worst_ncs.listAppend("the swamp beaver territory");
        else if ($item[shrunken navigator head].available_amount() > 0 && $item[branch from the Great Tree].available_amount() == 0) {
            minus_combat_relevant = true;
            subentry.entries.listAppend("Adventure in the Swamp Beaver Territory, follow the shrunken navigator head's directions, and defeat a conservationist hippy.");
        }

        if (!$location[The Weird Swamp Village].locationAvailable())
            missing_bad_to_worst_ncs.listAppend("the village");
        else if ($item[bouquet of swamp roses].available_amount() == 0) {
            subentry.entries.listAppend("Adventure in the Weird Swamp Village to defeat a swamp skunk.");
            subentry.modifiers.listAppend("+item?");
        }

        if (missing_bad_to_worst_ncs.count() > 0) {
            minus_combat_relevant = true;
            subentry.entries.listAppend("Adventure in the Wildlife Sanctuarrrrrgh, go towards " + missing_bad_to_worst_ncs.listJoinComponents(" and ") + " in From Bad to Worst.");
        }
    }

    if (missing_fork_ncs.count() > 0) {
        minus_combat_relevant = true;
        subentry.entries.listAppend("Adventure in the edge of the swamp, go " + missing_fork_ncs.listJoinComponents(" and ") + " in Stick a Fork In It.");
    }
    if (minus_combat_relevant) //....?
        subentry.modifiers.listAppend("-combat?");

    if ($items[Phil Bunion's axe,bouquet of swamp roses,branch from the Great Tree].items_missing().count() == 0)
    {
        subentry.entries.listAppend("Go talk to Marty to finish the quest.");
        url = "place.php?whichplace=canadia";
    }

    boolean [location] relevant_locations;
    relevant_locations[$location[the edge of the swamp]] = true;
    relevant_locations[$location[The Dark and Spooky Swamp]] = true;
    relevant_locations[$location[The Corpse Bog]] = true;
    relevant_locations[$location[The Ruined Wizard Tower]] = true;
    relevant_locations[$location[The Wildlife Sanctuarrrrrgh]] = true;
    relevant_locations[$location[Swamp Beaver Territory]] = true;
    relevant_locations[$location[The Weird Swamp Village]] = true;

    optional_task_entries.listAppend(ChecklistEntryMake(base_quest_state.image_name, url, subentry, relevant_locations).ChecklistEntrySetIDTag("Marty Canadia quest"));
}