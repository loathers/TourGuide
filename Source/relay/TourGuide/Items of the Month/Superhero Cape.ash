/* RegisterTaskGenerationFunction("IOTMSuperheroCapeGenerateTasks");
void IOTMSuperheroCapeGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    task_entries.listAppend(ChecklistEntryMake("__item unwrapped knock-off retro superhero cape", "", ChecklistSubentryMake("", "", ""), -11).ChecklistEntrySetIDTag("Superhero cape now"));
} */

RegisterResourceGenerationFunction("IOTMSuperheroCapeGenerateResource");
void IOTMSuperheroCapeGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (!lookupItem("unwrapped knock-off retro superhero cape").have()) return;
    
    string currentHero = get_property("retroCapeSuperhero");
    string currentWash = get_property("retroCapeWashingInstructions");
    
    string cape_mods;
    stat thrill_stat;
    string hold_ability;
    skill hold_skill;
    skill kiss_skill;
    string kiss_ability;
    skill kill_skill;
    string kill_ability;
    
    if ( currentHero == "vampire" )
    {
        cape_mods = "Muscle +30% Maximum HP +50";
        hold_ability = "+3 all resistances";
        thrill_stat = $stat[Muscle];
        kiss_skill = $skill[Smooch of the Daywalker];
        kiss_ability = "Drain 20% of your foe's HP";
        kill_skill = $skill[Slay the Dead];
        kill_ability = "Instakill (costs turn, <font color='red'>Requires sword.</font>)<br>Reduces evil in the The Cyrpt zones by 1%.";
    }
    
    if ( currentHero == "heck" )
    {
        cape_mods = "Mysticality +30% Maximum MP +50";
        hold_ability = "Stuns foes at the start of combat";
        thrill_stat = $stat[Mysticality];
        kiss_skill = $skill[Unleash the Devil's Kiss];
        kiss_ability = "Yellow Ray (100 turn cool down)";
        kill_ability = "Makes your spells spookier";
    }
    
    if ( currentHero == "robot" )
    {
        cape_mods = "Moxie +30% Maximum HP/MP +25";
        hold_skill = $skill[Deploy Robo-Handcuffs];
        hold_ability = "Stagger and delevel by 20% 1x/fight";
        thrill_stat = $stat[Moxie];
        kiss_skill = $skill[Blow a Robo-Kiss];
        kiss_ability = "Deal ~50 sleaze damage";
        kill_skill = $skill[Precision Shot];
        kill_ability = "Stagger + critical hit. (<font color='red'>Requires gun.</font>)";
    }
    
    
    ChecklistSubentry getCurrentCapeConfig()
	{
        // Title
        string main_title = "Superhero Cape";
        string main_hero = ( currentHero=="vampire" ) ? "Vampire Slicer":
            ( currentHero=="heck" ) ? "Heck General":
            ( currentHero=="robot" ) ? "Robot Police":"unknown?";
        string main_wash = currentWash + " me";
        main_title += " ("+main_hero+" / "+main_wash+")";
        
        // Subtitle
        string subtitle = cape_mods;

        // Entries
        string [int] description;
        if ( currentWash == "hold" )
        {
            string holddsc;
            holddsc += ( hold_skill != $skill[none] ) ? "Skill: "+hold_skill.to_string()+"<br>":"";
            holddsc += ( hold_ability != "" ) ? hold_ability:"";
            if ( holddsc != "" )
                description.listAppend( HTMLGenerateSpanOfClass( holddsc, "" ) );
        }
        if ( currentWash == "thrill" )
        {
            string thrilldsc;
            thrilldsc += ( thrill_stat != $stat[none] ) ? "+3 "+thrill_stat.to_string()+" stats per fight":"";
            if ( thrilldsc != "" )
                description.listAppend( HTMLGenerateSpanOfClass( thrilldsc, "" ) );
        }
        if ( currentWash == "kiss" )
        {
            string kissdsc;
            kissdsc += ( kiss_skill != $skill[none] ) ? "Skill: "+kiss_skill.to_string()+"<br>":"";
            kissdsc += ( kiss_ability != "" ) ? kiss_ability:"";
            if ( kissdsc != "" )
                description.listAppend( HTMLGenerateSpanOfClass( kissdsc, "" ) );
        }
        if ( currentWash == "kill" )
        {
            string killdsc;
            killdsc += ( kill_skill != $skill[none] ) ? "Skill: "+kill_skill.to_string()+"<br>":"";
            killdsc += ( kill_ability != "" ) ? kill_ability:"";
            if ( killdsc != "" )
                description.listAppend( HTMLGenerateSpanOfClass(killdsc, "" ) );
        }
        
        return ChecklistSubentryMake(main_title, subtitle, description);
    }
    
    
    ChecklistSubentry usefulCapeConfigs()
	{
        string main_title = "Useful configurations: ";
        string [int] description;
        string capeStats;
        switch ( my_primestat() ) {
            case $stat[Muscle]:
                capeStats = "Vampire";
            break;
            case $stat[Mysticality]:
                capeStats = "Heck";
            break;
            case $stat[Moxie]:
                capeStats = "Robot";
            break;
            default:
            break;
        }
        if ( capeStats != "" )
            capeStats = HTMLGenerateSpanOfClass("Mainstat exp: ", "r_bold" )+capeStats;
            capeStats += " + Thrill";
        if ( capeStats != "" && currentWash != "thrill" )
            description.listAppend( capeStats );
		
		if ( currentHero != "heck" || currentWash != "kiss" )
			description.listAppend( HTMLGenerateSpanOfClass("Yellow ray: ", "r_bold" )+"Heck + Kiss" );
		if ( currentHero != "vampire" || currentWash != "hold" )
			description.listAppend( HTMLGenerateSpanOfClass("+3 Res: ", "r_bold" )+"Vampire + Hold" );
		if ( currentHero != "vampire" || currentWash != "kill" )
			description.listAppend( HTMLGenerateSpanOfClass("Instakill / Cyrpt Evil: ", "r_bold" )+"Vampire + Kill" );



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
