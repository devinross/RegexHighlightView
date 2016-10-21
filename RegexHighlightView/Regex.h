//
//  Regex.h
//  Snippy
//
//  Created by Devin Ross on 10/13/16.
//  Copyright © 2016 Devin Ross. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegexConstants.h"

@interface Regex : NSObject

+ (NSArray*) languages;
+ (NSDictionary*) syntaxThemeColors:(RegexHighlightViewTheme)theme;

@end
