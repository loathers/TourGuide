// Miniature crystal ball
RegisterTaskGenerationFunction("IOTMCrystalBallGenerateTasks");
void IOTMCrystalBallGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	string title = "Miniature crystal ball monster prediction";
	string image_name = "__item miniature crystal ball";
	string [int] description; // No general orb description yet.

	string [int] orb_predictions = get_property("crystalBallPredictions").split_string("[|]"); // Breaks mafia's orb tracking propterty down into a map of individual predictions.
	if (available_amount($item[miniature crystal ball]) > 0) // Only do things if we have the orb.
	{
		if (orb_predictions[0] != "") { // If the prediction property isn't empty:
			foreach x in orb_predictions { // For every indidivual prediction,
                string [int] split_predictions = orb_predictions[x].split_string(":"); // break down the prediciton into turn/zone/monster
				description.listAppend("Prediction Generated On: " + split_predictions[0] + " | Zone: " + split_predictions[1] + " | Monster: "+ split_predictions[2]); // then format and add the prediction substrings to the crystal ball tile.
			}
            if (!have_equipped($item[miniature crystal ball])) { // If we don't have the crystal ball equipped, add a reminder.
                description.listAppend("Equip your miniature crystal ball if you want to encounter your predictions!");	
            }
            optional_task_entries.listAppend(ChecklistEntryMake("__item miniature crystal ball", "familiar.php", ChecklistSubentryMake(title, description))); // Add the orb tile to the TourGuide window.		
		}
		else { // If we don't have any predictions, let us know.
 			description.listAppend("You currently have no predicitons.");
            if (!have_equipped($item[miniature crystal ball]))
            {							
                description.listAppend("Equip the miniature crystal ball to predict a monster!");	
            }
			optional_task_entries.listAppend(ChecklistEntryMake("__item miniature crystal ball", "familiar.php", ChecklistSubentryMake(title, description)));			
        }
    }
}
