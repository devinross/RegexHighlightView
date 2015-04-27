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
@property (nonatomic,assign) RegexHighlightViewTheme highlightTheme;

@property (nonatomic,strong) NSDictionary *syntaxColors;
@property (nonatomic,strong) NSDictionary *syntaxRegularExpressions;

@property (nonatomic,assign) BOOL showLineNumbers;

@property (nonatomic,copy) NSString *languageFile;

- (void) resize;

+ (NSArray*) languages;
+ (NSDictionary*) highlightTheme:(RegexHighlightViewTheme)theme;


@end
