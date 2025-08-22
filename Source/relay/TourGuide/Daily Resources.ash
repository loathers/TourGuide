import "relay/TourGuide/QuestState.ash"
import "relay/TourGuide/Support/Checklist.ash"
import "relay/TourGuide/Support/LocationAvailable.ash"
import "relay/TourGuide/Sets/Sets import.ash"



string [int] generateHotDogLine(string hotdog, string description, int fullness)
{
    description += " " + fullness + " full.";
    if (availableFullness() < fullness) {
        hotdog = HTMLGenerateSpanOfClass(hotdog , "r_future_option");
        description = HTMLGenerateSpanOfClass(description , "r_future_option");
    }
    return listMake(hotdog, description);
}


void generateDailyResources(Checklist [int] checklists)
{
    ChecklistEntry [int] resource_entries;
        
    SetsGenerateResources(resource_entries);
    QuestsGenerateResources(resource_entries);
    
    if (!get_property_boolean("_fancyHotDogEaten") && availableFullness() > 0 && __misc_state["VIP available"] && __misc_state["can eat just about anything"] && $item[Clan hot dog stand].is_unrestricted()) { //too expensive to use outside a run? well, more that it's information overload
        
        string name = "Fancy hot dog edible";
        string [int] description;
        string image_name = "basic hot dog";
        
        string [int][int] options;
        options.listAppend(generateHotDogLine("Optimal Dog", "Get Lucky!", 1));
        
        if (__misc_state["in run"]) {
            options.listAppend(generateHotDogLine("Ghost Dog", "-combat, 30 turns.", 3));
            options.listAppend(generateHotDogLine("Video Game Hot Dog", "+25% item, +25% meat, pixels, 50 turns.", 3));
            options.listAppend(generateHotDogLine("Junkyard dog", "+combat, 30 turns.", 3));
            if (!__quest_state["Level 8"].finished || __quest_state["Level 9"].state_int["a-boo peak hauntedness"] > 0)
                options.listAppend(generateHotDogLine("Devil dog", "+3 cold/spooky res, 30 turns.", 3));
            if (!__quest_state["Level 9"].state_boolean["Peak Stench Completed"])
                options.listAppend(generateHotDogLine("Chilly dog", "+10ML and +3 stench/sleaze res, 30 turns.", 3));
            if (my_primestat() == $stat[muscle])
                options.listAppend(generateHotDogLine("Savage macho dog", "+50% muscle, 50 turns.", 2));
            if (my_primestat() == $stat[mysticality])
                options.listAppend(generateHotDogLine("One with everything", "+50% mysticality, 50 turns.", 2));
            if (my_primestat() == $stat[moxie])
                options.listAppend(generateHotDogLine("Sly Dog", "+50% moxie, 50 turns.", 2));
            if (!$skill[Dog Tired].have_skill())
                options.listAppend(generateHotDogLine("Sleeping dog", "5 free rests/day (stats at chateau or cinch rests)", 2));
        }
            
        description.listAppend(HTMLGenerateSimpleTableLines(options));
        resource_entries.listAppend(ChecklistEntryMake(image_name, "clan_viplounge.php?action=hotdogstand", ChecklistSubentryMake(name, "", description), 5).ChecklistEntrySetIDTag("VIP hot dog stand"));
    }
    
        
    if (!get_property_boolean("_olympicSwimmingPoolItemFound") && __misc_state["VIP available"] && $item[Olympic-sized Clan crate].is_unrestricted())
        resource_entries.listAppend(ChecklistEntryMake("__item inflatable duck", "", ChecklistSubentryMake("Dive for swimming pool item", "", "\"swim item\" in GCLI"), 5).ChecklistEntrySetIDTag("VIP swimming pool item"));
    
    if (!get_property_boolean("_olympicSwimmingPool") && __misc_state["VIP available"] && $item[Olympic-sized Clan crate].is_unrestricted())
        resource_entries.listAppend(ChecklistEntryMake("__item inflatable duck", "clan_viplounge.php?action=swimmingpool", ChecklistSubentryMake("Swim in VIP pool", "50 turns", listMake("+20 ML, +30% init", "Or -combat")), 5).ChecklistEntrySetIDTag("VIP swimming pool buff"));
    
    if (!get_property_boolean("_aprilShower") && __misc_state["VIP available"] && $item[Clan shower].is_unrestricted()) {
        string [int] description;
        if (__misc_state["need to level"])
            description.listAppend("+mainstat gains. (50 turns)");
        
        string [int] reasons;
        if ($item[double-ice cap].available_amount() == 0)
            reasons.listAppend("nice hat");
        if ($familiar[fancypants scarecrow].familiar_is_usable() && $item[double-ice britches].available_amount() == 0)
            reasons.listAppend("scarecrow pants");
        //if (!__quest_state["Level 13"].state_boolean["past tower monsters"]) //don't think this is true
            //reasons.listAppend("situational tower killing");
        
        if (reasons.count() > 0)
            description.listAppend("Double-ice. (" + reasons.listJoinComponents(", ", "and") + ")");
        else
            description.listAppend("Double-ice.");
        
        resource_entries.listAppend(ChecklistEntryMake("__item shard of double-ice", "clan_viplounge.php?action=shower", ChecklistSubentryMake("Take a shower", description), 5).ChecklistEntrySetIDTag("VIP april shower"));
    }
    if (__misc_state["VIP available"] && get_property_int("_poolGames") <3 && $item[Clan pool table].is_unrestricted()) {
        int games_available = 3 - get_property_int("_poolGames");
        string [int] description;
        if (__misc_state["familiars temporarily blocked"])
            description.listAppend("+50% weapon damage. (aggressively)");
        else
            description.listAppend("+5 familiar weight, +50% weapon damage. (aggressively)");
        description.listAppend("Or +50% spell damage, +10 MP regeneration. (strategically)");
        description.listAppend("Or +10% item, +50% init. (stylishly)");
        resource_entries.listAppend(ChecklistEntryMake("__item pool cue", "clan_viplounge.php?action=pooltable", ChecklistSubentryMake(pluralise(games_available, "pool table game", "pool table games"), "10 turns", description), 5).ChecklistEntrySetIDTag("VIP table pool resource"));
    }
    if (__quest_state["Level 6"].finished && !get_property_boolean("friarsBlessingReceived") && my_path().id != PATH_SEA && my_path().id != PATH_COMMUNITY_SERVICE && !__misc_state["in CS aftercore"]) {
        string [int] description;
        if (!__misc_state["familiars temporarily blocked"]) {
            description.listAppend("+Familiar experience.");
            description.listAppend("Or +30% food drop.");
        }
        else
            description.listAppend("+30% food drop.");
        description.listAppend("Or +30% booze drop.");
        boolean should_output = true;
        if (!__misc_state["in run"]) {
            should_output = false;
        }
        if (!should_output && familiar_weight(my_familiar()) < 20 && my_familiar() != $familiar[none]) {
            description.listClear();
            description.listAppend("+Familiar experience.");
            should_output = true;
        }
        if (should_output)
            resource_entries.listAppend(ChecklistEntryMake("Monk", "friars.php", ChecklistSubentryMake("Forest Friars buff", "20 turns", description), 10).ChecklistEntrySetIDTag("Friars blessing resource"));
    }
    
    if (!get_property_boolean("_madTeaParty") && __misc_state["VIP available"] && $item[Clan looking glass].is_unrestricted() && $item[&quot;DRINK ME&quot; potion].item_is_usable()){
        string [int] description;
        string line = "Various effects.";
        if (__misc_state["in run"] && my_path().id != PATH_ZOMBIE_SLAYER && $item[pail].available_amount() > 0) {
            line = "+20ML";
            line += "|Or various effects.";
        }
        description.listAppend(line);
        resource_entries.listAppend(ChecklistEntryMake("__item insane tophat", "", ChecklistSubentryMake("Mad tea party", "30 turns", description), 5).ChecklistEntrySetIDTag("Rabbit hole tea party resource"));
    }
    
    if (true) {
        string image_name = "__item hell ramen";
        ChecklistSubentry [int] subentries;
        int importance = 11;
        if (availableFullness() > 0) {
            string [int] description;
            if ($effect[Got Milk].have_effect() > 0)
                description.listAppend(pluralise($effect[Got Milk]) + " available (woah).");
            if (!get_property_boolean("_milkOfMagnesiumUsed") && lookupItem("milk of magnesium").available_amount() > 0)
                description.listAppend("Use Milk of Magnesium for +5 adv.");
            if ($effect[barrel of laughs].have_effect() >= 5) {
                int turns = $effect[barrel of laughs].have_effect();
                description.listAppend(pluralise($effect[barrel of laughs]) + " available" + (turns % 5 > 0 ? " (" + (turns - turns % 5) + ")" : "") + ".");
            }
            subentries.listAppend(ChecklistSubentryMake(availableFullness() + " fullness", "", description));
        }
        if (inebriety_limit() > 0) {
            boolean stooper_is_equipped = my_familiar() == $familiar[Stooper];
            boolean could_equip_stooper = $familiar[Stooper].familiar_is_usable() && !stooper_is_equipped;
            string title = "";
            string [int] description;
            if (availableDrunkenness() >= 0) {
                boolean shotglass_drink_available = !get_property_boolean("_mimeArmyShotglassUsed") && lookupItem("mime army shotglass").is_unrestricted() && lookupItem("mime army shotglass").available_amount() > 0;
                if (subentries.count() == 0)
                    image_name = "__item gibson";
                if ($effect[ode to booze].have_effect() > 0)
                    description.listAppend(pluralise($effect[ode to booze]) + " available.");
                if ($effect[salty mouth].have_effect() > 0)
                    description.listAppend(pluralise($effect[salty mouth]) + " available. Drink beer for +5 adv!");
                if ($effect[beer barrel polka].have_effect() >= 5) {
                    int turns = $effect[beer barrel polka].have_effect();
                    description.listAppend(pluralise($effect[beer barrel polka]) + " available" + (turns % 5 > 0 ? " (" + (turns - turns % 5) + ")" : "") + ".");
                }
                
                if (availableDrunkenness() > 0)
                    title = availableDrunkenness() + " drunkenness" + (could_equip_stooper ? " + Stooper" : "");
                else {
                    title = "Can overdrink";
                    if (could_equip_stooper)
                        description.listAppend("Could equip Stooper for +1 drunkenness.");
                }
                if (shotglass_drink_available)
                    description.listAppend("1 free 1-drunkenness booze available.");
                subentries.listAppend(ChecklistSubentryMake(title, "", description));
            } else if (availableDrunkenness() == -1 && could_equip_stooper) {
                importance = -11;
                title = HTMLGenerateSpanFont("Equip the Stooper", "red");
                image_name = "__familiar stooper";
                description.listAppend("Can keep adventuring/overdrink further as long as it's equipped.");
                subentries.listAppend(ChecklistSubentryMake(title, "", description));
            }
        }
        if (availableSpleen() > 0) {
            if (subentries.count() == 0)
                image_name = "__item agua de vida";
            subentries.listAppend(ChecklistSubentryMake(availableSpleen() + " spleen", "", ""));
        }
        if (subentries.count() == 0) {
            image_name = "__skill stomach of steel";
            subentries.listAppend(ChecklistSubentryMake("No organ space available"));
        }
        
        int adventures_lost_due_to_cap = __misc_state_int["adventures lost to rollover"];
        int gain_from_rollover = __misc_state_int["adventures after rollover"] + adventures_lost_due_to_cap - my_adventures();
        
        string [int] rollover_description;
        rollover_description.listAppend("Will gain " + gain_from_rollover + " adventures if rollover happens now" + (adventures_lost_due_to_cap == 0 ? "" : ", wasting " + adventures_lost_due_to_cap) + ".");
        
        subentries[subentries.count() - 1].entries.listAppendList(rollover_description);
        
        resource_entries.listAppend(ChecklistEntryMake(image_name, "inventory.php?which=1", subentries, importance).ChecklistEntrySetIDTag("Organs consumption consumables"));
    }
    
    if (__quest_state["Level 13"].state_boolean["king waiting to be freed"]) {
        string [int] description;
        description.listAppend("Contains one (1) monarch.");
        description.listAppend(pluralise(my_ascensions(), "king", "kings") + " freed." + (my_ascensions() > 250 ? " Collect them all!" : ""));
        string image_name;
        image_name = "__effect sleepy";
        resource_entries.listAppend(ChecklistEntryMake(image_name, "place.php?whichplace=nstower", ChecklistSubentryMake("1 Prism", "", description), 10).ChecklistEntrySetIDTag("This is his home now"));
    }
    
    if ((get_property("sidequestOrchardCompleted") == "hippy" || get_property("sidequestOrchardCompleted") == "fratboy") && !get_property_boolean("_hippyMeatCollected") && my_path().id != PATH_WAY_OF_THE_SURPRISING_FIST) {
        resource_entries.listAppend(ChecklistEntryMake("__item herbs", "island.php", ChecklistSubentryMake("Meat from the hippy store", "", "~4500 free meat."), 8).ChecklistEntrySetIDTag("Island orchard meat cut")); //FIXME consider shop.php?whichshop=hippy
    }
    if ((get_property("sidequestArenaCompleted") == "hippy" || get_property("sidequestArenaCompleted") == "fratboy") && !get_property_boolean("concertVisited")) {
        string [int] description;
        if (get_property("sidequestArenaCompleted") == "hippy") {
            if (!__misc_state["familiars temporarily blocked"])
                description.listAppend("+5 familiar weight.");
            description.listAppend("Or +20% item.");
            if (__misc_state["need to level"])
                description.listAppend("Or +5 stats/fight.");
        } else if (get_property("sidequestArenaCompleted") == "fratboy") {
            description.listAppend("+40% meat.");
            description.listAppend("+50% init.");
            description.listAppend("+10% all attributes.");
        }
        
        string url = "bigisland.php?place=concert";
        if (__quest_state["Level 12"].finished)
            url = "postwarisland.php?place=concert";
        resource_entries.listAppend(ChecklistEntryMake("__item the legendary beat", url, ChecklistSubentryMake("Arena concert", "20 turns", description), 5).ChecklistEntrySetIDTag("Island arena daily buff"));
    }
    
    if (skill_is_usable($skill[Unaccompanied Miner])) {
        int free_digs_available = 5 - get_property_int("_unaccompaniedMinerUsed");
        if (free_digs_available > 0) {
            string [int] description;
            string url;

            if (__misc_state["hot airport available"]) {
                //volcano mining
                string [int] unmet_requirements;
                int heat_resistance = numeric_modifier("Hot Resistance");

                if (lookupItem("High-temperature mining drill").equipped_amount() == 0) {
                    if (lookupItem("High-temperature mining drill").available_amount() > 0) {
                        unmet_requirements.listAppend("to equip high-temperature mining drill");
                        if (url == "")  url = "inventory.php?ftext=high-temperature+mining+drill";
                    } else {
                        unmet_requirements.listAppend("to acquire a high-temperature mining drill");
                        if (url == "")  url = "inventory.php?ftext=broken+high-temperature+mining+drill"; // won't bother looking at if they have the broken drill, they can figure it out
                    }
                }

                if (heat_resistance < 15)
                    unmet_requirements.listAppend("15 hot resist (have " + heat_resistance + ")");
                
                if (url == "")  url = "mining.php?mine=6";

                description.listAppend("Can mine in the velvet/gold mine" + (unmet_requirements.count() > 0 ? " (Need " + listJoinComponents(unmet_requirements, ", ", "and") + ")" : "" ) + ".");
            }

            if (get_property_boolean("mapToAnemoneMinePurchased")) { //name is misleading; they are set to true even if this is the zone you automatically get access to based on your class
                if (lookupItem("Mer-kin digpick").equipped_amount() > 0) {
                    if (url == "")  url = "mining.php?mine=3";
                    description.listAppend("Anemone Mine (free even without fishy).");
                } else if (lookupItem("Mer-kin digpick").available_amount() > 0) {
                    description.listAppend("Equip a Mer-kin digpick to mine in Anemone Mine (won't need fishy).");
                    if (url == "")  url = "inventory.php?ftext=Mer-kin+digpick";
                } else {
                    description.listAppend("Buy and equip a Mer-kin digpick from the mall to mine in Anemone Mine.");
                    if (url == "")  url = "mall.php?justitems=0&pudnuggler=%22Mer-kin+digpick%22";
                }
            } else if (!get_property_boolean("bigBrotherRescued")) {
                if (!(__misc_state["in run"] && get_property("questS02Monkees") == "unstarted"))
                    description.listAppend("Could progress sea quest" + (my_primestat() != $stat[muscle] ? " (+ pay 50 sand dollars)" : "") + " to unlock Anemone Mine.");
            } else {
                if (my_primestat() == $stat[muscle]) {
                    description.listAppend("Talk to little brother to unlock Anemone Mine.");
                    if (url == "")  url = "seafloor.php";
                } else {
                    description.listAppend("Unlock Anemone Mine by buying the map from big brother (50 sand dollars, have " + $item[sand dollar].available_amount() + ").");
                    if (url == "")  url = "seafloor.php";
                }
            }


            string [int] available_basic_mines_message;
            string available_basic_mines_url;

            if (get_property("questL08Trapper") != "unstarted") { // is it the only way/a sure way to know?
                available_basic_mines_message.listAppend("Itznotyerzitz Mine");
                if (get_property("questL08Trapper") == "started") {
                    available_basic_mines_message.listAppend(" (Talk to Trapper first)");
                    if (url == "")  url = "place.php?whichplace=mclargehuge";
                }
                if (available_basic_mines_url == "")    available_basic_mines_url = "mining.php?mine=1";
            }
            if (lookupItem("Cobb's Knob lab key").available_amount() > 0) {
                available_basic_mines_message.listAppend("The Knob Shaft (last resort)");
                if (available_basic_mines_url == "")    available_basic_mines_url = "mining.php?mine=2";
            }

            if (available_basic_mines_message.count() > 0) { // Have access to either, or both
                string help_message;
                if (lookupEffect("Earthen Fist").have_effect() == 0 && !is_wearing_outfit("Mining Gear") && !is_wearing_outfit("Dwarvish War Uniform")) {
                    if (lookupSkill("Worldpunch").have_skill()) {
                        help_message += " (cast Worldpunch)"; // this is from an avatar path, so you'll never get both Unaccompanied miner AND worldpunch, right? Eh, whatever, you can still get the fist effect from hookah-like...
                        if (url == "")  url = "skillz.php";
                    } else if (can_equip_outfit("Mining Gear")) {
                        help_message += " (equip mining gear)";
                        if (url == "")  url = "inventory.php?which=2";
                    } else if (can_equip_outfit("Dwarvish War Uniform")) {
                        help_message += " (equip Dwarvish War Uniform)";
                        if (url == "")  url = "inventory.php?which=2";
                    } else
                        help_message += " (need proper equipment)";
                } else
                    if (url == "")  url = available_basic_mines_url;

                description.listAppend("Can mine in " + listJoinComponents(available_basic_mines_message, " ", "or") + "." + HTMLGenerateIndentedText(help_message));
            }


            resource_entries.listAppend(ChecklistEntryMake("__item 7-Foot Dwarven mattock", url, ChecklistSubentryMake( free_digs_available + " free minings", "", description), 5).ChecklistEntrySetIDTag("Unaccompanied miner resource"));
        }
    }

    //Not sure how I feel about this. It's kind of extraneous?
    if (get_property_int("telescopeUpgrades") > 0 && !get_property_boolean("telescopeLookedHigh") && __misc_state["in run"] && my_path().id != PATH_ACTUALLY_ED_THE_UNDYING && !in_bad_moon() && my_path().id != PATH_NUCLEAR_AUTUMN && my_path().id != PATH_G_LOVER && my_path().id != PATH_WEREPROFESSOR) {
        string [int] description;
        int percentage = 5 * get_property_int("telescopeUpgrades");
        description.listAppend("+" + (percentage == 25 ? "35% or +25" : percentage) + "% to all attributes. (10 turns)");
        resource_entries.listAppend(ChecklistEntryMake("__effect Starry-Eyed", "campground.php?action=telescope", ChecklistSubentryMake("Telescope buff", "", description), 10).ChecklistEntrySetIDTag("Telescope buff resource"));
    }
    
    
    if (__misc_state_int["free rests remaining"] > 0) {
        ChecklistEntry entry;
        entry.image_lookup_name = "__effect sleepy";
        entry.tags.id = "Campground free rests resource";
        entry.importance_level = 10;

        //Build the entries in an order dependant on user preferences
        boolean go_chateau = get_property_boolean("restUsingChateau");
        boolean go_away = get_property_boolean("restUsingCampAwayTent");
        string [int] order;
        order [go_chateau ? 0 : 1] = "Chateau Mantegna";
        order [go_chateau ? 1 : 0] = go_away ? "Getaway Campsite" : "Your Campsite";
        order [2] = go_away ? "Your Campsite" : "Getaway Campsite";


        string [int] url;
        ChecklistSubentry [int] subentries_handle;
        string [int] description;

        foreach i, loc in order {
            ChecklistSubentry subentry;
            switch {
                case loc == "Chateau Mantegna" && __misc_state["Chateau Mantegna available"]:
                    subentry.header = "At your Chateau Mantegna:";
                    url.listAppend(__misc_state_string["resting url Chateau Mantegna"]);

                    stat nightstand_stat = $stat[none];
                    int [item] chateau = get_chateau();

                    if (chateau[$item[electric muscle stimulator]] > 0)
                        nightstand_stat = $stat[muscle];
                    else if (chateau[$item[foreign language tapes]] > 0)
                        nightstand_stat = $stat[mysticality];
                    else if (chateau[$item[bowl of potpourri]] > 0)
                        nightstand_stat = $stat[moxie];

                    string nightstand_message;
                    if (nightstand_stat != $stat[none] && my_path().id != PATH_THE_SOURCE) {
                        float experience_multiplier = (100 + numeric_modifier(nightstand_stat + " Experience Percent")) / 100;
                        int nightstand_statgain = clampi(12 * my_level(), 0, 100) * experience_multiplier;
                        nightstand_message = ", " + nightstand_statgain + " " + nightstand_stat + " stats";
                    }

                    subentry.entries.listAppend("250 HP, 125 MP" + nightstand_message + ".");
                    
                    if (my_level() < 9 && my_path().id != PATH_THE_SOURCE)
                        subentry.entries.listAppend("May want to wait until level 9(?) for more stats from resting.");
                    
                    item [int] items_equipping = generateEquipmentToEquipForExtraExperienceOnStat(nightstand_stat);
                    if (items_equipping.count() > 0 && __misc_state["need to level"])
                        subentry.entries.listAppend("Could equip " + items_equipping.listJoinComponents(", ", "or") + " for more stats.");

                    subentries_handle.listAppend(subentry);
                    break;
                case loc == "Getaway Campsite" && __misc_state["Getaway Campsite available"]:
                    subentry.header = "At your Getaway Campsite:";
                    url.listAppend(__misc_state_string["resting url Getaway Campsite"]);

                    int tent_decoration = get_property_int("campAwayDecoration");
                    effect tent_decoration_effect = $effect[none]; //Not actually used...
                    string tent_decoration_stat;

                    switch (tent_decoration) {
                        case 1:
                            tent_decoration_effect = $effect[Muscular Intentions];
                            tent_decoration_stat = "muscle";
                            break;
                        case 2:
                            tent_decoration_effect = $effect[Mystical Intentions];
                            tent_decoration_stat = "myst";
                            break;
                        case 3:
                            tent_decoration_effect = $effect[Moxious Intentions];
                            tent_decoration_stat = "moxie";
                            break;
                    }
                    
                    subentry.entries.listAppend("250 HP, 125 MP, removes negative effects.");

                    if (tent_decoration != 0)
                        subentry.entries.listAppend("Gives 20 turns of +3 " + tent_decoration_stat + " stats/fight.");

                    subentries_handle.listAppend(subentry);
                    break;
                case loc == "Your Campsite" && __misc_state["recommend resting at campsite"]:
                    subentry.header = "At your Campsite:";
                    url.listAppend(__misc_state_string["resting url campsite"]);
                    
                    subentry.entries.listAppend(__misc_state_int["rest hp restore"] + " HP, " + __misc_state_int["rest mp restore"] + " MP.");
                    if ($item[pantsgiving].available_amount() > 0) {
                        if ($item[pantsgiving].equipped_amount() == 0)
                            subentry.entries.listAppend("Wear pantsgiving for extra HP/MP.");
                        if (availableFullness() > 0)
                            subentry.entries.listAppend("Eat more for +" + (availableFullness() * 5) + " extra HP/MP.");
                    }

                    if (__resting_bonuses.count() > 0) {
                        boolean saw_a_limit;
                        string [int] bonus_messages;
                        foreach source, bonus in __resting_bonuses {
                            string message;

                            if (source == $item[Confusing LED clock] && my_adventures() < 5)
                                continue; //won't activate

                            if (bonus.duration > 0) {
                                if (source == $item[Lucky cat statue]) //SETS the remaining duration of that effect to 5 adv
                                    message += pluralise(bonus.duration - bonus.given_effect.have_effect(), "turn", "turns") + " of ";
                                else if (bonus.tasteful && bonus.given_effect.have_effect() > 1)
                                    continue; //won't activate
                                else
                                    message += bonus.duration.pluralise("turn", "turns") + " of ";
                            }

                            message += bonus.given_effect == $effect[none] ? bonus.header : bonus.given_effect + " (" + bonus.header + ")";

                            if (bonus.limit > 0) {
                                saw_a_limit = true;
                                message += ", " + bonus.limit + (bonus.limit > 1 ? "x" : "") + "/day";
                            }

                            //if (bonus.tasteful) //player should already be well aware of this; not relevant
                            //  message += ", breaks after 3-5 uses";

                            message += ".";

                            bonus_messages.listAppend(message);
                        }

                        if (saw_a_limit) //tell the player that the tiles don't mean that the buffs are still obtainable today; we can't know if they reached the limits
                            subentry.modifiers.listAppend("Can't tell if you got them, sorry...");
                        
                        if (bonus_messages.count() > 1)
                            subentry.entries.listAppend("Will give:" + HTMLGenerateIndentedText(bonus_messages.listJoinComponents("<hr>")));
                        else if (bonus_messages.count() == 1)
                            subentry.entries.listAppend("Will give " + bonus_messages[0]);
                    }

                    subentries_handle.listAppend(subentry);
                    break;
            }
        }

        entry.url = url [0];

        if (subentries_handle.count() > 1) {
            entry.should_indent_after_first_subentry = true; //that feature is awesome!
            entry.subentries = subentries_handle;
            entry.subentries.listPrepend(ChecklistSubentryMake(pluralise(__misc_state_int["free rests remaining"], "free rest", "free rests"))); //entire entry acts as a "title"
        } else if (subentries_handle.count() == 1)
            entry.subentries.listAppend(ChecklistSubentryMake(pluralise(__misc_state_int["free rests remaining"], "free rest", "free rests"), "", subentries_handle[0].entries));

        resource_entries.listAppend(entry);
    }
    
    if (__quest_state["Sea Monkees"].finished && !get_property_boolean("_momFoodReceived")) {
        //FIXME Detect if they can breathe underwater, to go meet her
        string [int] description;

        if (__misc_state["in run"]) { //who knows...
            string [int] elemental_buffs;
        	elemental_buffs.listAppend(HTMLGenerateSpanOfClass("Hot Sweat", "r_element_hot"));
            elemental_buffs.listAppend(HTMLGenerateSpanOfClass("Cold Sweat", "r_element_cold"));
            elemental_buffs.listAppend(HTMLGenerateSpanOfClass("Rank Sweat", "r_element_stench"));
            elemental_buffs.listAppend(HTMLGenerateSpanOfClass("Black Sweat", "r_element_spooky"));
            elemental_buffs.listAppend(HTMLGenerateSpanOfClass("Flop Sweat", "r_element_sleaze"));
        
            description.listAppend("<strong>" + elemental_buffs.listJoinComponents(" / ") + ":</strong> +7 X resistance.");
        }

        description.listAppend("<strong>Mark of Candy Cain:</strong> +20% critical & spell critical hit.");
        description.listAppend("<strong>Cereal Killer:</strong> +200 stats/fight.");

        resource_entries.listAppend(ChecklistEntryMake("Mom Monkey Castle Window", "monkeycastle.php?who=4", ChecklistSubentryMake('Have Mom "make breakfast"', "50 turns", description), 5).ChecklistEntrySetIDTag("Mom sea monkey resource"));
    }
    
    if (true) {
        //FIXME Detect if they can breathe underwater
        string [string] dailySkateParkBuffs;

        switch (__quest_state["Sea Monkees"].state_string["skate park status"]) {
            case "ice":
                if (!get_property_boolean("_skateBuff1"))
                    dailySkateParkBuffs["Lutz, the Ice Skate"] = "Fishy";
                break;
            case "roller":
                if (!get_property_boolean("_skateBuff2"))
                    dailySkateParkBuffs["Comet, the Roller Skate"] = "-30% pressure penalty";
                break;
            case "peace":
                if (!get_property_boolean("_skateBuff3"))
                    dailySkateParkBuffs["The Bandshell"] = "+1 sand dollar/underwater combat";
                if (!get_property_boolean("_skateBuff4"))
                    dailySkateParkBuffs["A Merry-Go Round"] = "+25% underwater item";
                if (!get_property_boolean("_skateBuff5"))
                    dailySkateParkBuffs["The Eclectic Eels"] = "+10 underwater familiar weight";
                break;
        }

        if (dailySkateParkBuffs.count() > 0) {
            ChecklistEntry entry;
            entry.image_lookup_name = "Skate Park";
            entry.url = "sea_skatepark.php";
            entry.tags.id = "Sea skate park buff resource";
            entry.importance_level = 5;

            if (dailySkateParkBuffs.count() > 1) {
                entry.subentries.listAppend(ChecklistSubentryMake("Daily Skate Park buffs (30 turns each)"));
                entry.should_indent_after_first_subentry = true; //to make it clear(er) that they are not mutually exclusive
                foreach whoYouGonnaCall, buff in dailySkateParkBuffs {
                    entry.subentries.listAppend(ChecklistSubentryMake(whoYouGonnaCall, "", buff));
                }
            } else {
                foreach whoYouGonnaCall, buff in dailySkateParkBuffs //We know there's only 1 key, but I think it's the only way to get it?
                    entry.subentries.listAppend(ChecklistSubentryMake("Daily Skate Park buff (30 turns)", "", HTMLGenerateSpanOfClass(whoYouGonnaCall, "r_bold") + ": " + buff));
            }

            resource_entries.listAppend(entry);
        }
    }
    
    if (my_path().id != PATH_BEES_HATE_YOU && !get_property_boolean("guyMadeOfBeesDefeated") && get_property_int("guyMadeOfBeesCount") > 0 && (__misc_state["in aftercore"] || !__quest_state["Level 12"].state_boolean["Arena Finished"])) {
        //Not really worthwhile? But I suppose we can track it if they've started it, and are either in aftercore or haven't flyered yet.
        //For flyering, it's 20 turns at -25%, 25 turns at -15%. 33 turns at -5%. Not worthwhile?
        int summon_count = get_property_int("guyMadeOfBeesCount");
        
        string [int] description;
        string times = "";
        if (summon_count == 4)
            times = "One More Time.";
        else
            times = int_to_wordy(5 - summon_count) + " times.";
        description.listAppend("Speak his name " + times);
        if ($item[antique hand mirror].available_amount() == 0)
            description.listAppend("Need antique hand mirror to win. Or towerkill.");
        resource_entries.listAppend(ChecklistEntryMake("__item guy made of bee pollen", $location[the haunted bathroom].getClickableURLForLocation(), ChecklistSubentryMake("The Guy Made Of Bees", "", description), 10).ChecklistEntrySetIDTag("Guy made of bees"));
    }
    
    if (stills_available() > 0) {
        string [int] description;
        string [int] mixables;
        if (__misc_state["can drink just about anything"] && my_path().id != PATH_SLOW_AND_STEADY) {
            mixables.listAppend("neuromancer-level drinks");
        }
        mixables.listAppend("~40MP from tonic water");
        
        description.listAppend(mixables.listJoinComponents(", ", "or").capitaliseFirstLetter() + ".");
        
        resource_entries.listAppend(ChecklistEntryMake("Superhuman Cocktailcrafting", "shop.php?whichshop=still", ChecklistSubentryMake(pluralise(stills_available(), "still use", "still uses"), "", description), 10).ChecklistEntrySetIDTag("Nash crosby still resource"));
    }
    
    if (__last_adventure_location == $location[The Red Queen\'s Garden]) {
        string will_need_effect = "";
        if ($effect[down the rabbit hole].have_effect() == 0)
            will_need_effect = "|Will need to use &quot;DRINK ME&quot; potion first.";
        if (get_property_int("pendingMapReflections") > 0)
            resource_entries.listAppend(ChecklistEntryMake("__item reflection of a map", "place.php?whichplace=rabbithole", ChecklistSubentryMake(pluralise(get_property_int("pendingMapReflections"), "pending reflection of a map", "pending reflections of a map"), "+900% item", "Adventure in the Red Queen's garden to acquire." + will_need_effect), 0).ChecklistEntrySetIDTag("Rabbit hole map reflections future"));
        if ($items[reflection of a map].available_amount() > 0) {
            resource_entries.listAppend(ChecklistEntryMake("__item reflection of a map", "inventory.php?ftext=reflection+of+a+map", ChecklistSubentryMake(pluralise($item[reflection of a map]), "", "Queen cookies." + will_need_effect), 0).ChecklistEntrySetIDTag("Rabbit hole map reflections resource"));
        }
    }
    
    if (__misc_state["VIP available"]) {
        if (!get_property_boolean("_lookingGlass") && $item[Clan looking glass].is_unrestricted()) {
            resource_entries.listAppend(ChecklistEntryMake("__item &quot;DRINK ME&quot; potion", "clan_viplounge.php?whichfloor=2", ChecklistSubentryMake("A gaze into the looking glass", "", "Acquire a " + $item[&quot;DRINK ME&quot; potion] + "."), 10).ChecklistEntrySetIDTag("VIP mirror gaze resource"));
        }
        //_deluxeKlawSummons?
        //_crimboTree?
        int soaks_remaining = __misc_state_int["hot tub soaks remaining"];
        if (__misc_state["in run"] && soaks_remaining > 0 && my_path().id != PATH_ACTUALLY_ED_THE_UNDYING && my_path().id != PATH_VAMPIRE) {
            string description = "Restore all HP, removes most bad effects.";
            resource_entries.listAppend(ChecklistEntryMake("__effect blessing of squirtlcthulli", "clan_viplounge.php", ChecklistSubentryMake(pluralise(soaks_remaining, "hot tub soak", "hot tub soaks"), "", description), 8).ChecklistEntrySetIDTag("VIP hot tub soaks resource"));
        }
        
        
    }
    //_klawSummons?
    
    //Skill books we have used, but don't have the skill for?
    
    //soul sauce tracking?
    
    if ($item[can of rain-doh].available_amount() > 0 && $item[empty rain-doh can].available_amount() == 0 && __misc_state["in run"]) {
        resource_entries.listAppend(ChecklistEntryMake("__item can of rain-doh", "inventory.php?ftext=can+of+rain-doh", ChecklistSubentryMake("Can of Rain-Doh", "", "Open it!"), 0).ChecklistEntrySetIDTag("Can of rain-doh resource"));
    }
    
    
    
    if (get_property_int("goldenMrAccessories") > 0) {
        //FIXME inline with hugs
        int total_casts_available = get_property_int("goldenMrAccessories") * 5;
        int casts_used = get_property_int("_smilesOfMrA");
        
        int casts_remaining = total_casts_available - casts_used;
        
        if (casts_remaining > 0) {
            string image_name = "__item Golden Mr. Accessory";
            if (my_id() == 1043600)
                image_name = "__item defective Golden Mr. Accessory"; //does not technically give out sunshine, but...
            resource_entries.listAppend(ChecklistEntryMake(image_name, "skills.php", ChecklistSubentryMake(pluralise(casts_remaining, "smile of the Mr. Accessory", "smiles of the Mr. Accessory"), "", "Give away sunshine."), 8).ChecklistEntrySetIDTag("Smile of Mr A heart"));
        }
    }
    
    if ( __iotms_usable[$item[Chateau Mantegna room key]] && !get_property_boolean("_chateauDeskHarvested")) {
        string image_name = "__item fancy calligraphy pen";
        resource_entries.listAppend(ChecklistEntryMake(image_name, "place.php?whichplace=chateau", ChecklistSubentryMake("Chateau desk openable", "", "Daily collectable."), 8).ChecklistEntrySetIDTag("Chateau Mantegna desk resource"));
    }

    if (!get_property_boolean("_lyleFavored") && my_path().id != PATH_G_LOVER) {
        string image_name = "__effect favored by lyle";
        string description = $effect[Favored by Lyle].have_effect() > 0 ? "Increases duration of Favored by Lyle." : "+10% all attributes.";
        resource_entries.listAppend(ChecklistEntryMake(image_name, "place.php?whichplace=monorail", ChecklistSubentryMake("Visit Lyle", "10 turns", description), 10).ChecklistEntrySetIDTag("Lyle favored resource"));
    }
    
    checklists.listAppend(ChecklistMake("Resources", resource_entries));
}
