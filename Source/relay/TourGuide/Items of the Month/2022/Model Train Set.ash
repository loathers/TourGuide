string [string, string] carDescriptions;

int trainSetReconfigurableIn() {
    int trainPosition = get_property_int("trainsetPosition");
    int whenTrainsetWasConfigured = get_property_int("lastTrainsetConfiguration");
    if (whenTrainsetWasConfigured == trainPosition ||
        trainPosition - whenTrainsetWasConfigured >= 40) {
        return 0;
    } else {
        return 40 - (trainPosition - whenTrainsetWasConfigured);
    }
}

boolean stationConfigured(string station) {
    return contains_text(get_property("trainsetConfiguration"), station);
}

boolean oreConfiguredWhenNotNeeded() {
    boolean oreConfigured = stationConfigured("ore_hopper");
    string oreNeeded = get_property("trapperOre");
    boolean haveAllOreNeeded = __quest_state["Level 8"].state_boolean["Past mine"] ||
        (oreNeeded != "" && to_item(oreNeeded).available_amount() >= 3) ||
        (to_item("asbestos ore").available_amount() >= 3 &&
         to_item("chrome ore").available_amount() >= 3 &&
         to_item("linoleum ore").available_amount() >= 3);
    return oreConfigured && haveAllOreNeeded;
}

boolean loggingMillConfiguredWhenNotNeeded() {
    boolean loggingMillConfigured = stationConfigured("logging_mill");
    int fastenersNeeded = __quest_state["Level 9"].state_int["bridge fasteners needed"];
	int lumberNeeded = __quest_state["Level 9"].state_int["bridge lumber needed"];
    boolean haveAllPartsNeeded = __quest_state["Level 9"].mafia_internal_step > 1 ||
        (fastenersNeeded == 0 && lumberNeeded == 0);
    return loggingMillConfigured && haveAllPartsNeeded;
}

boolean statsConfiguredWhenNotNeeded() {
    boolean statsConfigured = stationConfigured("viewing_platform") ||
        (stationConfigured("brawn_silo") && my_primestat() == $stat[muscle]) ||
        (stationConfigured("brain_silo") && my_primestat() == $stat[mysticality]) ||
        (stationConfigured("groin_silo") && my_primestat() == $stat[moxie]);
    boolean haveAllStatsNeeded = my_level() >= 13 && __misc_state["in run"];
    return statsConfigured && haveAllStatsNeeded;
}

boolean shouldNag() {
    return trainSetReconfigurableIn() == 0 &&
        (oreConfiguredWhenNotNeeded() ||
        loggingMillConfiguredWhenNotNeeded() ||
        statsConfiguredWhenNotNeeded());
}

RegisterTaskGenerationFunction("IOTMModelTrainSetGenerateTasks");
void IOTMModelTrainSetGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if (!__iotms_usable[lookupItem("model train set")]) return;

    string url = "campground.php?action=workshed";
    string [int] description;
    string main_title = "Model train set progress";

    int trainPosition = get_property_int("trainsetPosition");
    int whenTrainsetWasConfigured = get_property_int("lastTrainsetConfiguration");
    string trainCars = get_property("trainsetConfiguration");
    string[int] splitTrain = split_string(trainCars, ",");

    if (oreConfiguredWhenNotNeeded()) {
        description.listAppend(HTMLGenerateSpanFont("Have ore configured when it's not needed!", "red"));
    }
    if (loggingMillConfiguredWhenNotNeeded()) {
        description.listAppend(HTMLGenerateSpanFont("Have lumber mill configured when it's not needed!", "red"));
    }
    if (statsConfiguredWhenNotNeeded()) {
        description.listAppend(HTMLGenerateSpanFont("Have stats configured when they're not needed!", "red"));
    }

    int reconfigurableIn = trainSetReconfigurableIn();
    if (reconfigurableIn == 0)
    {
        description.listAppend("Train set reconfigurable!");
    }
    else {
        description.listAppend("Train set reconfigurable in " + HTMLGenerateSpanOfClass(reconfigurableIn.to_string() + " combats.", "r_bold"));
    }

    string[string] nextTrainCar = carDescriptions[splitTrain[trainPosition % 8]];
    description.listAppend("Next car: " + HTMLGenerateSpanOfClass(nextTrainCar["name"], "r_bold") + " - " + nextTrainCar["description"]);

    string [int][int] tooltipTable;
    for i from trainPosition to trainPosition + 7 {
		string[string] car = carDescriptions[splitTrain[i % 8]];
		tooltipTable.listAppend(listMake(HTMLGenerateSpanOfClass(car["name"], "r_bold"), car["description"]));
	}
    buffer tooltipText;
    tooltipText.append(HTMLGenerateTagWrap("div", "Train car cycle", mapMake("class", "r_bold r_centre", "style", "padding-bottom:0.25em;")));
	tooltipText.append(HTMLGenerateSimpleTableLines(tooltipTable));
    string trainCycleList = HTMLGenerateSpanOfClass(HTMLGenerateSpanOfClass(tooltipText, "r_tooltip_inner_class r_tooltip_inner_class_margin") + "Full train cycle", "r_tooltip_outer_class");
	description.listAppend(trainCycleList);
    
    ChecklistEntry[int] whereToAddTile = optional_task_entries;
    int priority = 8;

    if (shouldNag()) {
        whereToAddTile = task_entries;
        priority = -11;
    }

    whereToAddTile.listAppend(ChecklistEntryMake("__item toy crazy train", url, ChecklistSubentryMake(main_title, description), priority).ChecklistEntrySetIDTag("Model train set"));
}

