// archaeologist's spade

RegisterResourceGenerationFunction("IOTMArchaeologistSpadeGenerateResource");
void IOTMArchaeologistSpadeGenerateResource(ChecklistEntry [int] resource_entries) {
    // TODO: include following info:
    //   - digs left
    //   - dig suggestions (maybe w/ "is this relevant" piece?)

    if (!__iotms_usable[lookupItem("Archaeologist's Spade")]) return;

}