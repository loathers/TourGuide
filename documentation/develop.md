<img src="https://user-images.githubusercontent.com/8014761/190516106-6e8c948c-9302-47e0-b09e-114a5456301d.png" alt="tourguide logo" style="width: 50%;">

# TourGuide Development

This file will go over the basics of developing for TourGuide.

## Testing local changes

As you develop features locally for TourGuide, you'll want to run them on your local machine to ensure they work. The test_local_changes.py script makes this easy.

When starting to develop for the first time, you'll want to edit test_local_changes.py and ensure that `MAFIA_DIRECTORY` points at the base folder for your mafia install. Once that's done, you just need to run test_local_changes.py each time you want to test your changes. It will build it into a single script and then set it up in Mafia as `TourGuide-Dev` in the relay browser.

If you leave that instance of TourGuide running in the relay browser, it will auto-update each time you run test_local_changes.py without needing to manually refresh.
