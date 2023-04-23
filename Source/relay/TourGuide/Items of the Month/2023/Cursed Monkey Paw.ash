record Wishable {
    // If the wishable is an item, set that here. Otherwise, use $item[none].
    item theItem;

    // If the wishable is an effect, set that here. Otherwise, use $effect[none].
    effect theEffect;

    // If you want additional description text other than the item/effect name,
    // set that here.
    string additionalDescription;

    // A boolean value indicating whether the wishable is useful at all.
    boolean shouldDisplay;

    // A boolean value indicating whether the wishable is currently accessible
    // (since the paw will prevent wishes you can't access).
    boolean currentlyAccessible;
};

string showWishable(Wishable wishable) {
    string color = wishable.currentlyAccessible ? "black" : "gray";
    string wishableStr;
    string additionalDescription = wishable.additionalDescription != "" ?
        `: {wishable.additionalDescription}` :
        "";
    if (wishable.theItem != $item[none]) {
        wishableStr = `{wishable.theItem.name}{additionalDescription}`;
    } else if (wishable.theEffect != $effect[none]) {
        wishableStr = `{wishable.theEffect.name}{additionalDescription}`;
    } else {
        wishableStr = "Unknown item/effect. Report to TourGuide devs >:(";
    }
    return HTMLGenerateSpanFont(wishableStr, color);
}

string [int] showWishables(Wishable [int] wishables) {
    string [int] currentWishables = {};
    string [int] futureWishables = {};
    // My kingdom for polymorphic filter :|
    foreach index, wishable in wishables {
        if (!wishable.shouldDisplay) continue;

        if (wishable.theItem == $item[short writ of habeas corpus]) {
            print(__quest_state["Level 11 Hidden City"].finished);
            print(wishable.shouldDisplay);
        }
        if (wishable.currentlyAccessible) {
            currentWishables.listAppend(showWishable(wishable));
        } else {
            futureWishables.listAppend(showWishable(wishable));
        }
    }
    string [int] allWishables = {};
    allWishables.listAppendList(currentWishables);
    allWishables.listAppendList(futureWishables);
    return allWishables;
}

record MonkeySkill {
    int fingerCount;
    skill theSkill;
    string description;
};

