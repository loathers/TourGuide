/* RegisterTaskGenerationFunction("IOTMSuperheroCapeGenerateTasks");
void IOTMSuperheroCapeGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    task_entries.listAppend(ChecklistEntryMake("__item unwrapped knock-off retro superhero cape", "", ChecklistSubentryMake("", "", ""), -11).ChecklistEntrySetIDTag("Superhero cape now"));
} */

RegisterResourceGenerationFunction("IOTMSuperheroCapeGenerateResource");
void IOTMSuperheroCapeGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (!mafiaIsPastRevision(20494)) return;
    item cape = lookupItem("unwrapped knock-off retro superhero cape");
    if (!__iotms_usable[$item[unwrapped knock-off retro superhero cape]]) return;
    
    if (!__misc_state["in run"]) return; //Only relevant information in aftercore is YR, but the YR tile will already mention the cape if needed anyway, in aftercore.
    
    // Not too sure if this should even be kept? There's no real precedent of Guide showing a resource that "never ends"...
    // We could make a new section that lists a player's possessions and everything special related to them, and this would go there, but currently... not too sure...
    // To be clear, I'm not saying this should be erased, just... commented out for the time being? IDK...
    
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
            "+30% muscle, +50 HP",
            string [string] {
                "hold":"+3 all resistances",
                "thrill":"+3 muscle stats/fight",
                "kiss":"Skill: Smooch of the Daywalker|Drain 20% of your foe's HP",
                "kill":"Skill: Slay the Dead|Undead insta-bone (NOT free kill, <font color='red'>requires sword</font>).|+1% Cyrpt evilness reduction."
            }
        ),
        "heck":new CapeConfiguration(
            "Heck General",
            "+30% myst, +50 MP",
            string [string] {
                "hold":"Auto 3 rounds stun at start of combats",
                "thrill":"+3 myst stats/fight",
                "kiss":"Skill: Unleash the Devil's Kiss|Yellow Ray (100 turns)",
                "kill":"+100% (multiplicative) spell dmg, dealt as spooky dmg"
            }
        ),
        "robot":new CapeConfiguration(
            "Robot Police",
            "+30% moxie, +25 HP/MP",
            string [string] {
                "hold":"Skill: Deploy Robo-Handcuffs|Stagger + 20% delevel 1x/fight",
                "thrill":"+3 moxie stats/fight",
                "kiss":"Skill: Blow a Robo-Kiss<br>Deal ~50 sleaze damage",
                "kill":"Skill: Precision Shot|Stagger + critical hit (<font color='red'>requires gun</font>)."
            }
        )
    };
    
    CapeConfiguration current_cape = cape_configurations[current_hero];
    
    
    ChecklistSubentry getCurrentCapeConfig() {
        // Title
        string main_title = "Superhero Cape";
        
        // Subtitle
        string main_hero = current_cape.hero_name != "" ? current_cape.hero_name : "unknown?";
        string subtitle = " (" + main_hero + " / " + current_wash + " me)";
        
        // Entries
        string [int] description;
        if (cape_configurations contains current_hero) {
            description.listAppend( current_cape.main_modifiers );
            description.listAppend( current_cape.tmhmkmkm[current_wash] );
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
        if ( __misc_state["need to level"] && cape_stats != "" && (current_hero != cape_stats.to_lower_case() || current_wash != "thrill") )
            description.listAppend( HTMLGenerateSpanOfClass("Mainstat exp: ", "r_bold" ) + cape_stats + " + Thrill" );
        
        if ( $effect[Everything looks yellow].have_effect() == 0 && (current_hero != "heck" || current_wash != "kiss") )
            description.listAppend( HTMLGenerateSpanOfClass("Yellow ray: ", "r_bold" ) + "Heck + Kiss" );
        
        if ( current_hero != "vampire" || current_wash != "hold" )
            description.listAppend( HTMLGenerateSpanOfClass("+3 Res: ", "r_bold" ) + "Vampire + Hold" );
        
        if ( current_hero != "vampire" || current_wash != "kill" ) //reminder: add this to the cyrpt tile
            description.listAppend( HTMLGenerateSpanOfClass("Instakill / Cyrpt Evil: ", "r_bold" ) + "Vampire + Kill" );
        
        return ChecklistSubentryMake(main_title, "", description);
    }
    
    
    ChecklistEntry entry;
    entry.image_lookup_name = "__item unwrapped knock-off retro superhero cape";
    entry.url = cape.equipped() ? "inventory.php?action=hmtmkmkm" : cape.invSearch(); // we don't even need to change/adapt the name, kol recognizes it anyway!
    entry.tags.id = "Superhero cape resource";
    entry.should_indent_after_first_subentry = true;
    entry.importance_level = 5;

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
