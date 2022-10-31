#!/usr/bin/env python3

import os
import shutil

import Bundle_ASH_script

# If needed, replace this with the path to your mafia's base config folder
MAFIA_DIRECTORY = f"/Users/{os.getlogin()}/Library/Application Support/Kolmafia"

# Change this if you prefer a different name in-game
BUNDLED_SCRIPT_NAME = "relay_TourGuide-Dev.ash"

if not os.path.exists(MAFIA_DIRECTORY):
    print(f"""Path {MAFIA_DIRECTORY} doesn't exist.
Try editing MAFIA_DIRECTORY in {os.path.basename(__file__)} to your mafia's base config folder.
""")
    exit(1)

if os.path.exists(BUNDLED_SCRIPT_NAME):
    os.remove(BUNDLED_SCRIPT_NAME)

Bundle_ASH_script.bundle_and_write("relay/relay_TourGuide.ash", BUNDLED_SCRIPT_NAME, "Source")
shutil.copy2(BUNDLED_SCRIPT_NAME, f"{MAFIA_DIRECTORY}/relay/.")
