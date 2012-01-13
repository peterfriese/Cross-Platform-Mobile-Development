//
//  AppDelegate.m
//  HelloPhoneGap
//
//  Created by Peter Friese on 12.01.12.
//  Copyright http://peterfriese.de 2012. All rights reserved.
//

#import "AppDelegate.h"
#ifdef PHONEGAP_FRAMEWORK
	#import <PhoneGap/PhoneGapViewController.h>
#else
	#import "PhoneGapViewController.h"
#endif

@implementation AppDelegate

@synthesize invokeString;

- (id) init
{	
	/** If you need to do any extra app-specific initialization, you can do it here
	 *  -jm
	 **/
    return [super init];
}

/**
 * This is main kick off after the app inits, the views and Settings are setup here. (preferred - iOS4 and up)
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    NSURL* url = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    if (url && [url isKindOfClass:[NSURL class]])
    {
        self.invokeString = [url absoluteString];
		NSLog(@"HelloPhoneGap launchOptions = %@",url);
    }    
		
	return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

// this happens while we are running ( in the background, or from within our own app )
// only valid if HelloPhoneGap.plist specifies a protocol to handle
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url 
{
    // must call super so all plugins will get the notification, and their handlers will be called 
	// super also calls into javascript global function 'handleOpenURL'
    return [super application:application handleOpenURL:url];
}

-(id) getCommandInstance:(NSString*)className
{
	/** You can catch your own commands here, if you wanted to extend the gap: protocol, or add your
	 *  own app specific protocol to it. -jm
	 **/
	return [super getCommandInstance:className];
}

/**
 Called when the webview finishes loading.  This stops the activity view and closes the imageview
 */
- (void)webViewDidFinishLoad:(UIWebView *)theWebView 
{
	// only valid if HelloPhoneGap.plist specifies a protocol to handle
	if(self.invokeString)
	{
		// this is passed before the deviceready event is fired, so you can access it in js when you receive deviceready
		NSString* jsString = [NSString stringWithFormat:@"var invokeString = \"%@\";", self.invokeString];
		[theWebView stringByEvaluatingJavaScriptFromString:jsString];
	}
	
	 // Black base color for background matches the native apps
   	theWebView.backgroundColor = [UIColor blackColor];
    
	return [ super webViewDidFinishLoad:theWebView ];
}

- (void)webViewDidStartLoad:(UIWebView *)theWebView 
{
	return [ super webViewDidStartLoad:theWebView ];
}

/**
 * Fail Loading With Error
 * Error - If the webpage failed to load display an error with the reason.
 */
- (void)webView:(UIWebView *)theWebView didFailLoadWithError:(NSError *)error 
{
	return [ super webView:theWebView didFailLoadWithError:error ];
}

/**
 * Start Loading Request
 * This is where most of the magic happens... We take the request(s) and process the response.
 * From here we can redirect links and other protocols to different internal methods.
 */
- (BOOL)webView:(UIWebView *)theWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // DEMO (Peter): All requests must pass this method. Here's a log statement showing this:
    NSLog(@"Request: %@", [request URL]);
    
    
    // DEMO (Peter): Intercept URL of kind demo:// and display what's after demo://
    if ([[[request URL] scheme] isEqualToString:@"demo"]) {
        [[[UIAlertView alloc] initWithTitle:@"Message from your browser" message:[[request URL] host] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return NO;
    }
    
    // DEMO (Peter): Execute a piece of JavaScript inside the browser:
    if ([[[request URL] scheme] isEqualToString:@"form"]) {
        NSString *value = [[request URL] query];
        NSArray *tuples = [value componentsSeparatedByString:@"="];
        NSString *script = [NSString stringWithFormat:@"document.getElementById('stuff').innerHTML += '<li>%@</li>'", [tuples objectAtIndex:1]];
        [theWebView stringByEvaluatingJavaScriptFromString:script];
        return NO;
    }
    else {
        // this is the original call to PhoneGap
        return [ super webView:theWebView shouldStartLoadWithRequest:request navigationType:navigationType ];        
    }
}


- (BOOL) execute:(InvokedUrlCommand*)command
{
	return [ super execute:command];
}

- (void)dealloc
{
	[ super dealloc ];
}

@end
