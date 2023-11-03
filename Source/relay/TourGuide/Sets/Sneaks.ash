// STEPS TO HAVE NC FORCERS IN TILES
//   This will require quite a few things. In order:
//     - we will need to have a way for tourguide to tell that you have an NC forcer up for supernag
//     - we will need to have a tile that shows good NCs to force
//     - we will need to append NC forcers available to this 

// SYNTAX FOR NEW NC FORCERS
//   In order to centralize, all NC forcers that were old were placed in this file. They utilize a
//   new record type that should make it mildly easier to loop through the lot.

    record SneakSource {
        string sourceName;
        string url;
        string imageLookupName;
        boolean sneakCondition;
        int sneakCount;
        string tileDescription;
    };

RegisterResourceGenerationFunction("SocialDistanceGenerator");
void SocialDistanceGenerator(ChecklistEntry [int] resource_entries)
{
    // Saving some useful variables for use in the calculations.
    int spleenRemaining = spleen_limit() - my_spleen_use();
    int stomachLeft = availableFullness();
 
    SneakSource getSneakisol() {
        SneakSource final;

        final.sourceName = "sneakisol";
        final.url = "main.php?eowkeeper=1";
        final.imageLookupName = "__item Eight Days a Week Pill Keeper";

        // see # of free pillkeeepers remaining
        int freeSneakLeft = get_property_boolean("_freePillKeeperUsed") ? 1 : 0;

        // calculate possible spleen-based sneaks
        int spleenSneaks = floor(spleenRemaining / 3);

        // usable if we have pill keeper plus free sneaks or spleen sneaks available
        final.sneakCondition = __iotms_usable[lookupItem("Eight Days a Week Pill Keeper")] && (freeSneakLeft + spleenSneaks > 0);

        final.sneakCount = freeSneakLeft + spleenSneaks;
        final.tileDescription = get_property_boolean("_freePillKeeperUsed") ? "" : `<b>1x free sneak, </b>`;
        final.tileDescription = final.tileDescription + `<b>{spleenSneaks}x sneaks</b> for 3 spleen each`;
        return final;
    }

    SneakSource getStenchJellies() {
        SneakSource final;

        final.sourceName = "stench jelly";
        final.url = "";
        final.imageLookupName = "__familiar space jellyfish";

        // You can get more than 3 in a run, but 3 is a good fairway estimate.
        int likelyJellies = 3;

        // Check if the familiar is usable & you have jellies in your inventory
        boolean canUseJellyfish = $familiar[space jellyfish].familiar_is_usable();
        int jellyCount = $item[stench jelly].available_amount();
        int toastCount = $item[toast with stench jelly].available_amount();

        // Check that you don't have full organs
        int numberOfJelliesConsumable = min(stomachLeft + spleenRemaining, jellyCount + toastCount);

        // Compare current extractions to the likelyJellies variable
        int currentExtractions = get_property_int("_spaceJellyfishDrops");
        int plausibleJellies = max(currentExtractions - likelyJellies, numberOfJelliesConsumable);

        // This is an or because it's possible to pull a stench jelly
        final.sneakCondition = canUseJellyfish || plausibleJellies > 0;

        // Use plauisible jellies here, to make sure it's added if it's possible
        final.sneakCount = plausibleJellies;
        final.tileDescription = `<b>{plausibleJellies}x stench jellies</b> (have {clampi(toastCount,0,15)} on toast, {clampi(jellyCount,0,15)} as jelly)`;
        return final;
    }
    
    SneakSource getSpikos() {
        SneakSource final;

        final.sourceName = 'spikolodon spikes';
        final.url = 'inventory.php?action=jparka';
        final.imageLookupName = "__item jurassic parka";

        int spikosLeft = clampi(5 - get_property_int("_spikolodonSpikeUses"), 0, 5);
        
        final.sneakCondition = __iotms_usable[$item[Jurassic Parka]];
        final.sneakCount = spikosLeft;
        final.tileDescription = `<b>{spikosLeft}x spikolodon spikes</b> left`;
        return final;

    }
    
    SneakSource getClaras() {
        SneakSource final;

        final.sourceName = `clara's bell`;
        final.url = '';
        final.imageLookupName = "__item clara's bell";

        final.sneakCondition = $item[clara's bell].available_amount() > 0 && !get_property_boolean("_claraBellUsed");
        final.sneakCount = get_property_boolean("_claraBellUsed") ? 0 : 1; 
        final.tileDescription = `<b>{final.sneakCount}x clara's bell</b> charge left`;

        return final;
    }
    
    SneakSource getCinchos() {
        SneakSource final;

        final.sourceName = `fiesta exits`;
        final.url = '';
        final.imageLookupName = "__skill Cincho: Fiesta Exit";
        final.sneakCondition = __iotms_usable[$item[Cincho de Mayo]];

        // _cinchUsed is a weird preference that actually means distance from 100% you are at in your current cinch.

        int freeRests = __misc_state_int["total free rests possible"];
        int cinchoRests = get_property_int('_cinchoRests');
        int cinchUsed = get_property_int('_cinchUsed');

        // Resting when Cincho is full might burn some of the Cincho rests
        int freeRestsRemaining = __misc_state_int["free rests remaining"];
        freeRests = min(freeRests, cinchoRests + freeRestsRemaining);

        // Calculating total available cinch

        int [int] cinchLevels = listMake(30,30,30,30,30,25,20,15,10,5);

        // Since the pref is weird, this tells you your current total cinch
        int totalCinch = 100 - cinchUsed;
        int rest = cinchoRests;

        // This while loop expands your possible cinch starting at rests you haven't used.
        while (rest < freeRests)
			{
                int cinchAmount = rest >= count(cinchLevels) ? 5 : cinchLevels[rest];
                totalCinch += cinchAmount;
                rest += 1;
			}

        int possibleFiestaExits = floor(totalCinch/60);

        final.sneakCount = possibleFiestaExits;
        final.tileDescription = `<b>{possibleFiestaExits}x fiesta exits</b>, with {totalCinch % 60} leftover cinch`;
        return final;
    }

    // Having generated these, we now get to generate a tile that combines them.

    SneakSource [string] sneakSources;

    sneakSources["cinco"] = getCinchos();
    sneakSources["spiko"] = getSpikos(); 
    sneakSources["jello"] = getStenchJellies();
    sneakSources["pillo"] = getSneakisol();
    sneakSources["claro"] = getClaras();

    // Making it use the order we want; almost most recent to oldest, but pills on the bottom.
    string [int] sneakOrder = listMake("cinco","spiko","jello","claro","pillo");

    ChecklistEntry entry;
    
	entry.url = "";
	entry.image_lookup_name = "__effect Feeling Sneaky";
    entry.tags.id = "Sneak sources available";
    entry.importance_level = -2;

    string [int] description;
    int totalSneaks = 0;

    string line = HTMLGenerateSpanOfClass("Force an NC with sneaky tricks!", "r_bold r_element_stench_desaturated");

    foreach it, sneakType in sneakOrder
    {
        SneakSource sneaker = sneakSources[sneakType];
        if (sneaker.sneakCount > 0 && sneaker.sneakCondition) {
            totalSneaks += sneaker.sneakCount;
            entry.url = sneaker.url;

            line += "|*"+sneaker.tileDescription;
        }

    }

    if (totalSneaks == 0) return;

    // Append all the lines to a description
    description.listAppend(line);

    // Store the base description within the mouseover subentries
    entry.subentries_on_mouse_over.listAppend(ChecklistSubentryMake(pluralise(totalSneaks, "sneak usable", "sneaks usable"), "", description));
    
    // Add a description that falls away when you hoverover
    entry.subentries.listAppend(ChecklistSubentryMake(pluralise(totalSneaks, "sneak usable", "sneaks usable"), "", description));

    // OK, now we're going to make a big table with the NC recommendations. Yeesh. 
    //   This tile is complicated, dude! First, start by initializing variables. 
    //   Ezan's table creators are formatted as string[int][int], where the first
    //   is the row and the second is the column... I think?

    int totalNCsRemaining = 0;
    string [int][int] table;

    // In the synth tile, Ezan populates table_lines and builds out from there. I
    //   am doing the same because I don't fully understand the syntax.
    string [int] tableLines;

    // This is a function that generates the right format for the table. Basically,
    //   it ingests the table title + a separated list of all sneak opportunities in
    //   that summarized title. 
    string populateSneakTable(string title, string [int] desc) {
        string finalDesc = "";

        // If nothing got added, just add an "all done!" to make the user feel better
        if (desc.count() == 0) finalDesc = "All done!";

        // Have to add line breaks here.
        foreach k, d in desc {
            finalDesc += d+"<br>";
        }

        // Finally, generate a little sub-tile that looks like this:
        
        //   NAME OF SNEAKS
        //   1 sneaksource
        //   1 sneaksource

        // Where the name is bold and the sneaksources are tiny. In some future world,
        // it might be nice to have coloring that grays those that are not available 
        // yet, but that is too much for this first implementation.
        return HTMLGenerateSpanOfClass(title, "r_bold") + "<br>" + HTMLGenerateSpanOfStyle(finalDesc, "font-size:0.8em");
    }

    // We aren't going to do a loop here; we're just going to populate table_lines
    //   semi-manually, using logic that is roughly correct in each case.

    // START = DELAY SNEAKS
    //   1x hidden apartment
    //   1x hidden office

    // Initialize your string-int array of the sneaks.
    string [int] sneakDelay;

    // You want to use prefs when possible to isolate that the user can use that sneak, then append to sneakDelay
    if (get_property_int("hiddenApartmentProgress") < 7) sneakDelay.listAppend("1 hidden apartment");
    if (get_property_int("hiddenOfficeProgress") < 7) sneakDelay.listAppend("1 hidden office");

    // Populate the sneaky table.
    tableLines[1] = populateSneakTable("Delay Zones", sneakDelay);

    // Add the detected NCs to your total NCs remaining.
    totalNCsRemaining += sneakDelay.count();

    // NEXT = 95% COMBAT SNEAKS
    //   12x friars NCs (-1 w/ carto)
    //    1x castle basement
    //    1x castle top

    string [int] sneak95;

    // Ripping some code from the friars tile to count NCs encountered. First, names of the relevant NCs.
    boolean [string] necks_known_ncs = $strings[How Do We Do It? Quaint and Curious Volume!,Strike One!,Olive My Love To You\, Oh.,Dodecahedrariffic!];
    boolean [string] heart_known_ncs = $strings[Moon Over the Dark Heart,Running the Lode,I\, Martin,Imp Be Nimble\, Imp Be Quick];
    boolean [string] elbow_known_ncs = $strings[Deep Imp Act,Imp Art\, Some Wisdom,A Secret\, But Not the Secret You're Looking For,Butter Knife?  I'll Take the Knife];
    
    // Then, a tiny function to count the NCs found by zone for friars.
    int countFriarNCs(boolean [string] known_ncs, location place) {
        int ncs_found = 0;

        if (known_ncs.count() > 0) {
            string [int] location_ncs = place.locationSeenNoncombats();

            foreach key, s in location_ncs
            {
                if (known_ncs contains s) ncs_found += 1;
            }
        }

        return ncs_found;

    }

    // You can remove one from the needed NCs if they have carto in their run.
    int cartoAdjustment = lookupSkill("Comprehensive Cartography").have_skill() ? 1 : 0;

    // Right now I think the raw logic off; I noted in the discord that we are having some small issues with
    //   it showing extra NCs in a few places. Not really sure what's up with that? An easy fix is to
    //   just set all of these to 0 in the event that questL06Friar = 'finished' -- I've implemented
    //   this fix, but I do think it's worth solving this at some point.

    int questPropMin = get_property('questL06Friar') == 'finished' ? 0 : 4;
    
    int necksNCsLeft = min(4 - countFriarNCs(necks_known_ncs, $location[The Dark Neck of the Woods]) - cartoAdjustment, questPropMin);
    int heartNCsLeft = min(4 - countFriarNCs(heart_known_ncs, $location[The Dark Heart of the Woods]), questPropMin);
    int elbowNCsLeft = min(4 - countFriarNCs(elbow_known_ncs, $location[The Dark Elbow of the Woods]), questPropMin);

    // Also correcting total NCs left here; we are using a "count" for this, and thus we only get 1
    //   out of however many NCs actually are left in these zones, because it just counts the elements
    //   in the list rather than the # prepending the element in the list.
    if (necksNCsLeft > 0) {
        sneak95.listAppend(`{necksNCsLeft} Dark Neck`);
        totalNCsRemaining += necksNCsLeft-1;
    }
    if (heartNCsLeft > 0) {
        sneak95.listAppend(`{heartNCsLeft} Dark Heart`);
        totalNCsRemaining += heartNCsLeft-1;
    }
    if (elbowNCsLeft > 0) {
        sneak95.listAppend(`{elbowNCsLeft} Dark Elbow`);
        totalNCsRemaining += elbowNCsLeft-1;
    }
    
    // If the pref is any of these, you can still sneak the basement.
    boolean [string] canSneakBasement = $strings[unstarted,started,step1,step2,step3,step4,step5,step6,step7];

    if (canSneakBasement contains get_property("questL10Garbage")) sneak95.listAppend("1 castle basement");

    // If the quest is unfinished, you can sneak the top floor.
    if (get_property("questL10Garbage")!= "finished") sneak95.listAppend("1 castle top floor");

    tableLines[2] = populateSneakTable("95% Combat", sneak95);

    totalNCsRemaining += sneak95.count();

    // NEXT = 90% COMBAT SNEAKS
    //    1x spookyraven bedroom
    //    1x spookyraven bathroom

    string [int] sneak90;

    // I don't really think I need to import this but I'm tired and copy/pasting logic from the spookyraven tile seems fine.
    QuestState dance_quest_state;
    QuestStateParseMafiaQuestProperty(dance_quest_state, "questM21Dance");
    if ($item[Lady Spookyraven's powder puff].available_amount() == 0 && dance_quest_state.mafia_internal_step < 4) sneak90.listAppend("1 spookyraven bathroom");
    if ($item[Lady Spookyraven's dancing shoes].available_amount() == 0 && dance_quest_state.mafia_internal_step < 4) sneak90.listAppend("1 spookyraven gallery");

    tableLines[3] = populateSneakTable("90% Combat", sneak90);

    totalNCsRemaining += sneak90.count();

    // Here is how Ezan built the lines into a table. It's kind of cute. First, make a placeholder "builder" line.
    string [int] building_line;
    foreach key in tableLines
    {
        // For each key, you append it to the empty building lines.
        building_line.listAppend(tableLines[key]);

        // However, if the key is even, you append to the table. This works, because you are appending a two-element
        //   item into the table, so it creates a string [int] that creates a row in the table.
        if (key % 2 == 1)
        {
            table.listAppend(building_line);

            // Then, you clear out the building line, to reset the next table row
            building_line = listMakeBlankString();
        }
    }
    // Then, at the end, you append the remainder to the table.
    if (building_line.count() > 0)
        table.listAppend(building_line);

    // Having done this, you now append the NCs remaining subentry to the end of the core entry, with an on_mouse_over bit as well.

    // However, I am going to be lazy, and not append either of these in the event the user is in CS/GG.
    if (my_path().id != PATH_COMMUNITY_SERVICE && my_path().id != PATH_GREY_GOO) {
        entry.subentries.listAppend(ChecklistSubentryMake(pluralise(totalNCsRemaining, "NC remaining","NCs remaining"), "", HTMLGenerateSpanOfClass("Mouse over for the best sneaks!", "r_bold r_element_spooky_desaturated")));
        entry.subentries_on_mouse_over.listAppend(ChecklistSubentryMake(pluralise(totalNCsRemaining, "NC remaining","NCs remaining"), "", table.HTMLGenerateSimpleTableLines(false)));
    }

    if (entry.subentries.count() > 0) resource_entries.listAppend(entry);

}

RegisterTaskGenerationFunction("SneakActiveTask");
void SneakActiveTask(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    // Use the new preference to tell if there's an NC forcer active
    if (!get_property_boolean("noncombatForcerActive")) return;
    
    // If you are forcing an NC, build the reminder
    ChecklistEntry entry;
    
	entry.url = "";
	entry.image_lookup_name = "__effect Feeling Sneaky";
    entry.tags.id = "Active sneak reminder";
    entry.importance_level = -11;

    entry.subentries.listAppend(ChecklistSubentryMake("Noncombat up next","","You're feeling sneaky; a noncombat will occur in the next zone where an NC is available. Don't waste it!")); 

    task_entries.listAppend(entry);
}