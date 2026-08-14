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
			description.listAppend("" + HTMLGenerateSpanFont(LaughingStockCharge + "/56 easy fruit progress", "green") + "");
			if (LaughingStockFruit == 0) {
				description.listAppend("" + HTMLGenerateSpanFont(LaughingStockCharge + "/1 progress", "green") + "");
			} else if (LaughingStockFruit == 1) {
				description.listAppend("" + HTMLGenerateSpanFont(LaughingStockCharge + "/2 progress", "green") + "");
			} else if (LaughingStockFruit == 2) {
				description.listAppend("" + HTMLGenerateSpanFont(LaughingStockCharge + "/4 progress", "green") + "");
			} else if (LaughingStockFruit == 3) {
				description.listAppend("" + HTMLGenerateSpanFont(LaughingStockCharge + "/7 progress", "green") + "");
			} else if (LaughingStockFruit == 4) {
				description.listAppend("" + HTMLGenerateSpanFont(LaughingStockCharge + "/11 progress", "green") + "");
			} else if (LaughingStockFruit == 5) {
				description.listAppend("" + HTMLGenerateSpanFont(LaughingStockCharge + "/16 progress", "green") + "");
			} else if (LaughingStockFruit == 6) {
				description.listAppend("" + HTMLGenerateSpanFont(LaughingStockCharge + "/22 progress", "green") + "");
			} else if (LaughingStockFruit == 7) {
				description.listAppend("" + HTMLGenerateSpanFont(LaughingStockCharge + "/29 progress", "green") + "");
			} else if (LaughingStockFruit == 8) {
				description.listAppend("" + HTMLGenerateSpanFont(LaughingStockCharge + "/37 progress", "green") + "");
			} else if (LaughingStockFruit == 9) {
				description.listAppend("" + HTMLGenerateSpanFont(LaughingStockCharge + "/46 progress", "green") + "");
			} else if (LaughingStockFruit == 10) {
				description.listAppend("" + HTMLGenerateSpanFont(LaughingStockCharge + "/56 progress", "green") + "");
			}
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
