// the eternity codpiece

RegisterResourceGenerationFunction("IOTMEternityCodpieceGenerateResource");
void IOTMEternityCodpieceGenerateResource(ChecklistEntry [int] resource_entries) {
    // TODO: include following info:
    //   - current enchantment
    //   - alternate available gems + their enchantments
    //   - remind user about BCZ/heartstone in codpiece, maybe note that peridot/baseball can be there too but might not be recommended?
    //   - use Pantogram slot structure maybe

    // Detect current gems via slot
    item cod1 = equipped_item($slot[codpiece1]);
    item cod2 = equipped_item($slot[codpiece2]);
    item cod3 = equipped_item($slot[codpiece3]);
    item cod4 = equipped_item($slot[codpiece4]);
    item cod5 = equipped_item($slot[codpiece5]);

    if (!__iotms_usable[lookupItem("The Eternity Codpiece")]) return;

}