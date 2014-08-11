Brightcove-Custom-Share
=======================

Alternative share overlay for a Video Cloud Flash player. Requires a custom template with a BEML button - the plugin listens for clicks on this button to trigger the display of the overlay.

Intended as a proof of concept. Could be extended e.g. by mkaing calls to an analytics platform when the sharing buttons have been clicked.

To compile you'll need the [Flex 4.6 SDK](http://www.adobe.com/devnet/flex/flex-sdk-download.html) and Brightcove's [Player API SWC](download a zip file that contains the Player API SWC)

    cd src
    /path/to/flex_sdk_4.6/bin/mxmlc -library-path+=/path/to/swc/ -static-link-runtime-shared-libraries=true -o ../bin/ShareOverlay.swf ShareOverlay.as
