import "relay/TourGuide/QuestState.ash"
import "relay/TourGuide/Support/Checklist.ash"

boolean [item] __pulls_reasonable_to_buy_in_run;

int pullable_amount(item it, int maximum_total_wanted)
{
	boolean buyable_in_run = false;
	if (__pulls_reasonable_to_buy_in_run contains it)
		buyable_in_run = true;
    if (it.tradeable && it.historical_price() > 0 && it.historical_price() < 75000)
    	buyable_in_run = true;
	if (maximum_total_wanted == 0)
		maximum_total_wanted = __misc_state_int["pulls available"] + it.available_amount();
	if (__misc_state["Example mode"]) //simulate pulls
	{
		if (buyable_in_run)
			return min(__misc_state_int["pulls available"], maximum_total_wanted);
		else
			return min(__misc_state_int["pulls available"], min(storage_amount(it) + it.available_amount(), maximum_total_wanted));
	}
	
	int amount = storage_amount(it);
	if (buyable_in_run)
		amount = 20;
	int total_amount = amount + it.available_amount();
	
	if (total_amount > maximum_total_wanted)
	{
		amount = maximum_total_wanted - it.available_amount();
	}
	
    // Code by MadCarew to limit your pull # to just 1, not > 1.
    if (in_ronin() && amount > 0 )
	{
        // Hooray for removing already-pulled stuff!
	    string ronin_storage_pulls = get_property("_roninStoragePulls");
	    string[int] already_pulled = split_string(ronin_storage_pulls, ",");
	    int requested_item = it.to_int();
        
	    boolean already_pulled_this_item = false;
		foreach key in already_pulled {
			if (already_pulled[key] == requested_item) already_pulled_this_item = true;
		}
	    amount = already_pulled_this_item ? 0 : 1;
	}

	return min(__misc_state_int["pulls available"], amount);
}

int pullable_amount(item it)
{
	return pullable_amount(it, 0);
}


//generic pull item
record GPItem
{
	//Either item OR alternate_name
	item it;
	string alternate_name;
	string alternate_image_name;
	
	string reason;
	int max_wanted;
};

GPItem GPItemMake(item it, string reason, int max_wanted)
{
	GPItem result;
	result.it = it;
	result.reason = reason;
	result.max_wanted = max_wanted;
	return result;
}

GPItem GPItemMake(item it, string reason)
{
	return GPItemMake(it, reason, 1);
}

GPItem GPItemMake(string alternate_name, string alternate_image_name, string reason)
{
	GPItem result;
	result.alternate_name = alternate_name;
	result.alternate_image_name = alternate_image_name;
	result.reason = reason;
	result.max_wanted = 1;
	return result;
}

void listAppend(GPItem [int] list, GPItem entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}


