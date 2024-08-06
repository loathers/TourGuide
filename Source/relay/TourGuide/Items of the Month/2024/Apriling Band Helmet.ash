// Apriling band helmet
RegisterResourceGenerationFunction("IOTMAprilingBandHelmetGenerateResource");
void IOTMAprilingBandHelmetGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (available_amount($item[apriling band helmet]) < 1)
        return;

    string [int] description;

    //battle of the bands
    int aprilingBandConductorTimer = get_property_int("nextAprilBandTurn");
    string url = "inventory.php?pwd=" + my_hash() + "&action=apriling";

    int aprilingBandInstrumentsAvailable = clampi(2 - get_property_int("_aprilBandInstruments"), 0, 2);
    if (aprilingBandInstrumentsAvailable > 0) {
        description.listAppend(HTMLGenerateSpanFont("Can pick " + aprilingBandInstrumentsAvailable + " more instruments!", "green"));
    }

    if (aprilingBandConductorTimer <= total_turns_played()) {
        description.listAppend(HTMLGenerateSpanFont("You can change your tune!", "blue"));
        if ($effect[Apriling Band Patrol Beat].have_effect() > 0) {
            description.listAppend(HTMLGenerateSpanFont("-10% Combat Frequency", "blue"));
            description.listAppend("+10% Combat Frequency");
            description.listAppend("+25% booze, +50% food, +100% candy");
        }
        if ($effect[Apriling Band Battle Cadence].have_effect() > 0) {
            description.listAppend("-10% Combat Frequency");
            description.listAppend(HTMLGenerateSpanFont("+10% Combat Frequency", "blue"));
            description.listAppend("+25% booze, +50% food, +100% candy");
        }
        if ($effect[Apriling Band Celebration Bop].have_effect() > 0) {
            description.listAppend("+10% Combat Frequency");
            description.listAppend("-10% Combat Frequency");
            description.listAppend(HTMLGenerateSpanFont("+25% booze, +50% food, +100% candy", "blue"));
        }
    }
    else {
        description.listAppend((aprilingBandConductorTimer - total_turns_played()) + " adventures until you can change your tune.");
    }
    resource_entries.listAppend(ChecklistEntryMake("__item apriling band helmet", url, ChecklistSubentryMake("Apriling band helmet buff", "", description), 8));

    int aprilingBandSaxUsesLeft = clampi(3 - get_property_int("_aprilBandSaxophoneUses"), 0, 3);
    int aprilingBandQuadTomUsesLeft = clampi(3 - get_property_int("_aprilBandTomUses"), 0, 3);
    int aprilingBandTubaUsesLeft = clampi(3 - get_property_int("_aprilBandTubaUses"), 0, 3);
    int aprilingBandPiccoloUsesLeft = clampi(3 - get_property_int("_aprilBandPiccoloUses"), 0, 3);
    int instrumentUses = get_property_int("_aprilBandSaxophoneUses") +
        get_property_int("_aprilBandTomUses") +
        get_property_int("_aprilBandTubaUses") +
        get_property_int("_aprilBandPiccoloUses");

    if (instrumentUses < 6) {
        string [int] instrumentDescription;
        string url = "inventory.php?ftext=apriling";
        if (aprilingBandSaxUsesLeft > 0 && available_amount($item[apriling band saxophone]) > 0) {
            description2.listAppend(`Can play the Sax {aprilingBandSaxUsesLeft} more times. {HTMLGenerateSpanFont("LUCKY!", "green")}`);
        }
        if (aprilingBandQuadTomUsesLeft > 0 && available_amount($item[apriling band quad tom]) > 0) {
            description2.listAppend(`Can play the Quad Toms {aprilingBandQuadTomUsesLeft} more times. {HTMLGenerateSpanFont("Sandworm!", "orange")}`);
        }
        if (aprilingBandTubaUsesLeft > 0 && available_amount($item[apriling band tuba]) > 0) {
            description2.listAppend(`Can play the Tuba {aprilingBandTubaUsesLeft} more times. {HTMLGenerateSpanFont("SNEAK!", "grey")}`);
        }
        if (aprilingBandPiccoloUsesLeft > 0 && available_amount($item[apriling band piccolo]) > 0) {
            description2.listAppend(`Can play the Piccolo {aprilingBandPiccoloUsesLeft} more times. {HTMLGenerateSpanFont("+40 fxp", "purple")}`);
        }
        resource_entries.listAppend(ChecklistEntryMake("__item apriling band helmet", url, ChecklistSubentryMake("Apriling band instruments", "", instrumentDescription), 8));
    }
}
