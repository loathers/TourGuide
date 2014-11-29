import "Level 11 - Copperhead.ash";
import "Level 11 - Pyramid.ash";
import "Level 11 - Desert.ash";
import "Level 11 - Palindome.ash";
import "Level 11 - Manor.ash";
import "Level 11 - Hidden City.ash";
import "Level 11 - Hidden Temple.ash";

void QLevel11Init()
{
	//questL11MacGuffin, questL11Manor, questL11Palindome, questL11Pyramid, questL11Worship
	//hiddenApartmentProgress, hiddenBowlingAlleyProgress, hiddenHospitalProgress, hiddenOfficeProgress, hiddenTavernUnlock
	//relocatePygmyJanitor, relocatePygmyLawyer
	
	
	/*
	gnasirProgress is a bitmap of things you've done with Gnasir to advance desert exploration:

	stone rose = 1
	black paint = 2
	killing jar = 4
	worm-riding manual pages (15) = 8
	successful wormride = 16
	*/
	if (true)
	{
		QuestState state;
		QuestStateParseMafiaQuestProperty(state, "questL11MacGuffin");
		state.quest_name = "MacGuffin Quest";
		state.image_name = "MacGuffin";
		state.council_quest = true;
	
		if (my_level() >= 11)
			state.startable = true;
		__quest_state["Level 11"] = state;
		__quest_state["MacGuffin"] = state;
	}

    QLevel11CopperheadInit();
    QLevel11PyramidInit();
    QLevel11DesertInit();
    QLevel11PalindomeInit();
    QLevel11ManorInit();
    QLevel11HiddenCityInit();
    QLevel11HiddenTempleInit();
}

