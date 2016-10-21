//
//  Regex.m
//  Snippy
//
//  Created by Devin Ross on 10/13/16.
//  Copyright © 2016 Devin Ross. All rights reserved.
//

#import "Regex.h"
#import "NSUserDefaults+NSColorSupport.h"

@implementation Regex

+ (NSArray*) languages{
	return [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Languages" ofType:@"plist"]];
}

#define RGBA(_RED,_GREEN,_BLUE,_ALPHA) [NSColor colorWithRed:_RED/255.0 green:_GREEN/255.0 blue:_BLUE/255.0 alpha:_ALPHA]

#define DEFAULT_KEY(_STRING) [NSString stringWithFormat:@"regex-color-%@",_STRING]

+ (NSDictionary*) syntaxThemeColors:(RegexHighlightViewTheme)theme {
	
	NSDictionary* themeColor;
	
	
	if(theme == kRegexHighlightViewThemeCustom){
		
		//default:
		NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
		
		NSMutableDictionary *md = [NSMutableDictionary dictionary];
		NSArray *keys = @[kRegexHighlightViewTypeText,
						  kRegexHighlightViewTypeBackground,
						  kRegexHighlightViewTypeComment,
						  kRegexHighlightViewTypeDocumentationComment,
						  kRegexHighlightViewTypeDocumentationCommentKeyword,
						  kRegexHighlightViewTypeString,
						  kRegexHighlightViewTypeCharacter,
						  kRegexHighlightViewTypeNumber,
						  kRegexHighlightViewTypeKeyword,
						  kRegexHighlightViewTypePreprocessor,
						  kRegexHighlightViewTypeURL,
						  kRegexHighlightViewTypeAttribute,
						  kRegexHighlightViewTypeProject,
						  kRegexHighlightViewTypeOther ];
		
		for(NSString *key in keys){
			NSColor *clr = [def colorForKey:DEFAULT_KEY(key)];
			if(clr) md[key] = clr;
		}
		return md.copy;
	}
	
	
	
	
	
	
	//If not define the theme and return it
	switch(theme) {
			
		case kRegexHighlightViewThemeDefault:
			themeColor = @{kRegexHighlightViewTypeText                           : RGBA(0, 0, 0, 1),
						   kRegexHighlightViewTypeBackground                     : RGBA(255, 255, 255, 0),
						   kRegexHighlightViewTypeComment                        : RGBA(0, 131, 16, 1),
						   kRegexHighlightViewTypeDocumentationComment           : RGBA(0, 131, 16, 1),
						   kRegexHighlightViewTypeDocumentationCommentKeyword    : RGBA(1, 75, 23, 1),
						   kRegexHighlightViewTypeString                         : RGBA(208, 45, 33, 1),
						   kRegexHighlightViewTypeCharacter                      : RGBA(32, 56, 213, 1),
						   kRegexHighlightViewTypeNumber                         : RGBA(32, 56, 213, 1),
						   kRegexHighlightViewTypeKeyword                        : RGBA(184, 51, 161, 1),
						   kRegexHighlightViewTypePreprocessor                   : RGBA(119, 72, 44, 1),
						   kRegexHighlightViewTypeURL                            : RGBA(0, 71, 252, 1),
						   kRegexHighlightViewTypeAttribute                      : RGBA(149, 125, 57, 1),
						   kRegexHighlightViewTypeProject                        : RGBA(80, 129, 135, 1),
						   kRegexHighlightViewTypeOther                          : RGBA(110, 67, 168, 1)};
			break;
		case kRegexHighlightViewThemeDusk:
			themeColor = @{kRegexHighlightViewTypeText                           : RGBA(255, 255, 255, 1),
						   kRegexHighlightViewTypeBackground                     : RGBA(40, 43, 53, 1),
						   
						   kRegexHighlightViewTypeComment                        : RGBA(82, 190, 91, 1),
						   kRegexHighlightViewTypeDocumentationComment           : RGBA(82, 190, 91, 1),
						   kRegexHighlightViewTypeDocumentationCommentKeyword    : RGBA(82, 190, 91, 1),
						   
						   kRegexHighlightViewTypeString                         : RGBA(226, 69, 76, 1),
						   kRegexHighlightViewTypeCharacter                      : RGBA(139, 134, 201, 1),
						   kRegexHighlightViewTypeNumber                         : RGBA(139, 134, 201, 1),
						   kRegexHighlightViewTypeKeyword                        : RGBA(195, 55, 149, 1),
						   kRegexHighlightViewTypePreprocessor                   : RGBA(211, 142, 99, 1),
						   kRegexHighlightViewTypeURL                            : RGBA(35, 63, 208, 1),
						   kRegexHighlightViewTypeAttribute                      : RGBA(103, 135, 142, 1),
						   kRegexHighlightViewTypeProject                        : RGBA(146, 199, 119, 1),
						   kRegexHighlightViewTypeOther                          : RGBA(0, 175, 199, 1)};
			break;
		case kRegexHighlightViewThemeLowKey:
			themeColor = @{kRegexHighlightViewTypeText                           : RGBA(0, 0, 0, 1),
						   kRegexHighlightViewTypeBackground                     : RGBA(255, 255, 255, 0),
						   
						   kRegexHighlightViewTypeComment                        : RGBA(84, 99, 75, 1),
						   kRegexHighlightViewTypeDocumentationComment           : RGBA(84, 99, 75, 1),
						   kRegexHighlightViewTypeDocumentationCommentKeyword    : RGBA(84, 99, 75, 1),
						   kRegexHighlightViewTypeString                         : RGBA(133, 63, 98, 1),
						   kRegexHighlightViewTypeCharacter                      : RGBA(50, 64, 121, 1),
						   kRegexHighlightViewTypeNumber                         : RGBA(50, 64, 121, 1),
						   kRegexHighlightViewTypeKeyword                        : RGBA(50, 64, 121, 1),
						   kRegexHighlightViewTypePreprocessor                   : RGBA(0, 0, 0, 1),
						   kRegexHighlightViewTypeURL                            : RGBA(24, 49, 168, 1),
						   kRegexHighlightViewTypeAttribute                      : RGBA(35, 93, 43, 1),
						   kRegexHighlightViewTypeProject                        : RGBA(87, 127, 164, 1),
						   kRegexHighlightViewTypeOther                          : RGBA(87, 127, 164, 1)};
			break;
		case kRegexHighlightViewThemeMidnight:
			themeColor = @{kRegexHighlightViewTypeText                           : RGBA(255, 255, 255, 1),
						   kRegexHighlightViewTypeBackground                     : RGBA(0, 0, 0, 1),
						   kRegexHighlightViewTypeComment                        : RGBA(69, 208, 106, 1),
						   kRegexHighlightViewTypeDocumentationComment           : RGBA(69, 208, 106, 1),
						   kRegexHighlightViewTypeDocumentationCommentKeyword    : RGBA(69, 208, 106, 1),
						   kRegexHighlightViewTypeString                         : RGBA(255, 68, 77, 1),
						   kRegexHighlightViewTypeCharacter                      : RGBA(139, 138, 247, 1),
						   kRegexHighlightViewTypeNumber                         : RGBA(139, 138, 247, 1),
						   kRegexHighlightViewTypeKeyword                        : RGBA(224, 59, 160, 1),
						   kRegexHighlightViewTypePreprocessor                   : RGBA(237, 143, 100, 1),
						   kRegexHighlightViewTypeURL                            : RGBA(36, 72, 244, 1),
						   kRegexHighlightViewTypeAttribute                      : RGBA(79, 108, 132, 1),
						   kRegexHighlightViewTypeProject                        : RGBA(0, 249, 161, 1),
						   kRegexHighlightViewTypeOther                          : RGBA(0, 179, 248, 1)};
			break;
		case kRegexHighlightViewThemePresentation:
			themeColor = @{kRegexHighlightViewTypeText                           : RGBA(0, 0, 0, 1),
						   kRegexHighlightViewTypeBackground                     : RGBA(255, 255, 255, 0),
						   kRegexHighlightViewTypeComment                        : RGBA(38, 126, 61, 1),
						   kRegexHighlightViewTypeDocumentationComment           : RGBA(38, 126, 61, 1),
						   kRegexHighlightViewTypeDocumentationCommentKeyword    : RGBA(38, 126, 61, 1),
						   kRegexHighlightViewTypeString                         : RGBA(158, 32, 32, 1),
						   kRegexHighlightViewTypeCharacter                      : RGBA(6, 63, 244, 1),
						   kRegexHighlightViewTypeNumber                         : RGBA(6, 63, 244, 1),
						   kRegexHighlightViewTypeKeyword                        : RGBA(140, 34, 96, 1),
						   kRegexHighlightViewTypePreprocessor                   : RGBA(125, 72, 49, 1),
						   kRegexHighlightViewTypeURL                            : RGBA(21, 67, 244, 1),
						   kRegexHighlightViewTypeAttribute                      : RGBA(150, 125, 65, 1),
						   kRegexHighlightViewTypeProject                        : RGBA(77, 129, 134, 1),
						   kRegexHighlightViewTypeOther                          : RGBA(113, 65, 163, 1)};
			break;
		case kRegexHighlightViewThemePrinting:
			themeColor = @{kRegexHighlightViewTypeText                           : RGBA(0, 0, 0, 1),
						   kRegexHighlightViewTypeBackground                     : RGBA(255, 255, 255, 0),
						   kRegexHighlightViewTypeComment                        : RGBA(113, 113, 113, 1),
						   kRegexHighlightViewTypeDocumentationComment           : RGBA(113, 113, 113, 1),
						   kRegexHighlightViewTypeDocumentationCommentKeyword    : RGBA(64, 64, 64, 1),
						   kRegexHighlightViewTypeString                         : RGBA(112, 112, 112, 1),
						   kRegexHighlightViewTypeCharacter                      : RGBA(71, 71, 71, 1),
						   kRegexHighlightViewTypeNumber                         : RGBA(71, 71, 71, 1),
						   kRegexHighlightViewTypeKeyword                        : RGBA(108, 108, 108, 1),
						   kRegexHighlightViewTypePreprocessor                   : RGBA(85, 85, 85, 1),
						   kRegexHighlightViewTypeURL                            : RGBA(84, 84, 84, 1),
						   kRegexHighlightViewTypeAttribute                      : RGBA(129, 129, 129, 1),
						   kRegexHighlightViewTypeProject                        : RGBA(120, 120, 120, 1),
						   kRegexHighlightViewTypeOther                          : RGBA(86, 86, 86, 1)};
			break;
		case kRegexHighlightViewThemeSunset:
			themeColor = @{kRegexHighlightViewTypeText                           : RGBA(0, 0, 0, 1),
						   kRegexHighlightViewTypeBackground                     : RGBA(255, 252, 236, 1),
						   kRegexHighlightViewTypeComment                        : RGBA(208, 134, 59, 1),
						   kRegexHighlightViewTypeDocumentationComment           : RGBA(208, 134, 59, 1),
						   kRegexHighlightViewTypeDocumentationCommentKeyword    : RGBA(190, 116, 55, 1),
						   kRegexHighlightViewTypeString                         : RGBA(234, 32, 24, 1),
						   kRegexHighlightViewTypeCharacter                      : RGBA(53, 87, 134, 1),
						   kRegexHighlightViewTypeNumber                         : RGBA(53, 87, 134, 1),
						   kRegexHighlightViewTypeKeyword                        : RGBA(53, 87, 134, 1),
						   kRegexHighlightViewTypePreprocessor                   : RGBA(119, 121, 148, 1),
						   kRegexHighlightViewTypeURL                            : RGBA(85, 99, 179, 1),
						   kRegexHighlightViewTypeAttribute                      : RGBA(58, 76, 166, 1),
						   kRegexHighlightViewTypeProject                        : RGBA(196, 88, 31, 1),
						   kRegexHighlightViewTypeOther                          : RGBA(196, 88, 31, 1)};
			break;
			
			
		case kRegexHighlightViewThemeSpaceGray:
			themeColor = @{kRegexHighlightViewTypeText                           : [NSColor colorWithRed:0.70156 green:0.723031 blue:0.767213 alpha:1],
						   kRegexHighlightViewTypeBackground                     : [NSColor colorWithRed:0.126146 green:0.139869 blue:0.174509 alpha:1],
						   kRegexHighlightViewTypeComment                        : [NSColor colorWithRed:0.242153 green:0.283381 blue:0.325653 alpha:1],
						   kRegexHighlightViewTypeDocumentationComment           : [NSColor colorWithRed:0.319563 green:0.371489 blue:0.414287 alpha:1],
						   kRegexHighlightViewTypeDocumentationCommentKeyword    : [NSColor colorWithRed:0.319563 green:0.371489 blue:0.414287 alpha:1],
						   kRegexHighlightViewTypeString                         : [NSColor colorWithRed:0.583466 green:0.705829 blue:0.482261 alpha:1],
						   kRegexHighlightViewTypeCharacter                      : [NSColor colorWithRed:0.772607 green:0.450947 blue:0.368476 alpha:1],
						   kRegexHighlightViewTypeNumber                         : [NSColor colorWithRed:0.772607 green:0.450947 blue:0.368476 alpha:1],
						   kRegexHighlightViewTypeKeyword                        : [NSColor colorWithRed:0.647495 green:0.479109 blue:0.620455 alpha:1],
						   kRegexHighlightViewTypePreprocessor                   : [NSColor colorWithRed:0.521837 green:0.654028 blue:0.646684 alpha:1],
						   kRegexHighlightViewTypeURL                            : [NSColor colorWithRed:0.772607 green:0.450947 blue:0.368476 alpha:1],
						   kRegexHighlightViewTypeAttribute                      : [NSColor colorWithRed:0.772607 green:0.450947 blue:0.368476 alpha:1],
						   kRegexHighlightViewTypeProject                        : [NSColor colorWithRed:0.897085 green:0.753645 blue:0.470402 alpha:1],
						   kRegexHighlightViewTypeOther                          : [NSColor colorWithRed:0.689693 green:0.296345 blue:0.345124 alpha:1]};
			break;
			
		case kRegexHighlightViewThemeSilver:
			themeColor = @{kRegexHighlightViewTypeText                           : [NSColor colorWithRed:0.242153 green:0.283381 blue:0.325653 alpha:1],
						   kRegexHighlightViewTypeBackground                     : [NSColor colorWithRed:0.92606 green:0.933418 blue:0.949697 alpha:1],
						   kRegexHighlightViewTypeComment                        : [NSColor colorWithRed:0.319563 green:0.371489 blue:0.414287 alpha:1],
						   kRegexHighlightViewTypeDocumentationComment           : [NSColor colorWithRed:0.319563 green:0.371489 blue:0.414287 alpha:1],
						   kRegexHighlightViewTypeDocumentationCommentKeyword    : [NSColor colorWithRed:0.319563 green:0.371489 blue:0.414287 alpha:1],
						   kRegexHighlightViewTypeString                         : [NSColor colorWithRed:0.583466 green:0.705829 blue:0.482261 alpha:1],
						   kRegexHighlightViewTypeCharacter                      : [NSColor colorWithRed:0.772607 green:0.450947 blue:0.368476 alpha:1],
						   kRegexHighlightViewTypeNumber                         : [NSColor colorWithRed:0.772607 green:0.450947 blue:0.368476 alpha:1],
						   kRegexHighlightViewTypeKeyword                        : [NSColor colorWithRed:0.647495 green:0.479109 blue:0.620455 alpha:1],
						   kRegexHighlightViewTypePreprocessor                   : [NSColor colorWithRed:0.521837 green:0.654028 blue:0.646684 alpha:1],
						   kRegexHighlightViewTypeURL                            : [NSColor colorWithRed:0.772607 green:0.450947 blue:0.368476 alpha:1],
						   kRegexHighlightViewTypeAttribute                      : [NSColor colorWithRed:0.772607 green:0.450947 blue:0.368476 alpha:1],
						   kRegexHighlightViewTypeProject                        : [NSColor colorWithRed:0.689693 green:0.296345 blue:0.345124 alpha:1],
						   kRegexHighlightViewTypeOther                          : [NSColor colorWithRed:0.521837 green:0.654028 blue:0.646684 alpha:1]};
			break;
			
		case kRegexHighlightViewThemeBasic:
		default:
			themeColor = @{kRegexHighlightViewTypeText                           : RGBA(0,   0,   0,   1),
						   kRegexHighlightViewTypeBackground                     : RGBA(255, 255, 255, 0),
						   kRegexHighlightViewTypeComment                        : RGBA(0,   142, 43,  1),
						   kRegexHighlightViewTypeDocumentationComment           : RGBA(0,   142, 43,  1),
						   kRegexHighlightViewTypeDocumentationCommentKeyword    : RGBA(0,   142, 43,  1),
						   kRegexHighlightViewTypeString                         : RGBA(181, 37,  34,  1),
						   kRegexHighlightViewTypeCharacter                      : RGBA(0,   0,   0,   1),
						   kRegexHighlightViewTypeNumber                         : RGBA(0,   0,   0,   1),
						   kRegexHighlightViewTypeKeyword                        : RGBA(6,   63,  244, 1),
						   kRegexHighlightViewTypePreprocessor                   : RGBA(6,   63,  244, 1),
						   kRegexHighlightViewTypeURL                            : RGBA(6,   63,  244, 1),
						   kRegexHighlightViewTypeAttribute                      : RGBA(0,   0,   0,   1),
						   kRegexHighlightViewTypeProject                        : RGBA(49,  149, 172, 1),
						   kRegexHighlightViewTypeOther                          : RGBA(49,  149, 172, 1)};
			break;
			
	}
	
	return themeColor;
}

@end
