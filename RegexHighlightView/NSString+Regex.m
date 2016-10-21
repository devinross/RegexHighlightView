//
//  NSString+Regex.m
//  Snippy
//
//  Created by Devin Ross on 10/20/16.
//  Copyright © 2016 Devin Ross. All rights reserved.
//

#import "NSString+Regex.h"
#import "RegexConstants.h"

@implementation NSString (Regex)


- (NSAttributedString*) highlightedTextWithDefinitions:(NSDictionary*)definitions colors:(NSDictionary*)colors{
	
	// Create a mutable attribute string to set the highlighting
	NSRange range = NSMakeRange(0,self.length);
	NSMutableAttributedString* coloredString = [[NSMutableAttributedString alloc] initWithString:self];
	
	NSNumber *kern = @0.0f;
	[coloredString addAttribute:(id)kCTKernAttributeName value:kern range:range];
	
	NSColor *textColor = colors[kRegexHighlightViewTypeText];

	
	[coloredString addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, coloredString.length)];
	
	
	//For each definition entry apply the highlighting to matched ranges
	for(NSString *key in definitions.allKeys) {
		
		NSString *expression = definitions[key];
		if(!expression || expression.length<=0) continue;
		
		NSArray* matches = [[NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionDotMatchesLineSeparators error:nil] matchesInString:self options:0 range:range];
		
		
		for(NSTextCheckingResult* match in matches) {
			NSColor *textColor = nil;
			//Get the text color, if it is a custom key and no color was defined, choose black
			if(!colors || !(textColor=colors[key]))
				textColor = [NSColor blueColor];
			
			TKLog(@"%@ %@ %@",key,textColor,@([match rangeAtIndex:0].location));
			
			[coloredString addAttribute:NSForegroundColorAttributeName value:textColor range:[match rangeAtIndex:0]];
		}
	}
	
	return coloredString.copy;
}

@end
