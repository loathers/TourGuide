RegisterResourceGenerationFunction("IOTMPeaceTurkeyGenerateResource");
void IOTMPeaceTurkeyGenerateResource(ChecklistEntry [int] resource_entries)
{
	if (!lookupFamiliar("Peace Turkey").familiar_is_usable()) return;

	// Purkey Title
    int turkeyProc = 24;
	float turkeyWeight = max(0.0, effective_familiar_weight($familiar[peace turkey]) + weight_adjustment());
	turkeyProc = 24 + square_root(turkeyWeight);
	
	int PeasCount = available_amount($item[whirled peas]);
	int PeaSoupCount = available_amount($item[handful of split pea soup]);
	string [int] description;
	string url = "familiar.php";
	{
		description.listAppend("" + PeasCount + " peas available (need to paste them)");
		description.listAppend("" + PeaSoupCount + " peabanishers available");
		resource_entries.listAppend(ChecklistEntryMake("__familiar peace turkey", url, ChecklistSubentryMake(HTMLGenerateSpanFont(turkeyProc +"% Peace Turkey proc", "black"), "", description), 2));
	}
	if ($item[handful of split pea soup].available_amount() > 0 )
    {
        resource_entries.listAppend(ChecklistEntryMake("__item handful of split pea soup", "", ChecklistSubentryMake(pluralise($item[handful of split pea soup]), "also, have " + PeasCount + " peas", "Free run, 30-turn banish. "), 0).ChecklistEntrySetCombinationTag("banish").ChecklistEntrySetIDTag("Purkey banish"));
    }
}
