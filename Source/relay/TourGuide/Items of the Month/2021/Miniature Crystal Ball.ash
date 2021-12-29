// Miniature crystal ball
RegisterTaskGenerationFunction("IOTMCrystalBallGenerateTasks");
void IOTMCrystalBallGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	string title = "Miniature crystal ball monster prediction";
	string [int] description; // No general orb description yet.
	string [int] orb_predictions = get_property("crystalBallPredictions").split_string("[|]"); // Breaks mafia's orb tracking propterty down into a map of individual predictions.

	if (available_amount($item[miniature crystal ball]) > 0) // Only do things if we have the orb.
	{
		if (orb_predictions[0] != "") { // If the prediction property isn't empty:
            description.listAppend(HTMLGenerateSpanFont("These predictions may not be accurate, the crystal ball is very fiddly.", "grey"));
			foreach x in orb_predictions { // For every indidivual prediction,
                string [int] split_predictions = orb_predictions[x].split_string(":"); // break down the prediciton into turn/zone/monster
				description.listAppend("Monster: " + split_predictions[2] + " | Zone: "+ split_predictions[1] + " | " + (split_predictions[0].to_int() + 2 - my_turncount() > 0 ? ("Turns left: " + (split_predictions[0].to_int() + 2 - my_turncount()).to_string()) : "Expired")); // then format and add the prediction substrings to the crystal ball tile.
			}

            string tile_image = count(orb_predictions) == 1 ? "__monster " + orb_predictions[0].split_string(":")[2] : "__item quantum of familiar";

            if (!have_equipped($item[miniature crystal ball])) { // If we don't have the crystal ball equipped, add a reminder.
                description.listAppend(HTMLGenerateSpanFont("Equip your miniature crystal ball if you want to encounter your predictions!", "red"));
                optional_task_entries.listAppend(ChecklistEntryMake(tile_image, "familiar.php", ChecklistSubentryMake(title, description), -1)); // Optional task if not equipped.
            }
			else {
            	task_entries.listAppend(ChecklistEntryMake(tile_image, "familiar.php", ChecklistSubentryMake(title, description), -11)); // Top priority if equipped.		
			}
        }
        else { // If we don't have any predictions, let us know.
            description.listAppend("The crystal ball will predict the next monster in a zone. Adventure in the zone again to encounter the monster, or elsewhere to reset the prediction.");
 			description.listAppend("You currently have no predicitons.");
            if (!have_equipped($item[miniature crystal ball]))
            {							
                description.listAppend(HTMLGenerateSpanFont("Equip the miniature crystal ball to predict a monster!", "red"));	
            }
			optional_task_entries.listAppend(ChecklistEntryMake("__item miniature crystal ball", "familiar.php", ChecklistSubentryMake(title, description), -1));			
        }
    }