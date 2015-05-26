//
//  NSUserDefaults+UIColorSupport.h
//  Snippy
//
//  Created by Devin Ross on 5/10/15.
//  Copyright (c) 2015 Devin Ross. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSUserDefaults (UIColorSupport)

- (void)setColor:(UIColor *)aColor forKey:(NSString *)aKey;
- (UIColor *)colorForKey:(NSString *)aKey;




@end
