//2021
//Miniature Crystal ball
RegisterTaskGenerationFunction("IOTMCrystalBallGenerateTasks");
void IOTMCrystalBallGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	if (lookupItem("miniature crystal ball").available_amount() == 0)
		return;
	string title = "Miniature crystal ball monster prediction";
	string image_name = "__item miniature crystal ball";
	monster crystalBallPrediction = (get_property_monster("crystalBallMonster"));
	location crystalBallZone = (get_property_location("crystalBallLocation"));
	image_name = "__monster " + crystalBallPrediction;
	string [int] description;
	if (!lookupItem("miniature crystal ball").equipped())
	{
		if (crystalBallPrediction != $monster[none])
		{
			description.listAppend("Next fight in " + HTMLGenerateSpanFont(crystalBallZone, "black") + " will be: " + HTMLGenerateSpanFont(crystalBallPrediction, "black"));
			description.listAppend("" + HTMLGenerateSpanFont("Equip the miniature crystal ball first!", "red") + "");
			optional_task_entries.listAppend(ChecklistEntryMake(image_name, "url", ChecklistSubentryMake(title, description), -11));
		}
		else
		{
			description.listAppend("Equip the miniature crystal ball to predict a monster!");
			optional_task_entries.listAppend(ChecklistEntryMake("__item miniature crystal ball", "url", ChecklistSubentryMake(title, description)));
		}
	}
	else
	{
		if (crystalBallPrediction != $monster[none])
		{
			description.listAppend("Next fight in " + HTMLGenerateSpanFont(crystalBallZone, "blue") + " will be: " + HTMLGenerateSpanFont(crystalBallPrediction, "blue"));
			task_entries.listAppend(ChecklistEntryMake(image_name, "url", ChecklistSubentryMake(title, description), -11));
		}
		else
		{
			description.listAppend("Adventure in a snarfblat to predict a monster!");
			task_entries.listAppend(ChecklistEntryMake("__item quantum of familiar", "url", ChecklistSubentryMake(title, description)));
		}	
	}
}