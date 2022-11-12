RegisterResourceGenerationFunction("IOTMCookbookbatGenerateResource");
void IOTMCookbookbatGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (!lookupFamiliar("Cookbookbat").familiar_is_usable()) return;

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

    // How many can we make of each food item?
    int borisBreadCraftable = floor(yeasts/2);
    int roastedVegCraftable = floor(vegs/2);
    int focacciaCraftable = roastedVegCraftable > 0 && borisBreadCraftable > 0 ? min(borisBreadCraftable, roastedVegCraftable) : 0;

    // Generating strings for the three most important food items
    string borisBread = "<strong>"+borisBreadCraftable+"x Boris's Bread:</strong> +100% meat"; // yeast + yeast 
    string roastedVeg = "<strong>"+roastedVegCraftable+"x Roasted Vegetable of Jarlsberg:</strong> +100% item"; // veg + veg";
    string focaccia = "<strong>"+focacciaCraftable+"x Roasted Vegetable Focaccia:</strong> +10 Fam XP"; // bread + roast veg";

    // Here, we're generating a list of what you can make with your loadout.
    string [int] pizzaParlorMenu;
    pizzaParlorMenu.listAppend("You can make...");
    pizzaParlorMenu.listAppend(borisBread);
    pizzaParlorMenu.listAppend(roastedVeg);
    pizzaParlorMenu.listAppend(focaccia);
    description.listAppend(pizzaParlorMenu.listJoinComponents("|*"));

    string [int][int] pizzaParlorRecipes;
	pizzaParlorRecipes.listAppend(listMake("Boris's Bread = yeast + yeast"));
	pizzaParlorRecipes.listAppend(listMake("Roasted Vegetable of Jarlsberg = veg + veg"));
	pizzaParlorRecipes.listAppend(listMake("Roasted Vegetable Focaccia = bread + roastveg"));

    buffer tooltip_text;
	tooltip_text.append(HTMLGenerateTagWrap("div", "Cookbookbat Recipes!", mapMake("class", "r_bold r_centre", "style", "padding-bottom:0.25em;")));
	tooltip_text.append(HTMLGenerateSimpleTableLines(pizzaParlorRecipes));
			
	description.listAppend(HTMLGenerateSpanOfClass(HTMLGenerateSpanOfClass(tooltip_text, "r_tooltip_inner_class r_tooltip_inner_class_margin") + "Important Recipes", "r_tooltip_outer_class"));

    resource_entries.listAppend(ChecklistEntryMake("__familiar cookbookbat", url, ChecklistSubentryMake("Pizza party with the Cookbookbat!", "", description)).ChecklistEntrySetIDTag("Cookbookbat Resource"));
}