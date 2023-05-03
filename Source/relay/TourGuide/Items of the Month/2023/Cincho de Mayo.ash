RegisterResourceGenerationFunction("IOTMCinchoDeMayoGenerateResource");
void IOTMCinchoDeMayoGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (lookupItem("Cincho de Mayo").available_amount() == 0) return;
    
    // _cinchUsed is a weird preference that actually means distance from 100% you are at in your current cinch.
    int freeRests = __misc_state_int["free rests remaining"];
    int cinchoRests = get_property_int('_cinchRests');
    int cinchUsed = get_property_int('_cinchUsed');
    
    // Since the pref is weird, this tells you your current total cinch
    int currentCinch = 100 - cinchUsed;

    // Calculating total available cinch requires storing the degradation of rest value
    int [int] cinchLevels = listMake(30,30,30,30,30,25,20,15,10,5);

    // Reiterating current state so the while loop can update it
    int totalCinch = 100 - cinchUsed;
    int rest = cinchoRests;

    // This while loop expands your possible cinch starting at rests you haven't used.
    while (rest < freeRests+1)
			{
                int cinchAmount = rest > count(cinchLevels) ? 5 : cinchLevels[rest];
                totalCinch += cinchAmount;
                rest += 1;
			}

    // This gives you your possible uses of the most powerful skill, Fiesta Exits
    int possibleFiestaExits = floor(totalCinch/60);

    // return if there is no cinch remaining for the homeboys
    if (totalCinch == 0) return;
    
    string [int] description;
    string [int] cinchUses;

    // For each use, check that there's enough cinch remaining to use it before appending.
    if (totalCinch > 25) {
        cinchUses.listAppend("<strong>Dispense Salt & Lime (25%):</strong> Add stats to your next drink."); 
        cinchUses.listAppend("<strong>Party Soundtrack (25%):</strong> 30 advs of +5 fam weight."); 
    }

    if (totalCinch > 5) {
        cinchUses.listAppend("<strong>Confetti Extravaganza (5%):</strong> 2x stats, in-combat");
        cinchUses.listAppend("<strong>Projectile Piñata (5%):</strong> 50 damage, complex candy, in-combat");
        cinchUses.listAppend("<strong>Party Foul (5%):</strong> 100"+HTMLGenerateSpanOfClass(" sleaze ", "r_element_sleaze")+"damage, stun, in-combat");
    }
    
    if (cinchUses.count() > 0)
        description.listAppend("Use <b>free rests</b> to cinch up your belt and cast some cool skills:");
        // Doing this one outside of the large list append, because it's more important.
        if (totalCinch > 60) { 
            description.listAppend("<strong>"+HTMLGenerateSpanOfClass("Fiesta Exit (60%)", "r_element_sleaze")+":</strong> Force a NC on your next adventure. "+HTMLGenerateSpanOfStyle("(Most of your cinch should do this!)", "font-size:0.8em"));
            description.listAppend(`<b>You can do {possibleFiestaExits}x more fiesta exits</b>, with {totalCinch % 60}% leftover cinch`);
        }
        description.listAppend("|*"+ cinchUses.listJoinComponents("<hr>|*"));

    description.listAppend(`You have {totalCinch}% more cinch available, accounting for your {pluralise(freeRests,"free rest","free rests")}.`);

    if (lookupItem("June cleaver").have() && !lookupItem("mother's necklace").have()) {
        description.listAppend("You do "+HTMLGenerateSpanOfClass("not", "r_element_hot")+" have a mother's necklace yet, so you're missing 5 free rests. Be careful of overusing the combat skills!");
    }

    resource_entries.listAppend(ChecklistEntryMake("__item cincho de mayo", "", ChecklistSubentryMake(`{currentCinch}% belt cinch`, "", description), 3).ChecklistEntrySetIDTag("Cincho de Mayo resource"));
}