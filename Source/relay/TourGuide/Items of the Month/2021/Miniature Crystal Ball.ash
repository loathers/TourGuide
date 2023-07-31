// Miniature Crystal ball
RegisterTaskGenerationFunction("IOTMCrystalBallGenerateTasks");
void IOTMCrystalBallGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	string title;
 
	title = "Miniature crystal ball monster prediction(s)";
	string image_name = "__item packaged miniature crystal ball";
	string crystalBall = (get_property("crystalBallPredictions"));
	string url;
	url = "inventory.php?ponder=1";
	string [int] description;
	description.listAppend("The future foretells... dickstabbing!");

	// Adding replica handling for LOL
    int ballsEquipped = lookupItem("miniature crystal ball").equipped_amount() + lookupItem("replica miniature crystal ball").equipped_amount();

	if (__iotms_usable[$item[miniature crystal ball]]) 
	{
		if (ballsEquipped == 0) //when mcb is not equipped
		{
			if (crystalBall != "")
			{
				string [int] predictionsSection;
                predictionsSection.listAppend(HTMLGenerateSpanOfClass("Predictions:", "r_bold"));
                string[] predictions = crystalBall.split_string("[|]");
                foreach i in (predictions) {
                    string[] predictions_split = predictions[i].split_string(":");
                    predictionsSection.listAppend(predictions_split[1] + " - " + predictions_split[2]);
                }
                description.listAppend(predictionsSection.listJoinComponents("|*"));
				description.listAppend("" + HTMLGenerateSpanFont("Equip the miniature crystal ball first!", "red") + "");
				url = "inventory.php?ponder=1";
				task_entries.listAppend(ChecklistEntryMake(image_name, url, ChecklistSubentryMake(title, description), -11));
			}
			else 
			{				
				description.listAppend("Equip the miniature crystal ball to predict a monster!");
				url = invSearch("miniature crystal ball");
				optional_task_entries.listAppend(ChecklistEntryMake("__item quantum of familiar", url, ChecklistSubentryMake(title, description)));
			}
		}
		else //when mcb is equipped
		{
			if (crystalBall != "")
			{
                string [int] predictionsSection;
                predictionsSection.listAppend(HTMLGenerateSpanOfClass("Predictions:", "r_bold"));
                string[] predictions = crystalBall.split_string("[|]");
                foreach i in (predictions) {
                    string[] predictions_split = predictions[i].split_string(":");
                    predictionsSection.listAppend(predictions_split[1] + " - " + predictions_split[2]);
                }
                description.listAppend(predictionsSection.listJoinComponents("|*"));
				description.listAppend("" + HTMLGenerateSpanFont("Miniature crystal ball equipped!", "blue") + "");
				task_entries.listAppend(ChecklistEntryMake(image_name, url, ChecklistSubentryMake(title, description), -11));
			}
			else
			{
				description.listAppend("Adventure in a snarfblat to predict a monster!");
				description.listAppend("" + HTMLGenerateSpanFont("Miniature crystal ball equipped!", "blue") + "");
				task_entries.listAppend(ChecklistEntryMake("__item quantum of familiar", url, ChecklistSubentryMake(title, description), -11));
			}	
		}
	}
}