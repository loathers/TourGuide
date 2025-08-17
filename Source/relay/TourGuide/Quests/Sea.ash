//merkinQuestPath

void QSeaInit()
{
    // While in 11,037 leagues under the sea, you want this showing no matter what.

    if (my_path().id != 55){
        //Have they adventured anywhere underwater?
        boolean have_adventured_in_relevant_area = false;
        foreach l in $locations[the briny deeps, the brinier deepers, the briniest deepests, an octopus's garden,the wreck of the edgar fitzsimmons, the mer-kin outpost, madness reef,the marinara trench, the dive bar,anemone mine, the coral corral, mer-kin elementary school,mer-kin library,mer-kin gymnasium,mer-kin colosseum,the caliginous abyss] {
            if (l.turnsAttemptedInLocation() > 0 || my_location() == l) {
                have_adventured_in_relevant_area = true;
                break;
            }
        }
        //don't list the quest unless they've started on the path under the sea:
        if (!have_adventured_in_relevant_area && $items[Mer-kin trailmap,Mer-kin lockkey,Mer-kin stashbox,wriggling flytrap pellet,damp old boot,Grandma's Map,Grandma's Chartreuse Yarn,Grandma's Fuchsia Yarn,Grandma's Note,black glass].available_amount() == 0)
            return;        
    }
        
    
    if (true) {
        QuestState state;
        
        state.state_string["path"] = get_property("merkinQuestPath");
        if (state.state_string["path"] == "done")
            QuestStateParseMafiaQuestPropertyValue(state, "finished");
        else
            QuestStateParseMafiaQuestPropertyValue(state, "started");
        
        state.quest_name = "Sea Quest";
        state.image_name = "Sea";
        
        boolean have_crappy_disguise = have_outfit_components("Crappy Mer-kin Disguise");
        state.state_boolean["have scholar disguise"] = have_outfit_components("Mer-kin Scholar's Vestments");
        state.state_boolean["have gladiator disguise"] = have_outfit_components("Mer-kin Gladiatorial Gear");
        state.state_boolean["can fight dad sea monkee"] = $items[Goggles of Loathing,Stick-Knife of Loathing,Scepter of Loathing,Jeans of Loathing,Treads of Loathing,Belt of Loathing,Pocket Square of Loathing].items_missing().count() <= 1;
        state.state_boolean["have one outfit"] = have_crappy_disguise || state.state_boolean["have scholar disguise"] || state.state_boolean["have gladiator disguise"];
        
        __quest_state["Sea Temple"] = state;
    }
    if (true) {
        QuestState state;
        
        QuestStateParseMafiaQuestProperty(state, "questS02Monkees");
        state.quest_name = "Hey, Hey, They're Sea Monkees";
        state.image_name = "Sea Monkey Castle";
        
        if (get_property_boolean("mapToTheSkateParkPurchased"))
            state.state_string["skate park status"] = get_property("skateParkStatus"); //"", "war", "ice", "roller", "peace"
        
        
        __quest_state["Sea Monkees"] = state;
    }
}

