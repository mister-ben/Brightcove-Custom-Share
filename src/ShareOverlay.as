package {
    import com.brightcove.api.events.*;
    import com.brightcove.api.*;
    import com.brightcove.api.modules.*;
    import com.brightcove.api.components.*;
    import flash.events.*;
    import flash.text.*;
    import flash.display.*;
    import flash.net.*;
    import flash.external.*;

    public class ShareOverlay extends CustomModule {

        private static const SHAREBUTTON_ID:String = "shareButton";

        private const LOG_TO_JAVASCRIPT:Boolean = true;

        private var _videoModule:VideoPlayerModule;
        private var _experienceModule:ExperienceModule;
        private var _socialModule:SocialModule;
        private var _menuModule:MenuModule;
        private var _shareButton:Button;
        private var _overlay:Sprite;
        private var _width:int;
        private var _height:int;
        private var facebook:Sprite;
        private var twitter:Sprite;
        private var google:Sprite;
        private var linkedin:Sprite;
        private var pinterest:Sprite;
        private var tumblr:Sprite;
        private var email:Sprite;
        private var shareLink:TextField;
        private var shareLinkStyle:TextFormat;

        override protected function initialize():void{
            var event:ExperienceEvent;
            this.log("This is a work in progress.");
            this.log("This is designed to work with a Chromeless Player with a specific button added to the BEML template. May not work or look right in other players.");
            this._videoModule = (player.getModule(APIModules.VIDEO_PLAYER) as VideoPlayerModule);
            this._experienceModule = (player.getModule(APIModules.EXPERIENCE) as ExperienceModule);
            this._socialModule = (player.getModule(APIModules.SOCIAL) as SocialModule);
            this._menuModule = (player.getModule(APIModules.MENU) as MenuModule);
            if (this._experienceModule.getReady()){
                event = new ExperienceEvent("dummy");
                this.onTemplateReady(event);
            } else {
                this._experienceModule.addEventListener(ExperienceEvent.TEMPLATE_READY, this.onTemplateReady);
            };
        }
        private function onTemplateReady(e:ExperienceEvent):void{
            this._overlay = this._videoModule.overlay();
            this._overlay.visible = false;
            this._shareButton = (this._experienceModule.getElementByID(SHAREBUTTON_ID) as Button);
            this._shareButton.setIncludeInLayout(true);
            this._shareButton.addEventListener(MouseEvent.CLICK, this.toggleSharePage);
            this._videoModule.addEventListener(MediaEvent.CHANGE, this.onChange);
            this._menuModule.addEventListener(MenuEvent.MENU_PAGE_OPEN, this.onMenuOpen);
            this._menuModule.addEventListener(MenuEvent.OVERLAY_MENU_OPEN, this.onMenuOpen);
            this.setupOverlay();
        }
        private function onChange(event:MediaEvent):void{
            this.updateShareLink();
        }
        private function onMenuOpen(event:MenuEvent):void{
            this._overlay.visible = false;
        }
        private function setupOverlay():void{
            this._width = this._videoModule.getCurrentDisplayWidth();
            this._height = this._videoModule.getCurrentDisplayHeight();
            this.shareLinkStyle = new TextFormat("_sans", 12, 0xFFFFFF, false, false, null, null, TextFormatAlign.CENTER);
            var lightbox:Sprite = new Sprite();
            lightbox.graphics.beginFill(0, 0.7);
            lightbox.graphics.drawRect(10, 40, (this._width - 20), (this._height - 100));
            this._overlay.addChild(lightbox);
            var shareTitle:TextField = new TextField();
            shareTitle.text = "Share this video";
            shareTitle.selectable = false;
            shareTitle.autoSize = TextFieldAutoSize.CENTER;
            shareTitle.setTextFormat(new TextFormat("_sans", 20, 0xFFFFFF, true, false, false, null, null, TextFormatAlign.CENTER));
            shareTitle.y = ((this._height / 2) - 85);
            shareTitle.x = ((this._width / 2) - (shareTitle.width / 2));
            this._overlay.addChild(shareTitle);
            var icons:Sprite = this.makeIcons();
            icons.y = ((shareTitle.y + shareTitle.height) + 20);
            icons.x = ((this._width / 2) - (icons.width / 2));
            this._overlay.addChild(icons);
            var shareLinkTitle:TextField = new TextField();
            shareLinkTitle.text = "Copy link";
            shareLinkTitle.selectable = false;
            shareLinkTitle.autoSize = TextFieldAutoSize.CENTER;
            shareLinkTitle.setTextFormat(new TextFormat("_sans", 14, 0xFFFFFF, false, false, null, null, TextFormatAlign.CENTER));
            shareLinkTitle.y = ((icons.y + icons.height) + 20);
            shareLinkTitle.x = ((this._width / 2) - (shareLinkTitle.width / 2));
            this._overlay.addChild(shareLinkTitle);
            this.shareLink = new TextField();
            this.shareLink.text = this._socialModule.getLink();
            this.shareLink.text = this._socialModule.getLink();
            this.shareLink.selectable = true;
            this.shareLink.autoSize = TextFieldAutoSize.CENTER;
            this.shareLink.setTextFormat(this.shareLinkStyle);
            this.shareLink.y = ((shareLinkTitle.y + shareLinkTitle.height) + 10);
            this.shareLink.x = ((this._width / 2) - (this.shareLink.width / 2));
            this._overlay.addChild(this.shareLink);
        }
        private function toggleSharePage(event:MouseEvent):void{
            if (this._overlay.visible){
                this._overlay.visible = false;
            } else {
                this._videoModule.goFullScreen(false);
                this.updateShareLink();
                if (this._menuModule.getOverlayMenuVisible()){
                    this._menuModule.closeMenuPage();
                };
                this._overlay.visible = true;
            };
        }
        private function updateShareLink():void{
            this.shareLink.text = this._socialModule.getLink();
            this.shareLink.setTextFormat(this.shareLinkStyle);
            this.shareLink.x = ((this._width / 2) - (this.shareLink.width / 2));
        }
        private function makeIcons():Sprite{
            var facebookIcon:Bitmap = new FacebookIcon();
            this.facebook = new Sprite();
            this.facebook.buttonMode = true;
            this.facebook.useHandCursor = true;
            this.facebook.addEventListener(MouseEvent.CLICK, this.onFacebookClick);
            this.facebook.addChild(facebookIcon);
            var twitterIcon:Bitmap = new TwitterIcon();
            this.twitter = new Sprite();
            this.twitter.buttonMode = true;
            this.twitter.useHandCursor = true;
            this.twitter.addEventListener(MouseEvent.CLICK, this.onTwitterClick);
            this.twitter.addChild(twitterIcon);
            var googleIcon:Bitmap = new GoogleIcon();
            this.google = new Sprite();
            this.google.buttonMode = true;
            this.google.useHandCursor = true;
            this.google.addEventListener(MouseEvent.CLICK, this.onGoogleClick);
            this.google.addChild(googleIcon);
            var linkedInIcon:Bitmap = new LinkedInIcon();
            this.linkedin = new Sprite();
            this.linkedin.buttonMode = true;
            this.linkedin.useHandCursor = true;
            this.linkedin.addEventListener(MouseEvent.CLICK, this.onLinkedInClick);
            this.linkedin.addChild(linkedInIcon);
            var pinterestIcon:Bitmap = new PinterestIcon();
            this.pinterest = new Sprite();
            this.pinterest.buttonMode = true;
            this.pinterest.useHandCursor = true;
            this.pinterest.addEventListener(MouseEvent.CLICK, this.onPinterestClick);
            this.pinterest.addChild(pinterestIcon);
            var tumblrIcon:Bitmap = new TumblrIcon();
            this.tumblr = new Sprite();
            this.tumblr.buttonMode = true;
            this.tumblr.useHandCursor = true;
            this.tumblr.addEventListener(MouseEvent.CLICK, this.onTumblrClick);
            this.tumblr.addChild(tumblrIcon);
            var icons:Sprite = new Sprite();
            icons.addChild(this.facebook);
            icons.addChild(this.twitter);
            icons.addChild(this.google);
            icons.addChild(this.linkedin);
            icons.addChild(this.pinterest);
            icons.addChild(this.tumblr);
            var iconGutter:Number = 20;
            if (this._width < 280){
                iconGutter = 2;
            } else {
                if (this._width < 350){
                    iconGutter = 10;
                };
            };
            this.twitter.x = ((this.facebook.x + this.facebook.width) + iconGutter);
            this.google.x = ((this.twitter.x + this.twitter.width) + iconGutter);
            this.linkedin.x = ((this.google.x + this.google.width) + iconGutter);
            this.pinterest.x = ((this.linkedin.x + this.linkedin.width) + iconGutter);
            this.tumblr.x = ((this.pinterest.x + this.pinterest.width) + iconGutter);
            return (icons);
        }
        private function onFacebookClick(pEvent:MouseEvent):void{
            var title:String = encodeURIComponent(this._videoModule.getCurrentVideo().displayName);
            var shareURL:String = encodeURIComponent(this._socialModule.getLink());
            var url:String = ((("https://www.facebook.com/sharer.php?u=" + shareURL) + "&t=") + title);
            this._videoModule.pause(true);
            navigateToURL(new URLRequest(url), "_blank");
        }
        private function onTwitterClick(pEvent:MouseEvent):void{
            var title:String = encodeURIComponent(this._videoModule.getCurrentVideo().displayName);
            var shareURL:String = encodeURIComponent(this._socialModule.getLink());
            var url:String = ((("https://twitter.com/share?url=" + shareURL) + "&text=") + title);
            this._videoModule.pause(true);
            navigateToURL(new URLRequest(url), "_blank");
        }
        private function onPinterestClick(pEvent:MouseEvent):void{
            var title:String = encodeURIComponent(this._videoModule.getCurrentVideo().displayName);
            var description:String = encodeURIComponent(this._videoModule.getCurrentVideo().shortDescription);
            var videoStill:String = encodeURIComponent(this._videoModule.getCurrentVideo().videoStillURL);
            var shareURL:String = encodeURIComponent(this._socialModule.getLink());
            var url:String = ((((((("http://pinterest.com/pin/create/button/?url=" + shareURL) + "&text=") + title) + "&media=") + videoStill) + "&description=") + description);
            this._videoModule.pause(true);
            navigateToURL(new URLRequest(url), "_blank");
        }
        private function onLinkedInClick(pEvent:MouseEvent):void{
            var title:String = encodeURIComponent(this._videoModule.getCurrentVideo().displayName);
            var description:String = encodeURIComponent(this._videoModule.getCurrentVideo().shortDescription);
            var videoStill:String = encodeURIComponent(this._videoModule.getCurrentVideo().videoStillURL);
            var shareURL:String = encodeURIComponent(this._socialModule.getLink());
            var url:String = ((((((((("http://www.linkedin.com/shareArticle?mini=true&url=" + shareURL) + "&title=") + title) + "&media=") + videoStill) + "&summary=") + description) + "&source=") + encodeURIComponent(shareURL));
            this._videoModule.pause(true);
            navigateToURL(new URLRequest(url), "_blank");
        }
        private function onGoogleClick(pEvent:MouseEvent):void{
            var shareURL:String = encodeURIComponent(this._socialModule.getLink());
            var url:String = ("https://plus.google.com/share?url=" + shareURL);
            this._videoModule.pause(true);
            navigateToURL(new URLRequest(url), "_blank");
        }
        private function onTumblrClick(pEvent:MouseEvent):void{
            var title:String = encodeURIComponent(this._videoModule.getCurrentVideo().displayName);
            var description:String = encodeURIComponent(this._videoModule.getCurrentVideo().shortDescription);
            var videoStill:String = encodeURIComponent(this._videoModule.getCurrentVideo().videoStillURL);
            var shareURL:String = encodeURIComponent(this._socialModule.getLink());
            var url:String = ((((("http://www.tumblr.com/share/link?url=" + shareURL) + "&name=") + title) + "&description=") + description);
            this._videoModule.pause(true);
            navigateToURL(new URLRequest(url), "_blank");
        }
        private function log(message:String):void{
            var message:* = message;
            trace(message);
            message = message.replace("'", "");
            if (this.LOG_TO_JAVASCRIPT == true){
                try {
                    ExternalInterface.call((("function() { if (window.console && window.console.log) {window.console.log('Share plugin: " + message) + "')} }()"));
                } catch(error:Error) {
                };
            };
        }

    }
}//package 