carDescriptions = {
    "unknown": {
        "name": "Unknown",
        "description": "We don't recognize that train car!",
    },
    "empty": {
        "name": "Empty",
        "description": HTMLGenerateSpanFont("Train set isn't fully configured!", "red"),
    },
    "meat_mine": {
        "name": "Meat Mine",
        "description": "Bonus meat",
    },
    "tower_fizzy": {
        "name": "Fizzy Tower",
        "description": "MP regen",
    },
    "viewing_platform": {
        "name": "Viewing Platform",
        "description": "Gain extra stats",
    },
    "tower_frozen": {
        "name": "Frozen Tower",
        "description": HTMLGenerateSpanFont("Hot", "red") + " res, " + HTMLGenerateSpanFont("Cold", "blue") + " dmg",
    },
    "spooky_graveyard": {
        "name": "Spooky Graveyard",
        "description": HTMLGenerateSpanFont("Stench", "green") + " res, " + HTMLGenerateSpanFont("Spooky", "grey") + " dmg",
    },
    "logging_mill": {
        "name": "Logging Mill",
        "description": "Bridge parts or stats",
    },
    "candy_factory": {
        "name": "Candy Factory",
        "description": "Pick up random candy",
    },
    "coal_hopper": {
        "name": "Coal Hopper",
        "description": "Double power of next station",
    },
    "tower_sewage": {
        "name": "Sewage Tower",
        "description": HTMLGenerateSpanFont("Cold", "blue") + " res, " + HTMLGenerateSpanFont("Stench", "green") + " dmg",
    },
    "oil_refinery": {
        "name": "Oil Refinery",
        "description": HTMLGenerateSpanFont("Spooky", "grey") + " res, " + HTMLGenerateSpanFont("Sleaze", "purple") + " dmg",
    },
    "oil_bridge": {
        "name": "Oil Bridge",
        "description": HTMLGenerateSpanFont("Sleaze", "purple") + " res, " + HTMLGenerateSpanFont("Hot", "red") + " dmg",
    },
    "water_bridge": {
        "name": "Bridge Over Troubled Water",
        "description": "Increase ML",
    },
    "groin_silo": {
        "name": "Groin Silo",
        "description": "Gain moxie",
    },
    "grain_silo": {
        "name": "Grain Silo",
        "description": "Get base booze",
    },
    "brain_silo": {
        "name": "Brain Silo",
        "description": "Gain mysticality",
    },
    "brawn_silo": {
        "name": "Brawn Silo",
        "description": "Gain muscle",
    },
    "prawn_silo": {
        "name": "Prawn Silo",
        "description": "Acquire more food",
    },
    "trackside_diner": {
        "name": "Trackside Diner",
        "description": "Serves the last food you found",
    },
    "ore_hopper": {
        "name": "Ore Hopper",
        "description": "Get some ore",
    }
};
