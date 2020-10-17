RegisterTaskGenerationFunction("IOTMGuzzlrGenerateTask");
void IOTMGuzzlrGenerateTask(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries) {

    if (!lookupItem("Guzzlr tablet").have()) return;

    boolean startedQuest = get_property("questGuzzlr") != "unstarted";
    string questTier = get_property("guzzlrQuestTier");

    int guzzlrQuestProgressLeft = 100 - get_property_int("guzzlrDeliveryProgress");
    float guzzlrQuestIncrement = max(3, 10 - get_property_int("_guzzlrDeliveries"));
    float guzzlrQuestShoedIncrement = floor(1.5 * guzzlrQuestIncrement);
    int guzzlrQuestFightsLeft = ceil(guzzlrQuestProgressLeft / guzzlrQuestIncrement);
    int guzzlrQuestShoedFightsLeft = ceil(guzzlrQuestProgressLeft / guzzlrQuestShoedIncrement);

    boolean hasShoes = lookupItem("Guzzlr shoes").available_amount() > 0;
    boolean hasPants = lookupItem("Guzzlr pants").available_amount() > 0;

    if (startedQuest) {
        boolean hasShoesEquipped = lookupItem("Guzzlr shoes").equipped_amount() > 0;
        boolean hasPantsEquipped = lookupItem("Guzzlr pants").equipped_amount() > 0;

        location questLocation = get_property("guzzlrQuestLocation").to_location();
        item questBooze = get_property("guzzlrQuestBooze").to_item();
        boolean [item] questBoozePlatinum;
        foreach platinumDrink in $strings[Steamboat, Ghiaccio Colada, Nog-on-the-Cob, Sourfinger, Buttery Boy] {
            questBoozePlatinum [lookupItem(platinumDrink)] = true;
        }

        boolean hasBooze = questTier == "platinum" ? questBoozePlatinum.item_amount() > 0 : questBooze.item_amount() > 0;
        boolean hasBoozeSomewhere = questTier == "platinum" ? questBoozePlatinum.available_amount() + questBoozePlatinum.display_amount() > 0 : questBooze.available_amount() + questBooze.display_amount() > 0;

        boolean oneFightRemains = hasShoesEquipped && guzzlrQuestShoedFightsLeft <= 1 || !hasShoesEquipped && guzzlrQuestFightsLeft <= 1;

        string subtitle = "free fights";
        initialiseLocationCombatRates(); //not done anywhere else in this script
        if (__location_combat_rates contains questLocation) {
            int rate = __location_combat_rates [questLocation];

            if (rate == -1) //if unknown
                subtitle += ", +combat";
            else if (rate != 100 && rate != 0)
                subtitle += ", +" + (100 - rate) + "% combat";
        } else //if unlisted
            subtitle += ", +combat";

        string [int] description;

        if (hasBooze) {
            description.listAppend("Deliver " + (questTier == "platinum" ? "platinum booze" : questBooze) + " by adventuring in " + questLocation + ".");
        } else {
            string color_of_reminder_to_get_drink = __last_adventure_location == questLocation ? "red" : "dark";

            if (questTier == "platinum") {
                int [item] creatablePlatinumDrinks = questBoozePlatinum.creatable_items();
                buffer message;

                message.append(HTMLGenerateSpanFont("Obtain one of the following:", color_of_reminder_to_get_drink));
                message.append(to_buffer("| • Steamboat" + (creatablePlatinumDrinks contains lookupItem("Steamboat") ? " (can make with a miniature boiler)" : "") + " | • Ghiaccio Colada" + (creatablePlatinumDrinks contains lookupItem("Ghiaccio Colada") ? " (can make with a cold wad)" : "") + " | • Nog-on-the-Cob" + (creatablePlatinumDrinks contains lookupItem("Nog-on-the-Cob") ? " (can make with a robin's egg)" : "") + " | • Sourfinger" + (creatablePlatinumDrinks contains lookupItem("Sourfinger") ? " (can make with a mangled finger)" : "") + " | • Buttery Boy" + (creatablePlatinumDrinks contains lookupItem("Buttery Boy") ? " (can make with a Dish of Clarified Butter)" : "") ) );
                description.listAppend(message);

                if (hasBoozeSomewhere) {
                    string [int] goLookThere;

                    if (get_property_boolean("autoSatisfyWithStorage") && questBoozePlatinum.storage_amount() > 0 && can_interact())
                        goLookThere.listAppend("in hagnk's storage");
                    if (get_property_boolean("autoSatisfyWithCloset") && questBoozePlatinum.closet_amount() > 0)
                        goLookThere.listAppend("in your closet");
                    if (get_property_boolean("autoSatisfyWithStash") && questBoozePlatinum.stash_amount() > 0)
                        goLookThere.listAppend("in your clan stash");
                    if (questBoozePlatinum.display_amount() > 0) // there's no relevant mafia property; is never taken into consideration
                        goLookThere.listAppend("in your display case");

                    description.listAppend("Go look " + (goLookThere.count() > 0 ? goLookThere.listJoinComponents(", ", "or") + "." : "...somewhere?"));
                }
            } else {
                description.listAppend(HTMLGenerateSpanFont("Obtain a " + questBooze + ".", color_of_reminder_to_get_drink));
                if (hasBoozeSomewhere) {
                    string [int] goLookThere;

                    if (get_property_boolean("autoSatisfyWithStorage") && questBooze.storage_amount() > 0 && can_interact())
                        goLookThere.listAppend(questBooze.storage_amount() + " in hagnk's storage");
                    if (get_property_boolean("autoSatisfyWithCloset") && questBooze.closet_amount() > 0)
                        goLookThere.listAppend(questBooze.closet_amount() + " in your closet");
                    if (get_property_boolean("autoSatisfyWithStash") && questBooze.stash_amount() > 0)
                        goLookThere.listAppend(questBooze.stash_amount() + " in your clan stash");
                    if (questBooze.display_amount() > 0)
                        goLookThere.listAppend(questBooze.display_amount() + " in your display case");

                    description.listAppend("Have " + (goLookThere.count() > 0 ? goLookThere.listJoinComponents(", ", "and") + "." : "some... somewhere..?"));
                }

                if (questBooze.creatable_amount() > 0)
                    description.listAppend("Could craft one.");
            }
        }

        if (guzzlrQuestProgressLeft <= 0)
            description.listAppend("Shouldn't this be over already?");
        else if (!hasShoes || guzzlrQuestFightsLeft == guzzlrQuestShoedFightsLeft) // if no shoes or if doesn't matter at that point
            description.listAppend("Takes " + pluralise(guzzlrQuestFightsLeft, "more fight", "more fights") + ".");
        else if (hasShoesEquipped)
            description.listAppend("Takes " + pluralise(guzzlrQuestShoedFightsLeft, "more fight", "more fights") + " (" + guzzlrQuestFightsLeft + " without shoes).");
        else {
            description.listAppend("Takes " + guzzlrQuestFightsLeft + " more fights (" + guzzlrQuestShoedFightsLeft + " with shoes).");
            description.listAppend(HTMLGenerateSpanFont("Equip your Guzzlr shoes for quicker deliveries.", "red"));
        }

        if (hasPants && !hasPantsEquipped)
            description.listAppend(HTMLGenerateSpanFont("Equip your Guzzlr pants for more Guzzlrbucks.", (oneFightRemains ? "red" : "dark")));

        if (!hasShoes)
            description.listAppend(HTMLGenerateSpanFont("Could buy Guzzlr shoes for quicker deliveries.", "grey"));
        if (!hasPants)
            description.listAppend(HTMLGenerateSpanFont("Could buy Guzzlr pants for more Guzzlrbucks.", "grey"));

        optional_task_entries.listAppend(ChecklistEntryMake("__item Guzzlrbuck", questLocation.getClickableURLForLocation(), ChecklistSubentryMake("Deliver booze", subtitle, description), boolean [location] {questLocation:true}).ChecklistEntrySetIDTag("Guzzlr quest task"));
    }


    if (true) { // for either telling the player to accept a quest, or reminding them if they can abandon it
        boolean canAbandonQuest = !get_property_boolean("_guzzlrQuestAbandoned");
        int platinumDeliveriesLeft = 1 - get_property_int("_guzzlrPlatinumDeliveries");
        int goldDeliveriesLeft = 3 - get_property_int("_guzzlrGoldDeliveries");
        int bronzeDeliveriesTotal = get_property_int("guzzlrBronzeDeliveries");
        boolean canAcceptPlatinum = get_property_int("guzzlrGoldDeliveries") >= 5;
        boolean canAcceptGold = bronzeDeliveriesTotal >= 5;

        string main_title;
        string subtitle;
        string [int] description;

        if (startedQuest && canAbandonQuest) {
            main_title = "Can abandon quest";
            description.listAppend("I mean... if you think you're not up to it...");
            if (questTier == "platinum") {
                description.listAppend("Do this to keep the Guzzlr cocktail set for yourself");
            }
        } else if (!startedQuest) {
            if (__misc_state["in run"] && platinumDeliveriesLeft > 0 && canAcceptPlatinum) {
                main_title = "Get your daily Guzzlr cocktail set";
                subtitle = "Accept a platinum quest";
                description.listAppend(canAbandonQuest ? "Then, abandon the quest." : "Will be stuck with this quest for the rest of the day.");
            } else if (!__misc_state["in run"]) {
                main_title = "Accept a booze delivery quest";
                string [int] chooseDeliveryMessage;

                if (bronzeDeliveriesTotal < 196)
                    chooseDeliveryMessage.listAppend("• Bronze");

                if (goldDeliveriesLeft > 0 && canAcceptGold)
                    chooseDeliveryMessage.listAppend("• Gold " + HTMLGenerateSpanFont("(" + goldDeliveriesLeft + " available)", "grey"));

                if (platinumDeliveriesLeft > 0 && canAcceptPlatinum)
                    chooseDeliveryMessage.listAppend("• Platinum " + HTMLGenerateSpanFont("(" + platinumDeliveriesLeft + " available)", "grey") + (canAbandonQuest ? " (Abandon for free cocktail set?)" : ""));

                if (chooseDeliveryMessage.count() > 0) {
                    description.listAppend("Start a delivery by choosing a client:" + chooseDeliveryMessage.HTMLGenerateIndentedText());
                    description.listAppend("Will take " + (hasShoes ? guzzlrQuestShoedFightsLeft + "-" : "") + guzzlrQuestFightsLeft + " fights.");
                    if (canAbandonQuest)
                        description.listAppend("Can abandon 1 more quest today.");
                }
            }
        }

        if (description.count() > 0)
            optional_task_entries.listAppend(ChecklistEntryMake("__item Guzzlr tablet", "inventory.php?tap=guzzlr", ChecklistSubentryMake(main_title, subtitle, description)).ChecklistEntrySetIDTag("Guzzlr tablet tap"));
    }
}
//FIXME todo: a separate tile to suggest how to use a spare cocktail set, when in run?
