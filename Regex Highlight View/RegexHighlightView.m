//
//  RegexHighlightView.m
//  Simple Objective-C Syntax Highlighter
//
//  Created by Kristian Kraljic on 30/08/12.
//  Copyright (c) 2012 Kristian Kraljic (dikrypt.com, ksquared.de). All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person 
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "RegexHighlightView.h"

#define EMPTY @""
static CGFloat MARGIN = 8;

NSString *const kRegexHighlightViewTypeText = @"text";
NSString *const kRegexHighlightViewTypeBackground = @"background";
NSString *const kRegexHighlightViewTypeComment = @"comment";
NSString *const kRegexHighlightViewTypeDocumentationComment = @"documentation_comment";
NSString *const kRegexHighlightViewTypeDocumentationCommentKeyword = @"documentation_comment_keyword";
NSString *const kRegexHighlightViewTypeString = @"string";
NSString *const kRegexHighlightViewTypeCharacter = @"character";
NSString *const kRegexHighlightViewTypeNumber = @"number";
NSString *const kRegexHighlightViewTypeKeyword = @"keyword";
NSString *const kRegexHighlightViewTypePreprocessor = @"preprocessor";
NSString *const kRegexHighlightViewTypeURL = @"url";
NSString *const kRegexHighlightViewTypeAttribute = @"attribute";
NSString *const kRegexHighlightViewTypeProject = @"project";
NSString *const kRegexHighlightViewTypeOther = @"other";



@interface RegexHighlightView() <UITextViewDelegate>
@property (nonatomic,weak) RegexDrawView *drawView;
@property (nonatomic,weak) RegexContainerView *containerView;

- (NSRange) visibleRangeOfTextView:(UITextView *)textView ;
- (NSAttributedString*) highlightText:(NSAttributedString*)attributedString;
@end

@implementation RegexContainerView

- (instancetype) initWithFrame:(CGRect)frame{
    if(!(self=[super initWithFrame:frame])) return nil;
    
    self.drawView = [[RegexDrawView alloc] initWithFrame:CGRectMake(0, 6, CGRectGetWidth(self.bounds), 8000)];
    self.drawView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.drawView];
    
    CGRect rect = self.bounds;
    rect.origin.y += 6;
    rect.size.height -= 6;
    
    
    self.highlightView = [[RegexHighlightView alloc] initWithFrame:rect];
    self.highlightView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.highlightView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.highlightView];

    
    

    self.drawView.highlightView = self.highlightView;
    self.highlightView.drawView = self.drawView;
    self.highlightView.containerView = self;
    
    self.clipsToBounds = YES;
    
    //self.highlightView.textColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    return self;
}
- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    [self resize];
}

- (void) resize{
//    
//    CGRect rr = self.drawView.frame;
//    rr.size.height = self.highlightView.contentSize.height;
//    rr.origin.y = -self.highlightView.contentOffset.y;
//    self.drawView.frame = rr;
    self.drawView.center = CGPointMake(self.drawView.center.x, 6 + CGRectGetHeight(self.drawView.frame)/2 - self.highlightView.contentOffset.y);
    [self setNeedsDisplay];
    
    
}

@end





@implementation RegexDrawView

