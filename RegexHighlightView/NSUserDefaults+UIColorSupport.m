//
//  NSUserDefaults+UIColorSupport.m
//  Snippy
//
//  Created by Devin Ross on 5/10/15.
//  Copyright (c) 2015 Devin Ross. All rights reserved.
//

#import "NSUserDefaults+UIColorSupport.h"

@implementation NSUserDefaults (ColorSupport)

- (void) setColor:(UIColor *)aColor forKey:(NSString *)aKey{
    if(!aColor){
        [self removeObjectForKey:aKey];
    }else{
        const CGFloat* colors = CGColorGetComponents( aColor.CGColor );
        [self setObject:[NSString stringWithFormat:@"%f|%f|%f|%f",colors[0],colors[1],colors[2],colors[3]] forKey:aKey];
    }
}

- (UIColor *) colorForKey:(NSString *)aKey{
    UIColor *theColor = nil;
    NSString *theData = [self objectForKey:aKey];
    if (theData != nil){
        NSArray *array = [theData componentsSeparatedByString:@"|"];
        theColor = [UIColor colorWithRed:[array[0] floatValue] green:[array[1] floatValue] blue:[array[2] floatValue] alpha:[array[3] floatValue]];
    }
    return theColor;
}


@end