void QSeaGenerateTempleEntry(ChecklistSubentry subentry, StringHandle image_name, QuestState temple_quest_state)
{
    string temple_path = temple_quest_state.state_string["path"];
    boolean can_fight_dad_sea_monkee = temple_quest_state.state_boolean["can fight dad sea monkee"];
    boolean have_any_outfit = temple_quest_state.state_boolean["have one outfit"] || temple_quest_state.state_boolean["can fight dad sea monkee"];
    
    if (!have_any_outfit) {
        subentry.entries.listAppend("Acquire crappy mer-kin disguise from grandma sea monkee.");
        return;
    }
    
    boolean at_boss = false;
    boolean at_gladiator_boss = false;
    boolean at_scholar_boss = false;
    if (temple_path == "gladiator") {
        image_name.s = "Shub-Jigguwatt";
        at_gladiator_boss = true;
    } else if (temple_path == "scholar") {
        image_name.s = "Yog-Urt";
        at_scholar_boss = true;
    }
    at_boss = at_gladiator_boss || at_scholar_boss;
    
    if (!at_boss || at_gladiator_boss) {
        string [int] description;
        string [int] modifiers;
        //gladiator:
        if (at_gladiator_boss) {
            description.listAppend("Buff muscle, equip a powerful weapon.");
            description.listAppend("Delevel him for a bit, then attack with your weapon.");
            if ($item[crayon shavings].available_amount() > 0) description.listAppend("|*Your crayon shavings are great for this!");
            description.listAppend("Make sure not to have anything along that will attack him. (familiars, etc)");
            //umm... this probably won't be updated:
            string [int] things_to_do;
            foreach it in $items[hand in glove,MagiMechTech NanoMechaMech,bottle opener belt buckle,old school calculator watch,ant hoe,ant pick,ant pitchfork,ant rake,ant sickle,fishy wand,moveable feast,oversized fish scaler,replica plastic pumpkin bucket,plastic pumpkin bucket,tiny bowler,cup of infinite pencils,double-ice box,smirking shrunken head,mr. haggis,stapler bear,dubious loincloth,muddy skirt,bottle of Goldschn&ouml;ckered,acid-squirting flower,ironic oversized sunglasses,hippy protest button,cannonball charrrm bracelet,groovy prism necklace,spiky turtle shoulderpads,double-ice cap,parasitic headgnawer,eelskin hat,balloon shield,hot plate,Ol' Scratch's stove door,Oscus's garbage can lid,eelskin shield,eelskin pants] {
                if (it.equipped_amount() > 0)
                    things_to_do.listAppend("unequip " + it);
            }
            foreach e in $effects[Skeletal Warrior,Skeletal Cleric,Skeletal Wizard,Bone Homie,Burning\, Man,Biologically Shocked,EVISCERATE!,Fangs and Pangs,Permanent Halloween,Curse of the Black Pearl Onion,Long Live GORF,Apoplectic with Rage,Dizzy with Rage,Quivering with Rage,Jaba&ntilde;ero Saucesphere,Psalm of Pointiness,Drenched With Filth,Stuck-Up Hair,It's Electric!,Smokin',Jalape&ntilde;o Saucesphere,Scarysauce,spiky shell] {
                if (e.have_effect() > 0)
                    things_to_do.listAppend("uneffect " + e);
            }
            if (things_to_do.count() > 0)
                description.listAppend(HTMLGenerateSpanFont(things_to_do.listJoinComponents(", ", "and").capitaliseFirstLetter() + ".", "red"));
            
            if ($item[dark porquoise ring].equipped_amount() == 0) {
                string line = "Possibly ";
                if ($item[dark porquoise ring].available_amount() == 0)
                    line += "acquire and ";
                line += "equip a dark porquoise ring to use fewer delevelers.";
                description.listAppend(line);
            }
            if ($effect[Ruthlessly Efficient].have_effect() == 0) {
                if ($skill[Ruthless Efficiency].have_skill()) {
                    description.listAppend("Possibly cast Ruthless Efficiency to delevel faster.");
                } else if ($item[Crimbot ROM: Ruthless Efficiency (dirty)].available_amount() > 0) {
                    description.listAppend("Possibly use Crimbot ROM: Ruthless Efficiency (dirty) and cast it to delevel faster.");
                } else if ($item[Crimbot ROM: Ruthless Efficiency].available_amount() > 0) {
                    description.listAppend("Possibly use Crimbot ROM: Ruthless Efficiency and cast it to delevel faster.");
                }
            }
            if (my_mp() > 0)
                description.listAppend(HTMLGenerateSpanFont("Try to reduce your MP to 0", "red") + " before fighting him.");
        } else {
            if (!temple_quest_state.state_boolean["have gladiator disguise"]) {
                description.listAppend("Acquire gladiatorial outfit.|Components can be found by running +combat in the gymnasium.|Make the outfit with grandma.");
                modifiers.listAppend("+combat");
            } else {
                string shrap_suggestion = "Shrap is nice for this.";
                if (!$skill[shrap].skill_is_usable()) {
                    if ($item[warbear metalworking primer (used)].available_amount() > 0) {
                        shrap_suggestion += " (use your used copy of warbear metalworking primer)";
                    } else
                        shrap_suggestion += " (from warbear metalworking primer)";
                }
                modifiers.listAppend("spell damage percent");
                modifiers.listAppend("mysticality");
                description.listAppend("Fight in the colosseum!");
                description.listAppend("Easy way is to buff mysticality and spell damage percent, then cast powerful spells.<br>" + shrap_suggestion);
                description.listAppend("There's another way, but it's a bit complicated. Check the wiki?");

                if (get_property("lastColosseumRoundWon") != "") { //backwards compatibility
                    int colosseum_round = get_property_int("lastColosseumRoundWon");
                    int enemy_level = colosseum_round / 3;
                    string enemy_type, counter_weapon, counter_weapon_property;

                    switch (colosseum_round % 3) {
                        case 0:
                            //missing the net GAIN cue: 1 turn of Gutballed (-300% muscle)
                            //missing the net LOSS cue: increase... monster level..?
                            //missing the net NEUTRALITY cue: reduces every future incoming damage to 1, for a few rounds
                            enemy_type = (enemy_level > 3 ? "Georgepaul, the B" : "a mer-kin b") + "alldodger";
                            counter_weapon = "Mer-kin dragnet";
                            counter_weapon_property = "gladiatorNetMovesKnown";
                            break;
                        case 1:
                            //missing the blade SLING cue: heals
                            //missing the blade ROLLER ("rolls") cue: 1 turn of Nettled (-300% moxie)
                            //missing the blade RUNNER cue: hits for 1/2 of you max HP
                            enemy_type = (enemy_level > 3 ? "Johnringo, the N" : "a mer-kin n") + "etdragger";
                            counter_weapon = "Mer-kin switchblade";
                            counter_weapon_property = "gladiatorBladeMovesKnown";
                            break;
                        case 2:
                            //missing the ball BUST cue: reflects all damage for a few rounds
                            //missing the ball SWEAT cue: increase attack? shrug off delevels?
                            //missing the ball SACK cue: unequips your weapon
                            enemy_type = (enemy_level > 3 ? "Ringogeorge, the B" : "a mer-kin b") + "ladeswitcher";
                            counter_weapon = "Mer-kin dodgeball";
                            counter_weapon_property = "gladiatorBallMovesKnown";
                            break;
                    }
                    int colosseum_skills_known = get_property_int(counter_weapon_property);

                    description.listAppend("Next fight is against " + enemy_type + ".");
                    if (counter_weapon.to_item().equipped_amount() == 0 && colosseum_skills_known > 0 && enemy_level > 0)
                        description.listAppend("Equip your " + counter_weapon + (colosseum_skills_known == 3 ? "." : "..?"));
                    //could be developped more?
                }

                //if ($item[Mer-kin gladiator mask].equipped_amount() == 0 || $item[Mer-kin gladiator tailpiece].equipped_amount() == 0)
                    //description.listAppend("Equip the Mer-kin Gladiatorial Gear.");
            }
        }
        string modifier_string = "";
        if (modifiers.count() > 0)
            modifier_string = ChecklistGenerateModifierSpan(modifiers);
        if (description.count() > 0)
            subentry.entries.listAppend("Gladiator path" +  HTMLGenerateIndentedText(modifier_string + description.listJoinComponents("<hr>")));
    }
    if (!at_boss || at_scholar_boss) {
        string [int] description;
        string [int] modifiers;
        //scholar:
        if (at_scholar_boss) {
            description.listAppend("Wear several mer-kin prayerbeads and possibly a mer-kin gutgirdle.");
            description.listAppend("Avoid wearing any +hp gear or buffs. Ideally, you want low HP.");
            description.listAppend("Each round, use a different healing item, until you lose the Suckrament effect.<br>After that, your stats are restored. Fully heal, then " + HTMLGenerateSpanOfClass("attack with elemental damage", "r_bold") + ".");
            string [item] potential_healers;
            potential_healers[$item[mer-kin healscroll]] = "mer-kin healscroll (full HP)";
            potential_healers[$item[scented massage oil]] = "scented massage oil (full HP)";
            potential_healers[$item[soggy used band-aid]] = "soggy used band-aid (full HP)";
            potential_healers[$item[sea gel]] = "sea gel (+500 HP)";
            potential_healers[$item[waterlogged scroll of healing]] = "waterlogged scroll of healing (+250 HP)";
            potential_healers[$item[extra-strength red potion]] = "extra-strength red potion (+200 HP)";
            potential_healers[$item[red pixel potion]] = "red pixel potion (+100-120 HP)";
            potential_healers[$item[red potion]] = "red potion (+100 HP)";
            potential_healers[$item[filthy poultice]] = "filthy poultice (+80-120 HP)";
            potential_healers[$item[gauze garter]] = "gauze garter (+80-120 HP)";
            potential_healers[$item[green pixel potion]] = "green pixel potion (+40-60 HP)";
            potential_healers[$item[cartoon heart]] = "cartoon heart (40-60 HP)";
            potential_healers[$item[red plastic oyster egg]] = "red plastic oyster egg (+35-40 HP)";
            string [int] description_healers;
            
            foreach it in potential_healers {
                if (it.item_amount() > 0)
                    description_healers.listAppend(potential_healers[it]);
                else
                    description_healers.listAppend(HTMLGenerateSpanFont(potential_healers[it], "red"));
            }
            description.listAppend("Potential healing items:|*" + description_healers.listJoinComponents("|*"));
        } else {
            if (!temple_quest_state.state_boolean["have scholar disguise"]) {
                description.listAppend("Acquire scholar outfit.|Components can be found by running -combat in the elementary school.|Make the outfit with grandma.");
                modifiers.listAppend("-combat");
            } else {
                if ($item[Mer-kin dreadscroll].available_amount() == 0) {
                    description.listAppend("Adventure in the library. Find the dreadscroll.");
                    modifiers.listAppend("-combat");
                } else {
                    if ($effect[deep-tainted mind].have_effect() > 0)
                        description.listAppend("Solve the dreadscroll.<br>Wait for Deep-Tainted Mind to wear off.");
                    else
                        description.listAppend("Solve the dreadscroll.");
                        
                    string [int] unknown_clues;
                    
                    /*
                    Mer-kin Library 1 -> dreadScroll1
                    Mer-kin healscroll -> dreadScroll2
                    Deep Dark Visions -> dreadScroll3
                    Mer-kin knucklebone -> dreadScroll4
                    Mer-kin killscroll -> dreadScroll5
                    Mer-kin Library 2 -> dreadScroll6
                    Mer-kin worktea -> dreadScroll7
                    Mer-kin Library 3 -> dreadScroll8
                    */
                    
                    int known_clue_count = 0;
                    boolean [int] known_clues;
                    int library_clues_known = 0;
                    for i from 1 to 8 {
                        string property_name = "dreadScroll" + i;
                        int property_value = get_property_int(property_name);
                        
                        if (property_value >= 1 && property_value <= 4) {
                            known_clue_count += 1;
                            known_clues[i] = true;

                            if (i == 1 || i == 6 || i == 8)
                                library_clues_known += 1;
                        }
                    }
                    
                    boolean need_to_learn_vocabulary = false;
                    
                    if (library_clues_known < 3) {
                        unknown_clues.listAppend((3 - library_clues_known).int_to_wordy().capitaliseFirstLetter() + " non-combats in the library. (vocabulary)");
                        need_to_learn_vocabulary = true;
                    }
                    if (!known_clues[5]) {
                        unknown_clues.listAppend("Use a mer-kin killscroll in combat. (vocabulary)");
                        need_to_learn_vocabulary = true;
                    }
                    if (!known_clues[2]) {
                        unknown_clues.listAppend("Use a mer-kin healscroll in combat. (vocabulary)");
                        need_to_learn_vocabulary = true;
                    }
                    if (!known_clues[4])
                        unknown_clues.listAppend("Use a mer-kin knucklebone.");
                    if (!known_clues[3])
                        unknown_clues.listAppend("Cast deep dark visions.");
                    if (!known_clues[7])
                        unknown_clues.listAppend("Eat sushi with mer-kin worktea.");
                    
                    if (unknown_clues.count() > 0)
                        description.listAppend("Clues are from:|*-" + unknown_clues.listJoinComponents("|*-"));
                    
                    if (need_to_learn_vocabulary) {
                        int vocabulary = get_property_int("merkinVocabularyMastery");
                        if (vocabulary < 100) {
                            int word_quizzes_needed = clampi(10 - vocabulary / 10, 1, 10);
                            description.listAppend("At " + (vocabulary) + "% Mer-Kin vocabulary. (use " + pluralise(word_quizzes_needed, $item[mer-kin wordquiz]) + " with a mer-kin cheatsheet)");
                        } else
                            description.listAppend("Mer-Kin vocabulary mastered.");
                    }
                    if (known_clue_count > 0) {
                        if (known_clue_count == 8)
                            description.listAppend("Have all clues.");
                        else
                            description.listAppend("Have " + known_clue_count + " out of 8 clues.");
                    }
                }
            }
        }
        string modifier_string = "";
        if (modifiers.count() > 0)
            modifier_string = ChecklistGenerateModifierSpan(modifiers);
        if (description.count() > 0)
            subentry.entries.listAppend("Scholar path" +  HTMLGenerateIndentedText(modifier_string + description.listJoinComponents("<hr>")));
    }
    if (!at_boss && can_fight_dad_sea_monkee) {
        string [int] description;
        
        description.listAppend("Equip Clothing of Loathing, go to the temple.");
        description.listAppend("Cast 120MP hobopolis spells at him.");
        description.listAppend("Use Mafia's \"dad\" GCLI command to see which element to use which round.");
        if (my_mp() < 1200)
            description.listAppend("Will need 1200MP, or less if using shrap/volcanometeor showeruption.");
            
        string [int] modifiers_needed_150;
        foreach s in $stats[] {
            if (s.my_basestat() < 150)
                modifiers_needed_150.listAppend((150 - s.my_basestat()) + " more " + s.to_lower_case());
        }
        
        if (modifiers_needed_150.count() > 0)
            description.listAppend("Need " + modifiers_needed_150.listJoinComponents(", ", "and") + " to wear Clothing of Loathing.");
        
        if (description.count() > 0)
            subentry.entries.listAppend("Dad sea monkee path" + HTMLGenerateIndentedText(description.listJoinComponents("<hr>")));
    }
    
    item [class] class_to_scholar_item;
    item [class] class_to_gladiator_item;
    
    class_to_scholar_item[$class[seal clubber]] = $item[Cold Stone of Hatred];
    class_to_scholar_item[$class[turtle tamer]] = $item[Girdle of Hatred];
    class_to_scholar_item[$class[pastamancer]] = $item[Staff of Simmering Hatred];
    class_to_scholar_item[$class[sauceror]] = $item[Pantaloons of Hatred];
    class_to_scholar_item[$class[disco bandit]] = $item[Fuzzy Slippers of Hatred];
    class_to_scholar_item[$class[accordion thief]] = $item[Lens of Hatred];
    
    class_to_gladiator_item[$class[seal clubber]] = $item[Ass-Stompers of Violence];
    class_to_gladiator_item[$class[turtle tamer]] = $item[Brand of Violence];
    class_to_gladiator_item[$class[pastamancer]] = $item[Novelty Belt Buckle of Violence];
    class_to_gladiator_item[$class[sauceror]] = $item[Lens of Violence];
    class_to_gladiator_item[$class[disco bandit]] = $item[Pigsticker of Violence];
    class_to_gladiator_item[$class[accordion thief]] = $item[Jodhpurs of Violence];
    
    item scholar_item = class_to_scholar_item[my_class()];
    item gladiator_item = class_to_gladiator_item[my_class()];
    
    if (!at_boss) {
        string line = "Can acquire " + scholar_item + " (scholar) or " + gladiator_item + " (gladiator)";
        if (can_fight_dad_sea_monkee)
            line += " or " + $item[pocket square of loathing] + " (dad)";
        subentry.entries.listAppend(line);
    } else if (at_gladiator_boss)
        subentry.entries.listAppend("Will acquire " + gladiator_item + ".");
    else if (at_scholar_boss)
        subentry.entries.listAppend("Will acquire " + scholar_item + ".");
}

