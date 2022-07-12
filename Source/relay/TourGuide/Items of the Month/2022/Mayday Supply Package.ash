// MayDay Package
RegisterResourceGenerationFunction("IOTMMayDayContractGenerateResource");
void IOTMMayDayContractGenerateResource(ChecklistEntry [int] resource_entries)
{
    if ($item[MayDay&trade; supply package].available_amount() > 0) #&& in_ronin() && $item[MayDay&trade; supply package].item_is_usable())
    {
        string [int] description;
		description.listAppend("Use for 30 advs of +100% init as well as useful seeded drops (formerly ten bucks)");
		resource_entries.listAppend(ChecklistEntryMake("__item MayDay&trade; supply package", "", ChecklistSubentryMake(pluralise($item[MayDay&trade; supply package]), "", description)));
    }
}