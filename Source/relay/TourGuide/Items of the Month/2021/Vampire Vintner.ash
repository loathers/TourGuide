//Vampire Vintner
RegisterTaskGenerationFunction("IOTMVampireVintnerGenerateTasks");
void IOTMVampireVintnerGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	if (!__misc_state["in run"] && lookupFamiliar("vampire vintner").familiar_is_usable()) return;
	
	int vintnerFightsLeft = clampi(14 - get_property_int("vintnerCharge"), 0, 14);
	int vintnerWineLevel = get_property_int("vintnerWineLevel");
	string url = "familiar.php";
	
	string [int] description;
	string [int] wineDescription;
	string wineType = (get_property("vintnerWineType"));
	description.listAppend("Use certain damage types to get premium wines:");
	description.listAppend(HTMLGenerateSpanFont("Hot damage:", "red") + " +item% wine.");
	description.listAppend(HTMLGenerateSpanFont("Cold damage:", "blue") + " +meat% wine.");
	description.listAppend(HTMLGenerateSpanFont("Familiar damage:", "orange") + " +fam xp and +ML wine.");

	if ($item[1950 vampire vintner wine].available_amount() == 1 && $item[1950 vampire vintner wine].item_is_usable())
	{
	   url = "inventory.php?ftext=vintner+wine";
	   wineDescription.listAppend(HTMLGenerateSpanFont("Can't charge another vintner wine until you use this one.", "red"));
	   	switch (wineType)			
		{
			case "hot":
				wineDescription.listAppend(HTMLGenerateSpanFont("Hot wine: grants +" + vintnerWineLevel * 3 + " hot damage and +" + vintnerWineLevel * 5 + "% item drops.", "red")); break;
			case "cold":
				wineDescription.listAppend(HTMLGenerateSpanFont("Cold wine: grants +" + vintnerWineLevel * 3 + " cold damage and +" + vintnerWineLevel * 5 + "% meat drops.", "blue")); break;
			case "stench":
				wineDescription.listAppend(HTMLGenerateSpanFont("Stench wine: grants +" + vintnerWineLevel * 3 + " stench damage and +" + vintnerWineLevel + " familiar weight.", "green")); break;
			case "spooky":
				wineDescription.listAppend(HTMLGenerateSpanFont("Spooky wine: grants +" + vintnerWineLevel * 4 + " spooky damage and +" + vintnerWineLevel * 2 + "% spell critical.", "grey")); break;
			case "sleaze":
				wineDescription.listAppend(HTMLGenerateSpanFont("Sleaze wine: grants +" + vintnerWineLevel * 3 + " sleaze damage and +" + vintnerWineLevel * 5 + "% pickpocket chance.", "purple")); break;
			case "physical":
				wineDescription.listAppend(HTMLGenerateSpanFont("Physical wine: grants +" + vintnerWineLevel * 2 + "% critical hit and +" + vintnerWineLevel * 10 + "% initiative.", "black")); break;
			case "familiar":
				wineDescription.listAppend(HTMLGenerateSpanFont("Familiar wine: grants +" + vintnerWineLevel + " familiar experience and +" + vintnerWineLevel * 3 + " ML.", "purple")); break;
		}
	   optional_task_entries.listAppend(ChecklistEntryMake("__item 1950 vampire vintner wine", url, ChecklistSubentryMake("Drink your vampire vintner wine", wineDescription)));
	}
	else if (vintnerFightsLeft > 1)
	{
        optional_task_entries.listAppend(ChecklistEntryMake("__familiar vampire vintner", url, ChecklistSubentryMake(vintnerFightsLeft + " Vintner combats remaining", "", description)));
    }	
	else if (vintnerFightsLeft == 1)
	{
        description.listAppend(HTMLGenerateSpanFont("Vintner will make wine next combat.", "purple"));
		task_entries.listAppend(ChecklistEntryMake("__familiar vampire vintner", url, ChecklistSubentryMake("Vintner wine soon", "", description), -11));
    }	
}
RegisterResourceGenerationFunction("IOTMVampireVintnerGenerateResource");
void IOTMVampireVintnerGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (!__misc_state["in run"]) return;
	int vintnerWineLevel = get_property_int("vintnerWineLevel");
	string [int] description;
	string [int] wineDescription;
	string url = "inventory.php?ftext=vintner+wine";
	string wineType = (get_property("vintnerWineType"));
	
	if ($item[1950 vampire vintner wine].available_amount() == 1 && $item[1950 vampire vintner wine].item_is_usable())
	{
	   wineDescription.listAppend(HTMLGenerateSpanFont("Can't charge another vintner wine until you use this one.", "red"));
	   	switch (wineType)			
		{
			case "hot":
				wineDescription.listAppend(HTMLGenerateSpanFont("Hot wine: grants +" + vintnerWineLevel * 3 + " hot damage and +" + vintnerWineLevel * 5 + "% item drops.", "red")); break;
			case "cold":
				wineDescription.listAppend(HTMLGenerateSpanFont("Cold wine: grants +" + vintnerWineLevel * 3 + " cold damage and +" + vintnerWineLevel * 5 + "% meat drops.", "blue")); break;
			case "stench":
				wineDescription.listAppend(HTMLGenerateSpanFont("Stench wine: grants +" + vintnerWineLevel * 3 + " stench damage and +" + vintnerWineLevel + " familiar weight.", "green")); break;
			case "spooky":
				wineDescription.listAppend(HTMLGenerateSpanFont("Spooky wine: grants +" + vintnerWineLevel * 4 + " spooky damage and +" + vintnerWineLevel * 2 + "% spell critical.", "grey")); break;
			case "sleaze":
				wineDescription.listAppend(HTMLGenerateSpanFont("Sleaze wine: grants +" + vintnerWineLevel * 3 + " sleaze damage and +" + vintnerWineLevel * 5 + "% pickpocket chance.", "purple")); break;
			case "physical":
				wineDescription.listAppend(HTMLGenerateSpanFont("Physical wine: grants +" + vintnerWineLevel * 2 + "% critical hit and +" + vintnerWineLevel * 10 + "% initiative.", "black")); break;
			case "familiar":
				wineDescription.listAppend(HTMLGenerateSpanFont("Familiar wine: grants +" + vintnerWineLevel + " familiar experience and +" + vintnerWineLevel * 3 + " ML.", "purple")); break;
		}
	   resource_entries.listAppend(ChecklistEntryMake("__item 1950 vampire vintner wine", url, ChecklistSubentryMake("Drink your vampire vintner wine", wineDescription), -11));
	}
}