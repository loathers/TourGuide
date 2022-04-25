//Grey Goose
RegisterTaskGenerationFunction("IOTMGreyGooseGenerateTasks");
void IOTMGreyGooseGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    // This tile just posts up a task if your Goose is hefty enough to snag adventures, and you have it equipped.
    int gooseWeight = min(floor(sqrt($familiar[Grey Goose].experience)),20);
    string [int] description;

     if (my_familiar() != lookupFamiliar("Grey Goose")) return;

    // Surprisingly, the "class" is called Grey Goo even if the path is Grey You. This is not a typo!
    if (my_class() == $class[grey goo] && gooseWeight > 5) 
    {
        string main_title = HTMLGenerateSpanFont("GOOSO is 6 pounds or higher", "grey");
        description.listAppend("GOOSO IS LIT.");
        description.listAppend("Re-Process a bunch of matter to gain a bunch of adventures, Grey You.");
        task_entries.listAppend(ChecklistEntryMake("__familiar grey goose", "", ChecklistSubentryMake(main_title, "", description), -11));
    }
}

RegisterResourceGenerationFunction("IOTMGreyGooseResource");
void IOTMGreyGooseResource(ChecklistEntry [int] resource_entries)
{
    ChecklistSubentry gooseInfo() {

        int gooseDrones = get_property_int("gooseDronesRemaining");
        int gooseWeight = min(floor(sqrt($familiar[Grey Goose].experience)),20);
        
        // Return if you aren't in-run, because this tile is really not needed in aftercore. Commenting out for testing.
        // if (!__misc_state["in run"]) return;
        
        string main_title;
        string subtitle;
        string [int] description;

        int dronesGenerated = max(gooseWeight-5,0);
        int meatifyAmount = dronesGenerated**2;
        int statGenerated = dronesGenerated**3;
        int statGeneratedGoo = dronesGenerated**2;

        int gooseExpToSix = max(36-$familiar[Grey Goose].experience,0);

        main_title = "Goose Skills"
        subtitle = "You have a " + gooseWeight + " pound Grey Goose."
        // Only show descriptive stuff if the goose can use the skills (IE, weight > 5)
        if (gooseWeight > 5) 
        { 
            if (my_class() == $class[grey goo]) 
            {
                description.listAppend(HTMLGenerateSpanOfClass("Re-Process Matter:", "r_bold") + " Get adventures from a monster, again!");
                description.listAppend(HTMLGenerateSpanOfClass("Gain Stats:", "r_bold") + " Process for Protein, Energy, or Pomade for " + statGeneratedGoo + " mus/mys/mox.");
            } else {
                description.listAppend(HTMLGenerateSpanOfClass("Gain Stats:", "r_bold") + " Process for Protein, Energy, or Pomade for " + statGenerated + " mus/mys/mox substats.");
            }
            description.listAppend(HTMLGenerateSpanOfClass("Replication Drones:", "r_bold") + " Copy " + dronesGenerated + " items from monsters via drone warfare.");
            description.listAppend(HTMLGenerateSpanOfClass("Meatify Matter:", "r_bold") + " Get " + meatifyAmount + " meat, instantly.");
        } else {
            description.listAppend("You can't use goose skills yet. Darn. Gain " + gooseExpToSix + " familiar XP to embrace GOOSO.");
        }

        return ChecklistSubentryMake(main_title, subtitle, description);

    }
    
    // Return if the goose is not usable in your path (or you don't own it)
    if (!lookupFamiliar("Grey Goose").familiar_is_usable()) return;

    ChecklistEntry entry;
    entry.image_lookup_name = "__familiar grey goose";
    entry.tags.id = "Grey Goose familiar resource";

    ChecklistSubentry skills = gooseInfo();
    if skills.entries.count() > 0) {
        entry.subentries.listAppend(skills);
    }

    if (entry.subentries.count() > 0) {
        resource_entries.listAppend(entry);
    }
}