//rose garden
RegisterResourceGenerationFunction("IOTMBlackGardenRoseGenerateResource");
void IOTMBlackGardenRoseGenerateResource(ChecklistEntry [int] resource_entries)
{
	string [int] description;
	int ChunkCount = available_amount($item[Statuary Chunk]);
	int TombstoneCount = available_amount($item[partial tombstone]);
	int tombstonesUsed = (get_property_int("_partialTombstonesUsed"));
	int tombstoneUsesLeft = clampi(11 - get_property_int("_partialTombstonesUsed"), 0, 11);
	
	description.listAppend("" + ChunkCount + " statuary chunks (worth " + ChunkCount/3 + " tombstones)");
	
    string subtitle = tombstonesUsed > 0 ? "have used "+pluralise(tombstonesUsed, "tombstone", "tombstones") : "";
    
	if ((ChunkCount + TombstoneCount) > 0)
    {
		string header = pluralise(TombstoneCount, "partial tombstone", "partial tombstones");
        if (tombstoneUsesLeft < TombstoneCount) {
            if (tombstoneUsesLeft == 0)
                header += " (not usable today)";
            else
                header += " (" + tombstoneUsesLeft + " usable today)";
        }
        resource_entries.listAppend(ChecklistEntryMake("__item partial tombstone", "", ChecklistSubentryMake(header, subtitle, description)).ChecklistEntrySetCombinationTag("free instakill"));
    }
}
