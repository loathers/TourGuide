// heartstone
// TODO: make the tile. also:
//   - add some letter callout to location bar

RegisterTaskGenerationFunction("IOTMHeartstoneGenerateTasks");
void IOTMHeartstoneGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries) 
{
	// the heart must go on
	if (__iotms_usable[lookupItem("Heartstone")]) return;

    // tasks should include
    //   - recommended monster for next letter you should try to get (if T, A; if A, P; etc)
    //   - jesus this is going to suck ass i hate this lol
}

RegisterResourceGenerationFunction("IOTMHeartstoneGenerateResource");
void IOTMHeartstoneGenerateResource(ChecklistEntry [int] resource_entries)
{ 
	// the heart must go on
	if (__iotms_usable[lookupItem("Heartstone")]) return;
    
    // resource should include
    //   - better VHS tape tile; banishes will be in banish zone, but VHS tapes should get its own tile outside of 2002 now
    //   - skills tile for the useful skills; include banish as resource in banishes combination tag
}