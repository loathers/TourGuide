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

record CursedItem {
    item theItem;
    monster boss;
    string description;
    boolean shouldDisplay;
    boolean valuableToGooseDupe;
};

void showCursedItemsResourceTile(ChecklistEntry [int] resource_entries) {
    CursedItem [int] cursedItems = {
        new CursedItem(
            $item[cursed goblin cape],
            $monster[goblin king's shadow],
            "-15% combat!",
            __quest_state["Knob Goblin King"].finished != true,
            false
        ),
        new CursedItem(
            $item[cursed bat paw],
            $monster[two-headed shadow bat],
            "+25 ML",
            __quest_state["Boss Bat"].finished != true,
            true
        ),
        new CursedItem(
            $item[cursed dragon wishbone],
            $monster[shadowboner shadowdagon],
            "+50% item",
            __quest_state["Cyrpt"].finished != true,
            true
        ),
        new CursedItem(
            $item[cursed blanket],
            $monster[shadow of groar],
            "+3 res",
            __quest_state["Trapper"].finished != true,
            false
        ),
        new CursedItem(
            $item[cursed machete],
            $monster[corruptor shadow],
            "+50% meat",
            __quest_state["Level 11 Hidden City"].finished != true,
            false
        ),
        new CursedItem(
            $item[cursed medallion],
            $monster[shadow of the 1960s],
            "+100% init",
            __quest_state["Island War"].finished != true,
            false
        )
    };

    string [int] description;
    foreach index, cursedItem in cursedItems {
        if (cursedItem.shouldDisplay) {
            string goose = cursedItem.valuableToGooseDupe ? "🦢 " : "";
            description.listAppend(`{goose}{HTMLGenerateSpanOfClass(cursedItem.boss.name, "r_bold")}: {cursedItem.description}`);
        }
    }

    if (count(description) > 0) {
        resource_entries.listAppend(ChecklistEntryMake("__monster shadow prism", "", ChecklistSubentryMake("Cursed boss drops", "consider duping the items with 🦢", description), 2).ChecklistEntrySetIDTag("Avatar of Shadows Over Loathing cursed items resource"));
    }
}

void showDecurseResourceTile(ChecklistEntry [int] resource_entries) {
    int fastenersNeeded = __quest_state["Level 9"].state_int["bridge fasteners needed"];
    int lumberNeeded = __quest_state["Level 9"].state_int["bridge lumber needed"];
    boolean needBridgeParts =  __quest_state["Level 9"].mafia_internal_step == 1 && // Bridge not complete yet
        (fastenersNeeded > 0 || lumberNeeded > 0 ); // And we need some parts
    boolean shouldDecurseBatPaw = my_level() >= 12 &&
        __quest_state["Cyrpt"].finished == true &&
        __quest_state["Typical Tavern"].finished == true &&
        needBridgeParts &&
        $item[uncursed bat paw].available_amount() < 1;

    if (shouldDecurseBatPaw) {
        string description = `{HTMLGenerateSpanOfClass("cursed bat paw", "r_bold")} to get -ML for bridge parts!`;
        resource_entries.listAppend(ChecklistEntryMake("__item uncursed bat paw", "", ChecklistSubentryMake("Useful items to decurse", "", description), 0).ChecklistEntrySetIDTag("Avatar of Shadows Over Loathing decurse resource"));
    }
}

RegisterResourceGenerationFunction("PathShadowsOverLoathingGenerateResource");
void PathShadowsOverLoathingGenerateResource(ChecklistEntry [int] resource_entries) {
    if (my_path() != $path[Avatar of Shadows Over Loathing]) return;

    showCursedItemsResourceTile(resource_entries);
    showDecurseResourceTile(resource_entries);
}
