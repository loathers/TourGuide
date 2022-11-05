
RegisterResourceGenerationFunction("IOTMCookbookbatGenerateResource");
void IOTMCookbookbatGenerateResource(ChecklistEntry [int] resource_entries)
{
    // Look up amount for the three constituent items for the bookbat foods
    int wheys  = lookupItem("10968").available_amount();
    int vegs   = lookupItem("10969").available_amount();
    int yeasts = lookupItem("10967").available_amount();

    // Do not generate a tile if you can't eat stuff or don't have any constituent items
    if (!__misc_state["can eat just about anything"] && (wheys + vegs + yeasts) < 1)
        return;
    
	string [int] description;
	string url = "craft.php?mode=cook";

	description.listAppend("Follow the old bat's wise counsel and craft legendary gluten bombs!");
    description.listAppend("You currently have "+wheys.to_string()+" whey, "+vegs.to_string()+" veg, and "+yeasts.to_string()+" yeast.");

    // Generating strings for the three most important food items
    string borisBread = "Boris's Bread: +100% meat; yeast + yeast";
    string roastedVeg = "Roasted Vegetable of Jarlsberg: +100% item; veg + veg";
    string focaccia = "Roasted Vegetable Focaccia: +10 Fam XP; bread + roast veg";

    // Here, we're generating a list of what you can make with your loadout.
    string [int] pizzaParlorMenu;
    pizzaParlorMenu.listAppend("You can make...");
    pizzaParlorMenu.listAppend(borisBread);
    pizzaParlorMenu.listAppend(roastedVeg);
    pizzaParlorMenu.listAppend(focaccia);
    description.listAppend(pizzaParlorMenu.listJoinComponents("|*"));

    resource_entries.listAppend(ChecklistEntryMake("__familiar cookbookbat", url, ChecklistSubentryMake("Pizza Party with Mr. Cookbookbat!", "", description)).ChecklistEntrySetIDTag("Cookbookbat Resource"));
}