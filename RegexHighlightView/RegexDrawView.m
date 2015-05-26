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
#import "RegexHighlightView.h"


@implementation RegexDrawView

- (instancetype) initWithFrame:(CGRect)frame{
    if(!(self=[super initWithFrame:frame])) return nil;
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor clearColor];
    return self;
}
- (void) drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    BOOL showLineNumbers = self.highlightView.showLineNumbers;
    
    RegexTextView *txtView = self.highlightView.textView;
    NSString *str = txtView.text;
    if(str.length < 1) {
        str = EMPTY;
    }
    
    NSDictionary* attributes;
    CTParagraphStyleRef style;

    //Prepare View for drawing
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context,CGAffineTransformIdentity);
    CGContextTranslateCTM(context,0,([self bounds]).size.height);
    CGContextScaleCTM(context,1.0,-1.0);
    
    CGSize size = self.frame.size;
    UIColor *textColor = self.highlightView.syntaxColors[kRegexHighlightViewTypeText];
    
    
    CGFloat minimumLineHeight = [str sizeWithFont:txtView.font].height - 1;;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone || UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        minimumLineHeight = [str sizeWithFont:txtView.font].height - 0.7;
        
    }else{
        minimumLineHeight = [str sizeWithFont:txtView.font].height - 1;

    }
    CGFloat maximumLineHeight = minimumLineHeight;
    
    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)txtView.font.fontName, txtView.font.pointSize,NULL);
    CTLineBreakMode lineBreakMode = kCTLineBreakByWordWrapping;
    
    //Apply paragraph settings
    style = CTParagraphStyleCreate((CTParagraphStyleSetting[3]){
        {   kCTParagraphStyleSpecifierMinimumLineHeight,sizeof(minimumLineHeight),&minimumLineHeight},
        {   kCTParagraphStyleSpecifierMaximumLineHeight,sizeof(maximumLineHeight),&maximumLineHeight},
        {   kCTParagraphStyleSpecifierLineBreakMode,sizeof(CTLineBreakMode),&lineBreakMode} },3);
    
    attributes = @{(NSString*)kCTFontAttributeName                : (__bridge id)font,
                   (NSString*)kCTForegroundColorAttributeName     : (__bridge id)textColor.CGColor,
                   (NSString*)kCTParagraphStyleAttributeName      : (__bridge id)style};
    
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat minX = showLineNumbers ? 30 : 12;
    CGFloat minY = - 9;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone || UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    
        minX = showLineNumbers ? (27+4) : 11;

    } else {
        minX = showLineNumbers ? 30 : 12;
    }
    
    
    
    CGFloat margin = 8;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone || UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        margin = showLineNumbers ? 8 : 2;
    } else {
        margin = 8;
    }

    CGFloat width = size.width - minX - margin, height = self.bounds.size.height;
    
    NSLog(@"%f %f %f",minX,margin,width);

    CGPathAddRect(path,NULL,CGRectMake(minX,minY,width,height));
    
    NSAttributedString *atr = [[NSAttributedString alloc] initWithString:str attributes:attributes];
    CFAttributedStringRef attributedString = (__bridge CFAttributedStringRef)[txtView highlightText:atr];
    
    CTFramesetterRef framesetter;
    CTFrameRef frame;

    framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0,CFAttributedStringGetLength(attributedString)),path,NULL);
    CTFrameDraw(frame,context);
    
    CGFloat frameHeight = [RegexDrawView measureFrame:frame].height;
    NSInteger num = (frameHeight)/minimumLineHeight;
    if([str hasSuffix:@"\n"]){
        frameHeight += minimumLineHeight;
        num ++;
    }
    
    
    if(self.highlightView.showLineNumbers){
        
        minY = self.bounds.size.height - frameHeight - 9;
        CGRect rr = CGRectMake(0,minY,24,frameHeight);
        CGMutablePathRef path2 = CGPathCreateMutable();
        CGPathAddRect(path2,NULL,rr);
        
        CTTextAlignment alignment = kCTRightTextAlignment;
        CTParagraphStyleSetting alignmentSetting;
        alignmentSetting.spec = kCTParagraphStyleSpecifierAlignment;
        alignmentSetting.valueSize = sizeof(CTTextAlignment);
        alignmentSetting.value = &alignment;
        
        style = CTParagraphStyleCreate((CTParagraphStyleSetting[4]){
            {   kCTParagraphStyleSpecifierMinimumLineHeight,sizeof(minimumLineHeight),&minimumLineHeight},
            {   kCTParagraphStyleSpecifierMaximumLineHeight,sizeof(maximumLineHeight),&maximumLineHeight},
            {   kCTParagraphStyleSpecifierLineBreakMode,sizeof(CTLineBreakMode),&lineBreakMode},
        alignmentSetting},4);
        
        
        attributes = @{(NSString*)kCTFontAttributeName               : (__bridge id)font,
                       (NSString*)kCTForegroundColorAttributeName     : (__bridge id)[UIColor colorWithWhite:125/255.0f alpha:1].CGColor,
                       (NSString*)kCTParagraphStyleAttributeName      : (__bridge id)style };
        
        atr = [[NSMutableAttributedString alloc] initWithString:[self numberStringWithText:str count:num frame:frame] attributes:attributes];
        attributedString = (__bridge CFAttributedStringRef)atr;
        
        
        
        CTFramesetterRef framesetter2 = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
        frame = CTFramesetterCreateFrame(framesetter2, CFRangeMake(0,CFAttributedStringGetLength(attributedString)),path2,NULL);
        CTFrameDraw(frame,context);
        
        CFRelease(framesetter2);
        CGPathRelease(path2);


    }


}

