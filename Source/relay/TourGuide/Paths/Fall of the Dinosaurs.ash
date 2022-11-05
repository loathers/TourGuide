RegisterResourceGenerationFunction("PathDinoFallGenerateResource");
void PathDinoFallGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (my_path().id != PATH_FALL_OF_THE_DINOSAURS)
        return;
    
    // #10944 = Dinodollar, the currency in the Dinostaur (good joke!)
    item dd = lookupItem("10944");

    int repellantsAvailable = (dd.available_amount() - (dd.available_amount() % 5))/5;

    if (dd.available_amount() > 0)
    {
        string [int] description;
        if (lookupItem("10941").available_amount() == 0)
            description.listAppend("Dino DNAde&trade;: +300% to all stats, good for survival & the tower");
         
        description.listAppend("Dinosaur Repellent: You can purchase " + repellantsAvailable.to_string() + " freeruns!");
        resource_entries.listAppend(ChecklistEntryMake("__item Dinodollar", "shop.php?whichshop=dino", ChecklistSubentryMake(pluralise(dd) + " available", "", description), 3).ChecklistEntrySetIDTag("The Dinostaur"));
    }
}
