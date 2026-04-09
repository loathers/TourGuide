// heartstone
// TODO: make the tile. also:
//   - add some letter callout to location bar

RegisterTaskGenerationFunction("IOTMHeartstoneGenerateTasks");
void IOTMHeartstoneGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries) 
{
	// the heart must go on
	if (!__iotms_usable[lookupItem("Heartstone")]) return;

    // tasks should include
    //   - recommended monster for next letter you should try to get (if T, A; if A, P; etc)
    //   - jesus this is going to suck ass i hate this lol
}

RegisterResourceGenerationFunction("IOTMHeartstoneGenerateResource");
void IOTMHeartstoneGenerateResource(ChecklistEntry [int] resource_entries)
{ 
	// the heart must go on
	if (!__iotms_usable[lookupItem("Heartstone")]) return;

    // What are the heartstone's letters?
    string heartLetters = get_property("heartstoneLetters");

    // resource should include
    //   - better VHS tape tile; banishes will be in banish zone, but VHS tapes should get its own tile outside of 2002 now
    //   - skills tile for the useful skills; include banish as resource in banishes combination tag

    // Can the user access the skills?
    boolean accessBOOM = get_property_boolean("heartstoneKillUnlocked");
    boolean accessGONE = get_property_boolean("heartstoneBanishUnlocked");
    boolean accessSTUN = get_property_boolean("heartstoneStunUnlocked");
    boolean accessBUDS = get_property_boolean("heartstonePalsUnlocked");
    boolean accessBUFF = get_property_boolean("heartstoneBuffUnlocked");
    boolean accessLUCK = get_property_boolean("heartstoneLuckUnlocked");

    // How many times has the user used the skills?
    int usesBOOM = get_property_int("heartstoneKillUsed");
    int usesGONE = get_property_int("heartstoneBanishUsed");
    int usesSTUN = get_property_int("heartstoneStunUsed");
    int usesBUDS = get_property_int("heartstonePalsUsed");
    int usesBUFF = get_property_int("heartstoneBuffUsed");
    int usesLUCK = get_property_int("heartstoneLuckUsed");

}