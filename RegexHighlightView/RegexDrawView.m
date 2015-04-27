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
    
    
    RegexTextView *txtView = self.highlightView.textView;
    if(txtView.text.length<=0) {
        txtView.text = EMPTY;
        return;
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
    CGFloat minimumLineHeight = [txtView.text sizeWithFont:txtView.font].height - 1,  maximumLineHeight = minimumLineHeight;
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
    CGFloat minX = -8, minY = - 9;
    minX = 30;

    CGFloat width = size.width - minX - MARGIN, height = self.bounds.size.height;
    CGPathAddRect(path,NULL,CGRectMake(minX,minY,width,height));
    
    NSString *str = txtView.text;
    NSAttributedString *atr = [[NSAttributedString alloc] initWithString:str attributes:attributes];
    CFAttributedStringRef attributedString = (__bridge CFAttributedStringRef)[txtView highlightText:atr];
    
    CTFramesetterRef framesetter;
    CTFrameRef frame, textFrame;

    framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    textFrame = frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0,CFAttributedStringGetLength(attributedString)),path,NULL);
    CTFrameDraw(frame,context);
    
    
    CGFloat frameHeight = [RegexDrawView measureFrame:frame].height;
    
    
    NSInteger num = (frameHeight)/minimumLineHeight;
    
    if([str hasSuffix:@"\n"]){
        frameHeight += minimumLineHeight;
        num ++;
    }
    

    minY = self.bounds.size.height - frameHeight - 9;
    CGRect rr = CGRectMake(0,minY,24,frameHeight);
    path = CGPathCreateMutable();
    CGPathAddRect(path,NULL,rr);
    
    

    
    CTTextAlignment alignment = kCTRightTextAlignment;
    CTParagraphStyleSetting alignmentSetting;
    alignmentSetting.spec = kCTParagraphStyleSpecifierAlignment;
    alignmentSetting.valueSize = sizeof(CTTextAlignment);
    alignmentSetting.value = &alignment;
    CTParagraphStyleSetting settings[1] = {alignmentSetting};
    size_t settingsCount = 1;
    CTParagraphStyleRef paragraphRef = CTParagraphStyleCreate(settings, settingsCount);
    

    attributes = @{(NSString*)kCTFontAttributeName                : (__bridge id)font,
                  (NSString*)kCTForegroundColorAttributeName     : (__bridge id)[UIColor colorWithWhite:125/255.0f alpha:1].CGColor,
                  (NSString*)kCTParagraphStyleAttributeName      : (__bridge id)paragraphRef };
    
    atr = [[NSMutableAttributedString alloc] initWithString:[self numberStringWithCount:num frame:textFrame] attributes:attributes];
    attributedString = (__bridge CFAttributedStringRef)atr;

    
    
    framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0,CFAttributedStringGetLength(attributedString)),path,NULL);
    CTFrameDraw(frame,context);
    
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


- (NSString*) numberStringWithCount:(NSInteger)count frame:(CTFrameRef)frame{
    
    
    NSMutableString *str = [[NSMutableString alloc] init];
    
    
    RegexTextView *txtView = self.highlightView.textView;
    NSString *text = txtView.text;

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
    
    
    if(end <= text.length)
        [str appendFormat:@"%ld\n",(long)ctr];



    return str;
}


@end
