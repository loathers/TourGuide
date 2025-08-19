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

// Prompt to use garden resources when they're helpful
RegisterResourceGenerationFunction("IOTMRockGardenGenerateResource");
void IOTMRockGardenGenerateResource(ChecklistEntry [int] resource_entries) {
    string [int] description;
    string url = "campground.php";

    if (!get_property_boolean("_molehillMountainUsed") && available_amount($item[molehill mountain]) > 0)
    {
        resource_entries.listAppend(ChecklistEntryMake("__item molehill mountain", url = "inventory.php?ftext=molehill+mountain", ChecklistSubentryMake("Molehill moleman", "", "Free scaling fight."), 5).ChecklistEntrySetCombinationTag("daily free fight").ChecklistEntrySetIDTag("Molehill free fight"));
    }

    int availableGravels = available_amount($item[groveling gravel]);
    int availableMilestones = available_amount($item[milestone]);
    int availableWhetStones = available_amount($item[whet stone]);

    // Ascension stuff
    if (!__misc_state["in run"] ||
        my_path().id == PATH_COMMUNITY_SERVICE ||
        availableGravels + availableMilestones + availableWhetstones == 0)
        return;

    int desertProgress = get_property_int("desertExploration");

    if (availableGravels > 0 && $item[groveling gravel].item_is_usable())
    {
        description.listAppend(gravelMessage(availableGravels));
    }

    if (availableWhetStones > 0 && $item[whet stone].item_is_usable() && (__misc_state["can eat just about anything"]))
    {
        description.listAppend(whetStoneMessage(availableWhetStones));
    }

    if (availableMilestones > 0 && $item[milestone].item_is_usable() && desertProgress < 100)
    {
        description.listAppend(milestoneMessage(availableMilestones));
    }

    resource_entries.listAppend(ChecklistEntryMake("__item rock garden guide", url, ChecklistSubentryMake("Rock garden resources", "", description)).ChecklistEntrySetIDTag("rock garden resource"));
	
    // Groveling Gravel: item-crunching instakill
    boolean instakills_usable = my_path().id != PATH_G_LOVER && my_path().id != PATH_POCKET_FAMILIARS && my_path().id != 52; // avant guard

    if (instakills_usable && availableGravels > 0)
    {
        string [int] gravelDescription;
        gravelDescription.listAppend("Use groveling gravel for a no-drop freekill.");
        resource_entries.listAppend(ChecklistEntryMake("__item groveling gravel", "", ChecklistSubentryMake(pluralise(availableGravels, "groveling gravel", "groveling gravels"), "", gravelDescription), 0).ChecklistEntrySetCombinationTag("free instakill").ChecklistEntrySetIDTag("groveling gravel free kill"));
        
    }
}
