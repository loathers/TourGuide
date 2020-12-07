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
    
    record CapeConfiguration {
        string hero_name;
        string main_modifiers;
        string [string] tmhmkmkm;
    };
    
    CapeConfiguration [string] cape_configurations = {
        "vampire":new CapeConfiguration(
            "Vampire Slicer",
            "Muscle +30% Maximum HP +50",
            string [string] {
                "hold":"+3 all resistances",
                "thrill":"+3 Muscle stats per fight",
                "kiss":"Skill: Smooch of the Daywalker<br>Drain 20% of your foe's HP",
                "kill":"Skill: Slay the Dead<br>Instakill (costs turn, <font color='red'>Requires sword.</font>)<br>Reduces evil in the The Cyrpt zones by 1%."
            }
        ),
        "heck":new CapeConfiguration(
            "Heck General",
            "Mysticality +30% Maximum MP +50",
            string [string] {
                "hold":"Stuns foes at the start of combat",
                "thrill":"+3 Mysticality stats per fight",
                "kiss":"Skill: Unleash the Devil's Kiss<br>Yellow Ray (100 turn cool down)",
                "kill":"Makes your spells spookier"
            }
        ),
        "robot":new CapeConfiguration(
            "Robot Police",
            "Moxie +30% Maximum HP/MP +25",
            string [string] {
                "hold":"Skill: Deploy Robo-Handcuffs<br>Stagger and delevel by 20% 1x/fight",
                "thrill":"+3 Moxie stats per fight",
                "kiss":"Skill: Blow a Robo-Kiss<br>Deal ~50 sleaze damage",
                "kill":"Skill: Precision Shot<br>Stagger + critical hit (<font color='red'>requires gun</font>)."
            }
        )
    };
    
    CapeConfiguration current_cape = cape_configurations[current_hero];
    
    
    ChecklistSubentry getCurrentCapeConfig() {
        // Title
        string main_title = "Superhero Cape";
        string main_hero = current_cape.hero_name != "" ? current_cape.hero_name : "unknown?";
        main_title += " (" + main_hero + " / " + current_wash + " me)";
        
        // Subtitle
        string subtitle = current_cape.main_modifiers;
        
        // Entries
        string [int] description;
        if (cape_configurations contains current_hero)
            description.listAppend( current_cape.tmhmkmkm[current_wash] );
        
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
        if ( cape_stats != "" && current_wash != "thrill" )
            description.listAppend( HTMLGenerateSpanOfClass("Mainstat exp: ", "r_bold" ) + cape_stats + " + Thrill" );
        
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
