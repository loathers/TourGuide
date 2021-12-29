
//Backup Camera
RegisterResourceGenerationFunction("IOTMBackupCameraGenerateResource");
void IOTMBackupCameraGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (!lookupItem("backup camera").have()) return;
    // Title
    string main_title = "Backupcheek cameracity snapshots";
    string [int] description;


    // Entries
    int backup_camera_snapsUsed = get_property_int("_backUpUses");
    int totalBackupCameras = 11;
    if (my_path_id() == PATH_YOU_ROBOT) {
        totalBackupCameras = 16;
        //for whatever awful reason, this is buggy and will miscount when you break prism until you relog
    }
    
    string url = "inventory.php?ftext=backup+camera";
    int backup_camera_uses_remaining = totalBackupCameras - backup_camera_snapsUsed;
    if (backup_camera_uses_remaining > 0) {
        string [int] description;
        description.listAppend("Back up and fight the last monster you fought.");
		
		monster nostalgicMonster = (get_property_monster("lastCopyableMonster"));
        description.listAppend(HTMLGenerateSpanFont(nostalgicMonster, "blue") + " is currently in your cringe compilation.");
		
		if (!lookupItem("backup camera").equipped()) {
            description.listAppend(HTMLGenerateSpanFont("Equip the backup camera first", "red"));
        }
        else {
            description.listAppend("Re-fight your last encountered monster.");
        }
		
		resource_entries.listAppend(ChecklistEntryMake("__item backup camera", url, ChecklistSubentryMake(backup_camera_uses_remaining + " backup camera snaps left", "", description)).ChecklistEntrySetIDTag("Backup camera skill resource"));
    }
}
