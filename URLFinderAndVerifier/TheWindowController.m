//
//  TheWindowController.m
//  EmailAddressFinder
//
//  Created by David Hoerl on 3/20/13.
//  Copyright (c) 2013 dhoerl. All rights reserved.
//

#import "TheWindowController.h"
#import "URLSearcher.h"

@interface TheWindowController ()
@end

@implementation TheWindowController
{
	IBOutlet NSTextView *testString;
	IBOutlet NSTextView *resultsList;

	IBOutlet NSPopUpButton *scheme;
	IBOutlet NSPopUpButton *authority;
	IBOutlet NSButton *query;
	IBOutlet NSButton *fragment;
	
	URLSearcher *es;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
	
	es = [URLSearcher new];

	[scheme selectItemAtIndex:1];
	[authority selectItemAtIndex:1];
}

- (void)windowWillClose:(NSNotification *)notification
{
	dispatch_async(dispatch_get_main_queue(), ^
		{
			[[NSApplication sharedApplication] terminate:self];
		} );
}

- (IBAction)testAction:(id)sender
{
#if 0
	NSString *str = [testString string];
	if(![str length]) {
		NSBeep();
	} else
	if([es.regex isEqualToString:@"Mailto"]) {
		[resultsList setString:@""];
	
		NSArray *a = [es findMailtoItems:str];
		NSMutableString *str = [NSMutableString stringWithCapacity:256];

		for(NSDictionary *dict in a) {
			[str appendString:dict.description];
			[str appendString:@"\n"];
		}
		
		[resultsList setString:str];
	} else {
		[resultsList setString:@""];
	
		NSArray *a = [es findMatchesInString:str];
		NSMutableString *str = [NSMutableString stringWithCapacity:256];
		
		for(id foo in a) {
			if([foo isMemberOfClass:[NSNull class]]) {
				NSLog(@"YIKES! failed to process address");
				continue;
			}
			NSDictionary *dict = (NSDictionary *)foo;
			NSString *entry;
			if(dict[@"mailbox"]) {
				entry = [NSString stringWithFormat:@"Address: %@  Name: %@  Mailbox: %@", dict[@"address"], dict[@"name"], dict[@"mailbox"]];
			} else {
				entry = [NSString stringWithFormat:@"Address: %@", dict[@"address"]];
			}
			[str appendString:entry];
			[str appendString:@"\n"];
		}
		
		[resultsList setString:str];
	}
#endif
}

- (IBAction)quitAction:(id)sender
{
	dispatch_async(dispatch_get_main_queue(), ^
		{
			[[NSApplication sharedApplication] terminate:self];
		} );
}
- (IBAction)testSelection:(id)sender
{
	NSString *str = [testString string];

	es = [URLSearcher urlSearcherWithRegexStr:[self createRegEx]];
	if(es) {
		BOOL val = [es isValidURL:str];
		[resultsList setString:val ? @"YES!" : @"No"];
	} else {
		[resultsList setString:@"Regex failed!"];
	}
}
- (IBAction)pasteRegex:(id)sender
{
	[resultsList setString:[self createRegEx]];
}

- (NSString *)createRegEx
{
	NSMutableString *regEx = [NSMutableString stringWithCapacity:512];

	NSString *fileName;
	NSString *part;

	fileName = [scheme indexOfSelectedItem] == 0 ? @"AllSchemes" : @"HTTPScheme";
	part = [self processFile:fileName];
	[regEx appendString:part];

	[regEx appendString:@":"];

	fileName = [authority indexOfSelectedItem] == 0 ? @"AllAuthority" : @"SlashSlashAuthPathABEmpty";
	part = [self processFile:fileName];
	[regEx appendString:part];

	if([query state] == NSOnState) {
	[regEx appendString:@":"];
		part = [self processFile:@"Query"];
		[regEx appendString:@"?"];
		[regEx appendString:part];
	}

	if([fragment state] == NSOnState) {
		part = [self processFile:@"Fragment"];
		[regEx appendString:@"#"];
		[regEx appendString:part];
	}
	return regEx;
}

- (NSString *)processFile:(NSString *)name
{
NSLog(@"PROCESS %@", name);
	NSString *file = [[NSBundle mainBundle] pathForResource:name ofType:@"txt"];
	assert(file);
	
	__autoreleasing NSError *error;
	NSString *origStr = [NSString stringWithContentsOfFile:file encoding:NSASCIIStringEncoding error:&error];

	NSMutableString *str = [NSMutableString stringWithCapacity:[origStr length]];
	NSArray *array = [origStr componentsSeparatedByString:@"\n"];
	[array enumerateObjectsUsingBlock:^(NSString *sub, NSUInteger idx, BOOL *stop)
		{
			if(![sub length]) return;
			if([sub characterAtIndex:0] == '#') return;
			if([sub characterAtIndex:0] == '.') { *stop = YES; return; }
			
			NSArray *line = [sub componentsSeparatedByString:@" #"];
			NSString *first = line[0];
			first = [first stringByReplacingOccurrencesOfString:@" " withString:@""];
			if([first length]) {
				//first = [first stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//NSLog(@"FIRST: \"%@\"", first);
				if([first length]) {
					[str appendString:first];
				}
			}
		} ];
	NSLog(@"REGEX file=%@: %@", name, str);
	return str;
}

@end