void QLevel11BaseGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	if (!__quest_state["Level 11"].in_progress)
        return;

    QuestState base_quest_state = __quest_state["Level 11"];
    ChecklistSubentry subentry;
    subentry.header = base_quest_state.quest_name;
    string url = "";
    boolean make_entry_future = false;
    if (base_quest_state.mafia_internal_step < 2)
    {
        //This needs better spading.
        //Side info: in the livestream, the flag [blackforestexplore] => 55 was visible, as well as [blackforestprogress] => 5
        
        //Unlock black market:
        url = "place.php?whichplace=woods";
        
        subentry.modifiers.listAppend("+5% combat");
        subentry.entries.listAppend("Unlock the black market by adventuring in the Black Forest with +5% combat.");
        
        if ($item[blackberry galoshes].available_amount() > 0)
        {
            if ($item[blackberry galoshes].equipped_amount() == 0)
            {
                subentry.entries.listAppend(HTMLGenerateSpanFont("Equip blackberry galoshes", "red", "") + " to speed up exploration.");
            }
        }
        else
        {
            if (!in_hardcore())
                subentry.entries.listAppend("Possibly pull and wear the blackberry galoshes?");
            //it seems unlikely finding the galoshes in HC would be worth it? maaaybe in no-familiar paths, but probably not? sneaky pete, perhaps
            //subentry.entries.listAppend("Possibly make the blackberry galoshes via NC, if you get three blackberries.");
        }
        
        familiar bird_needed_familiar;
        item bird_needed;
        if (my_path_id() == PATH_BEES_HATE_YOU)
        {
            bird_needed_familiar = $familiar[reconstituted crow];
            bird_needed = $item[reconstituted crow];
        }
        else
        {
            bird_needed_familiar = $familiar[reassembled blackbird];
            bird_needed = $item[reassembled blackbird];
        }
        item [int] missing_components = missingComponentsToMakeItem(bird_needed);
        
        //FIXME clean this up:
        //FIXME test if having a reassembled blackbird in your inventory is more than enough in any path?
        //FIXME handle both reassembled blackbird and reconstituted crow as familiar
        
        if (missing_components.count() > 0 && bird_needed.available_amount() == 0)
        {
            subentry.modifiers.listAppend("+100% item"); //FIXME what is the drop rate for bees hate you items? we don't know...
        }
        
        if (bird_needed_familiar.familiar_is_usable())
        {
            if (bird_needed.available_amount() == 0 && missing_components.count() == 0)
            {
                subentry.entries.listAppend("Make a " + bird_needed + ".");
            }
            else if (my_familiar() != bird_needed_familiar && bird_needed.available_amount() == 0)
            {
                subentry.entries.listAppend(HTMLGenerateSpanFont("Bring along " + bird_needed_familiar + " to speed up quest.", "red", ""));
            }
            else if (my_familiar() == bird_needed_familiar && bird_needed.available_amount() > 0)
            {
                subentry.entries.listAppend("Bring along another familiar, you don't need to use the bird anymore.");
            }
        }
        if (bird_needed.available_amount() == 0)
        {
            string line = "";
            line = "Acquire " + bird_needed + ".";
        
            if (missing_components.count() == 0)
                line += " You have all the parts, make it.";
            else
                line += " Parts needed: " + missing_components.listJoinComponents(", ", "and");
            subentry.entries.listAppend(line);
        }
        
        if (!__quest_state["Level 13"].state_boolean["have relevant drum"])
        {
            boolean church_unlocked = (get_property_int("blackForestProgress") >= 4);
            
            string line = "Acquire a drum from the non-combat" + (church_unlocked ? "" : " once the church is unlocked") + ". (Church -> orchestra pit)";
            if (!church_unlocked)
                line = HTMLGenerateSpanFont(line, "gray", "");
            
            subentry.entries.listAppend(line);
        }
    }
    else if (base_quest_state.mafia_internal_step < 3)
    {
        //Vacation:
        if ($item[forged identification documents].available_amount() == 0)
        {
            url = "shop.php?whichshop=blackmarket";
            subentry.entries.listAppend("Buy forged identification documents from the black market.");
            if ($item[can of black paint].available_amount() == 0)
                subentry.entries.listAppend("Also buy a can of black paint while you're there, for the desert quest.");
        }
        else
        {
            if (CounterLookup("Semi-rare").CounterWillHitExactlyInTurnRange(0,2))
            {
                subentry.entries.listAppend(HTMLGenerateSpanFont("Avoid vacationing; will override semi-rare.", "red", ""));
            }
            else
            {
                url = "place.php?whichplace=desertbeach";
                subentry.entries.listAppend("Vacation at the shore, read diary.");
            }
        }
    }
    else if (base_quest_state.mafia_internal_step < 4)
    {
        //Have diary:
        if ($item[holy macguffin].available_amount() == 0)
        {
            //nothing to say
            //subentry.entries.listAppend("Retrieve the MacGuffin.");
            return;
        }
        else
        {
            url = "place.php?whichplace=town";
            subentry.entries.listAppend("Speak to the council.");
        }
    }
    if (make_entry_future)
        future_task_entries.listAppend(ChecklistEntryMake(base_quest_state.image_name, url, subentry, $locations[the black forest]));
    else
        task_entries.listAppend(ChecklistEntryMake(base_quest_state.image_name, url, subentry, $locations[the black forest]));
}

void QLevel11GenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    QLevel11RonGenerateTasks(task_entries, optional_task_entries, future_task_entries);
    QLevel11ShenGenerateTasks(task_entries, optional_task_entries, future_task_entries);
    if (!__misc_state["In run"])
        return;
    //Such a complicated quest.
    QLevel11BaseGenerateTasks(task_entries, optional_task_entries, future_task_entries);
    QLevel11ManorGenerateTasks(task_entries, optional_task_entries, future_task_entries);
    QLevel11PalindomeGenerateTasks(task_entries, optional_task_entries, future_task_entries);
    QLevel11DesertGenerateTasks(task_entries, optional_task_entries, future_task_entries);
    QLevel11PyramidGenerateTasks(task_entries, optional_task_entries, future_task_entries);
    QLevel11HiddenCityGenerateTasks(task_entries, optional_task_entries, future_task_entries);
    QLevel11HiddenTempleGenerateTasks(task_entries, optional_task_entries, future_task_entries);
}