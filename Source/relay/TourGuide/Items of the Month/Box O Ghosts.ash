//Ghost of Crimbo Commerce
RegisterTaskGenerationFunction("IOTMCommerceGhostGenerateTasks");
void IOTMCommerceGhostGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    item commerce_item = get_property_item("commerceGhostItem");
	int commerce_statgain1 = my_level() * 20;
	int commerce_statgain2 = my_level() * 25;
    if (commerce_item != $item[none]) 
	{
		string [int] description;
		string title = "Give yourself the gift of getting!";
			description.listAppend(HTMLGenerateSpanFont("Buy", "red") + " " + HTMLGenerateSpanFont("buy ", "green") + " " + HTMLGenerateSpanFont("buy", "red") + " " + HTMLGenerateSpanFont("buy ", "green") + " " + HTMLGenerateSpanFont("buy!", "red"));
 
			string url = "mall.php?justitems=0&pudnuggler=%22" + commerce_item + "%22";
 
			description.listAppend("Buy " + commerce_item + " to get ~" + commerce_statgain1 + "-" + commerce_statgain2 + " to all 3 substats!");
			description.listAppend(HTMLGenerateSpanFont("Buy", "green") + " " + HTMLGenerateSpanFont("buy ", "red") + " " + HTMLGenerateSpanFont("buy ", "green") + " " + HTMLGenerateSpanFont("buy", "red") + " " + HTMLGenerateSpanFont("buy!", "green"));
 
            task_entries.listAppend(ChecklistEntryMake("__familiar Ghost of Crimbo Commerce", url, ChecklistSubentryMake(title, description), -11));
	}
}