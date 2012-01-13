# About this sample #

This is a very simple PhoneGap-based app which has been created using the Xcode project template delivered with PhoneGap. it's purpose is to demonstrate how PhoneGap works by showing:

* request interception
* PhoneGap plugins

## Request interception ##

In order to see how request interception works, have a look at `AppDelegate::webView:shouldStartLoadWithRequest:navigationType:` - it contains a few comments highlighting the various ways to intercept an URL.

## PhoneGap plugins ##

Writing PhoneGap plugins requires you to provide the following files:

1. A native class that implements the intended functionality
2. A JavaScript class that acts as a bridge between PhoneGap and the native class
3. You also need to register the plugin in `PhoneGap.plist`

This app contains a very simple sample plug-in which is made up of the following files:

1. `www/MyPlugin.js` (JavaScript bridge)
2. `Classes/Plugins/MyClass.h`  (Header file)
3. `Classes/Plugins/MyClass.m` (Implementation file)

It is worth pointing out that you need to provide the native class **and** the JavaScript class for each platform you intend to support.
