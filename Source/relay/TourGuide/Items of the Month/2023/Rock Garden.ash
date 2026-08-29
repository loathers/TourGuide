

// 2023
string gravelMessage(int gravels)
{
    return HTMLGenerateSpanOfClass(gravels, "r_bold") + "x groveling gravel (free kill*)";
}

string whetStoneMessage(int whetStones)
{
    return HTMLGenerateSpanOfClass(whetStones, "r_bold") + "x whet stone (+1 adv on food)";
}

string milestoneMessage(int milestones)
{
    int desertProgress = get_property_int("desertExploration");
    return HTMLGenerateSpanOfClass(milestones, "r_bold") + "x milestone (+5% desert progress), " + (100 - desertProgress) + "% remaining";
}

// Prompt to harvest your garden in run when useful items are growing in it
RegisterTaskGenerationFunction("IOTMRockGardenGenerateTasks");
void IOTMRockGardenGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries) {
    if ($effect[loded].have_effect() > 0) {
        string url = "place.php?whichplace=airport_hot";
		string [int] lodedDescription;
        lodedDescription.listAppend(HTMLGenerateSpanFont("First you mine, then you craft", "orange"));
        task_entries.listAppend(ChecklistEntryMake("__effect loded", url, ChecklistSubentryMake($effect[loded].have_effect() + " loded free mines", "", lodedDescription), -11));
    }
	
	string [int] description;
    string url = "campground.php";
    int gardenGravels = __campground[$item[groveling gravel]];
    int gardenMilestones = __campground[$item[milestone]];
    int gardenWhetstones = __campground[$item[whet stone]];

    if (!__iotms_usable[lookupItem("packet of rock seeds")] ||
        !__misc_state["in run"] ||
        my_path().id == PATH_COMMUNITY_SERVICE ||
        gardenGravels + gardenMilestones + gardenWhetstones == 0)
        return;

    int desertProgress = get_property_int("desertExploration");

    if (gardenGravels > 0)
    {
        description.listAppend(gravelMessage(gardenGravels));
    }

    if (gardenWhetstones > 0)
    {
        description.listAppend(whetStoneMessage(gardenWhetstones));
    }

    if (gardenMilestones > 0 && desertProgress < 100)
    {
        description.listAppend(milestoneMessage(gardenMilestones));
    }

    task_entries.listAppend(ChecklistEntryMake("__item rock garden guide", url, ChecklistSubentryMake("Harvest your rock garden", "", description)).ChecklistEntrySetIDTag("rock garden task"));
}
