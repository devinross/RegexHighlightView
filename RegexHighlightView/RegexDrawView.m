//
//  RegexDrawView.m
//  Regex Highlight View
//
//  Created by Devin Ross on 4/25/15.
//
//

#import "RegexDrawView.h"
#import "RegexTextView.h"
#import "RegexConstants.h"



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
            if(!(textColor=[RegexTextView highlightTheme:kRegexHighlightViewThemeDefault][kRegexHighlightViewTypeText]))
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
