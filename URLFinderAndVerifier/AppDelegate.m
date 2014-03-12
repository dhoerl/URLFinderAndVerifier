//
//  AppDelegate.m
//  URLFinderAndVerifier
//
//  Created by David Hoerl on 5/16/13.
//  Copyright (c) 2013-2014 David Hoerl All rights reserved.
//

#import "AppDelegate.h"
#import "TheWindowController.h"

@implementation AppDelegate
{
	TheWindowController *wc;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	wc = [[TheWindowController alloc] initWithWindowNibName:@"TheWindowController"];
	assert(wc);
	assert(wc.window);
	[wc.window makeKeyAndOrderFront:self];
}

@end
