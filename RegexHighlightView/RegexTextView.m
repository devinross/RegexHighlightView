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

#import "RegexTextView.h"
#import "RegexConstants.h"
#import "RegexDrawView.h"
#import "RegexHighlightView.h"

static NSMutableDictionary* highlightThemes;

@implementation RegexTextView

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
    self.textColor = [UIColor colorWithWhite:0.1 alpha:0.1];
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
            themeColor = @{kRegexHighlightViewTypeText                          : RGBA(0,   0,   0,   1),
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
            themeColor = @{kRegexHighlightViewTypeText                          : RGBA(0, 0, 0, 1),
                          kRegexHighlightViewTypeBackground                     : RGBA(255, 255, 255, 0),
                          kRegexHighlightViewTypeComment                        : RGBA(0, 131, 39, 1),
                          kRegexHighlightViewTypeDocumentationComment           : RGBA(0, 131, 39, 1),
                          kRegexHighlightViewTypeDocumentationCommentKeyword    : RGBA(0, 76, 29, 1),
                          kRegexHighlightViewTypeString                         : RGBA(211, 45, 38, 1),
                          kRegexHighlightViewTypeCharacter                      : RGBA(40, 52, 206, 1),
                          kRegexHighlightViewTypeNumber                         : RGBA(40, 52, 206, 1),
                          kRegexHighlightViewTypeKeyword                        : RGBA(188, 49, 156, 1),
                          kRegexHighlightViewTypePreprocessor                   : RGBA(120, 72, 48, 1),
                          kRegexHighlightViewTypeURL                            : RGBA(21, 67, 244, 1),
                          kRegexHighlightViewTypeAttribute                      : RGBA(150, 125, 65, 1),
                          kRegexHighlightViewTypeProject                        : RGBA(77, 129, 134, 1),
                          kRegexHighlightViewTypeOther                          : RGBA(113, 65, 163, 1)};
            break;
        case kRegexHighlightViewThemeDusk:
            themeColor = @{kRegexHighlightViewTypeText                          : RGBA(255, 255, 255, 1),
                          kRegexHighlightViewTypeBackground                     : RGBA(40, 43, 52, 1),
                          kRegexHighlightViewTypeComment                        : RGBA(72, 190, 102, 1),
                          kRegexHighlightViewTypeDocumentationComment           : RGBA(72, 190, 102, 1),
                          kRegexHighlightViewTypeDocumentationCommentKeyword    : RGBA(72, 190, 102, 1),
                          kRegexHighlightViewTypeString                         : RGBA(230, 66, 75, 1),
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
            themeColor = @{kRegexHighlightViewTypeText                          : RGBA(0, 0, 0, 1),
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
            themeColor = @{kRegexHighlightViewTypeText                          : RGBA(255, 255, 255, 1),
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
            themeColor = @{kRegexHighlightViewTypeText                          : RGBA(0, 0, 0, 1),
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
            themeColor = @{kRegexHighlightViewTypeText                          : RGBA(0, 0, 0, 1),
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
            themeColor = @{kRegexHighlightViewTypeText                          : RGBA(0, 0, 0, 1),
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
        definition = [RegexTextView defaultDefinition];
    
    //For each definition entry apply the highlighting to matched ranges
    for(NSString* key in definition) {
        NSString* expression = definition[key];
        if(!expression||[expression length]<=0) continue;
        NSArray* matches = [[NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionDotMatchesLineSeparators error:nil] matchesInString:string options:0 range:range];
        for(NSTextCheckingResult* match in matches) {
            UIColor* textColor = nil;
            //Get the text color, if it is a custom key and no color was defined, choose black
            if(!self.highlightColor||!(textColor=((self.highlightColor)[key])))
                if(!(textColor=[RegexTextView highlightTheme:kRegexHighlightViewThemeDefault][key]))
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
    self.highlightColor = [RegexTextView highlightTheme:theme];
    self.backgroundColor = [UIColor clearColor];
    
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
