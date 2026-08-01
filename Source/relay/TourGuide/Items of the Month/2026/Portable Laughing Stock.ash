//portable laughing stock
RegisterResourceGenerationFunction("IOTTPortableLaughingStockGenerateResource");
void IOTTPortableLaughingStockGenerateResource(ChecklistEntry [int] resource_entries)
{
	if (available_amount($item[portable laughing stock]) > 0) {
		string url = "inventory.php?ftext=portable+laughing+stock";
		string [int] description;
		
		int LaughingStockFruit = get_property_int("_laughingStockFruitDropped");
		string title = (HTMLGenerateSpanFont(LaughingStockFruit, "blue") + " portable laughing stock fruit");
		
		if (LaughingStockFruit < 12) {
			description.listAppend("" + HTMLGenerateSpanFont("Easy to get fruit drops", "green") + "");
		}
		else if (LaughingStockFruit > 11) {
			description.listAppend("" + HTMLGenerateSpanFont("Not so easy now, buckaroo", "purple") + "");
		}
		
		description.listAppend(HTMLGenerateSpanFont(available_amount($item[antique watermelon]) + " Antique watermelon", "red"));
		description.listAppend(HTMLGenerateSpanFont(available_amount($item[quince]) + " Quince", "blue"));
		description.listAppend(HTMLGenerateSpanFont(available_amount($item[classic banana]) + " Classic banana", "green"));
		resource_entries.listAppend(ChecklistEntryMake("__item portable laughing stock", url, ChecklistSubentryMake(title, description), 11));
	}
}
