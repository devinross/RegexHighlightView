//
//  NSString+Regex.h
//  Snippy
//
//  Created by Devin Ross on 10/20/16.
//  Copyright © 2016 Devin Ross. All rights reserved.
//

@import Foundation;

@interface NSString (Regex)

- (NSAttributedString*) highlightedTextWithDefinitions:(NSDictionary*)definitions colors:(NSDictionary*)colors;

@end
