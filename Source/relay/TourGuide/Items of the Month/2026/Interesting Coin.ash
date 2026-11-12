
//interesting coin
RegisterTaskGenerationFunction("IOTMInterestingCoinGenerateTasks");
void IOTMInterestingCoinGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    int ToxicAss = get_property_int("toxicAssetCharges");
	int IntangibleAss = get_property_int("intangibleAssetCharges");
	
	string [int] Tdescription;
	string [int] Idescription;
	if (ToxicAss > 0) {
		Tdescription.listAppend("Forces items from next monster");
		task_entries.listAppend(ChecklistEntryMake("__item toxic asset", "", ChecklistSubentryMake(HTMLGenerateSpanFont(ToxicAss + " Toxic Asset YR(s)", "purple"), Tdescription), -11).ChecklistEntrySetIDTag("interesting coin"));
	}
	if (IntangibleAss > 0) {
		Idescription.listAppend("Converts monster meat into substats");
		task_entries.listAppend(ChecklistEntryMake("__item intangible asset", "", ChecklistSubentryMake(HTMLGenerateSpanFont(IntangibleAss + " Intangible Asset statgain(s)", "grey"), Idescription), -11).ChecklistEntrySetIDTag("interesting coin"));
	}
}
RegisterResourceGenerationFunction("IOTMInterestingCoinGenerateResource");
void IOTMInterestingCoinGenerateResource(ChecklistEntry [int] resource_entries)
{
	boolean hasCoin = get_property_boolean("hasInterestingCoin");
	if (hasCoin) {
		string url = "shop.php?whichshop=interesting";
		string [int] description;
		string title = (available_amount($item[interesting coin]) + " interesting coins");
		description.listAppend("Collects interest and makes... stuff");
/*		if (floor(available_amount($item[interesting coin]) * 1.2 >= 16777215)) {
			description.listAppend(HTMLGenerateSpanFont("16,777,215 coins after rollover!", "blue"));
			if (floor(available_amount($item[interesting coin]) >= 13985056)) {
				description.listAppend(HTMLGenerateSpanFont("You can spend " + (available_amount($item[interesting coin] - 13985056) + " coins!", "blue"));
			}
		}
		else {
*/			description.listAppend("Gain " + max(3, floor(available_amount($item[interesting coin]) * 0.2)) + " coins on rollover.");
#		}
		boolean coinFlipped = get_property_boolean("_interestingCoinHeads");
		if (!coinFlipped) {
			description.listAppend(HTMLGenerateSpanFont("Flip a coin to kill for free!", "blue"));
			description.listAppend("(Destroys item/meat drops)");
			
			resource_entries.listAppend(ChecklistEntryMake("__item interesting coin", "", ChecklistSubentryMake("Interesting Coinflip", url, description), 0).ChecklistEntrySetCombinationTag("free instakill").ChecklistEntrySetIDTag("Interesting coin free kill"));
		}
		resource_entries.listAppend(ChecklistEntryMake("__item interesting coin", url, ChecklistSubentryMake(title, description), 11));
	}
	int LiquidAss = get_property_int("exerciseLiquidityCharges");
	string [int] Ldescription;
	if (LiquidAss > 0) {
		Ldescription.listAppend("Swap a monster!");
		resource_entries.listAppend(ChecklistEntryMake("__item liquid asset", "", ChecklistSubentryMake(HTMLGenerateSpanFont(LiquidAss + " Liquid Asset replacements(s)", "blue"), Ldescription), -11).ChecklistEntrySetIDTag("interesting coin"));
	}
}