- (instancetype) initWithFrame:(CGRect)frame{
    if(!(self=[super initWithFrame:frame])) return nil;
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor clearColor];
    
    return self;
}
- (void) drawRect:(CGRect)rect {
    //[super drawRect:rect];
    
    
    
    if(self.highlightView.text.length<=0) {
        self.highlightView.text = EMPTY;
        return;
    }
    
    
    //Prepare View for drawing
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context,CGAffineTransformIdentity);
    CGContextTranslateCTM(context,0,([self bounds]).size.height);
    CGContextScaleCTM(context,1.0,-1.0);
    
    //Get the view frame size
    CGSize size = self.frame.size;
    
    //Determine default text color
    UIColor* textColor = nil;
    if(!self.highlightView.highlightColor||!(textColor=(self.highlightView.highlightColor)[kRegexHighlightViewTypeText])) {
        if([self.highlightView.textColor isEqual:[UIColor clearColor]]) {
            if(!(textColor=[RegexHighlightView highlightTheme:kRegexHighlightViewThemeDefault][kRegexHighlightViewTypeText]))
                textColor = [UIColor blackColor];
        } else
            textColor = self.highlightView.textColor;
    }
    
    //Set line height, font, color and break mode
    CGFloat minimumLineHeight = [self.highlightView.text sizeWithFont:self.highlightView.font].height - 1,  maximumLineHeight = minimumLineHeight;
    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)self.highlightView.font.fontName, self.highlightView.font.pointSize,NULL);
    CTLineBreakMode lineBreakMode = kCTLineBreakByWordWrapping;
    
    //Apply paragraph settings
    CTParagraphStyleRef style = CTParagraphStyleCreate((CTParagraphStyleSetting[3]){
        {   kCTParagraphStyleSpecifierMinimumLineHeight,sizeof(minimumLineHeight),&minimumLineHeight},
        {   kCTParagraphStyleSpecifierMaximumLineHeight,sizeof(maximumLineHeight),&maximumLineHeight},
        {   kCTParagraphStyleSpecifierLineBreakMode,sizeof(CTLineBreakMode),&lineBreakMode}
    },3);
    NSDictionary* attributes = @{
                                 (NSString*)kCTFontAttributeName                : (__bridge id)font,
                                 (NSString*)kCTForegroundColorAttributeName     : (__bridge id)textColor.CGColor,
                                 (NSString*)kCTParagraphStyleAttributeName      : (__bridge id)style};
    
    //Create path to work with a frame with applied margins
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGFloat minX = MARGIN+0.0;
    CGFloat minY = (-self.highlightView.contentOffset.y+0) - 9;
    minY = -8;
    CGFloat width = (size.width-2*MARGIN);
    //CGFloat height = (size.height+(self.contentOffset.y - (int)((self.contentOffset.y-MARGIN)/minimumLineHeight)*minimumLineHeight)-MARGIN);
    CGFloat height = self.bounds.size.height; // self.highlightView.contentSize.height;
    CGPathAddRect(path,NULL,CGRectMake(minX,minY,width,height));
    
    
    // Create attributed string, with applied syntax highlighting
    NSString *str = [self.highlightView.text substringWithRange:[self.highlightView visibleRangeOfTextView:self.highlightView]];
    NSAttributedString *atr = [[NSAttributedString alloc] initWithString:str attributes:attributes];
    CFAttributedStringRef attributedString = (__bridge CFAttributedStringRef)[self.highlightView highlightText:atr];
    
    //NSLog(@"%@",str);
    
    
    //Draw the frame
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0,CFAttributedStringGetLength(attributedString)),path,NULL);
    CTFrameDraw(frame,context);
}

@end






static NSMutableDictionary* highlightThemes;

@implementation RegexHighlightView



#pragma mark Init & Friends
- (instancetype) init{
    if(!(self=[super init])) return nil;
    return self;
}
//- (instancetype) initWithCoder:(NSCoder*)decoder{
//    if(!(self=[super initWithCoder:decoder])) return nil;
//    self.textColor = [UIColor clearColor];
//    self.internalDelegate = [[RegexHighlightViewDelegate alloc] init];
//    self.delegate = self.internalDelegate;
//    return self;
//}
- (instancetype) initWithFrame:(CGRect)frame{
    if(!(self=[super initWithFrame:frame])) return nil;
    self.textColor = [UIColor clearColor];
    self.delegate = self;
    
    
    

    
    return self;
}

#pragma mark Public Functions
#define RGBA(_RED,_GREEN,_BLUE,_ALPHA) [UIColor colorWithRed:_RED/255.0 green:_GREEN/255.0 blue:_BLUE/255.0 alpha:_ALPHA]

