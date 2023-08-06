// August Scepter tile creation. This is... an annoying item.

// Start by associating skill names with the associated cast check variable
static {
    string [string] __augSkillsToVars;
    void initializeAugustSkills() {
        __augSkillsToVars["Aug. 1st: Mountain Climbing Day!"] = "_aug1Cast";            // turnbloat (+3)
        __augSkillsToVars["Aug. 2nd: Find an Eleven-Leaf Clover Day"] = "_aug2Cast";    // lucky!
        __augSkillsToVars["Aug. 3rd: Watermelon Day!"] = "_aug3Cast";                   // skip, though it could be good for some i guess
        __augSkillsToVars["Aug. 4th: Water Balloon Day!"] = "_aug4Cast";                // skip
        __augSkillsToVars["Aug. 5th: Oyster Day!"] = "_aug5Cast";                       // skip
        __augSkillsToVars["Aug. 6th: Fresh Breath Day!"] = "_aug6Cast";                 // +com for ninjas
        __augSkillsToVars["Aug. 7th: Lighthouse Day!"] = "_aug7Cast";                   // +50 item/+100 meat
        __augSkillsToVars["Aug. 8th: Cat Day!"] = "_aug8Cast";                          // skip
        __augSkillsToVars["Aug. 9th: Hand Holding Day!"] = "_aug9Cast";                 // mild sniff
        __augSkillsToVars["Aug. 10th: World Lion Day!"] = "_aug10Cast";                 // banish skill (non-free)
        __augSkillsToVars["Aug. 11th: Presidential Joke Day!"] = "_aug11Cast";          // myst stats
        __augSkillsToVars["Aug. 12th: Elephant Day!"] = "_aug12Cast";                   // mus stats
        __augSkillsToVars["Aug. 13th: Left/Off Hander's Day!"] = "_aug13Cast";          // double lewd deck in softcore
        __augSkillsToVars["Aug. 14th: Financial Awareness  Day!"] = "_aug14Cast";       // skip; extra space?
        __augSkillsToVars["Aug. 15th: Relaxation Day!"] = "_aug15Cast";                 // skip
        __augSkillsToVars["Aug. 16th: Roller Coaster Day!"] = "_aug16Cast";             // -full & +food for spookyraven
        __augSkillsToVars["Aug. 17th: Thriftshop Day!"] = "_aug17Cast";                 // -1000 meat on your kitchen
        __augSkillsToVars["Aug. 18th: Serendipity Day!"] = "_aug18Cast";                // i cannot believe this terrible thing is now meta
        __augSkillsToVars["Aug. 19th: Honey Bee Awareness Day!"] = "_aug19Cast";        // skip
        __augSkillsToVars["Aug. 20th: Mosquito Day!"] = "_aug20Cast";                   // skip
        __augSkillsToVars["Aug. 21st: Spumoni Day!"] = "_aug21Cast";                    // allstats but skip i think
        __augSkillsToVars["Aug. 22nd: Tooth Fairy Day!"] = "_aug22Cast";                // free tooth monster
        __augSkillsToVars["Aug. 23rd: Ride the Wind Day!"] = "_aug23Cast";              // mox stats
        __augSkillsToVars["Aug. 24th: Waffle Day!"] = "_aug24Cast";                     // 3 macros this rules
        __augSkillsToVars["Aug. 25th: Banana Split Day!"] = "_aug25Cast";               // skip
        __augSkillsToVars["Aug. 26th: Toilet Paper Day!"] = "_aug26Cast";               // skip the sgeea-like, it is not worth it in a post-on-the-trail world
        __augSkillsToVars["Aug. 27th: Just Because Day!"] = "_aug27Cast";               // crazy horse for crazy folks
        __augSkillsToVars["Aug. 28th: Race Your Mouse Day!"] = "_aug28Cast";            // +10 fam weight melting fam equip; skip if they have pet sweater?
        __augSkillsToVars["Aug. 29th: More Herbs, Less Salt  Day!"] = "_aug29Cast";     // skip; extra space?
        __augSkillsToVars["Aug. 30th: Beach Day!"] = "_aug30Cast";                      // +7 adv melting equip; turnbloat
        __augSkillsToVars["Aug. 31st: Cabernet Sauvignon  Day!"] = "_aug31Cast";        // booze drops + good booze. also, extra space?
    }
    initializeAugustSkills();
}

// Convert the user's mainstat to an August statgain skill
int mainstatAugustSkill() {
    switch (my_primestat()) 
    {
        case $stat[muscle]:
            return 12; // "Aug. 12th: Elephant Day!"
        case $stat[mysticality]:
            return 11; // "Aug. 11th: Presidential Joke Day!"
        case $stat[moxie]:
            return 23; // "Aug. 23rd: Ride the Wind Day!"
    }
}

// Helper function to grab the first # in the string
int grabNumber(string s){
    matcher numMatcher = create_matcher("\\d+",s);
    if (numMatcher.find()){
        return numMatcher.group(0).to_int();
    } else {
        return 0;
    }
}

