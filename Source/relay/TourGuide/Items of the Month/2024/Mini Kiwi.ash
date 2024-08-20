// Mini-Kiwi
RegisterResourceGenerationFunction("IOTMMiniKiwiGenerateResource");
void IOTMMiniKiwiGenerateResource(ChecklistEntry [int] resource_entries)
{
	if (!lookupFamiliar("Mini Kiwi").familiar_is_usable()) return;

    // This familiar sucks. It's really bad. Still, fine to have a tile, I guess.
    int miniKiwiCount = $item[mini kiwi].available_amount();
    float kiwiWeight = effective_familiar_weight($familiar[Mini Kiwi]) + weight_adjustment();
    float kiwiModifier = $item[aviator goggles].available_amount() > 0 ? 0.75 : 0.50;

    // Calculating the chance of a kiwi per fight; weight * your modifier
    int kiwiChance = to_int(min(kiwiWeight * kiwiModifier,100.0));
    boolean kiwiSpiritsBought = get_property_boolean("_miniKiwiIntoxicatingSpiritsBought"); 
    int miniKiwiBikiniCount = $item[mini kiwi bikini].available_amount();

    // Tile setup stuff
	string [int] description;
	string url = "familiar.php"; // Could send to the kwiki mart, but don't care enough.
	string header = pluralise(miniKiwiCount, "mini kiwi available", "mini kiwis available");

	description.listAppend(`At {to_int(kiwiWeight)} weight, you have a {kiwiChance}% chance of a mini kiwi each fight.`);

    if (!kiwiSpiritsBought) {
        description.listAppend('|*Consider purchasing mini kiwi intoxicating spirits, for 3 kiwis.');
    }

    if (miniKiwiBikiniCount < 1 && get_property_int("zeppelinProtestors") < 80) {
        description.listAppend('|*Consider purchasing mini kiwi bikinis, for the Zeppelin sleaze test.');
    } 

	resource_entries.listAppend(ChecklistEntryMake("__familiar mini kiwi", url, ChecklistSubentryMake(header, "", description), 10));

}
