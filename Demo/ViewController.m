//
//  ViewController.m
//  Regex Highlight View
//
//  Created by Kraljic, Kristian on 30.08.12.
//  Copyright (c) 2012 Kristian Kraljic (dikrypt.com, ksquared.de). All rights reserved.
//

#import "ViewController.h"
#import "RegexHighlightView.h"

@implementation ViewController

- (void) loadView{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.highlightView = [[RegexHighlightView alloc] initWithFrame:self.view.bounds];
    self.highlightView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.highlightView];
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Overwrite the textColor from the nib, set to clearColor
    self.highlightView.textView.textColor = [UIColor clearColor];
    // Set the syntax highlighting to use (the tempalate file contains the default highlighting)
    [self.highlightView.textView setHighlightDefinitionWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"objectivec" ofType:@"plist"]];
    // Set the color theme to use (all XCode themes are fully supported!)
    [self.highlightView.textView setHighlightTheme:kRegexHighlightViewThemeDusk];
}

- (void)viewDidUnload{
    [self setHighlightView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
