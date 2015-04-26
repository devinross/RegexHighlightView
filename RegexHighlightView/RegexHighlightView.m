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
    
    
    
    
    self.drawView.highlightView = self.textView;
    self.textView.drawView = self.drawView;
    self.textView.containerView = self;
    
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
    self.drawView.center = CGPointMake(self.drawView.center.x, 6 + CGRectGetHeight(self.drawView.frame)/2 - self.textView.contentOffset.y);
    [self setNeedsDisplay];
    
    
}


+ (NSArray*) languages{
    return [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Languages" ofType:@"plist"]];
}

@end