+ (NSDictionary*) highlightTheme:(RegexHighlightViewTheme)theme {
    //Check if the highlight theme has already been defined
    if(!highlightThemes)
        highlightThemes = [NSMutableDictionary dictionary];
    
    NSDictionary* themeColor = nil;

    if((themeColor=highlightThemes[@(theme)]))
        return themeColor;
    
    //If not define the theme and return it
    switch(theme) {
        case kRegexHighlightViewThemeBasic:
            themeColor = @{kRegexHighlightViewTypeText                          : RGBA(0.0, 0.0, 0.0, 1),
                          kRegexHighlightViewTypeBackground                     : RGBA(255.0, 255.0, 255.0, 1),
                          kRegexHighlightViewTypeComment                        : RGBA(0.0, 142.0, 43.0, 1),
                          kRegexHighlightViewTypeDocumentationComment           : RGBA(0.0, 142.0, 43.0, 1),
                          kRegexHighlightViewTypeDocumentationCommentKeyword    : RGBA(0.0, 142.0, 43.0, 1),
                          kRegexHighlightViewTypeString                         : RGBA(181.0, 37.0, 34.0, 1),
                          kRegexHighlightViewTypeCharacter                      : RGBA(0.0, 0.0, 0.0, 1),
                          kRegexHighlightViewTypeNumber                         : RGBA(0.0, 0.0, 0.0, 1),
                          kRegexHighlightViewTypeKeyword                        : RGBA(6.0, 63.0, 244.0, 1),
                          kRegexHighlightViewTypePreprocessor                   : RGBA(6.0, 63.0, 244.0, 1),
                          kRegexHighlightViewTypeURL                            : RGBA(6.0, 63.0, 244.0, 1),
                          kRegexHighlightViewTypeAttribute                      : RGBA(0.0, 0.0, 0.0, 1),
                          kRegexHighlightViewTypeProject                        : RGBA(49.0, 149.0, 172.0, 1),
                          kRegexHighlightViewTypeOther                          : RGBA(49.0, 149.0, 172.0, 1)};
            break;
        case kRegexHighlightViewThemeDefault:
            themeColor = @{kRegexHighlightViewTypeText                          : RGBA(0.0, 0.0, 0.0, 1),
                          kRegexHighlightViewTypeBackground                     : RGBA(255.0, 255.0, 255.0, 1),
                          kRegexHighlightViewTypeComment                        : RGBA(0.0, 131.0, 39.0, 1),
                          kRegexHighlightViewTypeDocumentationComment           : RGBA(0.0, 131.0, 39.0, 1),
                          kRegexHighlightViewTypeDocumentationCommentKeyword    : RGBA(0.0, 76.0, 29.0, 1),
                          kRegexHighlightViewTypeString                         : RGBA(211.0, 45.0, 38.0, 1),
                          kRegexHighlightViewTypeCharacter                      : RGBA(40.0, 52.0, 206.0, 1),
                          kRegexHighlightViewTypeNumber                         : RGBA(40.0, 52.0, 206.0, 1),
                          kRegexHighlightViewTypeKeyword                        : RGBA(188.0, 49.0, 156.0, 1),
                          kRegexHighlightViewTypePreprocessor                   : RGBA(120.0, 72.0, 48.0, 1),
                          kRegexHighlightViewTypeURL                            : RGBA(21.0, 67.0, 244.0, 1),
                          kRegexHighlightViewTypeAttribute                      : RGBA(150.0, 125.0, 65.0, 1),
                          kRegexHighlightViewTypeProject                        : RGBA(77.0, 129.0, 134.0, 1),
                          kRegexHighlightViewTypeOther                          : RGBA(113.0, 65.0, 163.0, 1)};
            break;
        case kRegexHighlightViewThemeDusk:
            themeColor = @{kRegexHighlightViewTypeText                          : RGBA(255.0, 255.0, 255.0, 1),
                          kRegexHighlightViewTypeBackground                     : RGBA(40.0, 43.0, 52.0, 1),
                          kRegexHighlightViewTypeComment                        : RGBA(72.0, 190.0, 102.0, 1),
                          kRegexHighlightViewTypeDocumentationComment           : RGBA(72.0, 190.0, 102.0, 1),
                          kRegexHighlightViewTypeDocumentationCommentKeyword    : RGBA(72.0, 190.0, 102.0, 1),
                          kRegexHighlightViewTypeString                         : RGBA(230.0, 66.0, 75.0, 1),
                          kRegexHighlightViewTypeCharacter                      : RGBA(139.0, 134.0, 201.0, 1),
                          kRegexHighlightViewTypeNumber                         : RGBA(139.0, 134.0, 201.0, 1),
                          kRegexHighlightViewTypeKeyword                        : RGBA(195.0, 55.0, 149.0, 1),
                          kRegexHighlightViewTypePreprocessor                   : RGBA(211.0, 142.0, 99.0, 1),
                          kRegexHighlightViewTypeURL                            : RGBA(35.0, 63.0, 208.0, 1),
                          kRegexHighlightViewTypeAttribute                      : RGBA(103.0, 135.0, 142.0, 1),
                          kRegexHighlightViewTypeProject                        : RGBA(146.0, 199.0, 119.0, 1),
                          kRegexHighlightViewTypeOther                          : RGBA(0.0, 175.0, 199.0, 1)};
            break;
        case kRegexHighlightViewThemeLowKey:
            themeColor = @{kRegexHighlightViewTypeText                          : RGBA(0.0, 0.0, 0.0, 1),
                          kRegexHighlightViewTypeBackground                     : RGBA(255.0, 255.0, 255.0, 1),
                          kRegexHighlightViewTypeComment                        : RGBA(84.0, 99.0, 75.0, 1),
                          kRegexHighlightViewTypeDocumentationComment           : RGBA(84.0, 99.0, 75.0, 1),
                          kRegexHighlightViewTypeDocumentationCommentKeyword    : RGBA(84.0, 99.0, 75.0, 1),
                          kRegexHighlightViewTypeString                         : RGBA(133.0, 63.0, 98.0, 1),
                          kRegexHighlightViewTypeCharacter                      : RGBA(50.0, 64.0, 121.0, 1),
                          kRegexHighlightViewTypeNumber                         : RGBA(50.0, 64.0, 121.0, 1),
                          kRegexHighlightViewTypeKeyword                        : RGBA(50.0, 64.0, 121.0, 1),
                          kRegexHighlightViewTypePreprocessor                   : RGBA(0.0, 0.0, 0.0, 1),
                          kRegexHighlightViewTypeURL                            : RGBA(24.0, 49.0, 168.0, 1),
                          kRegexHighlightViewTypeAttribute                      : RGBA(35.0, 93.0, 43.0, 1),
                          kRegexHighlightViewTypeProject                        : RGBA(87.0, 127.0, 164.0, 1),
                          kRegexHighlightViewTypeOther                          : RGBA(87.0, 127.0, 164.0, 1)};
            break;
        case kRegexHighlightViewThemeMidnight:
            themeColor = @{kRegexHighlightViewTypeText                          : RGBA(255.0, 255.0, 255.0, 1),
                          kRegexHighlightViewTypeBackground                     : RGBA(0.0, 0.0, 0.0, 1),
                          kRegexHighlightViewTypeComment                        : RGBA(69.0, 208.0, 106.0, 1),
                          kRegexHighlightViewTypeDocumentationComment           : RGBA(69.0, 208.0, 106.0, 1),
                          kRegexHighlightViewTypeDocumentationCommentKeyword    : RGBA(69.0, 208.0, 106.0, 1),
                          kRegexHighlightViewTypeString                         : RGBA(255.0, 68.0, 77.0, 1),
                          kRegexHighlightViewTypeCharacter                      : RGBA(139.0, 138.0, 247.0, 1),
                          kRegexHighlightViewTypeNumber                         : RGBA(139.0, 138.0, 247.0, 1),
                          kRegexHighlightViewTypeKeyword                        : RGBA(224.0, 59.0, 160.0, 1),
                          kRegexHighlightViewTypePreprocessor                   : RGBA(237.0, 143.0, 100.0, 1),
                          kRegexHighlightViewTypeURL                            : RGBA(36.0, 72.0, 244.0, 1),
                          kRegexHighlightViewTypeAttribute                      : RGBA(79.0, 108.0, 132.0, 1),
                          kRegexHighlightViewTypeProject                        : RGBA(0.0, 249.0, 161.0, 1),
                          kRegexHighlightViewTypeOther                          : RGBA(0.0, 179.0, 248.0, 1)};
            break;
        case kRegexHighlightViewThemePresentation:
            themeColor = @{kRegexHighlightViewTypeText                          : RGBA(0.0, 0.0, 0.0, 1),
                          kRegexHighlightViewTypeBackground                     : RGBA(255.0, 255.0, 255.0, 1),
                          kRegexHighlightViewTypeComment                        : RGBA(38.0, 126.0, 61.0, 1),
                          kRegexHighlightViewTypeDocumentationComment           : RGBA(38.0, 126.0, 61.0, 1),
                          kRegexHighlightViewTypeDocumentationCommentKeyword    : RGBA(38.0, 126.0, 61.0, 1),
                          kRegexHighlightViewTypeString                         : RGBA(158.0, 32.0, 32.0, 1),
                          kRegexHighlightViewTypeCharacter                      : RGBA(6.0, 63.0, 244.0, 1),
                          kRegexHighlightViewTypeNumber                         : RGBA(6.0, 63.0, 244.0, 1),
                          kRegexHighlightViewTypeKeyword                        : RGBA(140.0, 34.0, 96.0, 1),
                          kRegexHighlightViewTypePreprocessor                   : RGBA(125.0, 72.0, 49.0, 1),
                          kRegexHighlightViewTypeURL                            : RGBA(21.0, 67.0, 244.0, 1),
                          kRegexHighlightViewTypeAttribute                      : RGBA(150.0, 125.0, 65.0, 1),
                          kRegexHighlightViewTypeProject                        : RGBA(77.0, 129.0, 134.0, 1),
                          kRegexHighlightViewTypeOther                          : RGBA(113.0, 65.0, 163.0, 1)};
            break;
        case kRegexHighlightViewThemePrinting:
            themeColor = @{kRegexHighlightViewTypeText                          : RGBA(0.0, 0.0, 0.0, 1),
                          kRegexHighlightViewTypeBackground                     : RGBA(255.0, 255.0, 255.0, 1),
                          kRegexHighlightViewTypeComment                        : RGBA(113.0, 113.0, 113.0, 1),
                          kRegexHighlightViewTypeDocumentationComment           : RGBA(113.0, 113.0, 113.0, 1),
                          kRegexHighlightViewTypeDocumentationCommentKeyword    : RGBA(64.0, 64.0, 64.0, 1),
                          kRegexHighlightViewTypeString                         : RGBA(112.0, 112.0, 112.0, 1),
                          kRegexHighlightViewTypeCharacter                      : RGBA(71.0, 71.0, 71.0, 1),
                          kRegexHighlightViewTypeNumber                         : RGBA(71.0, 71.0, 71.0, 1),
                          kRegexHighlightViewTypeKeyword                        : RGBA(108.0, 108.0, 108.0, 1),
                          kRegexHighlightViewTypePreprocessor                   : RGBA(85.0, 85.0, 85.0, 1),
                          kRegexHighlightViewTypeURL                            : RGBA(84.0, 84.0, 84.0, 1),
                          kRegexHighlightViewTypeAttribute                      : RGBA(129.0, 129.0, 129.0, 1),
                          kRegexHighlightViewTypeProject                        : RGBA(120.0, 120.0, 120.0, 1),
                          kRegexHighlightViewTypeOther                          : RGBA(86.0, 86.0, 86.0, 1)};
            break;
        case kRegexHighlightViewThemeSunset:
            themeColor = @{kRegexHighlightViewTypeText                          : RGBA(0.0, 0.0, 0.0, 1),
                          kRegexHighlightViewTypeBackground                     : RGBA(255.0, 252.0, 236.0, 1),
                          kRegexHighlightViewTypeComment                        : RGBA(208.0, 134.0, 59.0, 1),
                          kRegexHighlightViewTypeDocumentationComment           : RGBA(208.0, 134.0, 59.0, 1),
                          kRegexHighlightViewTypeDocumentationCommentKeyword    : RGBA(190.0, 116.0, 55.0, 1),
                          kRegexHighlightViewTypeString                         : RGBA(234.0, 32.0, 24.0, 1),
                          kRegexHighlightViewTypeCharacter                      : RGBA(53.0, 87.0, 134.0, 1),
                          kRegexHighlightViewTypeNumber                         : RGBA(53.0, 87.0, 134.0, 1),
                          kRegexHighlightViewTypeKeyword                        : RGBA(53.0, 87.0, 134.0, 1),
                          kRegexHighlightViewTypePreprocessor                   : RGBA(119.0, 121.0, 148.0, 1),
                          kRegexHighlightViewTypeURL                            : RGBA(85.0, 99.0, 179.0, 1),
                          kRegexHighlightViewTypeAttribute                      : RGBA(58.0, 76.0, 166.0, 1),
                          kRegexHighlightViewTypeProject                        : RGBA(196.0, 88.0, 31.0, 1),
                          kRegexHighlightViewTypeOther                          : RGBA(196.0, 88.0, 31.0, 1)};
            break;
    }
    if(themeColor) {
        highlightThemes[[NSNumber numberWithInt:theme]] = themeColor;
        return themeColor;
    } else
        return nil;
}
+ (NSDictionary*) defaultDefinition {
    //It is recommended to use an ordered dictionary, because the highlighting will take place in the same order the dictionary enumerator returns the definitions
    NSMutableDictionary* definition = [NSMutableDictionary dictionary];
    definition[kRegexHighlightViewTypeKeyword]                          = @"(?<!\\w)(and|or|xor|for|do|while|foreach|as|return|die|exit|if|then|else|elseif|new|delete|try|throw|catch|finally|class|function|string|array|object|resource|var|bool|boolean|int|integer|float|double|real|string|array|global|const|static|public|private|protected|published|extends|switch|true|false|null|void|this|self|struct|char|signed|unsigned|short|long|print)(?!\\w)";
    definition[kRegexHighlightViewTypeURL]                              = @"((https?|mailto|ftp|file)://([-\\w\\.]+)+(:\\d+)?(/([\\w/_\\.]*(\\?\\S+)?)?)?)";
    definition[kRegexHighlightViewTypeProject]                          = @"\\b((NS|UI|CG)\\w+?)";
    definition[kRegexHighlightViewTypeAttribute]                        = @"(\\.[^\\d]\\w+)";
    definition[kRegexHighlightViewTypeNumber]                           = @"(?<!\\w)(((0x[0-9a-fA-F]+)|(([0-9]+\\.?[0-9]*|\\.[0-9]+)([eE][-+]?[0-9]+)?))[fFlLuU]{0,2})(?!\\w)";
    definition[kRegexHighlightViewTypeCharacter]                        = @"('.')";
    definition[kRegexHighlightViewTypeString]                           = @"(@?\"(?:[^\"\\\\]|\\\\.)*\")";
    definition[kRegexHighlightViewTypeComment]                          = @"//[^\"\\n\\r]*(?:\"[^\"\\n\\r]*\"[^\"\\n\\r]*)*[\\r\\n]";
    definition[kRegexHighlightViewTypeDocumentationCommentKeyword]      = @"(/\\*|\\*/)";
    definition[kRegexHighlightViewTypeDocumentationComment]             = @"/\\*(.*?)\\*/";
    definition[kRegexHighlightViewTypePreprocessor]                     = @"(#.*?)[\r\n]";
    definition[kRegexHighlightViewTypeOther]                            = @"(Kristian|Kraljic)";
    return definition;
}

