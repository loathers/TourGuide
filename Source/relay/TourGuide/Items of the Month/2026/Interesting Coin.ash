//interesting coin
RegisterResourceGenerationFunction("IOTMInterestingCoinGenerateResource");
void IOTMInterestingCoinGenerateResource(ChecklistEntry [int] resource_entries)
{
	boolean hasCoin = get_property_boolean("hasInterestingCoin");
	if (hasCoin) {
		string url = "shop.php?whichshop=interesting";
		string [int] description;
		string title = (available_amount($item[interesting coin]) + " interesting coins");
		description.listAppend("Collects interest and makes... stuff");
		description.listAppend("Gain " + floor(available_amount($item[interesting coin]) * 0.2) + " coins on rollover.");
		
		boolean coinFlipped = get_property_boolean("_interestingCoinHeads");
		if (!coinFlipped) {
			description.listAppend(HTMLGenerateSpanFont("Flip a coin to kill for free!", "blue"));
			description.listAppend("(Destroys item/meat drops)");
			
			resource_entries.listAppend(ChecklistEntryMake("__item interesting coin", "", ChecklistSubentryMake("Interesting Coinflip", url, description), 0).ChecklistEntrySetCombinationTag("free instakill").ChecklistEntrySetIDTag("Interesting coin free kill"));
		}
		resource_entries.listAppend(ChecklistEntryMake("__item interesting coin", url, ChecklistSubentryMake(title, description), 11));
	}
}
