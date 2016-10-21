//
//  NSUserDefaults+UIColorSupport.h
//  Snippy
//
//  Created by Devin Ross on 5/10/15.
//  Copyright (c) 2015 Devin Ross. All rights reserved.
//

@import Foundation;

@interface NSUserDefaults (NSColorSupport)

- (void)setColor:(NSColor *)aColor forKey:(NSString *)aKey;
- (NSColor *)colorForKey:(NSString *)aKey;


@end
