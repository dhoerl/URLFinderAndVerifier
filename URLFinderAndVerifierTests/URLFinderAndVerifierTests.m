//
//  URLFinderAndVerifierTests.m
//  URLFinderAndVerifierTests
//
//  Created by David Hoerl on 5/16/13.
//  Copyright (c) 2013 dhoerl. All rights reserved.
//
// http://mathiasbynens.be/demo/url-regex

#import "URLFinderAndVerifierTests.h"
#import "URLSearcher.h"

@interface NSString (Hexer)

- (NSString *)hexer;

@end


@implementation NSString (Hexer)

- (NSString *)hexer
{
	NSMutableString *mstr = [NSMutableString stringWithCapacity:2*[self length]+100];
	
	const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];

	for(int i=0; i<strlen(cstr); ++i) {
		unsigned char c = ((unsigned char *)cstr)[i];
		if(c < 128) {
			[mstr appendFormat:@"%c", c];
		} else {
			[mstr appendFormat:@"%%%02x", c];
		}
	}
	return mstr;
}

@end

@implementation URLFinderAndVerifierTests
{
	URLSearcher *es;
}

- (void)setUp
{
    [super setUp];
    
	NSMutableString *regExStr = [NSMutableString stringWithString:[self processFile:@"TestRegex"]];
	[regExStr appendString:[self processFile:@"Query"]];
	[regExStr appendString:[self processFile:@"Fragment"]];

    es = [URLSearcher urlSearcherWithRegexStr:regExStr];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testGood
{
	NSString *path = [[NSBundle mainBundle] pathForResource:@"GoodURLs" ofType:@"txt"];
	assert(path);
	
	__autoreleasing NSError *error;
    NSString *urlStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
	NSArray *urls = [urlStr componentsSeparatedByString:@"\n"];
	
	[urls enumerateObjectsUsingBlock:^(NSString *url, NSUInteger idx, BOOL *stop)
		{
			//NSLog(@"URL: %@ success=%d", [url hexer], [es isValidURL:[url hexer]]);
			BOOL val = [es isValidURL:[url hexer]];
			STAssertTrue(val, @"Good URL %@ Failed!", url);
		} ];
}
- (void)testBad
{
	NSString *path = [[NSBundle mainBundle] pathForResource:@"BadURLs" ofType:@"txt"];
	assert(path);
	
	__autoreleasing NSError *error;
    NSString *urlStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
	NSArray *urls = [urlStr componentsSeparatedByString:@"\n"];
	
	[urls enumerateObjectsUsingBlock:^(NSString *url, NSUInteger idx, BOOL *stop)
		{
			BOOL val = [es isValidURL:[url hexer]];
			if(val) {
				//NSLog(@"URL: %@ success=%d", [url hexer], [es isValidURL:[url hexer]]);
				NSString *foo = [NSString stringWithFormat:@"%@ success=%d", [url hexer], [es isValidURL:[url hexer]]];
				printf("%s\n", [foo cStringUsingEncoding:NSUTF8StringEncoding]);
			}
			//STAssertFalse(val, @"Good URL %@ Failed!", url);
		} ];
}

- (NSString *)processFile:(NSString *)name
{
	NSLog(@"PROCESS %@ xxx %@", [NSBundle mainBundle], name);
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
	//NSLog(@"REGEX file=%@: %@", name, str);
	return str;
}

@end
