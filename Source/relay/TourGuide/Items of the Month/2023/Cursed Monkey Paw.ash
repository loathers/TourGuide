record MonkeyWish {
    // If the wish is an item, set that here. Otherwise, use $item[none].
    item theItem;

    // If the wish is an effect, set that here. Otherwise, use $effect[none].
    effect theEffect;

    // If you want additional description text other than the item/effect name,
    // set that here.
    string additionalDescription;

    // A boolean value indicating whether the wish is useful at all.
    boolean shouldDisplay;

    // A boolean value indicating whether the wish is currently accessible
    // (since the paw will prevent wishes you can't access).
    boolean currentlyAccessible;
};

string showWish(MonkeyWish wish) {
    string color = wish.currentlyAccessible ? "black" : "gray";
    string wishStr;
    string additionalDescription = wish.additionalDescription != "" ?
        `: {wish.additionalDescription}` :
        "";
    if (wish.theItem != $item[none]) {
        wishStr = `{wish.theItem.name}{additionalDescription}`;
    } else if (wish.theEffect != $effect[none]) {
        wishStr = `{wish.theEffect.name}{additionalDescription}`;
    } else {
        wishStr = "Unknown item/effect. Report to TourGuide devs >:(";
    }
    return HTMLGenerateSpanFont(wishStr, color);
}

