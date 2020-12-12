void QSleazeAirportBuffJimmyGenerateTasks(ChecklistEntry [int] task_entries, QuestState [string] SBBState)
{
    if (SBBState["questESlMushStash"].in_progress)
    {
        //jimmy, fun-guy
        //run +item, collect 10 pencil thin mushrooms (item)
        ChecklistSubentry subentry;
        subentry.header = "Pencil-Thin Mush Stash";
        
        item item_to_collect = $item[pencil thin mushroom];
        int remaining_of_item = MAX(0, 10 - item_to_collect.item_amount());
        if (SBBState["questESlMushStash"].mafia_internal_step > 2 || remaining_of_item <= 0)
            subentry.entries.listAppend("Return to Buff Jimmy.");
        else if (SBBState["questESlAudit"].in_progress)
            subentry.entries.listAppend("Need to finish Audit-Tory Hallucinations, first.");
        else
        {
            subentry.modifiers.listAppend("+item");
            subentry.entries.listAppend("Adventure in the The Fun-Guy Mansion and collect " + pluraliseWordy(remaining_of_item, "more " + item_to_collect.name, "more " + item_to_collect.plural) + ".");
        }
        
        task_entries.listAppend(ChecklistEntryMake("__item pencil thin mushroom", "place.php?whichplace=airport_sleaze", subentry, $locations[The Fun-Guy Mansion]));
    }
    else if (SBBState["questESlCheeseburger"].in_progress)
    {
        //jimmy, diner
        //buffJimmyIngredients - need 15(?)
        //equip Paradaisical Cheeseburger recipe, olfact Sloppy Seconds Burgers
        ChecklistSubentry subentry;
        subentry.header = "Paradise Cheeseburger";
        
        int remaining_of_item = MAX(0, 15 - get_property_int("buffJimmyIngredients"));
        if (SBBState["questESlCheeseburger"].mafia_internal_step > 2 || remaining_of_item <= 0)
            subentry.entries.listAppend("Return to Buff Jimmy.");
        else
        {
            subentry.modifiers.listAppend("olfact Burgers");
            subentry.entries.listAppend("Adventure in the Sloppy Seconds Diner and collect " + pluraliseWordy(remaining_of_item, "more ingredient", "more ingredients") + ".");
            if ($item[Paradaisical Cheeseburger recipe].available_amount() > 0 && $item[Paradaisical Cheeseburger recipe].equipped_amount() == 0)
                subentry.entries.listAppend(HTMLGenerateSpanFont("Equip the Paradaisical Cheeseburger recipe.", "red"));
        }
        
        task_entries.listAppend(ChecklistEntryMake("__item hamburger", "place.php?whichplace=airport_sleaze", subentry, $locations[Sloppy Seconds Diner]));
    }
    else if (SBBState["questESlSalt"].in_progress)
    {
        //jimmy, yacht
        //collect 50 salty sailor salts (item), olfact son of a son of a sailor, run +ML, want fishy
        ChecklistSubentry subentry;
        subentry.header = "Lost Shaker of Salt";
        
        item item_to_collect = $item[salty sailor salt];
        int remaining_of_item = MAX(0, 50 - item_to_collect.item_amount());
        if (SBBState["questESlSalt"].mafia_internal_step > 2 || remaining_of_item <= 0)
            subentry.entries.listAppend("Return to Buff Jimmy.");
        else
        {
            subentry.modifiers.listAppend("+ML");
            subentry.modifiers.listAppend("olfact son of a son of a sailor");
            subentry.entries.listAppend("Adventure in The Sunken Party Yacht and collect " + pluraliseWordy(remaining_of_item, "more salt", "more salts") + ".");
            if ($effect[fishy].have_effect() == 0)
                subentry.entries.listAppend("Try to acquire Fishy effect.");
        }
        
        task_entries.listAppend(ChecklistEntryMake("__item salty sailor salt", "place.php?whichplace=airport_sleaze", subentry, $locations[The Sunken Party Yacht]));
    }
}
void QSleazeAirportTacoDanGenerateTasks(ChecklistEntry [int] task_entries, QuestState [string] SBBState)
{
    if (SBBState["questESlAudit"].in_progress)
    {
        //questESlAudit
        //taco dan, fun-guy
        //look for 10 Taco Dan's Taco Stand's Taco Receipt (item). requires Sleight of Mind effect from sleight-of-hand mushrooms dropped from area
        ChecklistSubentry subentry;
        subentry.header = "Audit-Tory Hallucinations";
        
        item item_to_collect = $item[Taco Dan's Taco Stand's Taco Receipt];
        int remaining_of_item = MAX(0, 10 - item_to_collect.item_amount());
        if (SBBState["questESlAudit"].mafia_internal_step > 2 || remaining_of_item <= 0)
            subentry.entries.listAppend("Return to Taco Dan.");
        else
        {
            if ($effect[sleight of mind].have_effect() == 0 && $item[sleight-of-hand mushroom].available_amount() > 0)
                subentry.entries.listAppend(HTMLGenerateSpanFont("Use sleight-of-hand mushroom", "red") + " to acquire receipts.");
            subentry.entries.listAppend("Adventure in the The Fun-Guy Mansion and collect " + pluraliseWordy(remaining_of_item, "more receipt", "more receipts") + ".");
        }
        
        task_entries.listAppend(ChecklistEntryMake("__item Taco Dan's Taco Stand's Taco Receipt", "place.php?whichplace=airport_sleaze", subentry, $locations[The Fun-Guy Mansion]));
    }
    else if (SBBState["questESlCocktail"].in_progress)
    {
        //taco dan, diner
        //tacoDanCocktailSauce
        //equip Taco Dan's Taco Stand Cocktail Sauce Bottle, olfact Sloppy Seconds Cocktails
        ChecklistSubentry subentry;
        subentry.header = "Cocktail as old as Cocktime";
        
        int remaining_of_item = MAX(0, 15 - get_property_int("tacoDanCocktailSauce"));
        if (SBBState["questESlCocktail"].mafia_internal_step > 2 || remaining_of_item <= 0)
            subentry.entries.listAppend("Return to Taco Dan.");
        else
        {
            subentry.modifiers.listAppend("olfact Cocktails");
            subentry.entries.listAppend("Adventure in the Sloppy Seconds Diner and collect " + remaining_of_item.int_to_wordy() + " more sauce.");
            if ($item[Taco Dan's Taco Stand Cocktail Sauce Bottle].available_amount() > 0 && $item[Taco Dan's Taco Stand Cocktail Sauce Bottle].equipped_amount() == 0)
                subentry.entries.listAppend(HTMLGenerateSpanFont("Equip the Taco Dan's Taco Stand Cocktail Sauce Bottle.", "red"));
        }
        
        task_entries.listAppend(ChecklistEntryMake("__item Taco Dan's Taco Stand Cocktail Sauce Bottle", "place.php?whichplace=airport_sleaze", subentry, $locations[Sloppy Seconds Diner]));
    }
    else if (SBBState["questESlFish"].in_progress)
    {
        //taco dan, yacht
        //tacoDanFishMeat
        //collect 300 fish meat, olfact taco fish, run +meat, want fishy
        ChecklistSubentry subentry;
        subentry.header = "Dirty Fishy Dish";
        
        int remaining_of_item = MAX(0, 300 - get_property_int("tacoDanFishMeat"));
        if (SBBState["questESlFish"].mafia_internal_step > 2 || remaining_of_item <= 0)
            subentry.entries.listAppend("Return to Taco Dan.");
        else
        {
            subentry.modifiers.listAppend("+meat");
            subentry.modifiers.listAppend("olfact taco fish");
            subentry.entries.listAppend("Adventure in The Sunken Party Yacht and collect " + remaining_of_item.int_to_wordy() + " more fish meat.");
            if ($effect[fishy].have_effect() == 0)
                subentry.entries.listAppend("Try to acquire Fishy effect.");
        }
        
        task_entries.listAppend(ChecklistEntryMake("__item fishy fish", "place.php?whichplace=airport_sleaze", subentry, $locations[The Sunken Party Yacht]));
    }
}
void QSleazeAirportBrodenGenerateTasks(ChecklistEntry [int] task_entries, QuestState [string] SBBState)
{
    if (SBBState["questESlBacteria"].in_progress)
    {
        //broden, fun-guy, brodenBacteria
        //+all(?) elemental resistance
        //collect 10 bacteria
        ChecklistSubentry subentry;
        subentry.header = "Cultural Studies";
        
        int remaining_of_item = MAX(0, 10 - get_property_int("brodenBacteria"));
        if (SBBState["questESlBacteria"].mafia_internal_step > 2 || remaining_of_item <= 0)
            subentry.entries.listAppend("Return to Broden.");
        else if (SBBState["questESlMushStash"].in_progress)
            subentry.entries.listAppend("Need to finish Pencil-Thin Mush Stash, first.");
        else if (SBBState["questESlAudit"].in_progress)
            subentry.entries.listAppend("Need to finish Audit-Tory Hallucinations, first.");
        else
        {
            subentry.modifiers.listAppend("+elemental resistance");
            subentry.entries.listAppend("Adventure in the The Fun-Guy Mansion and collect " + remaining_of_item.int_to_wordy() + " more bacteria.");
        }
        
        task_entries.listAppend(ChecklistEntryMake("__item chainsaw chain", "place.php?whichplace=airport_sleaze", subentry, $locations[The Fun-Guy Mansion]));
    }
    else if (SBBState["questESlSprinkles"].in_progress)
    {
        //broden, diner
        //brodenSprinkles
        //equip sprinkle shaker, olfact Sloppy Seconds Sundaes
        ChecklistSubentry subentry;
        subentry.header = "A Light Sprinkle";
        
        int remaining_of_item = MAX(0, 15 - get_property_int("brodenSprinkles"));
        if (SBBState["questESlSprinkles"].mafia_internal_step > 2 || remaining_of_item <= 0)
            subentry.entries.listAppend("Return to Broden.");
        else
        {
            subentry.modifiers.listAppend("olfact Sundaes");
            subentry.entries.listAppend("Adventure in the Sloppy Seconds Diner and collect " + remaining_of_item.int_to_wordy() + " more sprinkles.");
            if ($item[sprinkle shaker].available_amount() > 0 && $item[sprinkle shaker].equipped_amount() == 0)
                subentry.entries.listAppend(HTMLGenerateSpanFont("Equip the sprinkle shaker.", "red"));
        }
        
        task_entries.listAppend(ChecklistEntryMake("__item sprinkle shaker", "place.php?whichplace=airport_sleaze", subentry, $locations[Sloppy Seconds Diner]));
    }
    else if (SBBState["questESlDebt"].in_progress)
    {
        //broden, yacht
        //collect 15 bike rental broupon (item), olfact drownedbeat, want fishy
        ChecklistSubentry subentry;
        subentry.header = "Beat Dead the Deadbeats";
        
        item item_to_collect = $item[bike rental broupon];
        int remaining_of_item = MAX(0, 15 - item_to_collect.item_amount());
        if (SBBState["questESlDebt"].mafia_internal_step > 2 || remaining_of_item <= 0)
            subentry.entries.listAppend("Return to Broden.");
        else
        {
            subentry.modifiers.listAppend("olfact drownedbeat");
            subentry.entries.listAppend("Adventure in The Sunken Party Yacht and collect " + pluraliseWordy(remaining_of_item, "more " + item_to_collect.name, "more " + item_to_collect.plural) + ".");
            if ($effect[fishy].have_effect() == 0)
                subentry.entries.listAppend("Try to acquire Fishy effect.");
        }
        
        task_entries.listAppend(ChecklistEntryMake("__item fixed-gear bicycle", "place.php?whichplace=airport_sleaze", subentry, $locations[The Sunken Party Yacht]));
    }
}


