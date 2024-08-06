record MayamSymbol {
    // Which ring the symbol is in
    int ring;

    // Printable name for the symbol
    string friendlyName;

    // What mafia calls the symbol
    string mafiaName;

    // The player-friendly description of the symbol
    string description;
};

//Mayam calendar
RegisterResourceGenerationFunction("IOTMMayamCalendarGenerateResource");
void IOTMMayamCalendarGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (available_amount($item[mayam calendar]) < 1)
        return;

    MayamSymbol [int] mayamSymbols = {
        new MayamSymbol(1, "A yam", "yam1", "craftable ingredient"),
        new MayamSymbol(1, "Sword", "sword", `+{min(150, 10 * my_level())} mus stats`),
        new MayamSymbol(1, "Vessel", "vessel", "+1000 MP"),
        new MayamSymbol(1, "Fur", "fur", "+100 Fxp"),
        new MayamSymbol(1, "Chair", "chair", "+5 free rests"),
        new MayamSymbol(1, "Eye", "eye", "+30% item for 100 advs"),
        new MayamSymbol(2, "Another yam", "yam2", "craftable ingredient"),
        new MayamSymbol(2, "Lightning", "lightning", `+{min(150, 10 * my_level())} mys stats`),
        new MayamSymbol(2, "Bottle", "bottle", "+1000 HP"),
        new MayamSymbol(2, "Wood", "wood", "+4 bridge parts"),
        new MayamSymbol(2, "Meat", "meat", `+{min(150, 10 * my_level())} meat`),
        new MayamSymbol(3, "A third yam", "yam3", "craftable ingredient"),
        new MayamSymbol(3, "Eyepatch", "eyepatch", `+{min(150, 10 * my_level())} mox stats`),
        new MayamSymbol(3, "Wall", "wall", "+2 res for 100 advs"),
        new MayamSymbol(3, "Cheese", "cheese", "+1 goat cheese"),
        new MayamSymbol(4, "A fourth yam", "yam4", "yep."),
        new MayamSymbol(4, "Clock", "clock", "+5 advs"),
        new MayamSymbol(4, "Explosion", "explosion", "+5 fites")
    };

    string [int] description;
    string url = "inv_use.php?pwd=" + my_hash() + "&which=99&whichitem=11572";
    int templeResetAscension = get_property_int("lastTempleAdventures");
    description.listAppend("Happy Mayam New Year!");

    if (!get_property("_mayamSymbolsUsed").contains_text("yam4") ||
        !get_property("_mayamSymbolsUsed").contains_text("clock") ||
        !get_property("_mayamSymbolsUsed").contains_text("explosion") ||
        my_ascensions() > templeResetAscension)
    {
        description.listAppend(HTMLGenerateSpanFont(" ", "r_bold") + "");
        int[int] rings = {1, 2, 3, 4};
        foreach ring in rings {
            string ringName = `{capitaliseFirstLetter(substring(int_to_ordinal(ring + 1), 1))} ring:`;
            description.listAppend(HTMLGenerateSpanOfClass(ringName, "r_bold"));
            foreach index, mayamSymbol in mayamSymbols {
                if (mayamSymbol.ring == ring + 1 && !get_property("_mayamSymbolsUsed").contains_text(mayamSymbol.mafiaName)) {
                    description.listAppend(HTMLGenerateSpanOfClass(mayamSymbol.friendlyName, "r_bold") + ": " + mayamSymbol.description);
                }
            }
            description.listAppend(HTMLGenerateSpanFont(" ", "r_bold") + "");
        }

        string [int] resonances;
        resonances.listAppend(HTMLGenerateSpanOfClass("15-turn banisher", "r_bold") + ": Vessel + Yam + Cheese + Explosion");
        resonances.listAppend(HTMLGenerateSpanOfClass("Yam and swiss", "r_bold") + ": Yam + Meat + Cheese + Yam");
        resonances.listAppend(HTMLGenerateSpanOfClass("+55% meat accessory", "r_bold") + ": Yam + Meat + Eyepatch + Yam");
        resonances.listAppend(HTMLGenerateSpanOfClass("+100% Food drops", "r_bold") + ": Yam + Yam + Cheese + Clock");

        description.listAppend(HTMLGenerateSpanOfClass("Cool Mayam combos!", "r_bold") + resonances.listJoinComponents("<hr>").HTMLGenerateIndentedText());

        if (my_ascensions() > templeResetAscension) {
            description.listAppend(HTMLGenerateSpanFont("Temple reset available!", "r_bold") + "");
        }

        resource_entries.listAppend(ChecklistEntryMake("__item mayam calendar", url, ChecklistSubentryMake("Mayam Calendar", "", description), 8));
    }
}
