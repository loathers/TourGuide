// STEPS TO HAVE NC FORCERS IN TILES
//   This will require quite a few things. Things that still need to be done:
//     - we will need to have a way for tourguide to tell that you have an NC forcer up for supernag
//     - we will need to have a tile that shows good NCs to force

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

        final.sneakCondition = __iotms_usable[lookupItem("Eight Days a Week Pill Keeper")];

        // see # of free pillkeeepers remaining
        int freeSneakLeft = get_property_boolean("_freePillKeeperUsed") ? 1 : 0;

        // calculate possible spleen-based sneaks
        int spleenSneaks = floor(spleenRemaining / 3);

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
        final.tileDescription = `<b>{plausibleJellies}x stench jellies</b> (have {clampi(toastCount,0,15)} toast, {clampi(jellyCount,0,15)} spleen)`;
        return final;
    }
    
    SneakSource getSpikos() {
        SneakSource final;

        final.sourceName = 'spikolodon spikes';
        final.url = 'inventory.php?action=jparka';
        final.imageLookupName = "__item jurassic parka";

        int spikosLeft = clampi(5 - get_property_int("_spikolodonSpikeUses"), 0, 5);
        
        final.sneakCondition = lookupItem("jurassic parka").have();
        final.sneakCount = spikosLeft;
        final.tileDescription = `<b>{spikosLeft}x spikalodon spikes</b> left`;
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
        final.sneakCondition = lookupItem("Cincho de Mayo").have();

        // In the most recent draft of the PR (located here https://github.com/kolmafia/kolmafia/pull/1685 )
        //   the prefs are _cinchUsed for the amount of cinch used and _cinchRests for the amount 
        //   of rests you've done with your cincho. 

        int freeRests = __misc_state_int["free rests remaining"];
        int cinchoRests = get_property_int('_cinchRests');
        int cinchUsed = get_property_int('_cinchUsed');

        // Calculating total available cinch

        int [int] cinchLevels = listMake(30,30,30,30,30,25,20,15,10,5);

        int totalCinch = 100 - cinchUsed;
        int rest = 0;

        while (rest < freeRests+1)
			{
				int cinchAmount = rest > count(cinchLevels) ? 5 : cinchLevels[rest];
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
	entry.image_lookup_name = "";
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
            entry.image_lookup_name = sneaker.imageLookupName;
            entry.url = sneaker.url;

            line += "|*"+sneaker.tileDescription;
        }

    }


    if (totalSneaks == 0) return;

    description.listAppend(line);

    entry.subentries.listAppend(ChecklistSubentryMake(pluralise(totalSneaks, "sneak usable", "sneaks usable"), "", description));

    if (entry.subentries.count() > 0) resource_entries.listAppend(entry);

}