RegisterResourceGenerationFunction("IOTMAugustScepterGenerateResource");
void IOTMAugustScepterGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (!__iotms_usable[lookupItem("August Scepter")]) return;

    // Figure out how many of your five skills are still available; no tile if none are there!
    int skillsAvailable = 5 - get_property_int("_augSkillsCast");
    if (skillsAvailable < 1) return;

    // Initialize a list of "used" skills for tooltip purposes later.
    string [int] usedAugustSkills;

    // Similar to calculate the universe, store reasons why things have value while using 
    //   the day as the key. Should make the tile less painful to read, though a bit more
    //   confusing. Will *definitely* need a little summary text.
    string [int] usefulAugustSkills;

    foreach augSkillName, augSkillPref in __augSkillsToVars {

        // Convert text to number. You could argue that I should've just initially stored
        //   them as ints, but I wanted to store full skill names just in case we see a
        //   good use case for the full skill names later.
        int augSkillNumber = grabNumber(augSkillName);

        // For these particularly mediocre/bad skills, don't even look up the pref. This covers 12/31 skills
        if ($ints[3, 4, 5, 8, 14, 15, 19, 20, 21, 25, 26, 29] contains augSkillNumber) continue;

        // Skip the tile-creation logic for that guy if the skill has already been cast.
        if (get_property_boolean(augSkillPref)) {
            usedAugustSkills.listAppend(augSkillName);
            continue;
        }

        // Within this foreach, add descriptions for the valuable casts, if they're still 
        //   valuable to the player. 

        // LEVELING HELP; gain 50*level mainstats. 12, 11, 23 for 15/31 skills
        if (__misc_state["need to level"]) {

            if (augSkillNumber == mainstatAugustSkill()) {
                int statsGained = (50 * my_level() * (1.0 + numeric_modifier(my_primestat().to_string() + " Experience Percent") / 100.0)).floor();
                usefulAugustSkills[augSkillNumber] = "+"+statsGained+" mainstat";
            }

        }

        // TURNBLOAT; baywatch (30) + spirit (1) for 17/31 skills
        if (my_path() != $path[Slow and Steady]) {

            // Only show mountain effect if they need goat cheese, as there aren't many mountains in-run.
            if ($item[goat cheese].available_amount() < 2 && !__quest_state["Level 8"].state_boolean["Past mine"]) {
                if (augSkillNumber == 1) {
                    usefulAugustSkills[1] = "+2-5 turns "+HTMLGenerateSpanFont("(spend turns @ the Goatlet)", "gray", "0.9em");
                }
            }

            if (augSkillNumber == 30) {
                usefulAugustSkills[30] = "+7 advs rollover accessory"+HTMLGenerateSpanFont("(melting)", "gray", "0.9em");
            }
        }

        // +ITEM BUFFS; food/booze/base, with 31, 16, and 7. 20/31 skills

        boolean manorCheck = __quest_state["Level 11 Manor"].mafia_internal_step < 3 && __quest_state["Level 11 Manor"].state_boolean["Can use fast route"];
        string blastingAddendum = manorCheck && $item[blasting soda].available_amount() == 0 ? HTMLGenerateSpanFont("(blasting soda!)", "gray", "0.9em") : "";
        
        // I suppose -1 fullness is always good for turnbloat?
        if (augSkillNumber == 16) usefulAugustSkills[16] = "-1 fullness, +100% food drop "+blastingAddendum;

        if (manorCheck) {
            // Only need booze drop if you don't already have vinegar
            if ($item[bottle of Chateau de Vinegar].available_amount() == 0) {
                if (augSkillNumber == 31) usefulAugustSkills[31] = "+100% booze drop liquor "+HTMLGenerateSpanFont("(Chateau de Vinegar!)", "gray", "0.9em");
            }

        } 

        // +item is always good times
        if (augSkillNumber == 7) usefulAugustSkills[7] = "+50% item, +100% meat "+HTMLGenerateSpanFont("(30 turns)", "gray", "0.9em");

        // LUCKY!; 2, but important! 21/31 skills

        // WAFFLES!; 24, but the best guy here. 22/31

        // SERENDIPITY; cannot believe august 18th is the new meta 23/31

        // FREE TOOTH MONSTER; lol what the actual heck (22) 24/31 

        // +COM FOR NINJAS; kind of a crock but why not (6) 25/31

        // HAND HOLDING; we still don't know exactly what this does (9) 26/31

        // LION BANISH; definitely worth calling out; NOT a killbanish (10) 27/31

        // OFFHAND DOUBLER; wild stuff folks (13) 28/31

        // SAVE 1000 MEAT; barely useful only show if they're strapped (17) 29/31

        // CRAZY HORSE RETURNS; just because (27) 30/31

        // +10 FAM WEIGHT; this won't appear in modern standard lol (28) 31/31 
    }

    string [int][int] table;
    table.listAppend(listMake(HTMLGenerateSpanOfClass("Day", "r_bold"), HTMLGenerateSpanOfClass("Result", "r_bold")));

    foreach day, reason in usefulAugustSkills {
        table.listAppend(listMake(day.to_string(), reason));
    }

    string table_description = "";
    if (table.count() > 0)
        table_description += "|*" + HTMLGenerateSimpleTableLines(table);
    
    // Summary of the august tile
    string summarizeAugust = "Celebrate August tidings with your cherished scepter; cast skills corresponding to the given day to get valuable buffs, items, and benefits.";
    
    if (table_description != "")
        description.listAppend(summarizeAugust + table_description);
    else
        description.listAppend(summarizeAugust);

    string title = "Cast "+pluralise(skillsAvailable, "August Scepter skill", "August Scepter skills");
    
    resource_entries.listAppend(ChecklistEntryMake("__item August Scepter", "skillz.php", ChecklistSubentryMake(title, "", description), -1).ChecklistEntrySetIDTag("August Scepter resource"));

}