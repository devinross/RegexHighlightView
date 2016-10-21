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
#import "NSUserDefaults+NSColorSupport.h"

@implementation RegexHighlightView

- (instancetype) initWithFrame:(CGRect)frame{
    if(!(self=[super initWithFrame:frame])) return nil;
    
    self.drawView = [[RegexDrawView alloc] initWithFrame:CGRectMake(0, 6, CGRectGetWidth(self.bounds), 8000)];
    self.drawView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.drawView];
    
    CGRect rect = self.bounds;
    rect.origin.y += 7;
    rect.size.height -= 6;
    
    rect.origin.x += 22;
    rect.size.width -= 22;
    

    self.textView = [[RegexTextView alloc] initWithFrame:rect];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.textView.showsVerticalScrollIndicator = NO;
    self.textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self addSubview:self.textView];
    
    self.drawView.highlightView = self;
    self.textView.drawView = self.drawView;
    self.textView.containerView = self;
    
    self.clipsToBounds = YES;
    
    self.showLineNumbers = NO;
    
    
    return self;
}
- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    [self resize];
}

- (void) resize{
    self.drawView.center = CGPointMake(self.drawView.center.x, 6 + CGRectGetHeight(self.drawView.frame)/2 - self.textView.contentOffset.y);
    [self setNeedsDisplay];
}


#define RGBA(_RED,_GREEN,_BLUE,_ALPHA) [UIColor colorWithRed:_RED/255.0 green:_GREEN/255.0 blue:_BLUE/255.0 alpha:_ALPHA]
#define DEFAULT_KEY(_STRING) [NSString stringWithFormat:@"regex-color-%@",_STRING]


#pragma mark Properties
- (void) setLanguageFile:(NSString *)languageFile{
    _languageFile = languageFile.copy;
    self.syntaxRegularExpressions = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:languageFile ofType:@"plist"]];
}
- (void) setHighlightTheme:(RegexHighlightViewTheme)theme {
    _highlightTheme = theme;
    self.syntaxColors = [RegexHighlightView highlightTheme:theme];
}
- (void) setSyntaxColors:(NSDictionary*)newHighlightColor {
    if(_syntaxColors!=newHighlightColor) {
        _syntaxColors = newHighlightColor;
        self.backgroundColor = self.syntaxColors[kRegexHighlightViewTypeBackground];
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
- (void) setShowLineNumbers:(BOOL)showLineNumbers{
    _showLineNumbers = showLineNumbers;
    
    CGRect rect = self.bounds;
    if(showLineNumbers){
        
        rect.origin.y += 7;
        rect.size.height -= 6;
        rect.origin.x += 22;
        rect.size.width -= 22;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone || UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            rect.origin.x += 4;
            rect.size.width -= 8;
        }
        
    }else{
        
        rect.origin.y += 7;
        rect.size.height -= 6;
        rect.origin.x += 6;
        rect.size.width -= 6;

    }
    self.textView.frame = rect;
    [self setNeedsLayout];
    [self.drawView setNeedsDisplay];
}

@end


