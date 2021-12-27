//2021
//Miniature Crystal ball
RegisterTaskGenerationFunction("IOTMCrystalBallGenerateTasks");
void IOTMCrystalBallGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	string title;
	title = "Miniature crystal ball monster prediction";
	string image_name = "__item miniature crystal ball";
	string predictionArray = get_property("crystalBallPredictions").split_string("[|]");
	string [int] description;
	if (available_amount($item[miniature crystal ball]) > 0) 
	{
		if (predictionArray != "") {
			foreach x in predictionArray {
				description.listAppend(predictionArray[x]);
			}
			optional_task_entries.listAppend(ChecklistEntryMake("__item miniature crystal ball", "url", ChecklistSubentryMake(title, description)));			
		}
		else {
 			description.listAppend("You currently have no predicitons.");
			optional_task_entries.listAppend(ChecklistEntryMake("__item miniature crystal ball", "url", ChecklistSubentryMake(title, description)));			
		}

		if (!have_equipped($item[miniature crystal ball]))
		{							
			description.listAppend("Equip the miniature crystal ball to predict a monster!");
			optional_task_entries.listAppend(ChecklistEntryMake("__item miniature crystal ball", "url", ChecklistSubentryMake(title, description)));			
		}
		// else
		// {
		// 	if (predictionArray != "")
		// 	{
		// 		description.listAppend("Next fight in " + HTMLGenerateSpanFont(crystalBallZone, "blue") + " will be: " + HTMLGenerateSpanFont(crystalBallPrediction, "blue"));
		// 		task_entries.listAppend(ChecklistEntryMake(image_name, "url", ChecklistSubentryMake(title, description), -11));
		// 	}
		// 	else
		// 	{
		// 		description.listAppend("Adventure in a snarfblat to predict a monster!");
		// 		task_entries.listAppend(ChecklistEntryMake("__item quantum of familiar", "url", ChecklistSubentryMake(title, description)));
		// 	}	
		// }
	}
}