string [int] showWishes(MonkeyWish [int] wishes) {
    string [int] currentWishes = {};
    string [int] futureWishes = {};
    // My kingdom for polymorphic filter :|
    foreach index, wish in wishes {
        if (!wish.shouldDisplay) continue;

        if (wish.currentlyAccessible) {
            currentWishes.listAppend(showWish(wish));
        } else {
            futureWishes.listAppend(showWish(wish));
        }
    }
    string [int] allWishes = {};
    allWishes.listAppendList(currentWishes);
    allWishes.listAppendList(futureWishes);
    return allWishes;
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

    MonkeyWish [int] inRunWishes = {
        new MonkeyWish(
            $item[sonar-in-a-biscuit],
            $effect[none],
            "",
            get_property("questL04Bat") != "finished" &&
                !locationAvailable($location[The Boss Bat's Lair]),
            locationAvailable($location[Guano Junction])
        ),
        new MonkeyWish(
            $item[enchanted bean],
            $effect[none],
            "",
            !__quest_state["Level 10"].state_boolean["beanstalk grown"] &&
                available_amount($item[enchanted bean]) < 1,
            locationAvailable($location[The Beanbat Chamber])
        ),
        new MonkeyWish(
            $item[none],
            $effect[Knob Goblin Perfume],
            "",
            !__quest_state["Level 5"].finished &&
                available_amount($item[Knob Goblin perfume]) < 1,
            true
        ),
        new MonkeyWish(
            $item[Knob Goblin harem veil],
            $effect[none],
            "",
            !__quest_state["Level 5"].finished &&
                available_amount($item[Knob Goblin harem veil]) < 1,
            locationAvailable($location[Cobb's Knob Harem])
        ),
        new MonkeyWish(
            $item[Knob Goblin harem pants],
            $effect[none],
            "",
            !__quest_state["Level 5"].finished &&
                available_amount($item[Knob Goblin harem pants]) < 1,
            locationAvailable($location[Cobb's Knob Harem])
        ),
        new MonkeyWish(
            $item[stone wool],
            $effect[none],
            "",
            !locationAvailable($location[The Hidden Park]) &&
                available_amount($item[stone wool]) < 2,
            locationAvailable($location[The Hidden Temple])
        ),
        new MonkeyWish(
            $item[amulet of extreme plot significance],
            $effect[none],
            "",
            !locationAvailable($location[The Castle In The Clouds In The Sky (Ground Floor)]) &&
                available_amount($item[amulet of extreme plot significance]) < 1,
            locationAvailable($location[The Penultimate Fantasy Airship])
        ),
        new MonkeyWish(
            $item[mohawk wig],
            $effect[none],
            "",
            !__quest_state["Level 10"].finished &&
                available_amount($item[mohawk wig]) < 1,
            locationAvailable($location[The Penultimate Fantasy Airship])
        ),
        new MonkeyWish(
            $item[book of matches],
            $effect[none],
            "",
            my_ascensions() != get_property_int("hiddenTavernUnlock") &&
                $item[book of matches].available_amount() < 1,
            locationAvailable($location[The Hidden Park])
        ),
        new MonkeyWish(
            $item[rusty hedge trimmers],
            $effect[none],
            "",
            get_property_int("twinPeakProgress") < 13,
            locationAvailable($location[Twin Peak])
        ),
        new MonkeyWish(
            $item[killing jar],
            $effect[none],
            "",
            !__quest_state["Level 11 Desert"].state_boolean["Killing Jar Given"] &&
                get_property_int("desertExploration") < 100 &&
                available_amount($item[killing jar]) < 1,
            locationAvailable($location[The Haunted Library])
        ),
        new MonkeyWish(
            $item[none],
            $effect[Dirty Pear],
            HTMLGenerateSpanFont("double sleaze damage", "purple"),
            get_property_int("zeppelinProtestors") < 80,
            true
        ),
        new MonkeyWish(
            $item[none],
            $effect[Painted-On Bikini],
            HTMLGenerateSpanFont("+100 sleaze damage", "purple"),
            get_property_int("zeppelinProtestors") < 80,
            true
        ),
        new MonkeyWish(
            $item[glark cable],
            $effect[none],
            "",
            __quest_state["Level 11 Ron"].mafia_internal_step < 5,
            locationAvailable($location[The Red Zeppelin])
        ),
        new MonkeyWish(
            $item[short writ of habeas corpus],
            $effect[none],
            "",
            !__quest_state["Level 11 Hidden City"].finished,
            locationAvailable($location[The Hidden Park])
        ),
        new MonkeyWish(
            $item[lion oil],
            $effect[none],
            "",
            $item[mega gem].available_amount() < 1 &&
                $item[lion oil].available_amount() < 1,
            locationAvailable($location[Whitey's Grove])
        ),
        new MonkeyWish(
            $item[bird rib],
            $effect[none],
            "",
            $item[mega gem].available_amount() < 1 &&
                $item[bird rib].available_amount() < 1,
            locationAvailable($location[Whitey's Grove])
        ),
        new MonkeyWish(
            $item[drum machine],
            $effect[none],
            "",
            get_property_int("desertExploration") < 100 &&
                $item[drum machine].available_amount() < 1,
            locationAvailable($location[The Oasis])
        ),
        new MonkeyWish(
            $item[shadow brick],
            $effect[none],
            "",
            get_property_int("_shadowBricksUsed") + available_amount($item[shadow brick]) < 13,
            true
        ),
        new MonkeyWish(
            $item[green smoke bomb],
            $effect[none],
            "",
            !__quest_state["Level 12"].finished &&
                __quest_state["Level 12"].state_string["Side seemingly fighting for"] != "hippy",
            __quest_state["Level 12"].state_boolean["War in progress"] &&
                get_property_int("hippiesDefeated") >= 400
        ),
        new MonkeyWish(
            $item[star chart],
            $effect[none],
            "",
            !__quest_state["Level 13"].state_boolean["Richard's star key used"] &&
                $item[Richard's star key].available_amount() < 1 &&
                $item[star chart].available_amount() < 1,
            locationAvailable($location[The Hole In The Sky])
        ),
        new MonkeyWish(
            $item[none],
            $effect[Frosty],
            "init/item/meat",
            !__quest_state["Level 13"].state_boolean["digital key used"] &&
                $item[digital key].available_amount() < 1 &&
                get_property("8BitScore") < 10000,
            true
        ),
        new MonkeyWish(
            $item[none],
            $effect[Staying Frosty],
            HTMLGenerateSpanFont("cold damage race", "blue"),
            !__quest_state["Level 13"].state_boolean["Elemental damage race completed"] && 
                __quest_state["Level 13"].state_string["Elemental damage race type"] == "cold",
			true
        ),
        new MonkeyWish(
            $item[none],
            $effect[Dragged Through the Coals],
            HTMLGenerateSpanFont("hot damage race", "red"),
            !__quest_state["Level 13"].state_boolean["Elemental damage race completed"] && 
                __quest_state["Level 13"].state_string["Elemental damage race type"] == "hot",
			true
        ),
        new MonkeyWish(
            $item[none],
            $effect[Bored Stiff],
            HTMLGenerateSpanFont("spooky damage race", "gray"),
            !__quest_state["Level 13"].state_boolean["Elemental damage race completed"] && 
                __quest_state["Level 13"].state_string["Elemental damage race type"] == "spooky",
			true
        ),
        new MonkeyWish(
            $item[none],
            $effect[Sewer-Drenched],
            HTMLGenerateSpanFont("stench damage race", "green"),
            !__quest_state["Level 13"].state_boolean["Elemental damage race completed"] && 
                __quest_state["Level 13"].state_string["Elemental damage race type"] == "stench",
			true
        ),
        new MonkeyWish(
            $item[none],
            $effect[Fifty Ways to Bereave Your Lover],
            HTMLGenerateSpanFont("sleaze damage race", "purple"),
            !__quest_state["Level 13"].state_boolean["Elemental damage race completed"] && 
                __quest_state["Level 13"].state_string["Elemental damage race type"] == "sleaze" &&
                get_property_int("zeppelinProtestors") > 79,
			true
        ),
        new MonkeyWish(
            $item[lowercase N],
            $effect[none],
            "summon the nagamar",
            !__quest_state["Level 13"].state_boolean["king waiting to be freed"] &&
                // This accounts for being on a path that needs the wand as well
                // as whether you already have one. See State.ash
                __misc_state["wand of nagamar needed"] &&
                $item[lowercase N].available_amount() < 1 &&
                $item[ruby W].available_amount() > 0 &&
                $item[metallic A].available_amount() > 0 &&
                $item[heavy D].available_amount() > 0,
            locationAvailable($location[The Valley of Rof L'm Fao])
        )
    };

    MonkeyWish [int] aftercoreWishes = {
        new MonkeyWish(
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
        options.listAppendList(showWishes(inRunWishes));
    }
    if (!__misc_state["in run"]) {
        options.listAppendList(showWishes(aftercoreWishes));
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

    // Banish combination tag for the monkey slap, if you've got it.
    if (monkeyWishesLeft == 5) {
        string [int] description;
        string url;
        url = "main.php";
        description.listAppend("Turn-taking repeat-use banish. Lasts until you use it again!");
        if ($item[cursed monkey paw].equipped_amount() == 0) {
            description.listAppend("Equip your cursed monkey paw first.");
            url = "inventory.php?ftext=cursed+monkey";
        }
        resource_entries.listAppend(ChecklistEntryMake("__skill monkey slap", "", ChecklistSubentryMake("Monkey Slap usable", "", description), 0).ChecklistEntrySetCombinationTag("banish").ChecklistEntrySetIDTag("Cursed monkey paw banish"));
    }
}
