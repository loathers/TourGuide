//Ghost of Crimbo Commerce
RegisterTaskGenerationFunction("IOTMCommerceGhostGenerateTasks");
void IOTMCommerceGhostGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	item commerce_item = get_property_item("commerceGhostItem");
	int commerce_statgain1 = my_level() * 20;
	int commerce_statgain2 = my_level() * 25;
	if (__misc_state["in run"] && $familiar[Ghost of Crimbo Commerce].familiar_is_usable())
	{
		// Title
		string url = "familiar.php";
		string title = get_property("commerceGhostCombats") + "/11 Commerce Ghost combats";
		string [int] description;
		description.listAppend(HTMLGenerateSpanFont("Don't", "red") + " " + HTMLGenerateSpanFont("ask", "green") + " " + HTMLGenerateSpanFont("questions,", "red") + " " + HTMLGenerateSpanFont("just", "green") + " " + HTMLGenerateSpanFont("consume", "red") + " " + HTMLGenerateSpanFont("product", "green") + " " + HTMLGenerateSpanFont("and", "red") + " " + HTMLGenerateSpanFont("then", "green") + " " + HTMLGenerateSpanFont("get", "red") + " " + HTMLGenerateSpanFont("excited", "green") + " " + HTMLGenerateSpanFont("for", "red") + " " + HTMLGenerateSpanFont("new", "green") + " " + HTMLGenerateSpanFont("products.", "red"));
		description.listAppend("Gain ~" + commerce_statgain1 + "-" + commerce_statgain2 + " to all 3 substats.");
		description.listAppend("Wins, losses, banishes, anything works.");
		
		if (commerce_item != $item[none]) 
		{
			string title = "Give yourself the gift of getting!";
			description.listAppend(HTMLGenerateSpanFont("Buy", "red") + " " + HTMLGenerateSpanFont("buy ", "green") + " " + HTMLGenerateSpanFont("buy", "red") + " " + HTMLGenerateSpanFont("buy ", "green") + " " + HTMLGenerateSpanFont("buy!", "red"));
			
			string url = "mall.php?justitems=0&pudnuggler=%22" + commerce_item + "%22";
			
			description.listAppend("Buy " + commerce_item + " to get ~" + commerce_statgain1 + "-" + commerce_statgain2 + " to all 3 substats!");
			description.listAppend(HTMLGenerateSpanFont("Buy", "green") + " " + HTMLGenerateSpanFont("buy ", "red") + " " + HTMLGenerateSpanFont("buy ", "green") + " " + HTMLGenerateSpanFont("buy", "red") + " " + HTMLGenerateSpanFont("buy!", "green"));
		
			task_entries.listAppend(ChecklistEntryMake("__familiar Ghost of Crimbo Commerce", url, ChecklistSubentryMake(title, description), -11));
		}
		optional_task_entries.listAppend(ChecklistEntryMake("__familiar Ghost of Crimbo Commerce", url, ChecklistSubentryMake(title, description)));
	}
}