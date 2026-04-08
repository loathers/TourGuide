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

void addToBothDescriptions(string [int] description1, string [int] description2, string text) {
    description1.listAppend(text);
    description2.listAppend(text);
}

//Mayam calendar
RegisterResourceGenerationFunction("IOTMMayamCalendarGenerateResource");
void IOTMMayamCalendarGenerateResource(ChecklistEntry [int] resource_entries)
{
    // Adding this prior to the check if the user has stinkbombs.
    if ($item[stuffed yam stinkbomb].available_amount() > 0 )
    {
        resource_entries.listAppend(ChecklistEntryMake("__item stuffed yam stinkbomb", "", ChecklistSubentryMake(pluralise($item[stuffed yam stinkbomb]), "", "Free run/banish."), 0).ChecklistEntrySetCombinationTag("banish").ChecklistEntrySetIDTag("Haunted doghouse banish"));
    }

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

    string [int] description, hoverDescription;

    int templeResetAscension = get_property_int("lastTempleAdventures");
    string mayamSymbolsUsed = get_property("_mayamSymbolsUsed");
    addToBothDescriptions(description, hoverDescription, "Happy Mayam New Year!");

    ChecklistEntry entry;
    entry.url = "inv_use.php?pwd=" + my_hash() + "&which=99&whichitem=11572";
    entry.image_lookup_name = "mayam calendar";
    entry.tags.id = "Mayam Calendar";
    entry.importance_level = 8;

    if (!mayamSymbolsUsed.contains_text("yam4") ||
        !mayamSymbolsUsed.contains_text("clock") ||
        !mayamSymbolsUsed.contains_text("explosion") ||
        my_ascensions() > templeResetAscension)
    {
        // do not generate the tile if in sea path and no picks left
        if (mayamSymbolsUsed.contains_text("yam4") &&
        mayamSymbolsUsed.contains_text("clock") &&
        mayamSymbolsUsed.contains_text("explosion") &&
        my_path().id == PATH_SEA) return;

        description.listAppend(HTMLGenerateSpanFont(" ", "r_bold") + "");
        hoverDescription.listAppend(HTMLGenerateSpanFont(" ", "r_bold") + "");

        int[int] rings = {1, 2, 3, 4};
        foreach ring in rings {
            string ringOrdinal = capitaliseFirstLetter(substring(int_to_ordinal(ring + 1), 1));
            hoverDescription.listAppend(HTMLGenerateSpanOfClass(`{ringOrdinal} ring:`, "r_bold"));

            string [int] unusedSymbols;
            foreach index, mayamSymbol in mayamSymbols {
                if (mayamSymbol.ring == ring + 1 && !get_property("_mayamSymbolsUsed").contains_text(mayamSymbol.mafiaName)) {
                    hoverDescription.listAppend(`- {HTMLGenerateSpanOfClass(mayamSymbol.friendlyName, "r_bold")}: {mayamSymbol.description}`);
                    unusedSymbols.listAppend(mayamSymbol.friendlyName);
                }
            }
            description.listAppend(`{HTMLGenerateSpanOfClass(`{ringOrdinal} ring:`, "r_bold")} {unusedSymbols.listJoinComponents(", ")}`);
            hoverDescription.listAppend(HTMLGenerateSpanFont(" ", "r_bold") + "");
        }
        description.listAppend(HTMLGenerateSpanFont(" ", "r_bold") + "");

        string [int] resonances;

        // adding some filtering to remove from resonance list if cannot make
        if (!mayamSymbolsUsed.contains_text("vessel") && !mayamSymbolsUsed.contains_text("yam2") && !mayamSymbolsUsed.contains_text("cheese") && !mayamSymbolsUsed.contains_text("explosion"))
            resonances.listAppend(HTMLGenerateSpanOfClass("15-turn banisher", "r_bold") + ": Vessel + Yam + Cheese + Explosion");
        if (!mayamSymbolsUsed.contains_text("yam1") && !mayamSymbolsUsed.contains_text("meat") && !mayamSymbolsUsed.contains_text("cheese") && !mayamSymbolsUsed.contains_text("yam4"))
            resonances.listAppend(HTMLGenerateSpanOfClass("Yam and swiss", "r_bold") + ": Yam + Meat + Cheese + Yam");
        if (!mayamSymbolsUsed.contains_text("yam1") && !mayamSymbolsUsed.contains_text("meat") && !mayamSymbolsUsed.contains_text("eyepatch") && !mayamSymbolsUsed.contains_text("yam4"))
            resonances.listAppend(HTMLGenerateSpanOfClass("+55% meat accessory", "r_bold") + ": Yam + Meat + Eyepatch + Yam");
        if (!mayamSymbolsUsed.contains_text("yam1") && !mayamSymbolsUsed.contains_text("yam2") && !mayamSymbolsUsed.contains_text("cheese") && !mayamSymbolsUsed.contains_text("clock"))
            resonances.listAppend(HTMLGenerateSpanOfClass("+100% Food drops", "r_bold") + ": Yam + Yam + Cheese + Clock");
        
        if (length(resonances) > 0)
            addToBothDescriptions(description, hoverDescription, HTMLGenerateSpanOfClass("Cool Mayam combos!", "r_bold") + resonances.listJoinComponents("<hr>").HTMLGenerateIndentedText());

        if (my_ascensions() > templeResetAscension && my_path().id != PATH_SEA) {
            addToBothDescriptions(description, hoverDescription, HTMLGenerateSpanFont("Temple reset available!", "r_bold") + "");
        }

        entry.subentries.listAppend(ChecklistSubentryMake("Mayam Calendar", "", description));
        entry.subentries_on_mouse_over.listAppend(ChecklistSubentryMake("Mayam Calendar", "", hoverDescription));
        resource_entries.listAppend(entry);
    }
}
