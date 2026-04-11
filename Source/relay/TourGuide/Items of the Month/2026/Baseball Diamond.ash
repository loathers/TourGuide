// baseball diamond
// TODO: make the tile lol. things that would help this tile:
//   - abstract out a "here's your lineup" popout box
//   - if mafia has a limit_mode(), add task entries for each pitch so you know what pitches are ready

// helper function to generate monster lineup
monster [int] baseballBuddies() {
    monster [int] finalTeam;
    string [int] rawTeam = get_property("baseballTeam").split_string(", ");

    foreach i, playerID in rawTeam {
        finalTeam[i] = to_monster(to_int(playerID));
    }

    return finalTeam;
}

RegisterTaskGenerationFunction("IOTMBaseballDiamondGenerateTasks");
void IOTMBaseballDiamondGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries) 
{
    // tasks should include
    //   - recruit monsters for your baseball lineup if <9 
    //   - current lineup hoverover
    //   - maybe a supernag if you have a useful freekill + YR in the last 3 monsters?
    
	if (!__iotms_usable[lookupItem("Baseball Diamond")]) return;
    monster [int] myTeam = baseballBuddies(); 
    boolean baseballEquipped = lookupItem("Baseball Diamond").equipped_amount() > 0;
}

RegisterResourceGenerationFunction("IOTMBaseballDiamondGenerateResource");
void IOTMBaseballDiamondGenerateResource(ChecklistEntry [int] resource_entries)
{ 
    // resource should include
    //   - number of ball games remaining
    //   - monsters to consider 
    //       => use shrunken head for YR
    //       => repeated nonfree monsters for freekill
    //       => feesh for ML
    
    if (!__iotms_usable[lookupItem("Baseball Diamond")]) return;
    monster [int] myTeam = baseballBuddies();
    boolean baseballEquipped = lookupItem("Baseball Diamond").equipped_amount() > 0;

}