RegisterResourceGenerationFunction("IOTMCursedMonkeysPawGenerateResource");
void IOTMCursedMonkeysPawGenerateResource(ChecklistEntry [int] resource_entries) {
    if (!lookupItem("cursed monkey's paw").have()) return;

    string url;
    string [int] description;
    url = "main.php?action=cmonk&pwd=" + my_hash() + "";
    description.listAppend("Return to monke. Wish for items or effects:");

    Wishable [int] inRunWishables = {
        new Wishable(
            $item[sonar-in-a-biscuit],
            $effect[none],
            "",
            get_property("questL04Bat") != "finished" &&
                !locationAvailable($location[The Boss Bat's Lair]),
            locationAvailable($location[Guano Junction])
        ),
        new Wishable(
            $item[stone wool],
            $effect[none],
            "",
            !locationAvailable($location[The Hidden Park]) &&
                available_amount($item[stone wool]) < 1,
            locationAvailable($location[The Hidden Temple])
        ),
        new Wishable(
            $item[amulet of extreme plot significance],
            $effect[none],
            "",
            !locationAvailable($location[The Castle In The Clouds In The Sky (Basement)]),
            locationAvailable($location[The Penultimate Fantasy Airship])
        ),
        new Wishable(
            $item[mohawk wig],
            $effect[none],
            "",
            !locationAvailable($location[The Castle In The Clouds In The Sky (Basement)]),
            locationAvailable($location[The Penultimate Fantasy Airship])
        ),
        new Wishable(
            $item[soft green echo eyedrop antidote],
            $effect[none],
            "",
            !locationAvailable($location[The Castle In The Clouds In The Sky (Basement)]),
            locationAvailable($location[The Penultimate Fantasy Airship])
        ),
        new Wishable(
            $item[book of matches],
            $effect[none],
            "",
            my_ascensions() > get_property_int("hiddenTavernUnlock") &&
                $item[book of matches].available_amount() < 1,
            locationAvailable($location[The Hidden Park])
        ),
        new Wishable(
            $item[rusty hedge trimmers],
            $effect[none],
            "",
            get_property_int("twinPeakProgress") < 13,
            locationAvailable($location[Twin Peak])
        ),
        new Wishable(
            $item[killing jar],
            $effect[none],
            "",
            !__quest_state["Level 11 Desert"].state_boolean["Killing Jar Given"] &&
                get_property_int("desertExploration") < 100 &&
                available_amount($item[killing jar]) < 1,
            locationAvailable($location[The Haunted Library])
        ),
        new Wishable(
            $item[none],
            $effect[Dirty Pear],
            HTMLGenerateSpanFont("double sleaze damage", "purple"),
            get_property_int("zeppelinProtestors") < 80,
            true
        ),
        new Wishable(
            $item[none],
            $effect[Painted-On Bikini],
            HTMLGenerateSpanFont("+100 sleaze damage", "purple"),
            get_property_int("zeppelinProtestors") < 80,
            true
        ),
        new Wishable(
            $item[glark cable],
            $effect[none],
            "",
            __quest_state["Level 11 Ron"].mafia_internal_step < 5,
            locationAvailable($location[The Red Zeppelin])
        ),
        new Wishable(
            $item[short writ of habeas corpus],
            $effect[none],
            "",
            !__quest_state["Level 11 Hidden City"].finished,
            locationAvailable($location[The Hidden Park])
        ),
        new Wishable(
            $item[lion oil],
            $effect[none],
            "",
            $item[mega gem].available_amount() < 1 &&
                $item[lion oil].available_amount() < 1,
            locationAvailable($location[Whitey's Grove])
        ),
        new Wishable(
            $item[bird rib],
            $effect[none],
            "",
            $item[mega gem].available_amount() < 1 &&
                $item[bird rib].available_amount() < 1,
            locationAvailable($location[Whitey's Grove])
        ),
        new Wishable(
            $item[drum machine],
            $effect[none],
            "",
            get_property_int("desertExploration") < 100 &&
                $item[drum machine].available_amount() < 1,
            locationAvailable($location[The Oasis])
        ),
        new Wishable(
            $item[green smoke bomb],
            $effect[none],
            "",
            __quest_state["Level 12"].state_string["Side seemingly fighting for"] != "hippy",
            !__quest_state["Level 12"].finished &&
                locationAvailable($location[The Battlefield (Frat Uniform)])
        ),
        new Wishable(
            $item[star chart],
            $effect[none],
            "",
            !__quest_state["Level 13"].state_boolean["Richard's star key used"] &&
                $item[Richard's star key].available_amount() < 1 &&
                $item[star chart].available_amount() < 1,
            locationAvailable($location[The Hole In The Sky])
        ),
        new Wishable(
            $item[none],
            $effect[Frosty],
            "init/item/meat for 8-bit",
            !__quest_state["Level 13"].state_boolean["digital key used"] &&
                $item[digital key].available_amount() < 1 &&
                get_property("8BitScore") < 10000,
            true
        ),
        new Wishable(
            $item[lowercase N],
            $effect[none],
            "",
            !__quest_state["Level 13"].state_boolean["king waiting to be freed"] &&
                $item[wand of nagamar].available_amount() < 1 &&
                $item[lowercase N].available_amount() < 1,
            locationAvailable($location[The Valley of Rof L'm Fao])
        )
    };

    Wishable [int] aftercoreWishables = {
        new Wishable(
            $item[bag of foreign bribes],
            $effect[none],
            "",
            locationAvailable($location[The Ice Hotel]),
            true
        )
    };

    int monkeyWishesLeft = clampi(5 - get_property_int("_monkeyPawWishesUsed"), 0, 5);
    string [int] options;
    if (__misc_state["in run"] && my_path().id != PATH_COMMUNITY_SERVICE) {
        options.listAppendList(showWishables(inRunWishables));
    }
    if (!__misc_state["in run"]) {
        options.listAppendList(showWishables(aftercoreWishables));
        if (count(options) == 0) {
            options.listAppend("The poors will have to settle for wishing effects.");
        }
    }

    if (count(options) > 0) {
        description.listAppend("Possible wishes:" + options.listJoinComponents("<hr>").HTMLGenerateIndentedText());
    }

    MonkeySkill [int] monkeySkills = {
        new MonkeySkill(5, $skill[Monkey Slap], "killbanish"),
        new MonkeySkill(4, $skill[Monkey Tickle], "delevel"),
        new MonkeySkill(3, $skill[Evil Monkey Eye], "spooky delevel"),
        new MonkeySkill(2, $skill[Monkey Peace Sign], "heal"),
        new MonkeySkill(1, $skill[Monkey Point], "Olfaction-lite")
        // No need for 0 (physical damage), tile is invisible anyway
    };

    string imageName;
    foreach index, monkeySkill in monkeySkills {
        description.listAppend(HTMLGenerateSpanOfClass(pluralise(monkeySkill.fingerCount, "finger", "fingers") + ": ", "r_bold") + monkeySkill.description);
        if (monkeySkill.fingerCount == monkeyWishesLeft) {
            imageName = `__skill {monkeySkill.theSkill.name}`;
        }
    }

    if (monkeyWishesLeft > 0) {
        resource_entries.listAppend(ChecklistEntryMake(imageName, url, ChecklistSubentryMake(pluralise(monkeyWishesLeft, "monkey's paw wish", `monkey's paw wishes`), "", description)).ChecklistEntrySetIDTag("Monkey wishes"));
    }
}
