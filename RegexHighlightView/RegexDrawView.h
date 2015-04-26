//
//  RegexDrawView.h
//  Regex Highlight View
//
//  Created by Devin Ross on 4/25/15.
//
//

#import <UIKit/UIKit.h>

@class RegexTextView;

@interface RegexDrawView : UIView
@property (nonatomic,weak) RegexTextView *highlightView;
@end

