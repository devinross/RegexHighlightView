//
//  RegexHighlightView.h
//  iOS Syntax Highlighter
//
//  Created by Kristian Kraljic on 30/8/12.
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

@import UIKit;
@import CoreText;
#import "RegexConstants.h"


@class RegexDrawView,RegexHighlightView;

@interface RegexTextView : UITextView <UITextViewDelegate>

@property (nonatomic,weak) RegexDrawView *drawView;
@property (nonatomic,weak) RegexHighlightView *containerView;

- (NSRange) visibleRangeOfTextView:(UITextView *)textView ;
- (NSAttributedString*) highlightText:(NSAttributedString*)attributedString;

@end