- (void) drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    return;

//    if(self.text.length<=0) {
//        self.text = EMPTY;
//        return;
//    }
//    
//
//    //Prepare View for drawing
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetTextMatrix(context,CGAffineTransformIdentity);
//    CGContextTranslateCTM(context,0,([self bounds]).size.height);
//    CGContextScaleCTM(context,1.0,-1.0);
//
//    //Get the view frame size
//    CGSize size = self.frame.size;
//    
//    //Determine default text color
//    UIColor* textColor = nil;
//    if(!self.highlightColor||!(textColor=(self.highlightColor)[kRegexHighlightViewTypeText])) {
//        if([self.textColor isEqual:[UIColor clearColor]]) {
//            if(!(textColor=[RegexHighlightView highlightTheme:kRegexHighlightViewThemeDefault][kRegexHighlightViewTypeText]))
//               textColor = [UIColor blackColor];
//        } else
//            textColor = self.textColor;
//    }
//    
//    //Set line height, font, color and break mode
//    CGFloat minimumLineHeight = [self.text sizeWithFont:self.font].height - 1,  maximumLineHeight = minimumLineHeight;
//    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)self.font.fontName, self.font.pointSize,NULL);
//    CTLineBreakMode lineBreakMode = kCTLineBreakByWordWrapping;
//    
//    //Apply paragraph settings
//    CTParagraphStyleRef style = CTParagraphStyleCreate((CTParagraphStyleSetting[3]){
//        {   kCTParagraphStyleSpecifierMinimumLineHeight,sizeof(minimumLineHeight),&minimumLineHeight},
//        {   kCTParagraphStyleSpecifierMaximumLineHeight,sizeof(maximumLineHeight),&maximumLineHeight},
//        {   kCTParagraphStyleSpecifierLineBreakMode,sizeof(CTLineBreakMode),&lineBreakMode}
//    },3);
//    NSDictionary* attributes = @{
//                                 (NSString*)kCTFontAttributeName                : (__bridge id)font,
//                                 (NSString*)kCTForegroundColorAttributeName     : (__bridge id)textColor.CGColor,
//                                 (NSString*)kCTParagraphStyleAttributeName      : (__bridge id)style};
//                
//    //Create path to work with a frame with applied margins
//    CGMutablePathRef path = CGPathCreateMutable();
//    
//    CGFloat minX = MARGIN+0.0;
//    CGFloat minY = (-self.contentOffset.y+0) - 9;
//    minY = 0;
//    CGFloat width = (size.width-2*MARGIN);
//    //CGFloat height = (size.height+(self.contentOffset.y - (int)((self.contentOffset.y-MARGIN)/minimumLineHeight)*minimumLineHeight)-MARGIN);
//    CGFloat height = self.contentSize.height;
//    CGPathAddRect(path,NULL,CGRectMake(minX,minY,width,height));
//    
//    
//    // Create attributed string, with applied syntax highlighting
//    NSString *str = [self.text substringWithRange:[self visibleRangeOfTextView:self]];
//    NSAttributedString *atr = [[NSAttributedString alloc] initWithString:str attributes:attributes];
//    CFAttributedStringRef attributedString = (__bridge CFAttributedStringRef)[self highlightText:atr];
////    NSLog(@"%f %f %f %f",self.contentOffset.y,rect.origin.y,rect.size.height,height);
////    NSLog(@"%@",str);
//
//    
//    //Draw the frame
//    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
//    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0,CFAttributedStringGetLength(attributedString)),path,NULL);
//    CTFrameDraw(frame,context);
}

