//
// URLSearcher.m
// Copyright (C) 2012-2013 by David Hoerl
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "URLSearcher.h"

@interface URLSearcher ()
@property (nonatomic, strong) NSRegularExpression *regEx;
@property (nonatomic, strong) NSString *regExStr;

@end

@implementation URLSearcher

+ (instancetype)urlSearcherWithRegexStr:(NSString *)str
{
	URLSearcher *us;
	if([str length]) {
		__autoreleasing NSError *error;
		NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern:str options:0 error:&error];
		if(regEx) {
			us = [URLSearcher new];
			us.regExStr = [str copy];
			us.regEx = regEx;
		} else {
			NSLog(@"YIKES! Error %@", error);
		}
	}
	return us;
}

- (NSArray *)findMatchesInString:(NSString *)origStr
{
NSLog(@"CALLED");
	NSString *str = [origStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	// str = [origStr stringByReplacingOccurrencesOfString:@"\r" withString:@""]; // if needbe

	NSArray *ret = [self.regEx matchesInString:str options:0 range:NSMakeRange(0, [str length])];
	
	NSMutableArray *mret = [NSMutableArray arrayWithCapacity:[ret count]];
	for(NSTextCheckingResult *spec in ret) {
		NSRange r = spec.range;
		[mret addObject:[str substringWithRange:r]];
	}
	return mret;
}

- (BOOL)isValidURL:(NSString *)str
{
	NSRange r = NSMakeRange(0, [str length]);
	NSTextCheckingResult *exp = [self.regEx firstMatchInString:str options:0 range:r];
	//NSLog(@"str=%@ exp=%@", str, exp);
	//NSLog(@"regexStr=%@", self.regExStr);
	//if(exp && (exp.range.location != NSNotFound)) NSLog(@"EXP STR: %@", [str substringWithRange:exp.range]);

	return (exp && NSEqualRanges(r, exp.range));
}

@end
