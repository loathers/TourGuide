/* RegisterTaskGenerationFunction("IOTMSuperheroCapeGenerateTasks");
void IOTMSuperheroCapeGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    task_entries.listAppend(ChecklistEntryMake("__item unwrapped knock-off retro superhero cape", "", ChecklistSubentryMake("", "", ""), -11).ChecklistEntrySetIDTag("Superhero cape now"));
} */

RegisterResourceGenerationFunction("IOTMSuperheroCapeGenerateResource");
void IOTMSuperheroCapeGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (!mafiaIsPastRevision(20494)) return;
    if (!lookupItem("unwrapped knock-off retro superhero cape").have()) return;
    
    string current_hero = get_property("retroCapeSuperhero");
    string current_wash = get_property("retroCapeWashingInstructions");
    
    string cape_mods;
    string thrill_ability;
    string hold_ability;
    string kiss_ability;
    string kill_ability;
    
    if ( current_hero == "vampire" ) {
        cape_mods = "Muscle +30% Maximum HP +50";
        hold_ability = "+3 all resistances";
        thrill_ability = "+3 Muscle stats per fight";
        kiss_ability = "Skill: Smooch of the Daywalker<br>Drain 20% of your foe's HP";
        kill_ability = "Skill: Slay the Dead<br>Instakill (costs turn, <font color='red'>Requires sword.</font>)<br>Reduces evil in the The Cyrpt zones by 1%.";
    }
    
    if ( current_hero == "heck" ) {
        cape_mods = "Mysticality +30% Maximum MP +50";
        hold_ability = "Stuns foes at the start of combat";
        thrill_ability = "+3 Mysticality stats per fight";
        kiss_ability = "Skill: Unleash the Devil's Kiss<br>Yellow Ray (100 turn cool down)";
        kill_ability = "Makes your spells spookier";
    }
    
    if ( current_hero == "robot" ) {
        cape_mods = "Moxie +30% Maximum HP/MP +25";
        hold_ability = "Skill: Deploy Robo-Handcuffs<br>Stagger and delevel by 20% 1x/fight";
        thrill_ability = "+3 Moxie stats per fight";
        kiss_ability = "Skill: Blow a Robo-Kiss<br>Deal ~50 sleaze damage";
        kill_ability = "Skill: Precision Shot<br>Stagger + critical hit. (<font color='red'>Requires gun.</font>)";
    }
    
    
    ChecklistSubentry getCurrentCapeConfig() {
        // Title
        string main_title = "Superhero Cape";
        string main_hero = ( current_hero == "vampire" ) ? "Vampire Slicer" :
            ( current_hero == "heck" ) ? "Heck General" :
            ( current_hero == "robot" ) ? "Robot Police" : "unknown?";
        main_title += " (" + main_hero + " / " + current_wash + " me)";
        
        // Subtitle
        string subtitle = cape_mods;

        // Entries
        string [int] description;
        if ( current_wash == "hold" ) {
            string holddsc = hold_ability;
            if ( holddsc != "" )
                description.listAppend( HTMLGenerateSpanOfClass( holddsc, "" ) );
        }
        if (current_wash == "thrill") {
            string thrilldsc = thrill_ability;
            if ( thrilldsc != "" )
                description.listAppend( HTMLGenerateSpanOfClass( thrilldsc, "" ) );
        }
        if ( current_wash == "kiss" ) {
            string kissdsc = kiss_ability;
            if ( kissdsc != "" )
                description.listAppend( HTMLGenerateSpanOfClass( kissdsc, "" ) );
        }
        if ( current_wash == "kill" ) {
            string killdsc = kill_ability;
            if ( killdsc != "" )
                description.listAppend( HTMLGenerateSpanOfClass(killdsc, "" ) );
        }
        
        return ChecklistSubentryMake(main_title, subtitle, description);
    }
    
    
    ChecklistSubentry usefulCapeConfigs() {
        string main_title = "Useful configurations: ";
        string [int] description;
        string cape_stats;
        switch ( my_primestat() ) {
            case $stat[Muscle]:
                cape_stats = "Vampire";
                break;
            case $stat[Mysticality]:
                cape_stats = "Heck";
                break;
            case $stat[Moxie]:
                cape_stats = "Robot";
                break;
        }
        if ( cape_stats != "" )
            cape_stats = HTMLGenerateSpanOfClass("Mainstat exp: ", "r_bold" ) + cape_stats;
            cape_stats += " + Thrill";
        if ( cape_stats != "" && current_wash != "thrill" )
            description.listAppend( cape_stats );
        
        if ( current_hero != "heck" || current_wash != "kiss" )
            description.listAppend( HTMLGenerateSpanOfClass("Yellow ray: ", "r_bold" ) + "Heck + Kiss" );
        if ( current_hero != "vampire" || current_wash != "hold" )
            description.listAppend( HTMLGenerateSpanOfClass("+3 Res: ", "r_bold" ) + "Vampire + Hold" );
        if ( current_hero != "vampire" || current_wash != "kill" )
            description.listAppend( HTMLGenerateSpanOfClass("Instakill / Cyrpt Evil: ", "r_bold" ) + "Vampire + Kill" );



        return ChecklistSubentryMake(main_title, "", description);
    }
    
    
    ChecklistEntry entry;
    entry.image_lookup_name = "__item unwrapped knock-off retro superhero cape";
    entry.url = "inventory.php?action=hmtmkmkm";
    entry.tags.id = "Superhero cape resource";

    ChecklistSubentry ccc = getCurrentCapeConfig();
    if ( ccc.entries.count() > 0 ) {
        entry.subentries.listAppend(ccc);
    }

    ChecklistSubentry ucc = usefulCapeConfigs();
    if ( ucc.entries.count() > 0 ) {
        entry.subentries.listAppend(ucc);
    }

    if ( entry.subentries.count() > 0 ) {
        resource_entries.listAppend(entry);
    }
}