void generatePullList(Checklist [int] checklists)
{
    // Start out pull list generation with some general bookkeeping
	ChecklistEntry [int] pulls_entries;
	
    // Return in the event that the user has no pulls available
	int pulls_available = __misc_state_int["pulls available"];
	if (pulls_available <= 0)
		return;
	if (pulls_available > 0)
		pulls_entries.listAppend(ChecklistEntryMake("special subheader", "", ChecklistSubentryMake(pluralise(pulls_available, "pull", "pulls") + " remaining")).ChecklistEntrySetIDTag("Pulls special subheader"));
	
    // Establish your base lists & variables
	item [int] pullable_list_item;
	int [int] pullable_list_max_wanted;
	string [int] pullable_list_reason;
	GPItem [int] pullable_item_list;
    boolean combat_items_usable = true;
    boolean combat_skills_usable = true;

    // Set a single path-related variable
    if (my_path().id == PATH_POCKET_FAMILIARS)
    	combat_items_usable = false;
    	combat_skills_usable = false;

    // =====================================================================
    // ------ SECTION #1: 3+ TURNS -----------------------------------------
    // =====================================================================
    
    // Pulls in this category are highly valuable turnsave pulls that can 
    //   either bypass certain quests entirely or save entire chunks of 
    //   quests. Everything here is stupid valuable. Ordering is:
    //     1. Free kills
    //     2. Free runs
    //     3. Copiers
    //     4. Quest-y pulls

    boolean canUseHeavySpleeners = availableSpleen() >= 2 && my_path().id != PATH_NUCLEAR_AUTUMN && my_path().id != PATH_COMMUNITY_SERVICE;

    // Breathitin is virtually always good. Absurdly nice pull.
    if (canUseHeavySpleeners)
		pullable_item_list.listAppend(GPItemMake($item[Breathitin&trade;], "5 outdoor free kills for 2 spleen", 7));
    
    // Bat-oomerang is a great freekill pull
    if (combat_items_usable && $item[replica bat-oomerang].item_is_usable())
    	pullable_item_list.listAppend(GPItemMake($item[replica bat-oomerang], "3 daily free kills", 1));
    
    // Carnivorous Potted Plant is frustrating when you have lots of offhands, but it's
    //   unambiguously good... so long as you have enough combats left. Going to say
    //   that after 250 turns spent, it's unlikely you want this. 
    pullable_item_list.listAppend(GPItemMake($item[carnivorous potted plant], "offhand; +25 ML, 4% chance of turning any given combat free", 1));

    // Part of me kind of wants to make one pull tile that concatenates the 3 battery
    //   types, but this is good enough.

    if (combat_skills_usable) {
    	pullable_item_list.listAppend(GPItemMake($item[battery (car)], "1 yellow ray + freekill|30 turns of 100% item/meat", 2));
    	pullable_item_list.listAppend(GPItemMake($item[battery (lantern)], "1 yellow ray + freekill|30 turns of 100% item", 2));
    	pullable_item_list.listAppend(GPItemMake($item[battery (9-volt)], "1 yellow ray + freekill", 2));
    }

    boolean freeRunFamiliarUsable = familiar_is_usable($familiar[pair of stomping boots]) || ($skill[the ode to booze].skill_is_usable() && familiar_is_usable($familiar[Frumious Bandersnatch]));

    // This is a catch-all for familiar weight pulls, which are only useful if the user can use boots/bander
    if (!__misc_state["familiars temporarily blocked"] && $familiar[pair of stomping boots].is_unrestricted() && freeRunFamiliarUsable) {

        // Sort of a pain, but if they have it, it's a nice +4 runs...
        if ($item[snow suit].item_is_usable()) pullable_item_list.listAppend(GPItemMake($item[snow suit], "+20 familiar weight for a while, +4 free runs (boots/bander)", 1));

        // If they've got a free-run fam, this is a dope pull
        if ($item[repaid diaper].item_is_usable()) pullable_item_list.listAppend(GPItemMake($item[repaid diaper], "+3 free runs (boots/bander)", 1));
        
        // If they've got a free-run fam, this is a dope pull
        if ($item[silver face paint].item_is_usable()) pullable_item_list.listAppend(GPItemMake($item[silver face paint], "+4 free runs (boots/bander)|only lasts 1 turn; extend w/ wool or PYEC?", 1));
    }

    // Generic free-run based pulls
    if (__misc_state["free runs usable"]) {

        // GAP & navel are still good pulls, even now! Priority is GAP > navel > parasol, if you own all.
        int storagePants = pullable_amount($item[greatest american pants]);
        int storageNavel = pullable_amount($item[navel ring of navel gazing]);
        int totalGAPandNavel = $items[greatest american pants, navel ring of navel gazing].available_amount();

        if (storagePants > 0) {
	        pullable_item_list.listAppend(GPItemMake($item[greatest american pants], "3+ free runaways|item, mox, DA buff", 1));
        }
        else if (storageNavel > 0) {
            pullable_item_list.listAppend(GPItemMake($item[navel ring of navel gazing], "3+ free runaways|easier fights", 1));
        }
	    else if (storagePants + storageNavel + totalGAPandNavel == 0) {
		    pullable_item_list.listAppend(GPItemMake($item[peppermint parasol], "3+ free runaways", 1));
        }

        if (!get_property_boolean("_blankoutUsed") && $item[bottle of blank-out].item_is_usable())
            pullable_item_list.listAppend(GPItemMake($item[bottle of blank-out], "5 free runaways|flee your problems", 1));

    }

    // Rain-Doh & Spooky Putty; 5 copies is roughly 3+ turns in value, even without going in delay.
	if ($item[empty rain-doh can].available_amount() == 0 && $item[can of rain-doh].available_amount() == 0 && $item[can of rain-doh].item_is_usable())
		pullable_item_list.listAppend(GPItemMake($item[can of rain-doh], "5 copies/day|everything really", 1));

	if ($items[empty rain-doh can,can of rain-doh,spooky putty monster].available_amount() == 0 && $item[spooky putty sheet].item_is_usable())
		pullable_item_list.listAppend(GPItemMake($item[spooky putty sheet], "5 copies/day", 1));

    // Extro: the modern stuffer/blaster lol.
    if (canUseHeavySpleeners) pullable_item_list.listAppend(GPItemMake($item[Extrovermectin&trade;], "3 copies (as wanderers) for 2 spleen", 7));

    // Stuffers and blasters are still good, though blaster is strictly inferior to a breath
    if (availableSpleen() >= 2 && my_path().id != PATH_NUCLEAR_AUTUMN && my_path().id != PATH_COMMUNITY_SERVICE)
    {
        pullable_item_list.listAppend(GPItemMake($item[turkey blaster], "Burns five turns of delay in last adventured area. Costs spleen, limited uses/day.", MIN(3 - get_property_int("_turkeyBlastersUsed"), MIN(availableSpleen() / 2, 3))));

        if (!__quest_state["Level 12"].finished && __quest_state["Level 12"].state_int["frat boys left on battlefield"] >= 936 && __quest_state["Level 12"].state_int["hippies left on battlefield"] >= 936)
        {
            pullable_item_list.listAppend(GPItemMake($item[stuffing fluffer], "Saves eight turns if you use two at the start of fighting in the war.", 2));
        }
    }

    // Homebodyl is a pretty good pull if the user doesn't have free crafts.
    boolean hasAnyFreeCrafts = false;

    if ($item[recording of Inigo's Incantation of Inspiration].available_amount() > 0) {
       hasAnyFreeCrafts = true;
    }
    else if ($item[cuppa Craft tea].available_amount() > 0) {
       hasAnyFreeCrafts = true;
    }
    else if ($skill[rapid prototyping].skill_is_usable()) {
       hasAnyFreeCrafts = true;
    }
    else if (lookupSkill("Expert Corner-Cutter").skill_is_usable()) {
       hasAnyFreeCrafts = true;
    }    
    else if (get_property_int("homebodylCharges") > 0 || $item[Homebodyl&trade;].available_amount() > 0) {
       hasAnyFreeCrafts = true;
    }

    if (!hasAnyFreeCrafts)
		pullable_item_list.listAppend(GPItemMake($item[Homebodyl&trade;], "11 free crafts for 2 spleen", 1));

    // Hero key generators save 3+ turns apiece, but if you have a zap wand, you should pull accessories instead
    if (__misc_state_int["fat loot tokens needed"] > 0) {

        string [int] hero_key_selections; // general summary hero selection variable
        string [int] which_pies; // if it's pie time
        string [int] which_accessories; // if it's wand time
        string line;
        string description;

        // If they have an easy way to get a wand (or have a wand, or are in shrunken adv) suggest hero accessories instead of pies
        if (my_path() == $path[A Shrunken Adventurer am I] || __iotms_usable[lookupItem("diabolic pizza cube")] || __misc_state["zap wand owned"]) {
            if ($items[boris's key,boris's key lime pie].available_amount() == 0) which_accessories.listAppend("Boris' Ring");
            if ($items[jarlsberg's key,jarlsberg's key lime pie].available_amount() == 0) which_accessories.listAppend("Jarlsberg's Earring");
            if ($items[sneaky pete's key,sneaky pete's key lime pie].available_amount() == 0) which_accessories.listAppend("Sneaky Pete's Breath Spray");
            if (which_accessories.count() > 0)
                line += which_accessories.listJoinComponents(", ")+" ... get a wand and zap them!";
            hero_key_selections.listAppend(line);

            // If they're pulling accessories, should also probably pull PYEC
            pullable_item_list.listAppend(GPItemMake($item[Platinum Yendorian Express Card], "recharge your zap wand, extend some effects"));
        }
        else if (__misc_state["can eat just about anything"] && availableFullness() > 0)
        {       
            if ($items[boris's key,boris's key lime pie].available_amount() == 0 && $item[boris's key lime pie].item_is_usable())
                which_pies.listAppend("Boris");
            if ($items[jarlsberg's key,jarlsberg's key lime pie].available_amount() == 0 && $item[jarlsberg's key lime pie].item_is_usable())
                which_pies.listAppend("Jarlsberg");
            if ($items[sneaky pete's key,sneaky pete's key lime pie].available_amount() == 0 && $item[sneaky pete's key lime pie].item_is_usable())
                which_pies.listAppend("Sneaky Pete");
            if (which_pies.count() > 0)
                line += which_pies.listJoinComponents("/") + "'s ";
            line += "key lime pie";
            if (which_pies.count() > 1)
                line += "s";
            hero_key_selections.listAppend(line);
        
        }

        if (hero_key_selections.count() > 0) {
            description = hero_key_selections.listJoinComponents(", ");
            pullable_item_list.listAppend(GPItemMake("Hero Key Generators", "Boris's key", description));
        }
    }

    // Being able to skip HITS entirely is pretty strong, much like Whitey's skip. 
    int starChartsNeeded = MAX(1 - $item[star chart].available_amount(), 0);
    int starsNeeded = MAX(8 - $item[star].available_amount(), 0);
    int linesNeeded = MAX(7 - $item[line].available_amount(), 0);

    boolean haveStarKey = __quest_state["Level 13"].state_boolean["Richard\'s star key used"] || $item[richard\'s star key].available_amount() > 0;

    if (!haveStarKey) {
        // First, if they don't have a star chart, recommend a chart or a greasy desk bell.
        if (starChartsNeeded > 0) {
            if ($item[greasy desk bell].is_unrestricted()) {
                pullable_item_list.listAppend(GPItemMake($item[greasy desk bell], "get a star chart + 2 stars & 2 lines|free (but difficult) fight", 1));
            }
            else {
                pullable_item_list.listAppend(GPItemMake($item[star chart], "for Richard's Star Key", 1));
            }
        }

        // Next, suggest star pops
        if (__misc_state["can eat just about anything"] && my_path() != $path[A Shrunken Adventurer am I]) {
            if (availableFullness() > 0 ) {
                string starPopDesc = "3-4 stars & lines";
                if (starsNeeded < 4 && linesNeeded < 4) starPopDesc += ", will finish your key"; 
                if (starsNeeded > 3 && linesNeeded > 3) starPopDesc += ", of the "+starsNeeded+" stars & "+linesNeeded+" lines you still need";
                pullable_item_list.listAppend(GPItemMake($item[star pop], starPopDesc));
            }

        // Next, suggest star KLPs; if we've already suggested star pops, don't suggest KLPs, as they're strictly worse
            if (availableFullness() > 3 && !$item[star pop].is_unrestricted()) {
                string starKLPDesc = "2-4 stars & lines";
                if (starsNeeded < 3 && linesNeeded < 3) starKLPDesc += ", will finish your key"; 
                if (starsNeeded > 2 && linesNeeded > 2) starKLPDesc += ", of the "+starsNeeded+" stars & "+linesNeeded+" lines you still need";
                pullable_item_list.listAppend(GPItemMake($item[star key lime pie], starKLPDesc));
            }
        }
    }

	
    // Wet stew is just an eternally great pull, Whitey's sucks
	if (!__quest_state["Level 11 Palindome"].finished && $item[mega gem].available_amount() == 0 && ($item[wet stew].available_amount() + $item[wet stunt nut stew].available_amount() + $item[wet stew].creatable_amount() == 0) && my_path().id != PATH_ACTUALLY_ED_THE_UNDYING)
		pullable_item_list.listAppend(GPItemMake($item[wet stew], "make into wet stunt nut stew|skip whitey's grove", 1));

    // While a machete is quest-relevant, it's a 4-7 turn pull; that's absurd value.
    if (!__quest_state["Level 11 Hidden City"].finished && !__quest_state["Level 11"].finished && (get_property_int("hiddenApartmentProgress") < 1 || get_property_int("hiddenBowlingAlleyProgress") < 1 || get_property_int("hiddenHospitalProgress") < 1 || get_property_int("hiddenOfficeProgress") < 1) && __misc_state["can equip just about any weapon"] && my_path().id != PATH_POCKET_FAMILIARS)
    {
        boolean have_machete = false;
        foreach it in __dense_liana_machete_items
        {
            if (it.available_amount() > 0 && it.is_unrestricted())
                have_machete = true;
        }
        if (!have_machete)
        {
            if (my_basestat($stat[muscle]) < 62 && $item[machetito].is_unrestricted())
            {
                //machetito
                pullable_item_list.listAppend(GPItemMake($item[machetito], "Machete for dense liana", 1));
            }
            else if ($item[muculent machete].is_unrestricted() && my_path().id != PATH_G_LOVER) //my_basestat($stat[muscle]) < 62 &&
            {
                //muculent machete, also gives +5% meat, op ti mal
                pullable_item_list.listAppend(GPItemMake($item[muculent machete], "Machete for dense liana", 1));
            }
            else
            {
                //antique machete
                pullable_item_list.listAppend(GPItemMake($item[antique machete], "Machete for dense liana", 1));
            }
        }
    }

    // As with machete, these are just flat-out great pulls, quest relevant or not
    // 2025 UPDATE: ... or, well, they were. lol.
    // if (!__quest_state["Level 8"].state_boolean["Mountain climbed"] && !have_outfit_components("eXtreme Cold-Weather Gear"))
    // {
    //     item [int] missing_ninja_components = items_missing($items[ninja carabiner, ninja crampons, ninja rope]);
    //     if (missing_ninja_components.count() > 0)
    //     {
    //         string description = missing_ninja_components.listJoinComponents(", ", "and").capitaliseFirstLetter() + ".";
            
    //         if (numeric_modifier("cold resistance") < 5.0)
    //             description += "|Will require five " + HTMLGenerateSpanOfClass("cold", "r_element_cold") + " resist to use properly.";
    //         pullable_item_list.listAppend(GPItemMake("Ninja peak climbing", "__item " + missing_ninja_components[0], description));
    //     }
    // }

    // Literally just 3 straight turnsave to pull scrips if you need em, lol
    string [int] scrip_reasons;
	int scrip_needed = 0;
	if (!__misc_state["mysterious island available"] && $item[dinghy plans].available_amount() == 0)
	{
		scrip_needed += 3;
		scrip_reasons.listAppend("mysterious island");
	}
	if ($item[uv-resistant compass].available_amount() == 0 && $item[ornate dowsing rod].available_amount() == 0 && __misc_state["can equip just about any weapon"] && !__quest_state["Level 11 Desert"].state_boolean["Desert Explored"])
	{
		scrip_needed += 1;
		scrip_reasons.listAppend($item[uv-resistant compass].to_string());
	}
	if (scrip_needed > 0 && my_path().id != PATH_COMMUNITY_SERVICE && my_path().id != PATH_EXPLOSIONS)
	{
		pullable_item_list.listAppend(GPItemMake($item[Shore Inc. Ship Trip Scrip], "Saves three turns each. (One per day?)|" + scrip_reasons.listJoinComponents(", ", "and").capitaliseFirstLetter() + ".", scrip_needed));
	}

    // Zepp mob, if done via faceroll, is 40+ turns. This stuff is massive value in ignoring that.
    if (my_path().id != PATH_SEA && __quest_state["Level 11 Ron"].mafia_internal_step <= 2 && __quest_state["Level 11 Ron"].state_int["protestors remaining"] > 1)
    {
        item [int] missing_freebird_components = items_missing( __misc_state["Torso aware"] ? $items[lynyrdskin cap,lynyrdskin tunic,lynyrdskin breeches,lynyrd musk] : $items[lynyrdskin cap,lynyrdskin breeches,lynyrd musk] );
        
        // In softcore, you are -almost- always going to prefer sleaze route in modern standard.
        //   However, for the sake of completionism, I will do a short and sweet sleaze calc; if
        //   the user is over the line of 262 sleaze, they should just pull a dang lewd deck.

        int projectedSleaze = 31; // assuming war outfit + kicks + ghost of a necklace

        if (__iotms_usable[$item[Jurassic Parka]]) projectedSleaze += 40;
        if (__iotms_usable[$item[June Cleaver]]) projectedSleaze += 50;
        if (__iotms_usable[$item[tiny stillsuit]]) projectedSleaze += 40;
        if (__iotms_usable[$item[cursed monkey's paw]]) projectedSleaze += 200;
        if (__iotms_usable[$item[designer sweatpants]]) projectedSleaze += 120;

        if (missing_freebird_components.count() > 0 && projectedSleaze < 262)
        {
            string description = missing_freebird_components.listJoinComponents(", ", "and").capitaliseFirstLetter() + ".";
            if (__misc_state["Torso aware"])
            {
                if ($strings[Wombat,Blender,Packrat] contains my_sign() && my_path().id != PATH_ZOMBIE_SLAYER)	// gnome trainer may be available
                    description += "|Plus five clovers. Skips protestors in five turns? Or become torso aware and pull the tunic first.";
                else
                    description += "|Plus five clovers. Skips the entire Zeppelin Mob in five turns?";
            }
            else
                description += "|Plus four clovers. Skips the entire Zeppelin Mob in ~four turns?";
            pullable_item_list.listAppend(GPItemMake("Weird copperhead NC strategy", "__item " + missing_freebird_components[0], description));
        }

        if (my_path().id != PATH_GELATINOUS_NOOB && projectedSleaze > 100)
            pullable_item_list.listAppend(GPItemMake($item[deck of lewd playing cards], "+138 sleaze damage equip for Zeppelin Mob", 1));
        
    }

    // Gravy Boat used to be an unreasonable pull, but in 37 evil per zone era, this is a good one now    
    if (__quest_state["Level 7"].in_progress) 
    {
        pullable_item_list.listAppend(GPItemMake($item[gravy boat], "Wear to save 3-4 turns in the cyrpt.")); 
        
    }

    // =====================================================================
    // ------ SECTION #2: 1-2 TURNS ----------------------------------------
    // =====================================================================
    
    // Not as valuable as the section #1 pulls, but better than average. In
    //   general, these pulls should be considered above quest misses and 
    //   are less related to explicit in-run findings.
    
    // Generic free-run based pulls, but these are less valuable than those in section #1 
    if (__misc_state["free runs usable"])
    {
        // Middle finger ring is straight up good!
        if (my_path().id != PATH_ZOMBIE_SLAYER && combat_skills_usable) // can't use due to MP cost in zombie slayer
			pullable_item_list.listAppend(GPItemMake($item[mafia middle finger ring], "1 free 80-turn banish, per day", 1));

        // I did not realize vivala mask gave a 10-turn banish until Legacy of Loathing. I was unfamiliar with its game.
        if ($item[v for vivala mask].item_is_usable()) pullable_item_list.listAppend(GPItemMake($item[v for vivala mask], "1 free 10-turn banish, per day", 1));
    }

    // Generic free-kill based pulls, but less valuable than tier 1 pulls
    int pills_pullable = clampi(20 - get_property_int("_powerPillUses"), 0, 20);
    if (pills_pullable > 0 && ($familiar[ms. puck man].have_familiar() || $familiar[puck man].have_familiar()))
    {
        pullable_item_list.listAppend(GPItemMake($item[power pill], "1 free kill, with your puck", pills_pullable));
    }

    if (combat_items_usable) {
        // Shadow bricks are pretty much fine as a pull; certainly better than writs/GSBs
        pullable_item_list.listAppend(GPItemMake($item[shadow brick], "1 free kill", 13));

        // Powdered Madness is expensive but fine
        pullable_item_list.listAppend(GPItemMake($item[powdered madness], "1 free kill",5));

        // Groveling Gravel is worse, but it's... fine
        pullable_item_list.listAppend(GPItemMake($item[groveling gravel], "1 free kill|destroys item drops, buyer beware!",5));
    }

    // NC forcers are great! Clara's is nice because it's 2 in a 2-day run.
    if ($item[Clara's Bell].item_is_usable())
	    pullable_item_list.listAppend(GPItemMake($item[Clara's Bell], "Forces a non-combat, once/day.", 1));
    
    // ... but one stench jelly is also fine!
    if (availableSpleen() > 0 && $item[stench jelly].item_is_usable() && my_path().id != PATH_LIVE_ASCEND_REPEAT)
	    pullable_item_list.listAppend(GPItemMake($item[stench jelly], "Skips ahead to an NC, saves 2-3 turns each.", 20));

    // Quest-y pull; just save searching for an NC, like an NC forcer, but also save the turn spent!
    if (my_path().id != PATH_SEA && !get_property_ascension("lastTempleUnlock") && $item[spooky-gro fertilizer].item_amount() == 0 && $item[spooky-gro fertilizer].item_is_usable())
        pullable_item_list.listAppend(GPItemMake($item[spooky-gro fertilizer], "Saves 2-ish turns while unlocking temple."));
	
    if (my_path().id != PATH_COMMUNITY_SERVICE && $item[11-leaf clover].item_is_usable())
		pullable_item_list.listAppend(GPItemMake($item[11-leaf clover], "Various turn saving applications|Zeppelin Mob, Wand of Nagamar, etc."));
    
    // If you can't hit 25% combat, all of these are actually pretty dope...
    if (!__misc_state["can reasonably reach -25% combat"])
    {
        if ((my_primestat() == $stat[moxie] || my_basestat($stat[moxie]) >= 35) && $item[iFlail].item_is_usable())
            pullable_item_list.listAppend(GPItemMake($item[iFlail], "-combat, +11 ML, +5 familiar weight"));
        if (__misc_state["Torso aware"] && $item[xiblaxian stealth vest].item_is_usable()) //FIXME exclusiveness with camouflage T-shirt. probably should pull camou if we're over muscle stat, otherwise stealth vest, or whichever we have
            pullable_item_list.listAppend(GPItemMake($item[xiblaxian stealth vest], "-combat shirt"));
        if ($item[duonoculars].item_is_usable())
	        pullable_item_list.listAppend(GPItemMake($item[duonoculars], "-combat, +5 ML"));
        if ($item[ring of conflict].item_is_usable())
            pullable_item_list.listAppend(GPItemMake($item[ring of conflict], "-combat"));
        if (($item[red shoe].can_equip() || my_path().id == PATH_GELATINOUS_NOOB) && $item[red shoe].item_is_usable())
            pullable_item_list.listAppend(GPItemMake($item[red shoe], "-combat"));
    }

    // ... but even if you CAN hit 25% combat, invisibility tonic is actually pretty great
    if (my_path().id != PATH_LIVE_ASCEND_REPEAT) {
	    pullable_item_list.listAppend(GPItemMake($item[patent invisibility tonic], "30 turns of -15% combat|If you route 30 turns of NC hunting together, this is solid value"));  
    }

    // If they have grey goose, they should (perhaps) consider pulling some of the familiar XP gear
    if ($familiar[grey goose].familiar_is_usable() && my_path() != $path[Legacy of Loathing]) {
        int extraVestXP = $item[tiny stillsuit].available_amount() > 0 ? 1 : 2;
	    pullable_item_list.listAppend(GPItemMake($item[grey down vest], "Equip for +"+extraVestXP+" goose XP over your next best option")); 

        if ($item[teacher's pen].available_amount() < 3) {
    	    pullable_item_list.listAppend(GPItemMake($item[teacher's pen], "Equip for +2 goose XP per fight"));  
        }

    }

    // Speaking of goose, Claw of the Infernal Seal is a nice pull for 5 free-ish fights
    if (my_class() == $class[seal clubber] && $item[Claw of the Infernal Seal].available_amount() == 0) {
	    pullable_item_list.listAppend(GPItemMake($item[Claw of the Infernal Seal], "Fight 5 more free seals per day|Familiar turns, XP, and other fight-advanced goodies")); 
    }
    
    // Sure, why not; pocket wishes are fine
    if ($item[pocket wish].item_is_usable())
	    pullable_item_list.listAppend(GPItemMake($item[pocket wish], "Save turns with meat/item wishes, monster summons, and more", 20));  

    // If nuns is still needed, recommend pulling an inhaler.
    if (!__quest_state["Level 12"].state_boolean["Nuns Finished"] && my_path().id != PATH_2CRS) {
        pullable_item_list.listAppend(GPItemMake($item[Mick's IcyVapoHotness Inhaler], "10 turns of +200% meat|Worth anywhere from 1-3 turns on the nuns war sidequest"));
    }
        
    // One copy is kind of marginal but it's fine to include right at the end.
	if ($familiar[Intergnat].familiar_is_usable() && $item[infinite BACON machine].item_is_usable())
    {
        pullable_item_list.listAppend(GPItemMake($item[infinite BACON machine], "One copy/day with ~seven turns of your intergnat.", 1));
    }

    // Speaking of one copy, fine, we'll suggest a 4-d camera
    if (combat_items_usable) {
        pullable_item_list.listAppend(GPItemMake($item[4-d camera], "Use in a fight to copy a monster", 1));
    }

    // =====================================================================
    // ------ SECTION #3: QUEST MISSES -------------------------------------
    // =====================================================================
    
    // Most pulls in here can be (relatively) painlessly routed into your 
    //   run. However, if you don't have them, they're good pulls, just not
    //   universally valuable like the 1/2 tier pulls. A few of these end
    //   up being better than pulls above if you miss them, too.
    
    // I have not included the following 3 pulls because although they sort
    //   of belong, the logic is complex enough that I didn't want to hassle

    //   - QUEST MISS: tangle of rat tails
    //   - QUEST MISS: sonar-in-a-biscuit
    //   - QUEST MISS: disposable instant camera
    
    if (__quest_state["Level 10"].mafia_internal_step >= 8)
    {
    	if (__quest_state["Level 10"].mafia_internal_step == 8 && $item[amulet of extreme plot significance].available_amount() == 0)
        {
        	pullable_item_list.listAppend(GPItemMake($item[amulet of extreme plot significance], "Speeds up castle basement.", 1));
        }
        if (!__quest_state["Level 10"].finished && $item[mohawk wig].available_amount() == 0 && (!lookupSkill("Comprehensive Cartography").skill_is_usable() || $item[model airship].available_amount() == 0))
        {
            pullable_item_list.listAppend(GPItemMake($item[mohawk wig], "Speeds up top floor of castle.", 1));
        }
    }
    
	if (!__quest_state["Level 9"].state_boolean["bridge complete"])
	{
		int boxes_needed = MIN(__quest_state["Level 9"].state_int["bridge fasteners needed"], __quest_state["Level 9"].state_int["bridge lumber needed"]) / 5;
		
		boxes_needed = MIN(6, boxes_needed); //bridge! farming?

        if (__iotms_usable[lookupItem("model train set")]) boxes_needed = 0; // you REALLY do not need to pull this if you have a train lol
		
		if (boxes_needed > 0 && $item[smut orc keepsake box].item_is_usable())
			pullable_item_list.listAppend(GPItemMake($item[smut orc keepsake box], "Skip a few turns in building your smut orc bridge.", boxes_needed));
	}

    if (__quest_state["Level 9"].state_int["peak tests remaining"] > 0)
    {
        int trimmers_needed = clampi(__quest_state["Level 9"].state_int["peak tests remaining"], 0, 4);
        if (trimmers_needed > 0)
			pullable_item_list.listAppend(GPItemMake($item[rusty hedge trimmers], "Speed up twin peak, burn delay.|Saves ~2 turns each", trimmers_needed));
    }

    if (__quest_state["Level 11"].mafia_internal_step < 2)
        pullable_item_list.listAppend(GPItemMake($item[blackberry galoshes], "Speed up Black Forest by 2-3 turns", 1));
        
    //OUTFITS: √War outfit
    if (!__quest_state["Level 12"].finished && (!have_outfit_components("War Hippy Fatigues") && !have_outfit_components("Frat Warrior Fatigues")))
    {
        item [int] missing_hippy_components = missing_outfit_components("War Hippy Fatigues");
        item [int] missing_frat_components = missing_outfit_components("Frat Warrior Fatigues");
        pullable_item_list.listAppend(GPItemMake("Island War Outfit", "__item round purple sunglasses", "<strong>Hippy</strong>: " + missing_hippy_components.listJoinComponents(", ", "and") + ".|<strong>Frat boy</strong>: " + missing_frat_components.listJoinComponents(", ", "and") + "."));
    }

    // These are technically 1 turn if you're using clovers, less if you use other resource uses.    	        
    if (!__quest_state["Level 8"].state_boolean["Past mine"] && __quest_state["Level 8"].state_string["ore needed"] != "" && !$skill[unaccompanied miner].skill_is_usable())
    {
        item ore_needed = __quest_state["Level 8"].state_string["ore needed"].to_item();

        // Adding a trainset switch here, as you can just get this with trainset if you have it
        if (ore_needed != $item[none] && ore_needed.available_amount() < 3 && !__iotms_usable[lookupItem("model train set")])
        {
            pullable_item_list.listAppend(GPItemMake(ore_needed, "Level 8 quest.", 3));
        }
    }

    if (!have_outfit_components("Knob Goblin Elite Guard Uniform") && !__quest_state["Level 5"].finished)
    {
        item [int] missing_outfit_components = missing_outfit_components("Knob Goblin Harem Girl Disguise");
        
        string entry = missing_outfit_components.listJoinComponents(", ", "and").capitaliseFirstLetter() + ".";
        entry += " Level 5 quest.";
        if (missing_outfit_components.count() > 0)
            pullable_item_list.listAppend(GPItemMake("Knob Goblin Harem Girl Disguise", "__item " + missing_outfit_components[0], entry));
    }

    
    if (!__quest_state["Level 11 Desert"].state_boolean["Desert Explored"] && __quest_state["Level 11 Desert"].state_int["Desert Exploration"] < 95)
    {
        if (!__quest_state["Level 11 Desert"].state_boolean["Wormridden"] && $item[drum machine].item_is_usable())
            pullable_item_list.listAppend(GPItemMake($item[drum machine], "30% desert exploration with pages.", 1));
        if (!__quest_state["Level 11 Desert"].state_boolean["Killing Jar Given"] && $location[the haunted bedroom].locationAvailable())
            pullable_item_list.listAppend(GPItemMake($item[killing jar], "15% desert exploration.", 1));
        if (!__quest_state["Level 11 Desert"].state_boolean["Black Paint Given"] && my_path().id == PATH_NUCLEAR_AUTUMN)
            pullable_item_list.listAppend(GPItemMake($item[can of black paint], "15% desert exploration.", 1));
        
        // Adding milestone, as it's valuable enough to warrant a mention.
        pullable_item_list.listAppend(GPItemMake($item[milestone], "5% desert exploration; can use as many as you get!", 10));
    }

    if (!__quest_state["Level 10"].state_boolean["beanstalk grown"] && $item[enchanted bean].available_amount() == 0) {
       pullable_item_list.listAppend(GPItemMake($item[enchanted bean], "Grow it in the Nearby Plains for the Level 10 quest", 1));
    }

    int hospital_progress = get_property_int("hiddenHospitalProgress");

    if (hospital_progress < 7) {
        item [int] missingSurgeonComponents;
        if (__misc_state["Torso aware"])  
            missingSurgeonComponents = items_missing($items[bloodied surgical dungarees,surgical mask,head mirror,half-size scalpel,surgical apron]);
        if (!__misc_state["Torso aware"])
            missingSurgeonComponents = items_missing($items[bloodied surgical dungarees,surgical mask,head mirror,half-size scalpel]);
        
        if (missingSurgeonComponents.count() > 0)
        {
            string description = "Still need: " + missingSurgeonComponents.listJoinComponents(", ", "and").capitaliseFirstLetter() + ".";
            pullable_item_list.listAppend(GPItemMake("Surgeon disguise for the Hidden Hospital", "__item " + missingSurgeonComponents[0], description));
        }

    }

    boolean hiddenTavernUnlocked = get_property_ascension("hiddenTavernUnlock");
    
    if ($item[book of matches].available_amount() == 0 && !hiddenTavernUnlocked) {
       pullable_item_list.listAppend(GPItemMake($item[book of matches], "Unlock Cursed Punch & Bowl of Scorpions for Hidden City turnsaving", 1));
    }

    // Can pull a bowling ball, I guess.
    int bowling_progress = get_property_int("hiddenBowlingAlleyProgress");
    int numberOfRollsLeft = 6 - bowling_progress;
    int bowlingBallsNeeded = numberOfRollsLeft - $item[bowling ball].available_amount_including_closet();
    int bowlingBallsInInventory = $item[bowling ball].available_amount();

    if (bowling_progress < 7 && bowlingBallsNeeded > 0) {
        pullable_item_list.listAppend(GPItemMake($item[bowling ball], "Could pull a bowling ball for the Hidden Bowling Alley", bowlingBallsNeeded));
    }

    if ($item[electric boning knife].available_amount() == 0 && __quest_state["Level 13"].state_boolean["wall of bones will need to be defeated"] && my_path().id != PATH_POCKET_FAMILIARS) {
        if (!$skill[garbage nova].skill_is_usable() && !in_bad_moon() && !__quest_state["Level 13"].state_boolean["past tower level 2"] && $location[the castle in the clouds in the sky (top floor)].locationAvailable()) {
            pullable_item_list.listAppend(GPItemMake("Can pull a clusterbomb to crumble the wall of bones", "__ item sleaze clusterbomb", "Unbelievably expensive pull that will save you a few turns if you cannot towerkill the wall of bones"));
        }
    }


    // =====================================================================
    // ------ SECTION #4: LEVELING -----------------------------------------
    // =====================================================================
    
    // Pulls in this category aren't really measured by turn-value; they're
    //   measured by how many stats they give the user. Ergo, in cases where
    //   it's possible, try to include the # of expected stats in the desc

    if (__misc_state["need to level"])
    {
        // Best stat pull is the glitch, so put it at the top. But only show it at a critical mass of implementations.
        int glitchMonsterStats = MAX(10, 5 * (1.0 + numeric_modifier(my_primestat().to_string() + " Experience Percent") / 100.0 ) * get_property_int("glitchItemImplementationCount") / 4);

        // Below this, you might as well just pull sprout or whatever.
        if (glitchMonsterStats > 400) {
            string glitchDesc = "Difficult free fight, but massive meat/stat gains!";

            // Display meat if it actually matters
            if (my_meat() < 7500) glitchDesc += "|Will gain "+get_property_int("glitchItemImplementationCount")*5+" meat from your glitch.";
            
            glitchDesc += "|Will gain "+glitchMonsterStats+" stats from your glitch.";

            if (__iotms_usable[$item[emotion chip]] && clampi(3 - get_property_int("_feelPrideUsed"), 0, 3) > 0) glitchDesc += "|Consider using Feel Pride to get 3x that total of stats.";

            pullable_item_list.listAppend(GPItemMake(lookupItem("[glitch season reward name]"), glitchDesc));
        }

        if (my_primestat() == $stat[muscle])
        {
            if ($item[fake washboard].item_is_usable())
                pullable_item_list.listAppend(GPItemMake($item[fake washboard], "+25% to mainstat gain, offhand."));
            if ($item[red LavaCo Lamp&trade;].item_is_usable())
                pullable_item_list.listAppend(GPItemMake($item[red LavaCo Lamp&trade;], "+5 adventures, 50 turns of +50% mainstat gain after rollover."));
        }
        else if (my_primestat() == $stat[mysticality])
        {
            if ($item[basaltamander buckler].item_is_usable())
                pullable_item_list.listAppend(GPItemMake($item[basaltamander buckler], "+25% to mainstat gain, offhand."));
            if ($item[blue LavaCo Lamp&trade;].item_is_usable())            
                pullable_item_list.listAppend(GPItemMake($item[blue LavaCo Lamp&trade;], "+5 adventures, 50 turns of +50% mainstat gain after rollover."));
            if (my_path().id == PATH_THE_SOURCE)
            {
                int amount = 3;
                if ($item[battle broom].available_amount() > 0)
                    amount = 2;
                pullable_item_list.listAppend(GPItemMake($item[wal-mart nametag], "+4 mainstat/fight", amount));
            }
        }
        else if (my_primestat() == $stat[moxie])
        {
            if ($item[backwoods banjo].item_is_usable())
                pullable_item_list.listAppend(GPItemMake($item[backwoods banjo], "+20% to mainstat gain, 2h weapon."));
            if ($item[green LavaCo Lamp&trade;].item_is_usable())
                pullable_item_list.listAppend(GPItemMake($item[green LavaCo Lamp&trade;], "+5 adventures, 50 turns of +50% mainstat gain after rollover."));
            if (my_path().id == PATH_THE_SOURCE)
                pullable_item_list.listAppend(GPItemMake($item[wal-mart overalls], "+4 mainstat/fight"));
        }

        // If the user can use a red rocket, and user doesn't have a cleaver, suggest pulling a guilty sprout
        if (__misc_state["in run"] && __misc_state["can eat just about anything"] && available_amount($item[Clan VIP Lounge key]) > 0 && get_property("_fireworksShop").to_boolean() && my_path().id != PATH_G_LOVER) {
            if (!__iotms_usable[$item[June Cleaver]]) {
                int sproutStats = MAX(0, 4 * 225 * (1.0 + numeric_modifier(my_primestat().to_string() + " Experience Percent") / 100.0)); 
                pullable_item_list.listAppend(GPItemMake($item[guilty sprout],"Food; gain "+sproutStats+" stats with a red-rocketed sprout!"));
            }
        }

        // Vamp stats are pretty stupid but they're plausible I guess.
        int vampingStats = MIN(500, 4 * my_basestat(my_primestat())) * (1.0 + numeric_modifier(my_primestat().to_string() + " Experience Percent") / 100.0);
        pullable_item_list.listAppend(GPItemMake($item[plastic vampire fangs], "Gain"+vampingStats+" mainstat, once/day; costs a turn!", 1));
    }

    
    // =====================================================================
    // ------ SECTION #5: PATH-SPECIFIC ------------------------------------
    // =====================================================================
    
    // Pulls in this category are path-specific pulls that are useful in a 
    //   particular challenge path context and not particularly useful in
    //   other situations. 

    if (my_path() == $path[A Shrunken Adventurer am I])
        pullable_item_list.listAppend(GPItemMake("Flat +100 stat potion", "__item bottle of pirate juice", "The tower stat test is really, really tough in this path!|Once at the tower, pull a bottle of pirate juice for moxie, teeny-tiny magic scroll for myst, or a bottle of rhinoceros hormones for muscle."));

    if (my_path().id == PATH_COMMUNITY_SERVICE)
    	pullable_item_list.listAppend(GPItemMake($item[pocket wish], "Saves turns on everything in Community Service.", 20));
    
    if (my_path().id == PATH_HEAVY_RAINS)
        pullable_item_list.listAppend(GPItemMake($item[fishbone catcher's mitt], "offhand, less items washing away", 1));

    // =====================================================================
    // ------ SECTION #6: TURNBLOAT ----------------------------------------
    // =====================================================================
    
    // Pulls in this category are only really worth it if they help you make
    //   daycount. You probably ignore it in most unrestricted contexts, but 
    //   instead of flat ignoring it I think you just throw these at the
    //   absolute bottom of the list.
    
    // Turnbloat does not work in slow and steady, unless you are sweaty bill
    if (my_path().id != PATH_SLOW_AND_STEADY)
    {
        // PANTSGIVING: banishes aren't really turnsaving anymore, you'd only pull it for unrestricted bloat.
        pullable_item_list.listAppend(GPItemMake($item[pantsgiving], "5x non-free banishes|+2 stats/fight|+15% items|2 extra fullness (realistically)", 1));
        
        // General food/drink constructors
        if (__misc_state["can eat just about anything"] && availableFullness() > 0)
        {
            string [int] food_selections;
            
            if (availableFullness() >= 5 && my_path() != $path[A Shrunken Adventurer am I])
            {
                if (my_level() >= 13 && my_path().id != PATH_G_LOVER)
                    food_selections.listAppend("hi meins");
                else if ($item[moon pie].is_unrestricted() && $item[moon pie].item_is_usable())
                    food_selections.listAppend("moon pies");
                if ($item[fleetwood mac 'n' cheese].item_is_usable())
                    food_selections.listAppend("fleetwood mac 'n' cheese" + (my_level() < 8 ? " (level 8)" : ""));
                if ($item[karma shawarma].is_unrestricted() && $item[karma shawarma].item_is_usable())
                    food_selections.listAppend("karma shawarma? (expensive" + (my_level() < 7 ? ", level 7" : "") + ")");
            }
            
            // adding the legendary cookbookbat foods; technically, if they have a bander, DDoL is
            //   also 3 turnsave via freeruns, but that's kind of annoying logic...
            if ($item[Deep Dish of Legend].item_is_usable() && storage_amount($item[Deep Dish of Legend]) > 0)
                food_selections.listAppend("Deep Dish of Legend" + (my_level() < 5 ? " (level 5)" : ""));
            if ($item[Calzone of Legend].item_is_usable() && storage_amount($item[Calzone of Legend]) > 0)
                food_selections.listAppend("Calzone of Legend" + (my_level() < 5 ? " (level 5)" : ""));
            if ($item[Pizza of Legend].item_is_usable() && storage_amount($item[Pizza of Legend]) > 0)
                food_selections.listAppend("Pizza of Legend" + (my_level() < 5 ? " (level 5)" : ""));
            
            string description;
            if (food_selections.count() > 0)
                description = food_selections.listJoinComponents(", ") + ", etc.";
            pullable_item_list.listAppend(GPItemMake("Food", "Deep Dish of Legend", description));
        }
        if (__misc_state["can drink just about anything"] && availableDrunkenness() >= 0 && inebriety_limit() >= 5)
        {
            string [int] drink_selections;
            if ($item[wrecked generator].is_unrestricted() && $item[wrecked generator].item_is_usable())
                drink_selections.listAppend("wrecked generators");
            if ($item[Ice Island Long Tea].is_unrestricted() && $item[Ice Island Long Tea].item_is_usable())
                drink_selections.listAppend("Ice Island Long Tea");
            if ($item[Boris's beer].is_unrestricted() && $item[Boris's beer].item_is_usable())
                drink_selections.listAppend("Boris's beer");
            if ($item[vintage smart drink].is_unrestricted() && $item[vintage smart drink].item_is_usable())
                drink_selections.listAppend("vintage smart drink");
            
            string description;
            if (drink_selections.count() > 0)
                description = drink_selections.listJoinComponents(", ") + ", etc.";
            
            pullable_item_list.listAppend(GPItemMake("Drink", "gibson", description));
        }

        if ($skill[ancestral recall].have_skill() && my_adventures() < 10)
        {
            int casts = get_property_int("_ancestralRecallCasts");
            if (casts < 10)
                pullable_item_list.listAppend(GPItemMake($item[blue mana], "+3 adventures each.", clampi(10 - casts, 0, 10)));
        }
    
    	//unify these... later...
        foreach it in $items[License to Chill,etched hourglass]
            pullable_item_list.listAppend(GPItemMake(it, "slotless turn generation", 1));

        boolean canEquipThumbRing = my_basestat($stat[muscle]) > 39;
        pullable_item_list.listAppend(GPItemMake($item[mafia thumb ring], "turn generation accessory"+(canEquipThumbRing ? "" : " (need 40 muscle to equip!)"), 1));
    }
    
    // =====================================================================
    // ------ SECTION #7: MARGINAL GRAVEYARD -------------------------------
    // =====================================================================
    
    // Pulls in this category are pretty bad. Most of them are leftover from 
    //   old metas where the were mildly useful. Commenting them out... for
    //   now, mostly because there's possibly some future use case I'm not 
    //   seeing and it's largely good stuff to at least remember that we 
    //   once considered a good pull.
 
    // ... however, pre-commenting-out, I will include one meat-generating 
    //   item at the end of the recommendations. It doesn't save turns, 
    //   really, but it's certainly comfortable!

    if (my_meat() < 5000) 
    {
        item meatyItem = $item[gold wedding ring];
        if (storage_amount($item[facsimile dictionary]) > 0) meatyItem = $item[facsimile dictionary];
        pullable_item_list.listAppend(GPItemMake(meatyItem, "Autosells for "+autosell_price(meatyItem)+" meat.|Likely non-optimal.", 1));
    }
    
    // At best, folder holder represents a minor leveling boost and +/- combat. Better than red shoe, but not dramatically...
    // if (true)
    // {
    //     string line = "So many things!";
    //     if ($item[over-the-shoulder folder holder].storage_amount() > 0 && $item[over-the-shoulder folder holder].item_is_usable())
    //     {
    //         string [int] description;
    //         string [item] folder_descriptions;
            
    //         folder_descriptions[$item[folder (red)]] = "+20 muscle";
    //         folder_descriptions[$item[folder (blue)]] = "+20 myst";
    //         folder_descriptions[$item[folder (green)]] = "+20 moxie";
    //         folder_descriptions[$item[folder (magenta)]] = "+15 muscle +15 myst";
    //         folder_descriptions[$item[folder (cyan)]] = "+15 myst +15 moxie";
    //         folder_descriptions[$item[folder (yellow)]] = "+15 muscle +15 moxie";
    //         folder_descriptions[$item[folder (smiley face)]] = "+2 muscle stat/fight";
    //         folder_descriptions[$item[folder (wizard)]] = "+2 myst stat/fight";
    //         folder_descriptions[$item[folder (space skeleton)]] = "+2 moxie stat/fight";
    //         folder_descriptions[$item[folder (D-Team)]] = "+1 stat/fight";
    //         folder_descriptions[$item[folder (Ex-Files)]] = "+5% combat";
    //         folder_descriptions[$item[folder (skull and crossbones)]] = "-5% combat";
    //         folder_descriptions[$item[folder (Knight Writer)]] = "+40% init";
    //         folder_descriptions[$item[folder (Jackass Plumber)]] = "+25 ML";
    //         folder_descriptions[$item[folder (holographic fractal)]] = "+4 all res";
    //         folder_descriptions[$item[folder (barbarian)]] = "stinging damage";
    //         folder_descriptions[$item[folder (rainbow unicorn)]] = "prismatic stinging damage";
    //         folder_descriptions[$item[folder (Seawolf)]] = "-pressure penalty";
    //         folder_descriptions[$item[folder (dancing dolphins)]] = "+50% item (underwater)";
    //         folder_descriptions[$item[folder (catfish)]] = "+15 familiar weight (underwater)";
    //         folder_descriptions[$item[folder (tranquil landscape)]] = "15 DR / 15 HP & MP regen";
    //         folder_descriptions[$item[folder (owl)]] = "+500% item (dreadsylvania)";
    //         folder_descriptions[$item[folder (Stinky Trash Kid)]] = "passive stench damage";
    //         folder_descriptions[$item[folder (sports car)]] = "+5 adv";
    //         folder_descriptions[$item[folder (sportsballs)]] = "+5 PVP fights";
    //         folder_descriptions[$item[folder (heavy metal)]] = "+5 familiar weight";
    //         folder_descriptions[$item[folder (Yedi)]] = "+50% spell damage";
    //         folder_descriptions[$item[folder (KOLHS)]] = "+50% item (KOLHS)";
            
    //         foreach s in $slots[folder1,folder2,folder3]
    //         {
    //             item folder = s.equipped_item();
    //             if (folder == $item[none]) continue;
                
    //             if (folder_descriptions contains folder)
    //                 description.listAppend(folder_descriptions[folder]);
    //         }
    //         if (description.count() > 0)
    //             line = description.listJoinComponents(" / ");
    //     }
    //     pullable_item_list.listAppend(GPItemMake($item[over-the-shoulder folder holder], line, 1));
    // }
    
    // As with folder holder, this just isn't really a great pull anymore. Minor back slot is just not useful at all.

    // if (!__misc_state["familiars temporarily blocked"] && ($item[protonic accelerator pack].available_amount() == 0 || $familiar[machine elf].familiar_is_usable())) //if you have a machine elf, it might be worth pulling a bjorn with a protonic pack anyways
    // {
    //     if ($item[Buddy Bjorn].storage_amount() > 0)
    //         pullable_item_list.listAppend(GPItemMake($item[Buddy Bjorn], "+10ML/+lots MP hat|or +item/+init/+meat/etc", 1));
    //     else if ($item[buddy bjorn].available_amount() == 0)
    //         pullable_item_list.listAppend(GPItemMake($item[crown of thrones], "+10ML/+lots MP hat|or +item/+init/+meat/etc", 1));
    // }

    // At best, this is +5 fam weight; not worth a pull at all.
	// if ($item[operation patriot shield].item_is_usable())
    //         pullable_item_list.listAppend(GPItemMake($item[operation patriot shield], "+america", 1));
    //     pullable_item_list.listAppend(GPItemMake($item[the crown of ed the undying], "Various in-run modifiers. (init, HP, ML/item/meat/etc)", 1));
    // }

	//pullable_item_list.listAppend(GPItemMake($item[haiku katana], "?", 1));
	// if ($item[bottle-rocket crossbow].item_is_usable())
    //     pullable_item_list.listAppend(GPItemMake($item[bottle-rocket crossbow], "?", 1));

    // This never showed up because it had an added false in the condition. I am commenting it out
    //   because I don't think anyone in unrestricted would ever want to do this?
	
    // boolean have_super_fairy = false;
    // // Pretty sure I deleted the places that use this, but in case I didn't...
	// if ((familiar_is_usable($familiar[fancypants scarecrow]) && $item[spangly mariachi pants].available_amount() > 0) || (familiar_is_usable($familiar[mad hatrack]) && $item[spangly sombrero].available_amount() > 0))
	// 	have_super_fairy = true;

    // if (!have_super_fairy && my_path().id != PATH_HEAVY_RAINS)
	// {
	// 	if (familiar_is_usable($familiar[fancypants scarecrow]))
	// 		pullable_item_list.listAppend(GPItemMake($item[spangly mariachi pants], "2x fairy on fancypants scarecrow", 1));
	// 	else if (familiar_is_usable($familiar[mad hatrack]))
	// 		pullable_item_list.listAppend(GPItemMake($item[spangly sombrero], "2x fairy on mad hatrack", 1));
	// }

    // These all suck now lol
	//pullable_item_list.listAppend(GPItemMake($item[jewel-eyed wizard hat], "a wizard is you!", 1));
	//pullable_item_list.listAppend(GPItemMake($item[origami riding crop], "+5 stats/fight, but only if the monster dies quickly", 1)); //not useful?
	//pullable_item_list.listAppend(GPItemMake($item[plastic pumpkin bucket], "don't know", 1)); //not useful?
	//pullable_item_list.listAppend(GPItemMake($item[packet of mayfly bait], "why let it go to waste?", 1));

    // Not good enough to use. The untinkering is cute, might unlock an extra battery YR, but not pull-worthy.
	// pullable_item_list.listAppend(GPItemMake($item[loathing legion knife], "?", 1));

    // No idea why you would want this, honestly.
	// if ($item[juju mojo mask].item_is_usable())
    //     pullable_item_list.listAppend(GPItemMake($item[juju mojo mask], "?", 1));
    
    // Technically this is best in slot at certain times of the month but I don't care enough to include it anymore.
	// if ($item[jekyllin hide belt].item_is_usable())
    //     pullable_item_list.listAppend(GPItemMake($item[jekyllin hide belt], "+variable% item", 3));
    
    // There's probably a (very small) case for still including as BIS +ML, but it's barely better than carn plant.
    // if (__misc_state["need to level"])
    // {
    //     pullable_item_list.listAppend(GPItemMake($item[hockey stick of furious angry rage], "+30ML accessory.", 1));
    // }

    // Not useful enough unfortunately.
    // pullable_item_list.listAppend(GPItemMake($item[ice sickle], "+15ML 1h weapon|+item/+meat/+init foldables", 1));
    
    // No world where you're wasting a pull on +15% item drop on purpose.
    // if ($item[buddy bjorn].available_amount() == 0 && $item[camp scout backpack].item_is_usable())
    //     pullable_item_list.listAppend(GPItemMake($item[camp scout backpack], "+15% items on back", 1));

    // Only really useful in their own paths.
    // if ($item[boris's helm].item_is_usable()) pullable_item_list.listAppend(GPItemMake($item[boris's helm], "+15ML/+5 familiar weight/+init/+mp regeneration/+weapon damage", 1));
    // pullable_item_list.listAppend(GPItemMake($item[Jarlsberg's Pan], "Cook up some cool Jarlsberg potions!", 1));

    // None of these shirts are particularly cool or good. 
    // if (__misc_state["Torso aware"])
    // {
    //     pullable_item_list.listAppend(GPItemMake($item[flaming pink shirt], "+15% items on shirt. (marginal)" + (__misc_state["familiars temporarily blocked"] ? "" : "|Or extra experience on familiar. (very marginal)"), 1));
    //     if (__misc_state["need to level"] && $item[Sneaky Pete's leather jacket (collar popped)].available_amount() == 0 && $item[Sneaky Pete's leather jacket].available_amount() == 0)
    //     {
            
    //         if ($item[Sneaky Pete's leather jacket (collar popped)].storage_amount() + $item[Sneaky Pete's leather jacket].storage_amount() > 0 && $item[Sneaky Pete's leather jacket].item_is_usable())
    //         {
    //             if (my_path().id != PATH_AVATAR_OF_SNEAKY_PETE)
    //                 pullable_item_list.listAppend(GPItemMake($item[Sneaky Pete's leather jacket], "+30ML/+meat/+adv/+init/+moxie shirt", 1));
    //         }
    //         else
	//             if ($item[cane-mail shirt].item_is_usable())
    //                 pullable_item_list.listAppend(GPItemMake($item[cane-mail shirt], "+20ML shirt", 1));
    //     }
    // }
    
    // Only useful in Grey Goo. Not worth a pull.
    // if (__misc_state["spooky airport available"] && __misc_state["need to level"] && __misc_state["can drink just about anything"] && $effect[jungle juiced].have_effect() == 0)
    // {
    //     pullable_item_list.listAppend(GPItemMake($item[jungle juice], "Drink that doubles stat-gain in the deep dark jungle.", 1));
    // }
    
    // lol absolutely not
    //pullable_item_list.listAppend(GPItemMake($item[slimy alveolus], "40 turns of +50ML (" + floor(40 * 50 * __misc_state_float["ML to mainstat multiplier"]) +" mainstat total, cave bar levelling)|1 spleen", 3)); //marginal now. low-skill oil peak/cyrpt?
    
    //FIXME suggest machetito?
    //FIXME suggest super marginal stuff in SCO or S&S
    //Ideas: Goat cheese, keepsake box, √spooky-gro fertilizer, harem outfit, perfume, rusty hedge trimmers, bowling ball, surgeon gear, tomb ratchets or tangles, all the other pies
    //FIXME suggest ore when we don't have access to free mining
	
    //FIXME add hat/stuffing fluffer/blank-out
    
    // Ezan had some cruft here for pulling XP% things for chateau rest improved stats. I removed it because it 
    //   didn't even show and isn't relevant to unrestricted anymore, high or low end. Sorry Ezan.

    // It's cute, but not really useful
    // if ($item[Mr. Cheeng's spectacles] != $item[none])
    //     pullable_item_list.listAppend(GPItemMake($item[Mr. Cheeng's spectacles], "+15% item, +30% spell damage, acquire random potions in-combat.|Not particularly optimal, but fun.")); 

    // ========================================================================================================
    // ------ OK COOL ALL THE PULLS ARE DEALT WITH, NOW LET'S CONCAT THE PULL LIST LADS -----------------------
    // ========================================================================================================
	
	boolean currently_trendy = (my_path().id == PATH_TRENDY);
	foreach key in pullable_item_list
	{
		GPItem gp_item = pullable_item_list[key];
		string reason = gp_item.reason;
		string [int] reason_list = split_string_alternate(reason, "\\|");
		
		if (gp_item.alternate_name != "")
		{
			pulls_entries.listAppend(ChecklistEntryMake(gp_item.alternate_image_name, "storage.php", ChecklistSubentryMake(gp_item.alternate_name, "", reason_list)).ChecklistEntrySetIDTag("Pull suggestions " + gp_item.alternate_name));
			continue;
		}
		
		
		item [int] items;
		int [item] related_items = get_related(gp_item.it, "fold");
		if (related_items.count() == 0)
			items.listAppend(gp_item.it);
		else
		{
			foreach it in related_items
				items.listAppend(it);
		}
		
		
		int max_wanted = gp_item.max_wanted;
		
        int found_total;
        foreach key, it in items
        {
            found_total += it.available_amount();
        }
        if (found_total >= max_wanted)
            continue;
        if (my_path().id == PATH_GELATINOUS_NOOB)
        {
            boolean allowed = false;
            boolean [item] whitelist = $items[gravy boat,blackberry galoshes,machetito,muculent machete,antique machete,Mr. Cheeng's spectacles,buddy bjorn,crown of thrones,navel ring of navel gazing,greatest american pants,plastic vampire fangs,the jokester's gun];
            foreach key, it in items
            {
                if ($slots[hat,weapon,off-hand,back,shirt,pants,acc1,acc2,acc3] contains it.to_slot() && !(whitelist contains it) && !it.discardable && !__items_in_outfits[it])
                {
                }
                else
                    allowed = true;
            }
            if (!allowed)
            {
                //print_html("Rejecting " + items[0]);
                continue;
            }
        }
		
		foreach key in items
		{
			item it = items[key];
			if (currently_trendy && !is_trendy(it))
				continue;
            if (!is_unrestricted(it))
                continue;
			int actual_amount = pullable_amount(it, max_wanted);
			if (actual_amount > 0)
			{
                string url = "storage.php";
                if (it != $item[none])
                {
                    if (it.fullness > 0 || it.inebriety > 0)
                        url = "storage.php?which=1";
                    if (it.to_slot() != $slot[none])
                        url = "storage.php?which=2";
                }
                
                if (it.storage_amount() == 0 && (__pulls_reasonable_to_buy_in_run contains it) && it != $item[11-leaf clover] && it != $item[none])
                    url = "mall.php";
                
                string title = pluralise(actual_amount, it);
				if (max_wanted == 1)
					title = it;
                
                pulls_entries.listAppend(ChecklistEntryMake(it, url, ChecklistSubentryMake(title, "", reason_list)).ChecklistEntrySetIDTag("Pull suggestions " + it.name));
				break;
			}
		}
	}
	
	checklists.listAppend(ChecklistMake("Suggested Pulls", pulls_entries));
}

void PullsInit()
{
    //Pulls which are reasonable to buy in the mall, then pull:
	__pulls_reasonable_to_buy_in_run = $items[peppermint parasol,slimy alveolus,bottle of blank-out,11-leaf clover,ninja rope,ninja crampons,ninja carabiner,clockwork maid,sonar-in-a-biscuit,knob goblin perfume,chrome ore,linoleum ore,asbestos ore,goat cheese,enchanted bean,dusty bottle of Marsala,dusty bottle of Merlot,dusty bottle of Muscat,dusty bottle of Pinot Noir,dusty bottle of Port,dusty bottle of Zinfandel,ketchup hound,lion oil,bird rib,stunt nuts,drum machine,beer helmet,distressed denim pants,bejeweled pledge pin,reinforced beaded headband,bullet-proof corduroys,round purple sunglasses,wand of nagamar,ng,star crossbow,star hat,star staff,star sword,Star key lime pie,Boris's key lime pie,Jarlsberg's key lime pie,Sneaky Pete's key lime pie,tomb ratchet,tangle of rat tails,swashbuckling pants,stuffed shoulder parrot,eyepatch,Knob Goblin harem veil,knob goblin harem pants,knob goblin elite polearm,knob goblin elite pants,knob goblin elite helm,cyclops eyedrops,mick's icyvapohotness inhaler,large box,marzipan skull,jaba&ntilde;ero-flavored chewing gum,handsomeness potion,Meleegra&trade; pills,pickle-flavored chewing gum,lime-and-chile-flavored chewing gum,gremlin juice,wussiness potion,Mick's IcyVapoHotness Rub,super-spiky hair gel,adder bladder,black no. 2,skeleton,rock and roll legend,wet stew,glass of goat's milk,hot wing,frilly skirt,pygmy pygment,wussiness potion,gremlin juice,adder bladder,Angry Farmer candy,thin black candle,super-spiky hair gel,Black No. 2,Mick's IcyVapoHotness Rub,Frigid ninja stars,Spider web,Sonar-in-a-biscuit,Black pepper,Pygmy blowgun,Meat vortex,Chaos butterfly,Photoprotoneutron torpedo,Fancy bath salts,inkwell,Hair spray,disease,bronzed locust,Knob Goblin firecracker,powdered organs,leftovers of indeterminate origin,mariachi G-string,NG,plot hole,baseball,razor-sharp can lid,tropical orchid,stick of dynamite,barbed-wire fence,smut orc keepsake box,spooky-gro fertilizer,machetito,muculent machete,antique machete,rusty hedge trimmers,Ice Island Long Tea,killing jar,can of black paint,gravy boat,ring of conflict,bram's choker,duonoculars];
}
