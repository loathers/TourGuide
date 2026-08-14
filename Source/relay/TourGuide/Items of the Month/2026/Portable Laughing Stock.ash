//portable laughing stock
RegisterResourceGenerationFunction("IOTTPortableLaughingStockGenerateResource");
void IOTTPortableLaughingStockGenerateResource(ChecklistEntry [int] resource_entries)
{
	if (available_amount($item[portable laughing stock]) > 0) {
		string url = "inventory.php?ftext=portable+laughing+stock";
		string [int] description;
		
		int LaughingStockFruit = get_property_int("_laughingStockFruitDropped");
		int LaughingStockCharge = get_property_int("_laughingStockCharges");
		
		string title = (HTMLGenerateSpanFont(LaughingStockFruit, "blue") + " portable laughing stock fruit");
		
		if (LaughingStockFruit < 11) {
			int LaughingStockFruitTotal;
			if (LaughingStockFruit == 0) {
				LaughingStockFruitTotal = 1;
			} else if (LaughingStockFruit == 1) {
				LaughingStockFruitTotal = 2;
			} else if (LaughingStockFruit == 2) {
				LaughingStockFruitTotal = 4;
			} else if (LaughingStockFruit == 3) {
				LaughingStockFruitTotal = 7;
			} else if (LaughingStockFruit == 4) {
				LaughingStockFruitTotal = 11;
			} else if (LaughingStockFruit == 5) {
				LaughingStockFruitTotal = 16;
			} else if (LaughingStockFruit == 6) {
				LaughingStockFruitTotal = 22;
			} else if (LaughingStockFruit == 7) {
				LaughingStockFruitTotal = 29;
			} else if (LaughingStockFruit == 8) {
				LaughingStockFruitTotal = 37;
			} else if (LaughingStockFruit == 9) {
				LaughingStockFruitTotal = 46;
			} else if (LaughingStockFruit == 10) {
				LaughingStockFruitTotal = 56;
			}
			description.listAppend("" + HTMLGenerateSpanFont(LaughingStockCharge + "/" + LaughingStockFruitTotal + " easy fruit progress", "green") + "");
		}
		else if (LaughingStockFruit > 10) {
			description.listAppend("" + HTMLGenerateSpanFont("Not so easy now, buckaroo", "purple") + "");
		}
		
		description.listAppend(HTMLGenerateSpanFont(available_amount($item[antique watermelon]) + " Antique watermelon", "red"));
		description.listAppend(HTMLGenerateSpanFont(available_amount($item[quince]) + " Quince", "blue"));
		description.listAppend(HTMLGenerateSpanFont(available_amount($item[classic banana]) + " Classic banana", "green"));
		resource_entries.listAppend(ChecklistEntryMake("__item portable laughing stock", url, ChecklistSubentryMake(title, description), 11));
	}
}
