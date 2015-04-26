//
//  RegexView.h
//  Regex Highlight View
//
//  Created by Devin Ross on 4/25/15.
//
//

#import <UIKit/UIKit.h>
#import "RegexConstants.h"
#import "RegexTextView.h"
#import "RegexDrawView.h"

@interface RegexHighlightView : UIView <UIScrollViewDelegate>

@property (nonatomic,strong) RegexTextView *textView;
@property (nonatomic,strong) RegexDrawView *drawView;

- (void) resize;


+ (NSArray*) languages;


@end
