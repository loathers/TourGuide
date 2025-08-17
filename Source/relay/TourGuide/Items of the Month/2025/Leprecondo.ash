//leprecondo
RegisterTaskGenerationFunction("IOTMLeprecondoGenerateTasks");
void IOTMLeprecondoGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if ($item[leprecondo].available_amount() == 0) return;
	string url = "inv_use.php?pwd=" + my_hash() + "&which=99&whichitem=11861";
	string [int] description;
	
	int lepCondoChanges = clampi(3 - get_property_int("_leprecondoRearrangements"), 0, 3);
	string lepCondoSetup = (get_property("leprecondoInstalled"));
	if (lepCondoSetup == "0,0,0,0") {
		description.listAppend("Decorate the Leprecondo");
		task_entries.listAppend(ChecklistEntryMake("__item leprecondo", url, ChecklistSubentryMake("Decorate your Leprecondo", "", description), -11));
    }
}

RegisterResourceGenerationFunction("IOTMLeprecondoGenerateResource");
void IOTMLeprecondoGenerateResource(ChecklistEntry [int] resource_entries)
{
	if ($item[leprecondo].available_amount() == 0) return;
	string url = "inv_use.php?pwd=" + my_hash() + "&which=99&whichitem=11861";
	string [int] description;
	
	int lepCondoChanges = clampi(3 - get_property_int("_leprecondoRearrangements"), 0, 3);
	string lepCondoCurrent = (get_property("leprecondoCurrentNeed"));
	string lepCondoCycle = (get_property("leprecondoNeedOrder"));
	string lepCondoSetup = (get_property("leprecondoInstalled"));
		description.listAppend("Current setup: " + lepCondoSetup + ".");
		if (lepCondoChanges > 0) {
			description.listAppend(HTMLGenerateSpanFont("Can redecorate " + lepCondoChanges + " more times today.", "green"));
		}
		description.listAppend("Need cycle: " + lepCondoCycle + ".");
		description.listAppend("Current need: " + lepCondoCurrent + ".");

		int nextCondoTurn = get_property_int("leprecondoLastNeedChange");
	
		if (nextCondoTurn +5 <= turns_played()) {
			description.listAppend(HTMLGenerateSpanFont("Condo trigger time!", "blue"));
		}
		else {
			description.listAppend(HTMLGenerateSpanFont("Condo trigger in " + (nextCondoTurn +5 - turns_played()) + " advs.", "blue"));
		}
	int punchOutChanges = (get_property_int("preworkoutPowderUses"));
	if (punchOutChanges > 0)
	{
		resource_entries.listAppend(ChecklistEntryMake("__item orange boxing gloves", "", ChecklistSubentryMake(pluralise(get_property_int("preworkoutPowderUses"), "Condo Punch", "Condo Punches"), "", "Free run/banish.")).ChecklistEntrySetCombinationTag("banish").ChecklistEntrySetIDTag("condo punch banish"));
	}
		
	resource_entries.listAppend(ChecklistEntryMake("__item leprecondo", url, ChecklistSubentryMake("Leprecondo stuff", description), 11));
}