- (NSRange) visibleRangeOfTextView:(UITextView *)textView {
    return NSMakeRange(0, self.text.length);
//    CGRect bounds = textView.bounds;
//    //Get start and end bouns for text position
//    UITextPosition *start = [textView characterRangeAtPoint:bounds.origin].start,*end = [textView characterRangeAtPoint:CGPointMake(CGRectGetMaxX(bounds),CGRectGetMaxY(bounds))].end;
//    //Make a range out of it and return
//    return NSMakeRange([textView offsetFromPosition:textView.beginningOfDocument toPosition:start],[textView offsetFromPosition:start toPosition:end]);
}
- (NSAttributedString*) highlightText:(NSAttributedString*)attributedString {
    //Create a mutable attribute string to set the highlighting
    NSString* string = attributedString.string; NSRange range = NSMakeRange(0,[string length]);
    NSMutableAttributedString* coloredString = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
    
    //Fix the offcenter of UITextView's and CoreText's text render by telling the CoreText to ignore the kerning
    NSNumber *kern = @0.0f;
    [coloredString addAttribute:(id)kCTKernAttributeName value:kern range:range];
    
    //Define the definition to use
    NSDictionary* definition = nil;
    if(!(definition=self.highlightDefinition))
        definition = [RegexHighlightView defaultDefinition];
    
    //For each definition entry apply the highlighting to matched ranges
    for(NSString* key in definition) {
        NSString* expression = definition[key];
        if(!expression||[expression length]<=0) continue;
        NSArray* matches = [[NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionDotMatchesLineSeparators error:nil] matchesInString:string options:0 range:range];
        for(NSTextCheckingResult* match in matches) {
            UIColor* textColor = nil;
            //Get the text color, if it is a custom key and no color was defined, choose black
            if(!self.highlightColor||!(textColor=((self.highlightColor)[key])))
                if(!(textColor=[RegexHighlightView highlightTheme:kRegexHighlightViewThemeDefault][key]))
                    textColor = [UIColor blackColor];
            [coloredString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)textColor.CGColor range:[match rangeAtIndex:0]];                            
        }
    }
    
    return coloredString.copy;
}


