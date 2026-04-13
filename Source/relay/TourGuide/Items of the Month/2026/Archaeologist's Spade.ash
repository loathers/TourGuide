// archaeologist's spade
RegisterResourceGenerationFunction("IOTMArchaeologistSpadeGenerateResource");
void IOTMArchaeologistSpadeGenerateResource(ChecklistEntry [int] resource_entries) {

    if (!__iotms_usable[lookupItem("Archaeologist's Spade")]) return;

    // end if no digs left
    int digsLeft = clampi(11 - get_property_int("_archSpadeDigs"), 0, 11);
    if (digsLeft == 0) return;

    string title;
    string url;
    string [int] description;

    url = "inv_use.php?pwd=" + my_hash() + "&whichitem=12184";
    title = pluralise(digsLeft, "Archaeologist's Spade dig","Archaeologist's Spade digs");

    // freekill combination tag for skelly digs
    resource_entries.listAppend(ChecklistEntryMake("__item Archaeologist's Spade", url, ChecklistSubentryMake(title, "", "Free kill a skeleton"), 0).ChecklistEntrySetCombinationTag("free instakill").ChecklistEntrySetIDTag("Archaeologist's Spade free kill"));

    // general resource tile, near end of the line probably
    description.listAppend("Excavate free skeletons!");

    // how many useful skeletons do you have left?
    int approxKitchenTurnsLeft = ceil(MAX(0, 21 - get_property_int("manorDrawerCount")) / 4) + to_int(lookupItem("Spookyraven billiards room key").available_amount() < 1);
    if (approxKitchenTurnsLeft > 0) description.listAppend("|*<b>"+pluralise(approxKitchenTurnsLeft,"skelly","skellies")+"</b> in the Haunted Kitchen");
    
    int approxBallroomTurnsLeft = delayRemainingInLocation($location[the haunted ballroom]);
    if (approxBallroomTurnsLeft > 0) description.listAppend("|*<b>"+pluralise(approxBallroomTurnsLeft,"skelly","skellies")+"</b> in the Haunted Ballroom");

    int approxNookTurnsLeft = ceil(max(0,get_property_int("cyrptNookEvilness")-13-$item[evil eye].available_amount() * 3) / 3);
    if (approxNookTurnsLeft > 0) description.listAppend("|*<b>"+pluralise(approxNookTurnsLeft,"skelly","skellies")+"</b> in the Defiled Nook");
    
    // only generate if you actually have a possibility of doing the garves snake
    if (__shen_items_to_locations[get_property_item("shenQuestItem")] == $location[The VERY Unquiet Garves] || get_property_int("shenInitiationDay") == 0 || get_property("questL11Shen") != "finished") {
        int approxGarvesTurnsLeft = ceil(max(0,5-$location[the unquiet garves].turns_spent));
        if (approxGarvesTurnsLeft > 0) {
            description.listAppend("|*<b>"+pluralise(approxGarvesTurnsLeft,"skelly","skellies")+"</b> in the Unquiet Garves");
            if (get_property_int("shenInitiationDay") != 1) description.listAppend("|*(Start Shen on D2 for Garve skellies)");
        }
    }
    
    resource_entries.listAppend(ChecklistEntryMake("__item Archaeologist's Spade", url, ChecklistSubentryMake(title, "", description)).ChecklistEntrySetIDTag("Archaeologist Spade skellies"));
            
}