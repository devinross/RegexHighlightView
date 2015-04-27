//
//  RegexView.m
//  Regex Highlight View
//
//  Created by Devin Ross on 4/25/15.
//
//

#import "RegexHighlightView.h"
#import "RegexTextView.h"
#import "RegexDrawView.h"
#import "RegexConstants.h"


@implementation RegexHighlightView


- (instancetype) initWithFrame:(CGRect)frame{
    if(!(self=[super initWithFrame:frame])) return nil;
    
    self.drawView = [[RegexDrawView alloc] initWithFrame:CGRectMake(0, 6, CGRectGetWidth(self.bounds), 8000)];
    self.drawView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.drawView];
    
    CGRect rect = self.bounds;
    rect.origin.y += 6;
    rect.size.height -= 6;
    
    
    self.textView = [[RegexTextView alloc] initWithFrame:rect];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.textView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.textView];
    
    
    self.drawView.highlightView = self;
    self.textView.drawView = self.drawView;
    self.textView.containerView = self;
    
    self.clipsToBounds = YES;
    
    self.backgroundColor = [UIColor redColor];
    
    //self.highlightView.textColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    return self;
}
- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    [self resize];
}

- (void) resize{
    self.drawView.center = CGPointMake(self.drawView.center.x, 6 + CGRectGetHeight(self.drawView.frame)/2 - self.textView.contentOffset.y);
    [self setNeedsDisplay];
}




- (void) setLanguageFile:(NSString *)languageFile{
    _languageFile = languageFile.copy;
    
    self.syntaxRegularExpressions = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:languageFile ofType:@"plist"]];
    
}

- (void) setHighlightTheme:(RegexHighlightViewTheme)theme {
    _highlightTheme = theme;

    self.syntaxColors = [RegexHighlightView highlightTheme:theme];
    self.backgroundColor = self.syntaxColors[kRegexHighlightViewTypeBackground];

}
- (void) setSyntaxColors:(NSDictionary*)newHighlightColor {
    if(_syntaxColors!=newHighlightColor) {
        _syntaxColors = newHighlightColor;
        [self setNeedsLayout];
        [self.drawView setNeedsDisplay];
    }
}
- (void) setSyntaxRegularExpressions:(NSDictionary*)newHighlightDefinition {
    if(_syntaxRegularExpressions!=newHighlightDefinition) {
        _syntaxRegularExpressions = newHighlightDefinition;
        [self setNeedsLayout];
    }
}


+ (NSArray*) languages{
    return [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Languages" ofType:@"plist"]];
}




static NSMutableDictionary* highlightThemes;
#define RGBA(_RED,_GREEN,_BLUE,_ALPHA) [UIColor colorWithRed:_RED/255.0 green:_GREEN/255.0 blue:_BLUE/255.0 alpha:_ALPHA]
+ (NSDictionary*) highlightTheme:(RegexHighlightViewTheme)theme {
   
    if(!highlightThemes)
        highlightThemes = [NSMutableDictionary dictionary];
    
    NSDictionary* themeColor = highlightThemes[@(theme)];
    
    if((themeColor=highlightThemes[@(theme)]))
        return themeColor;
    
    //If not define the theme and return it
    switch(theme) {
        case kRegexHighlightViewThemeBasic:
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
                           kRegexHighlightViewTypeBackground                     : RGBA(255, 255, 255, 1),
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
                           kRegexHighlightViewTypeBackground                     : RGBA(255, 255, 255, 1),
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
                           kRegexHighlightViewTypeBackground                     : RGBA(255, 255, 255, 1),
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
        case kRegexHighlightViewThemeCustom:
            
            break;
    }
    if(themeColor) {
        highlightThemes[@(theme)] = themeColor;
        return themeColor;
    } else
        return nil;
}


//case kRegexHighlightViewThemeDefault:
//themeColor = @{kRegexHighlightViewTypeText                           : RGBA(0, 0, 0, 1),
//               kRegexHighlightViewTypeBackground                     : RGBA(255, 255, 255, 0),
//               kRegexHighlightViewTypeComment                        : RGBA(0, 131, 39, 1),
//               kRegexHighlightViewTypeDocumentationComment           : RGBA(0, 131, 39, 1),
//               kRegexHighlightViewTypeDocumentationCommentKeyword    : RGBA(0, 76, 29, 1),
//               kRegexHighlightViewTypeString                         : RGBA(211, 45, 38, 1),
//               kRegexHighlightViewTypeCharacter                      : RGBA(40, 52, 206, 1),
//               kRegexHighlightViewTypeNumber                         : RGBA(40, 52, 206, 1),
//               kRegexHighlightViewTypeKeyword                        : RGBA(188, 49, 156, 1),
//               kRegexHighlightViewTypePreprocessor                   : RGBA(120, 72, 48, 1),
//               kRegexHighlightViewTypeURL                            : RGBA(21, 67, 244, 1),
//               kRegexHighlightViewTypeAttribute                      : RGBA(150, 125, 65, 1),
//               kRegexHighlightViewTypeProject                        : RGBA(77, 129, 134, 1),
//               kRegexHighlightViewTypeOther                          : RGBA(113, 65, 163, 1)};

//case kRegexHighlightViewThemeBasic:
//themeColor = @{kRegexHighlightViewTypeText                           : RGBA(0,   0,   0,   1),
//               kRegexHighlightViewTypeBackground                     : RGBA(255, 255, 255, 0),
//               kRegexHighlightViewTypeComment                        : RGBA(0,   142, 43,  1),
//               kRegexHighlightViewTypeDocumentationComment           : RGBA(0,   142, 43,  1),
//               kRegexHighlightViewTypeDocumentationCommentKeyword    : RGBA(0,   142, 43,  1),
//               kRegexHighlightViewTypeString                         : RGBA(181, 37,  34,  1),
//               kRegexHighlightViewTypeCharacter                      : RGBA(0,   0,   0,   1),
//               kRegexHighlightViewTypeNumber                         : RGBA(0,   0,   0,   1),
//               kRegexHighlightViewTypeKeyword                        : RGBA(6,   63,  244, 1),
//               kRegexHighlightViewTypePreprocessor                   : RGBA(6,   63,  244, 1),
//               kRegexHighlightViewTypeURL                            : RGBA(6,   63,  244, 1),
//               kRegexHighlightViewTypeAttribute                      : RGBA(0,   0,   0,   1),
//               kRegexHighlightViewTypeProject                        : RGBA(49,  149, 172, 1),
//               kRegexHighlightViewTypeOther                          : RGBA(49,  149, 172, 1)};

@end