+ (CGSize) measureFrame:(CTFrameRef)frame{
    // 1. measure width
    CFArrayRef  lines       = CTFrameGetLines(frame);
    CFIndex     numLines    = CFArrayGetCount(lines);
    CGFloat     maxWidth    = 0;
    
    for(CFIndex index = 0; index < numLines; index++){
        CTLineRef   line = (CTLineRef) CFArrayGetValueAtIndex(lines, index);
        CGFloat     ascent, descent, leading, width;
        
        width = CTLineGetTypographicBounds(line, &ascent,  &descent, &leading);
        if(width > maxWidth)
            maxWidth = width;
    }
    
    // 2. measure height
    CGFloat ascent, descent, leading;
    
    CTLineGetTypographicBounds((CTLineRef) CFArrayGetValueAtIndex(lines, 0), &ascent,  &descent, &leading);
    CGFloat firstLineHeight = ascent + descent + leading;
    
    CTLineGetTypographicBounds((CTLineRef) CFArrayGetValueAtIndex(lines, numLines - 1), &ascent,  &descent, &leading);
    CGFloat lastLineHeight  = ascent + descent + leading;
    
    CGPoint firstLineOrigin;
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 1), &firstLineOrigin);
    
    CGPoint lastLineOrigin;
    CTFrameGetLineOrigins(frame, CFRangeMake(numLines - 1, 1), &lastLineOrigin);
    
    CGFloat textHeight = ABS(firstLineOrigin.y - lastLineOrigin.y) + firstLineHeight + lastLineHeight;
    
    return CGSizeMake(maxWidth, textHeight);
}


- (NSString*) numberStringWithText:(NSString*)text count:(NSInteger)count frame:(CTFrameRef)frame{
    
    
    NSMutableString *str = [[NSMutableString alloc] init];
    
    


    CFArrayRef  lines       = CTFrameGetLines(frame);
    CFIndex     numLines    = CFArrayGetCount(lines);
    
    
    NSInteger ctr = 1;
    BOOL missed = NO;
    NSInteger end = 0;
    for(CFIndex index = 0; index < numLines; index++){
        CTLineRef line = (CTLineRef) CFArrayGetValueAtIndex(lines, index);
        CFRange range = CTLineGetStringRange(line);
        
        
        
        NSString *substring = [text substringWithRange:NSMakeRange(range.location, range.length)];
        
        if(missed){
            [str appendFormat:@"\n"];
        }else{
            [str appendFormat:@"%ld\n",(long)ctr];
            ctr++;
        }
        
        
        if([substring hasSuffix:@"\n"]){
            missed = NO;
        }else{
            missed = YES;
        }
        end = range.length + range.location;

        
        
    }
    
    if(end <= text.length || text.length < 1)
        [str appendFormat:@"%ld\n",(long)ctr];



    return str;
}


@end