#pragma mark Delegate
- (void) textViewDidChange:(UITextView *)textView {
    [textView setNeedsDisplay];
    [self.containerView resize];
    [self.drawView setNeedsDisplay];
}
- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    [scrollView setNeedsDisplay];
    
    [self.containerView scrollViewDidScroll:scrollView];
    
}
- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //Only update the text if the text changed
    NSString* newText = [text stringByReplacingOccurrencesOfString:@"\t" withString:@"    "];
    if(![newText isEqualToString:text]) {
        textView.text = [textView.text stringByReplacingCharactersInRange:range withString:newText];
        return NO;
    }
    return YES;
}


#pragma mark Properties
- (void) setHighlightTheme:(RegexHighlightViewTheme)theme {
    self.highlightColor = [RegexHighlightView highlightTheme:theme];
    
    // Set font, text color and background color back to default
    //self.textColor = [UIColor clearColor];
//    UIColor *backgroundColor = (self.highlightColor)[kRegexHighlightViewTypeBackground];
//    if(backgroundColor)
//         self.backgroundColor = backgroundColor;
//    else
        self.backgroundColor = [UIColor clearColor];
    
    //self.font = [UIFont systemFontOfSize:(theme!=kRegexHighlightViewThemePresentation?14.0:18.0)];
}
- (void) setHighlightColor:(NSDictionary*)newHighlightColor {
    if(_highlightColor!=newHighlightColor) {
        _highlightColor = newHighlightColor;
        [self setNeedsLayout];
    }
}
- (void) setHighlightDefinition:(NSDictionary*)newHighlightDefinition {
    if(_highlightDefinition!=newHighlightDefinition) {
        _highlightDefinition = newHighlightDefinition;
        [self setNeedsLayout];
    }
}
- (void) setHighlightDefinitionWithContentsOfFile:(NSString*)newPath {
    [self setHighlightDefinition:[NSDictionary dictionaryWithContentsOfFile:newPath]];
}
- (void) setText:(NSString *)text{
    [super setText:text];
    
    [self.drawView setNeedsDisplay];
}

@end