void QSleazeAirportUMDGenerateTasks(ChecklistEntry [int] task_entries)
{
    if (!__misc_state["sleaze airport available"])
        return;
    if (get_property("umdLastObtained") != "") { // && !__misc_state["in run"]
        string umd_date_obtained = get_property("umdLastObtained");
        
        int day_in_year_acquired_umd = format_date_time("yyyy-MM-dd", umd_date_obtained, "D").to_int();
        int year_umd_acquired = format_date_time("yyyy-MM-dd", umd_date_obtained, "yyyy").to_int();
        
        string todays_date = today_to_string();
        int today_day_in_year = format_date_time("yyyyMMdd", todays_date, "D").to_int();
        int todays_year = format_date_time("yyyyMMdd", todays_date, "yyyy").to_int();
        
        //We compute the delta of days since last UMD obtained. If it's seven or higher, they can obtain it.
        //If the year is different, more complicated.
        //Umm... this will inevitably have an off by one error from me not looking closely enough.
        
        boolean has_been_seven_days = false;
        if (year_umd_acquired != todays_year) {
            //Query the number of days in last year, then subtract it from day_in_year_acquired_umd.
            
            int days_in_last_year = format_date_time("yyyy-MM-dd", todays_year + "-12-31", "D").to_int(); //this may work well past the year 10k. if it doesn't and you track down this bug and it's a problem, hello from eight thousand years ago!
            
            day_in_year_acquired_umd -= days_in_last_year * (todays_year - year_umd_acquired); //this is technically incorrect due to leap years, but it'll still result in proper checking. do not use for delta code
        }
        
        if (today_day_in_year - day_in_year_acquired_umd >= 7)
            has_been_seven_days = true;
        if (has_been_seven_days) {
            string [int] description;
            description.listAppend("Adventure in the Sunken Party Yacht.|Choose the first option from a non-combat that appears every twenty adventures.");
            description.listAppend("Found once every seven days.");
            if ($effect[fishy].have_effect() == 0)
                description.listAppend("Possibly acquire fishy effect first.");
            if ($item[clara's bell].available_amount() > 0 && !get_property_boolean("_claraBellUsed"))
                description.listAppend("Use clara's bell to instantly acquire. Won't need fishy.");
            ChecklistEntry entry = ChecklistEntryMake("__item ultimate mind destroyer", $location[The Sunken Party Yacht].getClickableURLForLocation(), ChecklistSubentryMake("Ultimate Mind Destroyer collectable", "free runs", description), $locations[The Sunken Party Yacht]);
            entry.tags.id = "Airport sleaze UMD";
            task_entries.listAppend(entry);
        }
    }
}

void QSleazeAirportGenerateTasks(ChecklistEntry [int] task_entries)
{
    /*
    questESlMushStash - Jimmy, Fun-Guy
    questESlAudit - Taco Dan, Fun-Guy
    questESlBacteria - Broden, Fun-Guy, brodenBacteria
    
    questESlCheeseburger - Jimmy, Sloppy Seconds Diner, buffJimmyIngredients(?)
    questESlCocktail - Taco Dan, Sloppy Seconds Diner, tacoDanCocktailSauce
    questESlSprinkles - Broden, Sloppy Seconds Diner, brodenSprinkles
    
    questESlSalt - Jimmy, Sunken Yacht
    questESlFish - Taco Dan, Sunken Yacht, tacoDanFishMeat
    questESlDebt - Broden, Sunken Yacht
    */
    //if (__misc_state["in run"] && !($locations[the sunken party yacht,sloppy seconds diner,the fun-guy mansion] contains __last_adventure_location)) //too many
        //return;
    QuestState [string] SBBState;
        SBBState["questESlMushStash"] = QuestState("questESlMushStash");
        SBBState["questESlCheeseburger"] = QuestState("questESlCheeseburger");
        SBBState["questESlSalt"] = QuestState("questESlSalt");
        SBBState["questESlAudit"] = QuestState("questESlAudit");
        SBBState["questESlCocktail"] = QuestState("questESlCocktail");
        SBBState["questESlFish"] = QuestState("questESlFish");
        SBBState["questESlBacteria"] = QuestState("questESlBacteria");
        SBBState["questESlSprinkles"] = QuestState("questESlSprinkles");
        SBBState["questESlDebt"] = QuestState("questESlDebt");
    
    ChecklistEntry [int] subtask_entries;
    QSleazeAirportBuffJimmyGenerateTasks(subtask_entries, SBBState);
    QSleazeAirportTacoDanGenerateTasks(subtask_entries, SBBState);
    QSleazeAirportBrodenGenerateTasks(subtask_entries, SBBState);
    
    if (subtask_entries.count() > 0) {
        //Combine them into one entry, for convenience:
        ChecklistEntry final_entry;
        boolean first = true;
        foreach key, entry in subtask_entries {
            if (first) {
                final_entry = entry;
                first = false;
            } else {
                foreach key2, subentry in entry.subentries {
                    final_entry.subentries.listAppend(subentry);
                }
                if (entry.should_highlight)
                    final_entry.should_highlight = true;
            }
            
        }
        final_entry.tags.id = "Airport sleaze quest group";
        
        task_entries.listAppend(final_entry);
    }

    QSleazeAirportUMDGenerateTasks(task_entries);
}

//

void QSpookyAirportJunglePunGenerateTasks(ChecklistEntry [int] task_entries)
{
    QuestState state;
    state.image_name = "__item encrypted micro-cassette recorder";
    state.quest_name = "Pungle in the Jungle";
    QuestStateParseMafiaQuestProperty(state, "questESpJunglePun");
    
    if (!state.in_progress)
        return;
    item recorder = $item[encrypted micro-cassette recorder];
    
    if (recorder.available_amount() == 0)
        return;
    
    ChecklistSubentry subentry;
    
    subentry.header = state.quest_name;
    string url = "place.php?whichplace=airport_spooky";
    
    
    int puns_remaining = 11 - get_property_int("junglePuns");
    if (state.mafia_internal_step <= 2 && puns_remaining > 0) {
        subentry.entries.listAppend("Adventure in The Deep Dark Jungle.");
        subentry.modifiers.listAppend("+myst");
        
        if (recorder.equipped_amount() == 0) {
            subentry.entries.listAppend(HTMLGenerateSpanFont("Equip the " + recorder.name + ".", "red"));
            url = "inventory.php?ftext=encrypted+micro-cassette+recorder";
        }
        
        subentry.entries.listAppend(pluraliseWordy(puns_remaining, "pun", "puns").capitaliseFirstLetter() + " remaining.");
    } else {
        url = "place.php?whichplace=airport_spooky&action=airport2_radio";
        subentry.entries.listAppend("Return to the radio and reply.");
    }
    
    task_entries.listAppend(ChecklistEntryMake(state.image_name, url, subentry, $locations[The Deep Dark Jungle]).ChecklistEntrySetIDTag("Airport spooky jungle_pun quest"));
}

void QSpookyAirportFakeMediumGenerateTasks(ChecklistEntry [int] task_entries)
{
    QuestState state;
    state.image_name = "__familiar happy medium";
    state.quest_name = "Fake Medium at Large";
    QuestStateParseMafiaQuestProperty(state, "questESpFakeMedium");
    
    if (!state.in_progress)
        return;
    item collar = $item[ESP suppression collar];
    
    
    ChecklistSubentry subentry;
    
    subentry.header = state.quest_name;
    string url = "place.php?whichplace=airport_spooky";
    
    
    if (state.mafia_internal_step == 1 && collar.available_amount() == 0) {
        subentry.entries.listAppend("Adventure in The Secret Government Laboratory, find a non-combat every twenty turns.");
        if (__misc_state["free runs available"])
            subentry.modifiers.listAppend("free runs");
        if (__misc_state["have hipster"])
            subentry.modifiers.listAppend(__misc_state_string["hipster name"]);
        
        string [int,int] solutions;
        
        solutions.listAppend(listMake("dust motes float", "star"));
        solutions.listAppend(listMake("circle of light", "circle"));
        solutions.listAppend(listMake("waves a fly away", "waves"));
        solutions.listAppend(listMake("square one", "square"));
        solutions.listAppend(listMake("expression only adds to your anxiety", "plus"));
        
        
        subentry.entries.listAppend("The last line of the adventure text gives the solution:|*" + HTMLGenerateSimpleTableLines(solutions));
        
        if ($item[Personal Ventilation Unit].equipped_amount() == 0 && $item[Personal Ventilation Unit].available_amount() > 0) {
            subentry.entries.listAppend(HTMLGenerateSpanFont("Equip the " + $item[Personal Ventilation Unit].name + ".", "red"));
            url = $item[Personal Ventilation Unit].invSearch();
        }
    } else {
        url = "place.php?whichplace=airport_spooky&action=airport2_radio";
        subentry.entries.listAppend("Return to the radio and reply.");
    }
    
    task_entries.listAppend(ChecklistEntryMake(state.image_name, url, subentry, $locations[The Secret Government Laboratory]).ChecklistEntrySetIDTag("Airport spooky fake_medium quest"));
}


void QSpookyAirportClipperGenerateTasks(ChecklistEntry [int] task_entries)
{
    QuestState state;
    state.image_name = "__item military-grade fingernail clippers";
    state.quest_name = "The Big Clipper";
    QuestStateParseMafiaQuestProperty(state, "questESpClipper");
    
    if (!state.in_progress)
        return;
    item clipper = $item[military-grade fingernail clippers];
    
    if (clipper.available_amount() == 0)
        return;
    
    ChecklistSubentry subentry;
    
    subentry.header = state.quest_name;
    string url = "place.php?whichplace=airport_spooky";
    
    
    int fingernails_remaining = 23 - get_property_int("fingernailsClipped");
    if (state.mafia_internal_step == 1 && fingernails_remaining > 0) {
        subentry.entries.listAppend("Adventure in The Mansion of Dr. Weirdeaux, use the military-grade fingernail clippers on the monsters three times per fight.");
        
        int turns_remaining = ceil(fingernails_remaining.to_float() / 3.0);
        
        subentry.entries.listAppend(fingernails_remaining + " fingernails / " + pluralise(turns_remaining, "turn", "turns") + " remaining.");
    } else {
        url = "place.php?whichplace=airport_spooky&action=airport2_radio";
        subentry.entries.listAppend("Return to the radio and reply.");
    }
    
    task_entries.listAppend(ChecklistEntryMake(state.image_name, url, subentry, $locations[The Mansion of Dr. Weirdeaux]).ChecklistEntrySetIDTag("Airport spooky clipper quest"));
}

void QSpookyAirportEveGenerateTasks(ChecklistEntry [int] task_entries)
{
    QuestState state;
    state.image_name = "__item vial of patchouli oil"; //science lab
    state.quest_name = "Choking on the Rind";
    QuestStateParseMafiaQuestProperty(state, "questESpEVE");
    
    if (!state.in_progress)
        return;
    
    ChecklistSubentry subentry;
    
    subentry.header = state.quest_name;
    string url = "place.php?whichplace=airport_spooky";
    
    
    if (state.mafia_internal_step < 2) {
        subentry.entries.listAppend("Adventure in The Secret Government Laboratory, find a non-combat every twenty turns.|At the choice adventure, choose " + listMake("Left", "Left", "Right", "Left", "Right").listJoinComponents(__html_right_arrow_character) + ".");
        if (__misc_state["free runs available"])
            subentry.modifiers.listAppend("free runs");
        if (__misc_state["have hipster"])
            subentry.modifiers.listAppend(__misc_state_string["hipster name"]);
        
        if ($item[Personal Ventilation Unit].equipped_amount() == 0 && $item[Personal Ventilation Unit].available_amount() > 0) {
            subentry.entries.listAppend(HTMLGenerateSpanFont("Equip the " + $item[Personal Ventilation Unit].name + ".", "red"));
            url = $item[Personal Ventilation Unit].invSearch();
        }
    } else {
        url = "place.php?whichplace=airport_spooky&action=airport2_radio";
        subentry.entries.listAppend("Return to the radio and reply.");
    }
    task_entries.listAppend(ChecklistEntryMake(state.image_name, url, subentry, $locations[The Secret Government Laboratory]).ChecklistEntrySetIDTag("Airport spooky EVE quest"));
}



void QSpookyAirportSmokesGenerateTasks(ChecklistEntry [int] task_entries)
{
    QuestState state;
    state.image_name = "__item pack of smokes";
    state.quest_name = "Everyone's Running Out of Smokes";
    QuestStateParseMafiaQuestProperty(state, "questESpSmokes");
    
    if (!state.in_progress)
        return;
    
    ChecklistSubentry subentry;
    
    subentry.header = state.quest_name;
    string url = "place.php?whichplace=airport_spooky";
    
    item smokes = $item[pack of smokes];
    
    if (state.mafia_internal_step < 2 && smokes.available_amount() < 10) {
        subentry.entries.listAppend("Adventure in The Deep Dark Jungle and collect smokes from the smoke monster.");
        subentry.modifiers.listAppend("olfact smoke monster");
        
        if (smokes != $item[none]) {
            subentry.entries.listAppend(pluraliseWordy(clampi(10 - smokes.available_amount(), 0, 10), "more pack of smokes", "more packs of smokes").capitaliseFirstLetter() + " remaining.");
        }
    } else {
        url = "place.php?whichplace=airport_spooky&action=airport2_radio";
        subentry.entries.listAppend("Return to the radio and reply.");
    }
    task_entries.listAppend(ChecklistEntryMake(state.image_name, url, subentry, $locations[The Deep Dark Jungle]).ChecklistEntrySetIDTag("Airport spooky smoke quest"));
}


void QSpookyAirportGoreGenerateTasks(ChecklistEntry [int] task_entries)
{
    QuestState state;
    state.image_name = "__item gore bucket";
    state.quest_name = "Gore Tipper";
    QuestStateParseMafiaQuestProperty(state, "questESpGore");
    
    if (!state.in_progress)
        return;
    item bucket = $item[gore bucket];
    
    if (bucket.available_amount() == 0)
        return;
    
    ChecklistSubentry subentry;
    
    subentry.header = state.quest_name;
    string url = "place.php?whichplace=airport_spooky";
    
    
    int gore_remaining = 100 - get_property_int("goreCollected");
    if (state.mafia_internal_step <= 2 && gore_remaining > 0) {
        subentry.entries.listAppend("Adventure in The Secret Government Laboratory.");
        subentry.modifiers.listAppend("+meat");
        string [int] items_to_equip;
        if (bucket.equipped_amount() == 0) {
            items_to_equip.listAppend("gore bucket");
        }
        if ($item[Personal Ventilation Unit].equipped_amount() == 0 && $item[Personal Ventilation Unit].available_amount() > 0) {
            items_to_equip.listAppend("Personal Ventilation Unit");
        }
        if (items_to_equip.count() > 0) {
            subentry.entries.listAppend(HTMLGenerateSpanFont("Equip the " + items_to_equip.listJoinComponents(", ", "and") + ".", "red"));
            url = items_to_equip[0].invSearch();
        }
        subentry.entries.listAppend(pluralise(gore_remaining, "pound", "pounds") + " remaining.");
    } else {
        url = "place.php?whichplace=airport_spooky&action=airport2_radio";
        subentry.entries.listAppend("Return to the radio and reply.");
    }
    task_entries.listAppend(ChecklistEntryMake(state.image_name, url, subentry, $locations[The Secret Government Laboratory]).ChecklistEntrySetIDTag("Airport spooky gore quest"));
}


void QSpookyAirportOutOfOrderGenerateTasks(ChecklistEntry [int] task_entries)
{
    QuestState state;
    state.image_name = "__item GPS-tracking wristwatch";
    state.quest_name = "Out of Order";
    QuestStateParseMafiaQuestProperty(state, "questESpOutOfOrder");
    
    if (!state.in_progress)
        return;
    item wristwatch = $item[GPS-tracking wristwatch];
    
    if (wristwatch.available_amount() == 0)
        return;
    
    ChecklistSubentry subentry;
    
    subentry.header = state.quest_name;
    string url = "place.php?whichplace=airport_spooky";
    
    
    if (state.mafia_internal_step <= 2 && $item[Project T. L. B.].item_amount() == 0) {
        subentry.modifiers.listAppend("+init");
        
        if (wristwatch.equipped_amount() == 0) {
            subentry.entries.listAppend(HTMLGenerateSpanFont("Equip the " + wristwatch.name + ".", "red"));
            url = wristwatch.invSearch();
        } else
            subentry.entries.listAppend("Adventure in The Deep Dark Jungle.");
    } else {
        url = "place.php?whichplace=airport_spooky&action=airport2_radio";
        subentry.entries.listAppend("Return to the radio and reply.");
    }
    
    task_entries.listAppend(ChecklistEntryMake(state.image_name, url, subentry, $locations[The Deep Dark Jungle]).ChecklistEntrySetIDTag("Airport spooky out_of_order quest"));
}


void QSpookyAirportSerumGenerateTasks(ChecklistEntry [int] task_entries)
{
    QuestState state;
    state.image_name = "__item experimental serum P-00";
    state.quest_name = "Serum Sortie";
    QuestStateParseMafiaQuestProperty(state, "questESpSerum");
    
    if (!state.in_progress)
        return;
    item serum = $item[experimental serum P-00];
    
    if (serum == $item[none])
        return;
    
    ChecklistSubentry subentry;
    
    subentry.header = state.quest_name;
    string url = "place.php?whichplace=airport_spooky";
    
    
    if (state.mafia_internal_step <= 2 && serum.item_amount() < 5) {
        if (serum.available_amount() >= 5) {
            subentry.entries.listAppend("Pull " + pluralise(5 - serum.item_amount(), serum) + ".");
        } else {
            subentry.modifiers.listAppend("+item");
            
            subentry.entries.listAppend("Adventure in The Mansion of Dr. Weirdeaux, collect " + int_to_wordy(5 - serum.available_amount()) + " more " + serum.plural + ".");
        }
    } else {
        url = "place.php?whichplace=airport_spooky&action=airport2_radio";
        subentry.entries.listAppend("Return to the radio and reply.");
    }
    
    task_entries.listAppend(ChecklistEntryMake(state.image_name, url, subentry, $locations[The Mansion of Dr. Weirdeaux]).ChecklistEntrySetIDTag("Airport spooky serum quest"));
}

void QSpookyAirportWeirdeauxGenerateTasks(ChecklistEntry [int] task_entries)
{
    if (__last_adventure_location != $location[The Mansion of Dr. Weirdeaux] || my_level() >= 256)
        return;
    if (in_ronin())
        return;
    if (QuestState("questESpClipper").in_progress)
        return;
    
    string url = "place.php?whichplace=airport_spooky";
    string [int] description;
    string [int] modifiers;
    if (!$skill[curse of marinara].have_skill()) {
        if (my_class() == $class[sauceror]) {
            description.listAppend("Buy curse of marinara from the guild trainer.");
            url = "guild.php?place=trainer";
        } else if ($classes[disco bandit,disco bandit,seal clubber,turtle tamer,disco bandit,pastamancer,accordion thief,disco bandit] contains my_class()) {
            description.listAppend("Ascend sauceror to buy curse of marinara.");
            url = "ascend.php";
        } else
            description.listAppend("Become a sauceror at the end of this ascension, to buy curse of marinara.");
    } else {
        if ($skill[utensil twist].have_skill() && $item[dinsey's pizza cutter].available_amount() > 0) {
            string [int] tasks;
            if ($item[dinsey's pizza cutter].equipped_amount() == 0)
                tasks.listAppend("equip Dinsey's Pizza Cutter");
            tasks.listAppend("cast curse of marinara");
            tasks.listAppend("keep monster stunned");
            tasks.listAppend("cast utensil twist repeatedly in combat");
            
            description.listAppend(tasks.listJoinComponents(", ", "and").capitaliseFirstLetter() + ".");
        } else {
            if ($skill[utensil twist].have_skill()) {
                description.listAppend("Possibly acquire Dinsey's pizza cutter by fighting Wart Dinsey as a Pastamancer.");
            } else if ($item[dinsey's pizza cutter].available_amount() > 0) {
                description.listAppend("Possibly acquire the pastamancer skill Utensil Twist.");
            } else {
                description.listAppend("Possibly acquire the pastamancer skill Utensil Twist and Dinsey's pizza cutter by fighting Wart Dinsey as a Pastamancer.");
            }
            //Drunkula's bell - 15% to 20% of your buffed myst as damage?
            //right bear arm - Grizzly Scene, once/fight, 50% HP damage
            //Staff of the Headmaster's Victuals - chefstaff (requires skill), jiggle does 30% of monster HP
            //Great Wolf's lice - reduces monster attack/def by 30%. ???
            //great wolf's right paw, great wolf's left paw - gives Great Slash ability, which deals 1/3rd buffed muscle damage per paw equipped
            description.listAppend("Cast curse of marinara at the start of combat, and keep monster stunned.");
            string [item] other_relevant_items;
            other_relevant_items[$item[drunkula's bell]] = "throw in combat to deal damage";
            other_relevant_items[$item[right bear arm]] = "grizzly scene deals 50% HP damage";
            if ($skill[Spirit of Rigatoni].skill_is_usable())
                other_relevant_items[$item[Staff of the Headmaster's Victuals]] = "jiggle for 30% HP damage";
            other_relevant_items[$item[Great Wolf's lice]] = "throw in combat to deal damage";
            other_relevant_items[$item[great wolf's left paw]] = "great slash skill deals damage";
            other_relevant_items[$item[great wolf's right paw]] = "great slash skill deals damage";
            
            string [int] possibilities;
            foreach it, desc in other_relevant_items {
                if (it.available_amount() == 0)
                    continue;
                string line = it.capitaliseFirstLetter() + " - " + desc + ".";
                if (it.to_slot() != $slot[none] && it.equipped_amount() == 0)
                    line += " (equip)";
                possibilities.listAppend(line);
            }
            if (possibilities.count() > 0)
                description.listAppend("Try:|*" + possibilities.listJoinComponents("|*").capitaliseFirstLetter());
        }
        
        modifiers.listAppend("+spooky resistance");
        
        string [int] blocking_sources;
        if (!__misc_state["familiars temporarily blocked"])
            blocking_sources.listAppend("a potato familiar");
        foreach it in $items[Drunkula's ring of haze,Mesmereyes&trade; contact lenses,attorney's badge,ancient stone head,navel ring of navel gazing] {
            if (it.available_amount() == 0)
                continue;
            if (it.equipped_amount() > 0)
                continue;
            string line = it;
            if (it.equipped_amount() == 0)
                line += " (equip)";
            blocking_sources.listAppend(line);
        }
        if (my_class() == $class[pastamancer])
            blocking_sources.listAppend("spaghetti elemental thrall");
        if (blocking_sources.count() > 0)
            description.listAppend("Use sources of blocking, like " + blocking_sources.listJoinComponents(", ", "and") + ".");
    }
    
    //description.listAppend("Or use " + pluralise(clampi(256 - my_level(), 0, 256), "ultimate wad", "ultimate wads") + "."); //reasonable
    
    task_entries.listAppend(ChecklistEntryMake("__effect Incredibly Hulking", url, ChecklistSubentryMake("Gain " + pluralise(clampi(256 - my_level(), 0, 256), "level", "levels"), modifiers, description), $locations[The Mansion of Dr. Weirdeaux]).ChecklistEntrySetIDTag("Airport spooky weirdeaux"));
}

void QSpookyAirportGenerateTasks(ChecklistEntry [int] task_entries)
{
    if (!__misc_state["spooky airport available"])
        return;
    //if (__misc_state["in run"] && !($locations[the mansion of dr. weirdeaux,the secret government laboratory,the deep dark jungle] contains __last_adventure_location)) //a common strategy is to accept an island quest in-run, then finish it upon prism break to do two quests in a day. so, don't clutter their interface unless they're adventuring there? hmm...
        //return;
    
    QSpookyAirportClipperGenerateTasks(task_entries);
    QSpookyAirportEVEGenerateTasks(task_entries);
    QSpookyAirportSmokesGenerateTasks(task_entries);
    QSpookyAirportSerumGenerateTasks(task_entries);
    QSpookyAirportOutOfOrderGenerateTasks(task_entries);
    QSpookyAirportFakeMediumGenerateTasks(task_entries);
    QSpookyAirportGoreGenerateTasks(task_entries);
    QSpookyAirportJunglePunGenerateTasks(task_entries);
    QSpookyAirportWeirdeauxGenerateTasks(task_entries);
}

//

void QStenchAirportFishTrashGenerateTasks(ChecklistEntry [int] task_entries)
{
    QuestState state;
    state.image_name = "__item trash net";
    state.quest_name = "Teach a Man to Fish Trash";
    QuestStateParseMafiaQuestProperty(state, "questEStFishTrash");
    
    if (!state.in_progress)
        return;
    item trash_net = $item[trash net];
    
    if (trash_net.available_amount() == 0)
        return;
    
    ChecklistSubentry subentry;
    
    subentry.header = state.quest_name;
    string url = "place.php?whichplace=airport_stench";
    
    
    if (state.mafia_internal_step <= 2) {
        if (trash_net.equipped_amount() == 0) {
            subentry.entries.listAppend(HTMLGenerateSpanFont("Equip the " + trash_net + ".", "red"));
            url = trash_net.invSearch();
        } else {
            int turns_remaining = clampi(get_property_int("dinseyFilthLevel") / 5, 0, 20);
            subentry.entries.listAppend("Adventure in Pirates of the Garbage Barges for " + pluraliseWordy(turns_remaining, "more turn", "more turns") + ".");
        }
    } else {
        subentry.entries.listAppend("Collect wages from the employee assignment kiosk.");
        state.image_name = "stench airport kiosk";
        url = "place.php?whichplace=airport_stench&action=airport3_kiosk";
    }
        
    task_entries.listAppend(ChecklistEntryMake(state.image_name, url, subentry, $locations[pirates of the garbage barges]).ChecklistEntrySetIDTag("Airport stench fish_trash quest"));
}

void QStenchAirportNastyBearsGenerateTasks(ChecklistEntry [int] task_entries)
{
    QuestState state;
    state.image_name = "__item black picnic basket";
    state.quest_name = "Nasty, Nasty Bears";
    QuestStateParseMafiaQuestProperty(state, "questEStNastyBears");
    
    if (!state.in_progress)
        return;
    
    ChecklistSubentry subentry;
    
    subentry.header = state.quest_name;
    string url = "place.php?whichplace=airport_stench";
    
    
    int bears_left = 8 - get_property_int("dinseyNastyBearsDefeated");
    if (state.mafia_internal_step < 3 && bears_left > 0) {
        subentry.entries.listAppend("Adventure in Uncle Gator's Country Fun-Time Liquid Waste Sluice, defeat " + pluraliseWordy(bears_left, "more nasty bear", "more nasty bears") + ".");
        
        if (__misc_state["have olfaction equivalent"])
            subentry.modifiers.listAppend("olfact nasty bears?");
    } else {
        subentry.entries.listAppend("Collect wages from the employee assignment kiosk.");
        state.image_name = "stench airport kiosk";
        url = "place.php?whichplace=airport_stench&action=airport3_kiosk";
    }
    
    task_entries.listAppend(ChecklistEntryMake(state.image_name, url, subentry, $locations[Uncle Gator's Country Fun-Time Liquid Waste Sluice]).ChecklistEntrySetIDTag("Airport stench nasty_bears quest"));
}

void QStenchAirportSocialJusticeIGenerateTasks(ChecklistEntry [int] task_entries)
{
    QuestState state;
    state.image_name = "__item ms. accessory";
    state.quest_name = "Social Justice Adventurer I";
    QuestStateParseMafiaQuestProperty(state, "questEStSocialJusticeI");
    
    if (!state.in_progress)
        return;
    
    ChecklistSubentry subentry;
    
    subentry.header = state.quest_name;
    string url = "place.php?whichplace=airport_stench";
    
    
    int adventures_left = 15 - get_property_int("dinseySocialJusticeIProgress");
    if (state.mafia_internal_step < 2 && adventures_left > 0) {
        subentry.entries.listAppend("Adventure in Pirates of the Garbage Barges " + pluraliseWordy(adventures_left, "more time", "more times") + ".");
    } else {
        subentry.entries.listAppend("Collect wages from the employee assignment kiosk.");
        state.image_name = "stench airport kiosk";
        url = "place.php?whichplace=airport_stench&action=airport3_kiosk";
    }
    
    task_entries.listAppend(ChecklistEntryMake(state.image_name, url, subentry, $locations[Pirates of the Garbage Barges]).ChecklistEntrySetIDTag("Airport stench social_justice_1 quest"));
}

void QStenchAirportSocialJusticeIIGenerateTasks(ChecklistEntry [int] task_entries)
{
    QuestState state;
    state.image_name = "__monster black knight";
    state.quest_name = "Social Justice Adventurer II";
    QuestStateParseMafiaQuestProperty(state, "questEStSocialJusticeII");
    
    if (!state.in_progress)
        return;
    
    ChecklistSubentry subentry;
    
    subentry.header = state.quest_name;
    string url = "place.php?whichplace=airport_stench";
    
    
    if (state.mafia_internal_step < 2) {
        int adventures_left = clampi(15 - get_property_int("dinseySocialJusticeIIProgress"), 0, 15);
        subentry.entries.listAppend("Adventure in Uncle Gator's Country Fun-Time Liquid Waste Sluice " + pluraliseWordy(adventures_left, "more time", "more times") + ".");
    } else {
        subentry.entries.listAppend("Collect wages from the employee assignment kiosk.");
        state.image_name = "stench airport kiosk";
        url = "place.php?whichplace=airport_stench&action=airport3_kiosk";
    }
    
    task_entries.listAppend(ChecklistEntryMake(state.image_name, url, subentry, $locations[Uncle Gator's Country Fun-Time Liquid Waste Sluice]).ChecklistEntrySetIDTag("Airport stench social_justice_2 quest"));
}

void QStenchAirportSuperLuberGenerateTasks(ChecklistEntry [int] task_entries)
{
    QuestState state;
    state.image_name = "__item lube-shoes";
    state.quest_name = "Super Luber";
    QuestStateParseMafiaQuestProperty(state, "questEStSuperLuber");
    
    if (!state.in_progress)
        return;
    item quest_item = $item[lube-shoes];
    
    if (quest_item.available_amount() == 0)
        return;
    
    ChecklistSubentry subentry;
    
    subentry.header = state.quest_name;
    string url = "place.php?whichplace=airport_stench";
    
    
    if (state.mafia_internal_step <= 2) {
        if (quest_item.equipped_amount() == 0) {
            subentry.entries.listAppend(HTMLGenerateSpanFont("Equip the " + quest_item.name + ".", "red"));
            url = quest_item.invSearch();
        } else {
            subentry.entries.listAppend("Adventure in Barf Mountain, return to the kiosk after riding the rollercoaster.");
            subentry.modifiers.listAppend("optional +meat");
            if ($effect[How to Scam Tourists].have_effect() == 0 && $item[How to Avoid Scams].available_amount() > 0)
                subentry.entries.listAppend("Use How to Avoid Scams to farm extra meat, if you want.");
            
        }
    } else {
        subentry.entries.listAppend("Collect wages from the employee assignment kiosk.");
        state.image_name = "stench airport kiosk";
        url = "place.php?whichplace=airport_stench&action=airport3_kiosk";
    }
        
    task_entries.listAppend(ChecklistEntryMake(state.image_name, url, subentry, $locations[barf mountain]).ChecklistEntrySetIDTag("Airport stench super_luber quest"));
}

void QStenchAirportZippityDooDahGenerateTasks(ChecklistEntry [int] task_entries)
{
    QuestState state;
    state.image_name = "__item tea for one";
    state.quest_name = "Whistling Zippity-Doo-Dah";
    QuestStateParseMafiaQuestProperty(state, "questEStZippityDooDah");
    
    if (!state.in_progress)
        return;
    item quest_item = $item[Dinsey mascot mask];
    
    if (quest_item.available_amount() == 0)
        return;
    
    ChecklistSubentry subentry;
    
    subentry.header = state.quest_name;
    string url = "place.php?whichplace=airport_stench";
    
    int turns_remaining = clampi(15 - get_property_int("dinseyFunProgress"), 0, 15);
    
    if (state.mafia_internal_step <= 2) {
        if (quest_item.equipped_amount() == 0) {
            subentry.entries.listAppend(HTMLGenerateSpanFont("Equip the " + quest_item.name + ".", "red"));
            url = quest_item.invSearch();
        } else {
            subentry.entries.listAppend("Adventure in the Toxic Teacups for " + pluraliseWordy(turns_remaining, "more turn", "more turns") + ".");
        }
    } else {
        subentry.entries.listAppend("Collect wages from the employee assignment kiosk.");
        state.image_name = "stench airport kiosk";
        url = "place.php?whichplace=airport_stench&action=airport3_kiosk";
    }
        
    task_entries.listAppend(ChecklistEntryMake(state.image_name, url, subentry, $locations[the toxic teacups]).ChecklistEntrySetIDTag("Airport stench zippity quest"));
}

void QStenchAirportWillWorkForFoodGenerateTasks(ChecklistEntry [int] task_entries)
{
    QuestState state;
    state.image_name = "__item complimentary Dinsey refreshments";
    state.quest_name = "Will Work With Food";
    QuestStateParseMafiaQuestProperty(state, "questEStWorkWithFood");
    
    if (!state.in_progress)
        return;
        
    item quest_item = $item[complimentary Dinsey refreshments];
    
    if (quest_item.available_amount() == 0)
        return;
    
    ChecklistSubentry subentry;
    
    subentry.header = state.quest_name;
    string url = "place.php?whichplace=airport_stench";
    
    int tourists_to_feed = clampi(30 - get_property_int("dinseyTouristsFed"), 0, 30);
    if (state.mafia_internal_step == 1) {
        subentry.entries.listAppend("Adventure in Barf Mountain, use complimentary Dinsey refreshments on garbage/angry tourists.");
        subentry.entries.listAppend(pluraliseWordy(tourists_to_feed, "more remains", "more remain").capitaliseFirstLetter() + ".");
        subentry.modifiers.listAppend("olfact angry/garbage tourists");
        
    } else {
        subentry.entries.listAppend("Collect wages from the employee assignment kiosk.");
        state.image_name = "stench airport kiosk";
        url = "place.php?whichplace=airport_stench&action=airport3_kiosk";
    }
        
    task_entries.listAppend(ChecklistEntryMake(state.image_name, url, subentry, $locations[barf mountain]).ChecklistEntrySetIDTag("Airport stench refreshments quest"));
}

void QStenchAirportGiveMeFuelGenerateTasks(ChecklistEntry [int] task_entries)
{
    QuestState state;
    state.image_name = "__item toxic globule";
    state.quest_name = "Give me fuel";
    QuestStateParseMafiaQuestProperty(state, "questEStGiveMeFuel");
    
    if (!state.in_progress)
        return;
    
    ChecklistSubentry subentry;
    
    subentry.header = state.quest_name;
    string url = "place.php?whichplace=airport_stench";
    
    if ($item[toxic globule].available_amount() < 20) {
        int globules_needed = clampi(20 - $item[toxic globule].available_amount(), 0, 20);
        if (!in_ronin()) {
            subentry.entries.listAppend("Buy " + pluralise(globules_needed, "more toxic globule", "more toxic globules") + " in the mall.");
            url = "mall.php";
        } else {
            subentry.modifiers.listAppend("+unknown");
            subentry.entries.listAppend("Adventure in the Toxic Teacups and collect " + pluralise(globules_needed, "more toxic globule", "more toxic globules") + ".");
        }
    } else {
        if ($item[toxic globule].item_amount() < 20) {
            int globules_needed = clampi(20 - $item[toxic globule].item_amount(), 0, 20);
            subentry.entries.listAppend("Pull " + pluralise(globules_needed, "more toxic globule", "more toxic globules") + ".");
        } else {
            subentry.entries.listAppend("Collect wages from the employee assignment kiosk.");
            state.image_name = "stench airport kiosk";
            url = "place.php?whichplace=airport_stench&action=airport3_kiosk";
        }
    }
    
    task_entries.listAppend(ChecklistEntryMake(state.image_name, url, subentry, $locations[the toxic teacups]).ChecklistEntrySetIDTag("Airport stench fuel quest"));
}

void QStenchAirportGarbageGenerateTasks(ChecklistEntry [int] task_entries)
{
    if (get_property_boolean("_dinseyGarbageDisposed"))
        return;
    ChecklistSubentry subentry;
    subentry.header = "Turn in garbage";
    subentry.entries.listAppend("Maintenance Tunnels Access" + __html_right_arrow_character + "Waste Disposal.");
    if ($item[bag of park garbage].item_amount() == 0) {
        if ($item[bag of park garbage].available_amount() > 0)
            subentry.entries.listAppend("Have one, somewhere...");
        else {
            string line = "Fight barf mountain Garbage tourists";
            if (!in_ronin())
                line += " or buy from mall";
            subentry.entries.listAppend(line + ".");
        }
    }
    task_entries.listAppend(ChecklistEntryMake("__item bag of park garbage", "place.php?whichplace=airport_stench&action=airport3_tunnels", subentry).ChecklistEntrySetIDTag("Airport stench garbage"));
}

void QStenchAirportWartDinseyGenerateTasks(ChecklistEntry [int] task_entries)
{
    if (get_property_ascension("lastWartDinseyDefeated"))
        return;
        
    item dinsey_item;
    if (my_class() == $class[seal clubber])
        dinsey_item = $item[Dinsey's oculus];
    else if (my_class() == $class[turtle tamer])
        dinsey_item = $item[Dinsey's radar dish];
    else if (my_class() == $class[pastamancer])
        dinsey_item = $item[Dinsey's pizza cutter];
    else if (my_class() == $class[sauceror])
        dinsey_item = $item[Dinsey's brain];
    else if (my_class() == $class[disco bandit])
        dinsey_item = $item[Dinsey's pants];
    else if (my_class() == $class[accordion thief])
        dinsey_item = $item[Dinsey's glove];
    if (!($classes[seal clubber,turtle tamer,pastamancer,sauceror,disco bandit,accordion thief] contains my_class())) //class-specific items only drop when you're class-specific
        return;
        
    if (last_monster() != $monster[Wart Dinsey]) {
        if (dinsey_item == $item[none] || haveAtLeastXOfItemEverywhere(dinsey_item, 1))
            return;
    }
    boolean [item] keycards = $items[keycard &alpha;,keycard &beta;,keycard &gamma;,keycard &delta;];
    
    item [int] missing_keycards;
    foreach it in keycards {
        if (it.available_amount() == 0) {
            missing_keycards.listAppend(it);
        }
    }
    if (missing_keycards.count() > 0)
        return;
        
        
    string url = "place.php?whichplace=airport_stench&action=airport3_tunnels";
    string [int] description;
    string [int] modifiers;
    modifiers.listAppend("+" + MAX(250, $monster[Wart Dinsey].base_initiative) + "% init");
    modifiers.listAppend("+lots all resistance");
    
    item mercenary_pistol = $item[mercenary pistol];
    description.listAppend("Run +resistance, deal many sources of non-stench damage to him. (100 damage cap)");
    if (mercenary_pistol.available_amount() > 0) {
        string [int] tasks;
        if (mercenary_pistol.equipped_amount() == 0)
            tasks.listAppend("equip a mercenary pistol");
        item clip = $item[special clip: boneburners];
        if (clip.item_amount() == 0 && $item[special clip: splatterers].item_amount() > 0)
            clip = $item[special clip: splatterers];
        if (clip.item_amount() == 0) {
            tasks.listAppend("acquire a few clips of " + clip);
        }
        tasks.listAppend("throw " + clip + " in combat");
        
        description.listAppend(tasks.listJoinComponents(", ").capitaliseFirstLetter() + ".");
    } else {
        description.listAppend("The mercenary pistol is useful for this, if you can acquire one.");
    }
    description.listAppend("Will acquire a " + dinsey_item + ".");
    
    task_entries.listAppend(ChecklistEntryMake("__item " + dinsey_item, url, ChecklistSubentryMake("Defeat Wart Dinsey", modifiers, description)).ChecklistEntrySetIDTag("Airport stench Wart_Dinsey"));
}

void QStenchAirportGenerateTasks(ChecklistEntry [int] task_entries)
{
    if (!__misc_state["stench airport available"])
        return;
    //if (__misc_state["in run"] && !($locations[Pirates of the Garbage Barges,Barf Mountain,The Toxic Teacups,Uncle Gator's Country Fun-Time Liquid Waste Sluice] contains __last_adventure_location))
        //return;
    QStenchAirportFishTrashGenerateTasks(task_entries);
    QStenchAirportNastyBearsGenerateTasks(task_entries);
    QStenchAirportSocialJusticeIGenerateTasks(task_entries);
    QStenchAirportSocialJusticeIIGenerateTasks(task_entries);
    QStenchAirportSuperLuberGenerateTasks(task_entries);
    QStenchAirportZippityDooDahGenerateTasks(task_entries);
    QStenchAirportGarbageGenerateTasks(task_entries);
    QStenchAirportGiveMeFuelGenerateTasks(task_entries);
    QStenchAirportWillWorkForFoodGenerateTasks(task_entries);
    QStenchAirportWartDinseyGenerateTasks(task_entries);
}

//

void QHotAirportLavaCoLampGenerateTasks(ChecklistEntry [int] task_entries)
{
    if (in_ronin())
        return;
        
    if (__last_adventure_location != $location[LavaCo&trade; Lamp Factory]) //dave's not here, man
        return;
    
    item [int] missing_lamps = $items[Red LavaCo Lamp&trade;,Green LavaCo Lamp&trade;,Blue LavaCo Lamp&trade;].items_missing();
    
    if (missing_lamps.count() == 0)
        return;
        
    string url = "place.php?whichplace=airport_hot";
    string [int] modifiers;
    string [int] description;
    
    
    description.listAppend("+5 adventures/+sleepstatgain offhand, useful in ascension.");
    
    //One at a time:
    
    item targeting_lamp = missing_lamps[0];
    string [int] colours_missing;
    foreach key, it in missing_lamps
        colours_missing.listAppend(it.to_string().replace_string(" LavaCo Lamp&trade;", ""));
        
    string colour = colours_missing[0];
    
    item capped_item = to_item("capped " + colour + " lava bottle");
    item uncapped_item = to_item("uncapped " + colour + " lava bottle");
    item lava_glob_item = to_item(colour + " lava globs");
    
        
    if (capped_item.available_amount() == 0) {
        boolean have_all_items = true;
        if ($item[SMOOCH bottlecap].available_amount() == 0) {
            have_all_items = false;
            string line;
            line = "Acquire a SMOOCH bottlecap by eating SMOOCH soda";
            if (availableFullness() == 0)
                line += " later";
            line += ".";
            
            description.listAppend(line);
        }
        //uncapped red lava bottle
        if (uncapped_item.available_amount() == 0) {
            have_all_items = false;
            string [int] subdescription;
            if (lava_glob_item.available_amount() == 0) {
                subdescription.listAppend("Acquire " + lava_glob_item + " in LavaCo NC: Use the glob dyer" + __html_right_arrow_character + "Dye them " + colour + ".");
            }
            if ($item[full lava bottle].available_amount() > 0) {
                if (lava_glob_item.available_amount() > 0) {
                    subdescription.listAppend("Use " + lava_glob_item + ".");
                    url = lava_glob_item.invSearch();
                }
            } else {
                if ($item[empty lava bottle].item_amount() > 0) {
                    subdescription.listAppend("Adventure in the LavaCo&trade; Lamp Factory, use the squirter.");
                } else if ($item[empty lava bottle].available_amount() > 0) {
                    subdescription.listAppend("Acquire an empty lava bottle. (From hagnk's?)");
                } else {
                    if ($item[New Age healing crystal].item_amount() > 0) {
                        subdescription.listAppend("Adventure in the LavaCo&trade; Lamp Factory, use the klin.");
                    } else
                        subdescription.listAppend("Acquire New Age healing crystal from the mall or the mine.");
                }
            }
            
            description.listAppend("Acquire an " + uncapped_item + ".|*" + subdescription.listJoinComponents("|*"));
        }
        if (have_all_items) { //capped_item.creatable_amount() > 0) //BUG: capped_item.creatable_amount() > 0 when only having cap
            description.listAppend("Make " + capped_item + " (" + uncapped_item + " + SMOOCH bottlecap)");
            url = "craft.php?mode=combine";
        }
    } else if ($item[LavaCo&trade; Lamp housing].available_amount() > 0) {
        description.listAppend("Combine " + capped_item + " and LavaCo&trade; Lamp housing.");
        url = "craft.php?mode=combine";
    }
    
    if ($item[LavaCo&trade; Lamp housing].available_amount() == 0) {
        boolean have_all_items = true;
        if ($item[crystalline light bulb].item_amount() == 0) {
            have_all_items = false;
            
            if ($item[glowing New Age crystal].item_amount() > 0) {
                description.listAppend("Adventure in the LavaCo&trade; Lamp Factory, use the bulber.");
            } else {
                description.listAppend("Acquire glowing New Age crystal. (mall, or healing crystal golem in the mine))");
            }
        }
        if ($item[heat-resistant sheet metal].item_amount() == 0) {
            have_all_items = false;
            description.listAppend("Buy heat-resistant sheet metal from the mall.");
        }
        if ($item[insulated gold wire].item_amount() == 0) {
            have_all_items = false;
            
            
            if ($item[insulated gold wire].available_amount() > 0) {
                description.listAppend("Acquire insulated gold wire. (in hagnk's?)");
            } else if ($item[insulated gold wire].creatable_amount() > 0) {
                description.listAppend("Make insulated gold wire. (thin gold wire + unsmoothed velvet");
                url = "craft.php?mode=combine";
            } else {
                if ($item[thin gold wire].available_amount() == 0) {
                    if ($item[1\,970 carat gold].item_amount() == 0) {
                        description.listAppend("Acquire 1,970 carat gold by mining in the mine.");
                    } else {
                        description.listAppend("Adventure in the LavaCo&trade; Lamp Factory, use the wire puller.");
                    }
                }
                if ($item[unsmoothed velvet].available_amount() == 0)
                    description.listAppend("Buy unsmoothed velvet in the mall.");
            }
        }
        
        if (have_all_items) {
            description.listAppend("At the LavaCo&trade; NC, use the chassis assembler.");
        }
    }
    
    
    task_entries.listAppend(ChecklistEntryMake("__item " + missing_lamps[0], url, ChecklistSubentryMake("Make a " + colours_missing.listJoinComponents(", ", "and") + " LavaCo Lamp&trade;", modifiers, description), $locations[LavaCo&trade; Lamp Factory]).ChecklistEntrySetIDTag("Airport hot lavaco_lamp"));
}

void QHotAirportSuperduperheatedMetalGenerateTasks(ChecklistEntry [int] task_entries)
{
    int metal_sheets = lookupItem("Heat-resistant sheet metal").item_amount();
    string image;
    string header;
    string [int] description;

    if (!get_property_boolean("_volcanoSuperduperheatedMetal") && (__last_adventure_location == $location[The Bubblin\' Caldera] || !__misc_state["in run"])) {
        image = "__item superduperheated metal";
        header = "Get superduperheated metal";
            if (metal_sheets > 0)
                description.listAppend("Adventure in the Bubblin' Caldera. ~1/20 chance of superduperheated metal.");
            else
                description.listAppend("Get some (scraps of) heat-resistant sheet metal in your inventory.");
    } else if (__last_adventure_location == $location[The Bubblin\' Caldera] && metal_sheets > 0) {
        image = "__item superheated metal";
        header = "Don't waste more Heat-resistant sheet metal";
        description.listAppend("Already got Superduperheated metal today. Closet your Heat-resistant sheet metal (unless you want Superheated metal for the SMOOCH uniform).");
    }

    if (description.count() > 0)
        task_entries.listAppend(ChecklistEntryMake(image, "place.php?whichplace=airport_hot", ChecklistSubentryMake(header, "", description), $locations[The Bubblin\' Caldera]).ChecklistEntrySetIDTag("Airport hot superduperheated"));
}

void QHotAirportWLFBunkerGenerateTasks(ChecklistEntry [int] task_entries)
{
    if (get_property_boolean("_volcanoItemRedeemed"))
        return;
    
    /*
    _volcanoItem1, _volcanoItem2, _volcanoItem3
    _volcanoItemCount1, _volcanoItemCount2, _volcanoItemCount3
    */
    int [int] volcano_item_id;
    int [int] volcano_item_count;
    for i from 1 to 3 {
        volcano_item_id [i] = get_property_int("_volcanoItem" + i); // volcano_item_id [1st / 2nd / 3rd] => item ID
        volcano_item_count [volcano_item_id [i]] = get_property_int("_volcanoItemCount" + i); // volcano_item_count [item ID] => amount asked
    }
    string url = "place.php?whichplace=airport_hot";
    string subtitle;
    string [int] description;
    boolean [location] relevant_locations;

    if (volcano_item_id [1] == 0 && volcano_item_id [2] == 0 && volcano_item_id [3] == 0) {
        url = "place.php?whichplace=airport_hot&action=airport4_questhub";
        description.listAppend("Visit the W.L.F. bunker to learn today's accepted items.");
    } else {
        boolean [item] volcano_item; // rearranged in a format that is compatible with "contains" (also going from ID to $item)
        foreach i in volcano_item_id {
            if (volcano_item_id [i] == 0) {
                description.listAppend("Mafia's parsing of item " + i + " went wrong.");
                remove volcano_item_id [i];
            } else
                volcano_item [lookupItem(volcano_item_id [i])] = true;
        }

        /*
            The Bubblin' Caldera
        8517 => SMOOCH bracers
        8522 => superduperheated metal
        8504 => Lavalos core
        8496 => The One Mood Ring
            The Velvet / Gold Mine
        8516 => smooth velvet bra
        8425 => New Age healing crystal
        8505 => half-melted hula girl
        8497 => Mr. Choch's bone
            LavaCo™ Lamp Factory
        8470 => gooey lava globs
        8523 => fused fuse
        8498 => Mr. Cheeng's 'stache
        8506 => glass ceiling fragments
            The SMOOCH Army HQ
        8446 => SMOOCH bottlecap
        8500 => the tongue of Smimmons
        8501 => Raul's guitar pick
        8502 => Pener's crisps
        8503 => signed deuce
            Discotheque
        8499 => Saturday Night thermometer*/

        void WLFBunkerTasks(string [int] map, item it, int amount_normally_asked, string acquisition_text) {
            if (!(volcano_item contains it))
                return;
            
            boolean this_isnt_right = volcano_item_count [it.to_int()] != amount_normally_asked;
            
            string text;
            if (volcano_item_count [it.to_int()] > 1) //"5 (wait that's not right...) the tongues of Smimmons", "3 smooth velvet bras"
                text += volcano_item_count [it.to_int()] + (this_isnt_right ? " (wait, that's not right...) " : " ") + it.plural;
            else //"Raul's guitar pick", "New Age healing crystal x1 (wait that's not right...)"
                text += it.name.capitaliseFirstLetter() + (this_isnt_right ? " x1 (wait, that's not right...)" : "");
            
            text += " (have " + it.item_amount() + ").";
            text += "|*" + acquisition_text;
            map.listAppend(text);

            remove volcano_item [it];
        }

        string GenerateCommonZoneSpecificNCText(location l) {
            return HTMLGenerateSpanOfClass("Win", "r_bold") + " 50 fights in " + l + " on the " + HTMLGenerateSpanOfClass("same day", "r_bold") + " to get the zone's 1/day NC.";
        }

        if (true) {
            string [int] caldera;
            string nc_text = GenerateCommonZoneSpecificNCText($location[The Bubblin' Caldera]);

            caldera.WLFBunkerTasks($item[SMOOCH bracers], 3, "Multi-use 5 ingots of superheated metal (from adventuring in the caldera with heat-resistant sheet metal (from SMOOCH or mall) in inventory, or buy from mall) (each).");
            caldera.WLFBunkerTasks($item[superduperheated metal], 1, get_property_boolean("_volcanoSuperduperheatedMetal") ? "Buy from mall." : "Look at the tile above this one (or buy from mall).");
            caldera.WLFBunkerTasks($item[Lavalos core], 1, nc_text + " Head for the roaring (fight).");
            caldera.WLFBunkerTasks($item[The One Mood Ring], 1, nc_text + " Head for the singing.");

            if (caldera.count() > 0) {
                relevant_locations [$location[The Bubblin' Caldera]] = true;
                description.listAppend("In " + $location[The Bubblin' Caldera] + ":" + caldera.listJoinComponents("|").HTMLGenerateIndentedText());
            }
        }
        if (true) {
            string [int] VGmine;
            string nc_text = GenerateCommonZoneSpecificNCText($location[The Velvet / Gold Mine]);

            VGmine.WLFBunkerTasks($item[smooth velvet bra], 3, "Multi-use 3 pieces of unsmooth velvet (from mining) (each) (or buy from mall).");
            VGmine.WLFBunkerTasks($item[New Age healing crystal], 5, "Fight healing crystal golems or mine (or buy from mall).");
            VGmine.WLFBunkerTasks($item[half-melted hula girl], 1, nc_text + " Check out HR.");
            VGmine.WLFBunkerTasks($item[Mr. Choch's bone], 1, nc_text + " Head to the boss's shack (fight).");

            if (VGmine.count() > 0) {
                relevant_locations [$location[The Velvet / Gold Mine]] = true;
                description.listAppend("In " + $location[The Velvet / Gold Mine] + ":" + VGmine.listJoinComponents("|").HTMLGenerateIndentedText());
            }
        }
        if (true) {
            string [int] lavaco;
            string nc_text = GenerateCommonZoneSpecificNCText($location[LavaCo&trade; Lamp Factory]);

            lavaco.WLFBunkerTasks($item[gooey lava globs], 5, "Fight lava golems (or buy from mall).");
            lavaco.WLFBunkerTasks($item[fused fuse], 1, "Sabotage the machine at the NC that happens every 10 turns.");
            lavaco.WLFBunkerTasks($item[Mr. Cheeng's 'stache], 1, nc_text + " Go into the boss's office (fight).");
            lavaco.WLFBunkerTasks($item[glass ceiling fragments], 1, nc_text + " Go up the stairs.");

            if (lavaco.count() > 0) {
                relevant_locations [$location[LavaCo&trade; Lamp Factory]] = true;
                description.listAppend("In " + $location[LavaCo&trade; Lamp Factory] + ":" + lavaco.listJoinComponents("|").HTMLGenerateIndentedText());
            }
        }
        if (true) {
            string [int] SMOOCH;
            string nc_text = GenerateCommonZoneSpecificNCText($location[The SMOOCH Army HQ]) + " Open door #";

            SMOOCH.WLFBunkerTasks($item[SMOOCH bottlecap], 1, 'Eat ("drink") a SMOOCH soda (or buy from mall).');
            SMOOCH.WLFBunkerTasks($item[the tongue of Smimmons], 1, nc_text + "1.");
            SMOOCH.WLFBunkerTasks($item[Raul's guitar pick], 1, nc_text + "2.");
            SMOOCH.WLFBunkerTasks($item[Pener's crisps], 1, nc_text + "3.");
            SMOOCH.WLFBunkerTasks($item[signed deuce], 1, nc_text + "4.");

            if (SMOOCH.count() > 0) {
                relevant_locations [$location[The SMOOCH Army HQ]] = true;
                description.listAppend("In " + $location[The SMOOCH Army HQ] + ":" + SMOOCH.listJoinComponents("|").HTMLGenerateIndentedText());
            }
        }
        description.WLFBunkerTasks($item[Saturday Night thermometer], 1, get_property_boolean("_infernoDiscoVisited") ? "Elevator's already been used today :(" : "Rock a disco style of 3, go to the discotheque's elevator, go to the third floor.");

        if (volcano_item.count() > 0)
            description.listAppend(pluralise(volcano_item.count(), "of the items was", "of the items were") + " unregistered.");
        if (volcano_item_id.count() - volcano_item.count() > 1) //if <n° of items ID other than 0> - <n° of items that didn't get listed>  > 1...
            subtitle = "One of:";
    }

    task_entries.listAppend(ChecklistEntryMake("__item volcoino", url, ChecklistSubentryMake("Help smash the system!", subtitle, description), relevant_locations).ChecklistEntrySetIDTag("Airport hot WLF quest"));
}

void QHotAirportGenerateTasks(ChecklistEntry [int] task_entries)
{
    if (!__misc_state["hot airport available"])
        return;
    
    QHotAirportLavaCoLampGenerateTasks(task_entries);
    QHotAirportSuperduperheatedMetalGenerateTasks(task_entries);
    QHotAirportWLFBunkerGenerateTasks(task_entries);
    
    if ($item[lucky gold ring].available_amount() > 0 && !get_property_boolean("_luckyGoldRingVolcoino")) {
        string url;
        string title = "Adventure with ";
        if ($item[lucky gold ring].equipped_amount() == 0) {
            title = "Equip ";
            url = $item[lucky gold ring].invSearch();
        }
        task_entries.listAppend(ChecklistEntryMake("__item lucky gold ring", url, ChecklistSubentryMake(title + " your Lucky Gold Ring", "~1% volcoino/combat", "Can give 1 volcoino per day.")).ChecklistEntrySetIDTag("Airport hot lucky_gold_ring"));
    }
}

void QHotAirportGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (!__misc_state["hot airport available"])
        return;
    //Elevator:
    if (!get_property_boolean("_infernoDiscoVisited")) {
        int potential_disco_style_level = 0;
        int current_disco_style_level = 0;
        item [int] items_to_equip_for_additional_style;
        foreach it in $items[smooth velvet pocket square,smooth velvet socks,smooth velvet hat,smooth velvet shirt,smooth velvet hanky,smooth velvet pants] {
            if (it.equipped_amount() > 0)
                current_disco_style_level += 1;
            else if (it.available_amount() > 0)
                potential_disco_style_level += 1;
        }
        potential_disco_style_level += current_disco_style_level;
        
        string [int] description;
        string url = "place.php?whichplace=airport_hot&action=airport4_zone1";
        if (current_disco_style_level == 0)
            url = "inventory.php?ftext=smooth+velvet";
        /*
        Requires... disco style? (velvet gear)
        Floor 1: Gain 100 points in each stat!
        Floor 2: Get a temporary boost to Item Drops!
        Floor 3: Fight Travoltron!
        Floor 4: Reduce your Drunkenness by 1
        Floor 5: Go backwards in time by 5 Adventures!
        Floor 6: Get a Volcoino!
        */
        Record DiscoFloor
        {
            int floor_number;
            string description;
            boolean grey_out;
        };
        DiscoFloor DiscoFloorMake(int floor_number, string description, boolean grey_out)
        {
            DiscoFloor floor;
            floor.floor_number = floor_number;
            floor.description = description;
            floor.grey_out = grey_out;
            return floor;
        }
        DiscoFloor DiscoFloorMake(int floor_number, string description)
        {
            return DiscoFloorMake(floor_number, description, false);
        }
        void listAppend(DiscoFloor [int] list, DiscoFloor entry)
        {
            int position = list.count();
            while (list contains position)
                position += 1;
            list[position] = entry;
        }
        
        DiscoFloor [int] floors;
        if (__misc_state["need to level"])
            floors.listAppend(DiscoFloorMake(1, "+100 all substats."));
        
        floors.listAppend(DiscoFloorMake(2, "+100% item for 20 turns."));
        floors.listAppend(DiscoFloorMake(3, "Fight Travoltron."));
        if (inebriety_limit() > 0) {
            if (my_inebriety() == 0)
                floors.listAppend(DiscoFloorMake(4, "-1 drunkenness. (drink first)", true));
            else
                floors.listAppend(DiscoFloorMake(4, "-1 drunkenness."));
        }
        if (my_path_id() != PATH_SLOW_AND_STEADY)
            floors.listAppend(DiscoFloorMake(5, "+5 adventures, extend effects."));
        floors.listAppend(DiscoFloorMake(6, "Gain a volcoino."));
        
        foreach key, floor in floors {
            if (floor.floor_number > potential_disco_style_level)
                continue;
            
            string line = "Floor " + floor.floor_number + ": " + floor.description;
            if (floor.floor_number > current_disco_style_level || floor.grey_out) {
                if (floor.floor_number > current_disco_style_level)
                    line += " (wear smooth velvet)";
                line = HTMLGenerateSpanFont(line, "grey");
            }
            description.listAppend(line);
        }
        
        if (items_to_equip_for_additional_style.count() > 0 && potential_disco_style_level > current_disco_style_level)
            description.listAppend("Can equip " + items_to_equip_for_additional_style.listJoinComponents(", ", "and") + " for more style.");
        
        //fancy tophat, insane tophat, brown felt tophat, isotophat, tiny top hat and cane
        if (potential_disco_style_level > 0)
            resource_entries.listAppend(ChecklistEntryMake("__item disco ball", url, ChecklistSubentryMake("One elevator ride", "", description), 5).ChecklistEntrySetIDTag("Airport hot disco_elevator resource"));
    }
}

void QColdAirportGenerateTasks(ChecklistEntry [int] task_entries)
{
    if (!__misc_state["cold airport available"])
        return;
    string desired_walford_item = get_property("walfordBucketItem").to_lower_case();
    if ($item[Walford's bucket].available_amount() > 0 && QuestState("questECoBucket").in_progress && desired_walford_item != "") { //need quest tracking as well, you keep the bucket. FIXME should we be testing against desired_walford_item?
        string title = "";
        string [int] modifiers;
        string [int] description;
        string url = $location[The Ice Hotel].getClickableURLForLocation();
        int progress = get_property_int("walfordBucketProgress");
        if (progress >= 100) {
            url = "place.php?whichplace=airport_cold&action=glac_walrus";
            title = "Talk to Walford";
            description.listAppend("Turn in the quest.");
        } else {
            title = "Walford's quest";
            
            modifiers.listAppend("-combat");
            string [int] options;
            
            options.listAppend("The Ice Hole" + ($effect[fishy].have_effect() == 0 ? " with fishy" : "") + ". (5% per turn)");
            
            string [int] tasks;
            string hotel_string = "The Ice Hotel.";
            boolean nc_helps_in_hotel = true;
            if (desired_walford_item == "milk" || desired_walford_item == "rain")
                nc_helps_in_hotel = false;
            if (nc_helps_in_hotel) {
                if ($item[bellhop's hat].equipped_amount() == 0 && desired_walford_item != "moonbeams")
                    tasks.listAppend("equip bellhop's hat");
                tasks.listAppend("run -combat");
            }
            if (desired_walford_item == "moonbeams" && $slot[hat].equipped_item() != $item[none]) {
                tasks.listAppend("unequip your hat");
            }
            if (desired_walford_item == "blood")
                tasks.listAppend("use tin snips every fight");
            if (desired_walford_item == "chicken" && numeric_modifier("food drop") < 50.0) {
                modifiers.listAppend("+50% food drop");
                tasks.listAppend("run +50% food drop");
            }
            if (desired_walford_item == "milk" && numeric_modifier("booze drop") < 50.0) {
                modifiers.listAppend("+50% booze drop");
                tasks.listAppend("run +50% booze drop");
            }
            if (desired_walford_item == "rain")
                tasks.listAppend("cast hot spells");
            //FIXME verify all (ice?)
            
            if (!get_property_boolean("_iceHotelRoomsRaided"))
                tasks.listAppend("collect once/day certificates");
            if (tasks.count() > 0)
                hotel_string += " " + tasks.listJoinComponents(", ", "and").capitaliseFirstLetter() + ".";
            
            options.listAppend(hotel_string);
            
            tasks.listClear();
            string vkyea_string = "VYKEA.";
            boolean nc_helps_in_vykea = true;
            if (desired_walford_item == "blood")
                nc_helps_in_vykea = false;
            if (nc_helps_in_vykea) {
                tasks.listAppend("run -combat");
            }
            if (desired_walford_item == "moonbeams" && $slot[hat].equipped_item() != $item[none]) {
                tasks.listAppend("unequip your hat");
            }
            if (desired_walford_item == "blood")
                tasks.listAppend("use tin snips every fight");
            if (desired_walford_item == "bolts" && $item[VYKEA hex key].equipped_amount() == 0)
                tasks.listAppend("equip VYKEA hex key");
            if (desired_walford_item == "chum" && meat_drop_modifier() < 250.0) {
                modifiers.listAppend("+250% meat");
                tasks.listAppend("run +250% meat");
            }
            if (desired_walford_item == "balls" && item_drop_modifier() < 50) {
                modifiers.listAppend("+50% item");
                tasks.listAppend("run +50% item");
            }
            if (!get_property_boolean("_VYKEALoungeRaided"))
                tasks.listAppend("collect once/day certificates");
            
            if (tasks.count() > 0)
                vkyea_string += " " + tasks.listJoinComponents(", ", "and").capitaliseFirstLetter() + ".";
            
            options.listAppend(vkyea_string);
            
            tasks.listClear();
            if ($item[Walford's bucket].equipped_amount() == 0) {
                url = "inventory.php?ftext=walford's+bucket";
                tasks.listAppend("equip walford's bucket");
            }
            tasks.listAppend("adventure on the glacier");
            description.listAppend(tasks.listJoinComponents(", ", "then").capitaliseFirstLetter() + ":|*" + options.listJoinComponents("<hr>|*"));
            
            
            description.listAppend(progress + "% done collecting " + desired_walford_item + ".");
        }
        task_entries.listAppend(ChecklistEntryMake("__item Walford's bucket", url, ChecklistSubentryMake(title, modifiers, description), $locations[The Ice Hotel,VYKEA,The Ice Hole]).ChecklistEntrySetIDTag("Airport cold walford quest"));
    }
}

void QAirportGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    ChecklistEntry [int] chosen_entries = optional_task_entries;
    if (__misc_state["in run"])
        chosen_entries = future_task_entries;
    
    QSleazeAirportGenerateTasks(chosen_entries);
    QSpookyAirportGenerateTasks(chosen_entries);
    QStenchAirportGenerateTasks(chosen_entries);
    QHotAirportGenerateTasks(chosen_entries);
    QColdAirportGenerateTasks(chosen_entries);
}

void QAirportGenerateResource(ChecklistEntry [int] resource_entries)
{
    QHotAirportGenerateResource(resource_entries);
}
