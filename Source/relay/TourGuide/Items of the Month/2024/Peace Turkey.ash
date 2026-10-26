RegisterResourceGenerationFunction("IOTMPeaceTurkeyGenerateResource");
void IOTMPeaceTurkeyGenerateResource(ChecklistEntry [int] resource_entries) {
	if (lookupItem("handful of split pea soup").available_amount() > 0 ) {
    resource_entries.listAppend(ChecklistEntryMake("__item handful of split pea soup", "", ChecklistSubentryMake(pluralise($item[handful of split pea soup]), "also, have " + available_amount($item[whirled peas]) + " peas", "Free run, 30-turn banish. "), 0).ChecklistEntrySetCombinationTag("banish").ChecklistEntrySetIDTag("Purkey banish"));
  }
}