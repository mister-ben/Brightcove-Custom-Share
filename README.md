Brightcove-Custom-Share
=======================

Alternative share overlay for a Video Cloud Flash player. Requires a custom template with a BEML button - the plugin listens for clicks on this button to trigger the display of the overlay.

NOTE: This should be considered unfinished and intended as a proof of concept. Could be extended e.g. by mkaing calls to an analytics platform when the sharing buttons have been clicked. Probably needs a distinct close button rather than relying on the toggle button only. 

## Usage

* Create a new template with the BEML provided.
* Create a new player from the template.
* Upload the compiled swf to a web server and add the URL as a plugin in the player settings. Make sure your web server has a Flash crossdomain.xml policy file.
* Disable the regular sharing option / the menu.

## Example

http://bcove.me/8wwv1d16

## Compile

To compile you'll need the [Flex 4.6 SDK](http://www.adobe.com/devnet/flex/flex-sdk-download.html) and Brightcove's [Player API SWC](download a zip file that contains the Player API SWC)

    cd src
    /path/to/flex_sdk_4.6/bin/mxmlc -library-path+=/path/to/swc/ -static-link-runtime-shared-libraries=true -o ../bin/ShareOverlay.swf ShareOverlay.as
