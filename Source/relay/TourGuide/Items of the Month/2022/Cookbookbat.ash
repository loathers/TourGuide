RegisterTaskGenerationFunction("IOTMCookbookbatGenerateTasks");
void IOTMCookbookbatGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if (!lookupFamiliar("Cookbookbat").familiar_is_usable()) return;
	string url = "familiar.php";
	string [int] description;
	string cbbIngredient = (get_property("_cookbookbatQuestIngredient"));
	string cbbTarget = (get_property("_cookbookbatQuestMonster"));
	string cbbZone = (get_property("_cookbookbatQuestLastLocation"));
	int cbbResetTimer = get_property_int("_cookbookbatCombatsUntilNewQuest");
	string main_title = HTMLGenerateSpanFont("Cookbookbat hunt", "black");
	description.listAppend(HTMLGenerateSpanOfClass(cbbResetTimer, "r_bold") + " fights until new hunt");
	int cbbIngredientDrop = 11 - get_property_int("cookbookbatIngredientsCharge");
	description.listAppend(HTMLGenerateSpanOfClass(cbbIngredientDrop, "r_bold") + " wins until 3x ingredient");
			
	if (cbbTarget != "" && cbbIngredient != "") {
		description.listAppend("Hunt: " + HTMLGenerateSpanFont(cbbTarget, "blue"));
		description.listAppend("Zone: " + HTMLGenerateSpanFont(cbbZone, "purple"));
		description.listAppend("Reward: 3x " +HTMLGenerateSpanFont(cbbIngredient, "green"));
		location questLocation = get_property("_cookbookbatQuestLastLocation").to_location();
		
		if (my_familiar() == lookupFamiliar("cookbookbat")) {
			task_entries.listAppend(ChecklistEntryMake("__familiar cookbookbat", questLocation.getClickableURLForLocation(), ChecklistSubentryMake(main_title, description), -11, boolean [location] {questLocation:true}).ChecklistEntrySetIDTag("cookbookbat hunt"));
		}
		else if (my_familiar() != lookupFamiliar("cookbookbat")) {
			optional_task_entries.listAppend(ChecklistEntryMake("__familiar cookbookbat", questLocation.getClickableURLForLocation(), ChecklistSubentryMake(main_title, description), 10, boolean [location] {questLocation:true}).ChecklistEntrySetIDTag("cookbookbat hunt"));
		}
	}
	if (cbbTarget == "" && cbbIngredient == "" && my_familiar() == lookupFamiliar("cookbookbat")) {
		task_entries.listAppend(ChecklistEntryMake("__familiar cookbookbat", url, ChecklistSubentryMake("Cookbookbat charging", description), -11));
	}	
}

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
	
	int cbbIngredientDrop = 11 - get_property_int("cookbookbatIngredientsCharge");
	int cbbResetTimer = get_property_int("_cookbookbatCombatsUntilNewQuest");
	description.listAppend(HTMLGenerateSpanOfClass(cbbIngredientDrop, "r_bold") + " wins until 3x ingredient");
		description.listAppend(HTMLGenerateSpanOfClass(cbbResetTimer, "r_bold") + " fights until new hunt");
	
    int cookings_remaining = clampi(5 - get_property_int("_cookbookbatCrafting"), 0, 5);
    if (cookings_remaining > 0) 
    {
        description.listAppend(HTMLGenerateSpanOfClass(cookings_remaining, "r_bold") + " free cooks: Unstable fulminate, potions, and more.");
    }
	
    resource_entries.listAppend(ChecklistEntryMake("__familiar cookbookbat", url, ChecklistSubentryMake("Pizza party with the Cookbookbat!", "", description)).ChecklistEntrySetIDTag("Cookbookbat Resource"));
}