//Hmm. Possibly show taffy in resources, if they're under the sea?

void QSeaGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    QuestState temple_quest_state = __quest_state["Sea Temple"];
    QuestState monkees_quest_state = __quest_state["Sea Monkees"];

    if (!__misc_state["in aftercore"] && !monkees_quest_state.started || temple_quest_state.quest_name == "")
        return;

    //Will have 4 possible tiles. 1 is the main questline, and always appear, and the 3 others only appear once they diverge from the main questline (if unfinished, of course)
    //Tile 1 is the old man's boot (first since needs no adventuring once diverged). Diverges from the main questline when freeing big brother.
    //Tile 2 is the main questline, which goes up to the Mer-Kin temple boss(es). (in other words, main questline = mer-kin questline, with all of its prerequisites)
    //Tile 3 is the sea monkey questline (ends with finding Mom sea monkey). Diverges from the main questline when asking grandpa about grandma.
    //Tile 4 is the skate park. Diverges from the main questline when freeing big brother. Only shows once you buy the map to the skate park.

    //Tile 1
    if (get_property("questS01OldGuy") != "finished" && monkees_quest_state.mafia_internal_step >= 3) {
        string url, title, modifiers;
        string [int] description;
        if (get_property_boolean("dampOldBootPurchased")) {
            url = "place.php?whichplace=sea_oldman";
            title = "Return damp old boot to the old man";
            if ($item[fishy pipe].available_amount() == 0)
                description.listAppend("Choose the fishy pipe.");
            else if ($item[das boot].available_amount() == 0)
                description.listAppend("Choose the das boot.");
            else
                description.listAppend("Choose the damp old wallet.");
        } else {
            url = "monkeycastle.php?who=2";
            title = "Buy the old man's boot from Big Brother";
            modifiers = "50 sand dollars";
            int sand_dollars = $item[sand dollar].item_amount();
            if (sand_dollars < 50)
                description.listAppend("Have " + sand_dollars.pluralise("sand dollar", "sand dollars") + " on hand.");
        }
        optional_task_entries.listAppend(ChecklistEntryMake("__item damp old boot", url, ChecklistSubentryMake(title, modifiers, description)).ChecklistEntrySetIDTag("Sea old man boot quest"));
    }


    //Tiles 2, 3 and 4 all want fishy, but we don't want to put the full notification in each of them. So instead, we initialize the 3 ChecklistSubentries here, add the general reminder to all of them, and add the how_to to the first that will be displayed.
    ChecklistSubentry temple_subentry, sea_monkey_subentry, skate_park_subentry;

    boolean should_output_temple_questline = !temple_quest_state.finished;
    boolean should_output_sea_monkey_questline = !monkees_quest_state.finished && monkees_quest_state.mafia_internal_step >= 7;

    string get_fishy, how_to_get_fishy;
    if ($effect[fishy].have_effect() == 0) {
        get_fishy = "Acquire fishy.";
        how_to_get_fishy = "|*Easy way: Lucky adventure in the brinier deeps, 20 turns.";
        if ($item[fishy pipe].available_amount() > 0 && !get_property_boolean("_fishyPipeUsed"))
            how_to_get_fishy += "|*Use fishy pipe.";
        if (monkees_quest_state.state_string["skate park status"] == "ice" && !get_property_boolean("_skateBuff1"))
            how_to_get_fishy += "|*Visit Lutz at the Skate Park.";

        if (should_output_temple_questline) {
            temple_subentry.entries.listAppend(get_fishy + how_to_get_fishy);
            sea_monkey_subentry.entries.listAppend(get_fishy);
            skate_park_subentry.entries.listAppend(get_fishy);
        } else if (should_output_sea_monkey_questline) {
            sea_monkey_subentry.entries.listAppend(get_fishy + how_to_get_fishy);
            skate_park_subentry.entries.listAppend(get_fishy);
        } else
            skate_park_subentry.entries.listAppend(get_fishy + how_to_get_fishy);
    }


    //Tile 2
    string image_name = temple_quest_state.image_name;
    string url = "seafloor.php";

    temple_subentry.header = temple_quest_state.quest_name;
    boolean need_minus_combat_modifier = false;


    if (should_output_temple_questline) {
        if (get_property("seahorseName").length() == 0) {
            boolean professional_roper = false;
            //merkinLockkeyMonster questS01OldGuy questS02Monkees
            //Need to reach the temple:
            if (get_property("lassoTraining") != "expertly") {
                string line;
                if ($item[sea lasso].item_amount() == 0)
                    line += HTMLGenerateSpanFont((in_ronin() ? "Acquire" : "Buy") + " and use a sea lasso in each combat.", "red");
                else
                    line += "Use a sea lasso in each combat.";
                if ($item[sea cowboy hat].equipped_amount() == 0)
                    line += "|*Wear a sea cowboy hat to improve roping.";
                if ($item[sea chaps].equipped_amount() == 0)
                    line += "|*Wear sea chaps to improve roping.";
                temple_subentry.entries.listAppend(line);
            } else {
                professional_roper = true;
                string line;
                if ($item[sea lasso].item_amount() == 0)
                    line += "Buy a sea lasso.";
                if ($item[sea cowbell].item_amount() < 3) {
                    int needed_amount = MAX(3 - $item[sea cowbell].item_amount(), 0);
                    if (line != "") line += " ";
                    line += "Buy " + pluraliseWordy(needed_amount, "sea cowbell", "sea cowbells") + ".";
                }
                if (line != "")
                    temple_subentry.entries.listAppend(line);
            }
            location class_grandpa_location;
            if (my_primestat() == $stat[muscle])
                class_grandpa_location = $location[Anemone Mine];
            if (my_primestat() == $stat[mysticality])
                class_grandpa_location = $location[The Marinara Trench];
            if (my_primestat() == $stat[moxie])
                class_grandpa_location = $location[the dive bar];
            
            int grandpa_ncs_remaining = 3;
            
            //Match NC names to prevent other NCs interfering with tracking:
            int [string] noncombat_names;
            noncombat_names["Lost and Found and Lost Again"] = 2;
            noncombat_names["Respect Your Elders"] = 1;
            noncombat_names["You've Hit Bottom"] = 0;
            noncombat_names["Kids Today"] = 1;
            noncombat_names["Not a Micro Fish"] = 0;
            noncombat_names["No Country Music for Old Men"] = 2;
            noncombat_names["Salty Old Men"] = 1;
            noncombat_names["Boxing the Juke"] = 0;
            noncombat_names["Bar Hunting"] = 2;
            noncombat_names["The Salt of the Sea"] = 1;
            noncombat_names["Ode to the Sea"] = 0;
            foreach nc in noncombat_names {
                if (class_grandpa_location.noncombat_queue.contains_text(nc))
                    grandpa_ncs_remaining = MIN(grandpa_ncs_remaining, noncombat_names[nc]);
            }
            
            //Detect where we are:
            //This won't work beyond talking to little brother, my apologies (fixed since)
            if (get_property_boolean("corralUnlocked") || $location[the coral corral].turnsAttemptedInLocation() > 0) {
                //Coral corral. Banish strategy.
                string sea_horse_details;
                if (!professional_roper)
                    sea_horse_details = HTMLGenerateSpanFont("|But first, train up your roping skills.", "red");
                else
                    sea_horse_details = "|Once found, use three sea cowbells on him, then a sea lasso.";
                temple_subentry.entries.listAppend("Look for your sea horse in the Coral Corral." + sea_horse_details);
                string [int] banish_monsters;
                monster [int] monster_list = $location[the coral corral].get_monsters();
                foreach key in monster_list {
                    monster m = monster_list[key];
                    if (!m.is_banished() && m != $monster[wild seahorse])
                        banish_monsters.listAppend(m.to_string());
                }
                if (banish_monsters.count() > 1)
                    temple_subentry.entries.listAppend("Banish " + banish_monsters.listJoinComponents(", ", "and") + " with separate banish sources to speed up area.");
            } else if (monkees_quest_state.mafia_internal_step >= 7 || $location[the mer-kin outpost].turnsAttemptedInLocation() > 0) {
                //Find lockkey as well.
                //Then stash box. Mention monster source.
                //Use trailmap.
                //Ask grandpa about currents.
                if ($item[Mer-kin trailmap].available_amount() > 0) {
                    temple_subentry.entries.listAppend("Use Mer-kin trailmap.");
                } else if ($item[Mer-kin stashbox].available_amount() > 0) {
                    temple_subentry.entries.listAppend("Open stashbox.");
                } else if ($item[Mer-kin lockkey].available_amount() > 0) {
                    string nc_details = "";
                    monster lockkey_monster = get_property_monster("merkinLockkeyMonster");
                    if (lockkey_monster == $monster[Mer-kin burglar]) {
                        nc_details = "Stashbox is in the camouflaged tent.";
                    } else if (lockkey_monster == $monster[Mer-kin raider]) {
                        nc_details = "Stashbox is in the skull-bedecked tent.";
                    } else if (lockkey_monster == $monster[Mer-kin healer]) {
                        nc_details = "Stashbox is in the glyphed tent.";
                    }
                    
                    need_minus_combat_modifier = true;
                    temple_subentry.entries.listAppend("Adventure in the Mer-Kin outpost, find non-combat.|" + nc_details);
                } else {
                    temple_subentry.entries.listAppend("Adventure in the Mer-Kin outpost to acquire a lockkey.");
                    temple_subentry.entries.listAppend("Unless you discovered the currents already (can't tell), in which case go ask grandpa about currents.");
                }
            } else if (monkees_quest_state.mafia_internal_step == 6 || grandpa_ncs_remaining == 0) {
                url = "monkeycastle.php?who=3";
                temple_subentry.entries.listAppend("Ask grandpa about his wife to unlock the Mer-Kin outpost.");
            } else if (monkees_quest_state.mafia_internal_step == 5 || class_grandpa_location.turnsAttemptedInLocation() > 0) {
                //Find grandpa in one of the three zones.
                need_minus_combat_modifier = true;
                temple_subentry.entries.listAppend("Find grandpa sea monkee in " + class_grandpa_location + ".|" + pluraliseWordy(grandpa_ncs_remaining, "non-combat remains", "non-combats remain").capitaliseFirstLetter() + ".");
                if(grandpa_ncs_remaining == 3) temple_subentry.entries.listAppend("|*Make sure you talk to little brother, too; the quest only starts when you talk to him!");
            } else if (monkees_quest_state.mafia_internal_step == 4) {
                //Talk to little brother.
                temple_subentry.entries.listAppend("Talk to little brother.");
                url = "monkeycastle.php";
            } else if (monkees_quest_state.mafia_internal_step == 3) {
                //Talk to big brother.
                temple_subentry.entries.listAppend("Talk to big brother.");
                url = "monkeycastle.php";
            } else if (monkees_quest_state.mafia_internal_step == 2 || $location[The Wreck of the Edgar Fitzsimmons].turnsAttemptedInLocation() > 0) {
                //Adventure in wreck, free big brother.
                need_minus_combat_modifier = true;
                temple_subentry.entries.listAppend("Free big brother. Adventure in the wreck.|Then talk to him and little brother, find grandpa.");
            } else if (monkees_quest_state.mafia_internal_step == 1) {
                if ($item[wriggling flytrap pellet].available_amount() > 0) {
                    url = "inventory.php?ftext=wriggling+flytrap+pellet";
                    temple_subentry.entries.listAppend("Open a wriggling flytrap pellet, talk to little brother.");
                } else {
                    //Talk to little brother
                    temple_subentry.entries.listAppend("Talk to little brother.");
                    url = "monkeycastle.php";
                }
            } else {
                //Octopus's garden, obtain wriggling flytrap pellet
                if ($item[wriggling flytrap pellet].available_amount() == 0) {
                    temple_subentry.entries.listAppend("Adventure in octopus's garden, find a wriggling flytrap pellet from a Neptune flytrap.");
                    temple_subentry.modifiers.listAppend("olfact Neptune flytrap");
                } else {
                    url = "inventory.php?ftext=wriggling+flytrap+pellet";
                    temple_subentry.entries.listAppend("Open a wriggling flytrap pellet, talk to little brother.");
                }
            }
            
            //Find grandma IF they don't have a disguise/cloathing.
        } else {
            url = "seafloor.php?action=currents";
            StringHandle image_name_handle;
            image_name_handle.s = image_name;
            QSeaGenerateTempleEntry(temple_subentry, image_name_handle, temple_quest_state);
            image_name = image_name_handle.s;
        }
    }
    
    if (need_minus_combat_modifier)
        temple_subentry.modifiers.listAppend("-combat");

    if (should_output_temple_questline)
        optional_task_entries.listAppend(ChecklistEntryMake(image_name, url, temple_subentry, $locations[the brinier deepers, an octopus's garden,the wreck of the edgar fitzsimmons, the mer-kin outpost, madness reef,the marinara trench, the dive bar,anemone mine, the coral corral, mer-kin elementary school,mer-kin library,mer-kin gymnasium,mer-kin colosseum,the caliginous abyss]).ChecklistEntrySetIDTag("Sea mer-kin main quest"));


    //Tile 3
    url = "seafloor.php";
    boolean [location] relevant_locations = {$location[the caliginous abyss]:true};

    sea_monkey_subentry.header = monkees_quest_state.quest_name;
    need_minus_combat_modifier = false;


    if (should_output_sea_monkey_questline) {
        if (monkees_quest_state.mafia_internal_step == 13) {
            //Have black glass; only need to find mom. No progress tracking yet (the progress mechanic for this zone is not yet fully understood...)
            string line;
            line += "Adventure in the Caliginous Abyss. Find Mom Sea Monkey.";
            if ($item[shark jumper].equipped_amount() == 0)
                line += "|*Wear a shark jumper to speed up area.";
            if ($item[scale-mail underwear].equipped_amount() == 0)
                line += "|*Wear a scale-mail underwear to speed up area.";
            if ($effect[Jelly Combed].have_effect() == 0)
                line += "|*Use a Comb jelly to speed up area.";

            sea_monkey_subentry.entries.listAppend(line);

            if ($item[black glass].equipped_amount() == 0) {
                url = "inventory.php?ftext=black+glass";
                sea_monkey_subentry.entries.listAppend("Equip the black glass.");
            }
        } else if (monkees_quest_state.mafia_internal_step == 12) {
            url = "monkeycastle.php?who=2";
            sea_monkey_subentry.modifiers.listAppend("13 sand dollars");
            sea_monkey_subentry.entries.listAppend('"Buy" the black glass from big brother. Will get a full refund.');
            
            int sand_dollars = $item[sand dollar].item_amount();
            if (sand_dollars < 13)
                sea_monkey_subentry.entries.listAppend("Have " + sand_dollars.pluralise("sand dollar", "sand dollars") + " on hand.");
        } else if (monkees_quest_state.mafia_internal_step == 11) {
            //Discover the existence of the black glass
            url = "monkeycastle.php";
            sea_monkey_subentry.entries.listAppend("Talk to big brother.");
        } else if (monkees_quest_state.mafia_internal_step == 10) {
            //Lil' bro caught big bro acting weird, and it's not linked to puberty...
            url = "monkeycastle.php";
            sea_monkey_subentry.entries.listAppend("Talk to little brother.");
        } else if (monkees_quest_state.mafia_internal_step == 9) {
            //assembled grandma's map, now to find her
            need_minus_combat_modifier = true;
            relevant_locations[$location[the mer-kin outpost]] = true;
            sea_monkey_subentry.entries.listAppend("Adventure at the mer-kin outpost, find grandma.");
        } else if (monkees_quest_state.mafia_internal_step == 8 || !temple_quest_state.state_boolean["have one outfit"] && monkees_quest_state.mafia_internal_step == 7) {
            //7=unlocked outpost, but didn't find grandma's note. 8=found grandma's note
            string line = "Optionally, rescue grandma.|";
            item [int] missing_items = $items[Grandma's Chartreuse Yarn,Grandma's Fuchsia Yarn,Grandma's Note].items_missing();
            
            if (missing_items.count() == 0) {
                url = "monkeycastle.php?who=3";
                line += "Ask grandpa about the note.";
            } else {
                need_minus_combat_modifier = true;
                relevant_locations[$location[the mer-kin outpost]] = true;
                line += "Adventure at the mer-kin outpost, find " + missing_items.listJoinComponents(", ", "and") + ".";
            }
            sea_monkey_subentry.entries.listAppend(line);
        } else
            should_output_sea_monkey_questline = false;
    }

    if (need_minus_combat_modifier)
        sea_monkey_subentry.modifiers.listAppend("-combat");

    if (should_output_sea_monkey_questline)
        optional_task_entries.listAppend(ChecklistEntryMake(monkees_quest_state.image_name, url, sea_monkey_subentry, relevant_locations).ChecklistEntrySetIDTag("Sea monkey branch quest"));


    //Tile 4
    if (monkees_quest_state.state_string["skate park status"] == "war") { //map purchased, and conflict still ongoing
        skate_park_subentry.header = "Sea Side Story";
        skate_park_subentry.modifiers.listAppend("-combat");

        int [item] skate_park_ncs_progress = { $item[skate blade]:0, $item[brand new key]:0, $item[skate board]:0 };

        //Match NC names to prevent other NCs interfering with tracking:
        int [item] [string] noncombat_names;
        noncombat_names[$item[skate blade]]["Prayer of the Roller Skates"] = 1;
        noncombat_names[$item[skate blade]]["Rollerbawl"] = 2;
        noncombat_names[$item[skate blade]]["Holey Rollers"] = 3; //park now ice
        noncombat_names[$item[brand new key]]["The Onbringing"] = 1;
        noncombat_names[$item[brand new key]]["Choreography Amongst the Coral"] = 2;
        noncombat_names[$item[brand new key]]["The Last of the Ice Skates"] = 3; //park now roller
        noncombat_names[$item[skate board]]["A Boarding Party"] = 1;
        noncombat_names[$item[skate board]]["A Board of Education"] = 2;
        noncombat_names[$item[skate board]]["A Boarding Pass"] = 3; //park now peace
        foreach faction_weapon, nc in noncombat_names {
            if ($location[The Skate Park].noncombat_queue.contains_text(nc))
                skate_park_ncs_progress[faction_weapon] = MAX(skate_park_ncs_progress[faction_weapon], noncombat_names[faction_weapon][nc]);
        }
        
        int highest_progress_seen;
        item [int] factions_at_highest_progress;

        foreach faction_weapon, faction_progress in skate_park_ncs_progress {
            if (faction_progress >= highest_progress_seen && faction_progress > 0) {
                if (faction_progress > highest_progress_seen) {
                    factions_at_highest_progress.listClear();
                    highest_progress_seen = faction_progress;
                }
                factions_at_highest_progress.listAppend(faction_weapon);
            }
        }

        string [int] factions;

        foreach faction_weapon, faction_progress in skate_park_ncs_progress {
            string line;

            line += "• Use a " + faction_weapon.name + " for ";

            if (faction_weapon == $item[skate blade])
                line += "Fishy";
            else if (faction_weapon == $item[brand new key])
                line += "-30% pressure penalty (not recommended)";
            else if (faction_weapon == $item[skate board])
                line += "1 sand dollar/combat, +25% item drop and +10 fam weight (all 3 apply in underwater zones only)";

            if (faction_weapon.equipped_amount() > 0 && $slot[weapon].equipped_item() != faction_weapon)
                line += "<br>" + HTMLGenerateSpanFont("Weapon needs to be in your " + (faction_weapon.weapon_hands() > 1 ? "HANDS" : "MAIN-hand"), "red");

            factions.listAppend(line.HTMLGenerateSpanFont(highest_progress_seen > 0 && highest_progress_seen > faction_progress && faction_weapon.equipped_amount() == 0 ? "gray" : "dark"));
        }

        skate_park_subentry.entries.listAppend("Adventure in A Rumble Near the Fountain with a faction's weapon to unlock (a) daily 30 turns buff(s)." + factions.listJoinComponents("<hr>").HTMLGenerateIndentedText());

        if (factions_at_highest_progress.count() > 0)
            skate_park_subentry.entries.listAppend("At " + highest_progress_seen + "/3 NCs with " + factions_at_highest_progress.listJoinComponents(", ", "and") + (factions_at_highest_progress.count() > 1 ? " (will have to make a decision)" : "") + ".");

        optional_task_entries.listAppend(ChecklistEntryMake("Skate Park", "sea_skatepark.php", skate_park_subentry, $locations[The Skate Park]).ChecklistEntrySetIDTag("Sea skate park war quest"));
    }
}
