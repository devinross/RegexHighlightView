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
    self.textColor = [UIColor colorWithWhite:0.5 alpha:0.4];
    self.delegate = self;
    self.backgroundColor = [UIColor clearColor];
    return self;
}

#pragma mark Public Functions


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


- (NSRange) visibleRangeOfTextView:(UITextView *)textView {
    return NSMakeRange(0, self.text.length);
}
- (NSAttributedString*) highlightText:(NSAttributedString*)attributedString {
    //Create a mutable attribute string to set the highlighting
    NSString* string = attributedString.string; NSRange range = NSMakeRange(0,[string length]);
    NSMutableAttributedString* coloredString = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
    
    NSNumber *kern = @0.0f;
    [coloredString addAttribute:(id)kCTKernAttributeName value:kern range:range];
    
    NSDictionary* definition = self.containerView.syntaxRegularExpressions;

    //For each definition entry apply the highlighting to matched ranges
    for(NSString* key in definition) {
        
        NSString* expression = definition[key];
        if(!expression||[expression length]<=0) continue;
        
        
        
        NSArray* matches = [[NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionDotMatchesLineSeparators error:nil] matchesInString:string options:0 range:range];
        
        for(NSTextCheckingResult* match in matches) {
            UIColor* textColor = nil;
            //Get the text color, if it is a custom key and no color was defined, choose black
            if(!self.containerView.syntaxColors || !(textColor=((self.containerView.syntaxColors)[key])))
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

- (void) setText:(NSString *)text{
    [super setText:text];
    [self.drawView setNeedsDisplay];
}

@end
