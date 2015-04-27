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

}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.highlightView = [[RegexHighlightView alloc] initWithFrame:self.view.bounds];
    self.highlightView.textView.font = [UIFont fontWithName:@"Menlo" size:11];
    self.highlightView.textView.text = @"#import <Foundation/Foundation.h>\n@import Foundation;\n\n#pragma mark - Hello\nint main()\n{\n\t/* my first program in Objective-C */\n\tNSLog(@\"Hello, World! \");\n\tNSArray *array = @[@5,@10,@YES];\n\n\treturn 0;\n}";
    self.highlightView.highlightTheme = kRegexHighlightViewThemeDefault;     // Set the color theme to use (all XCode themes are fully supported!)
    self.highlightView.languageFile = @"objectivec";     // Set the syntax highlighting to use (the tempalate file contains the default highlighting)
    [self.view addSubview:self.highlightView];

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
