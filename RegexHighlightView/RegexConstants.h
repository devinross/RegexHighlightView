//
//  Regex.h
//  Regex Highlight View
//
//  Created by Devin Ross on 4/25/15.
//
//


FOUNDATION_EXPORT NSString *const kRegexHighlightViewTypeText;
FOUNDATION_EXPORT NSString *const kRegexHighlightViewTypeBackground;
FOUNDATION_EXPORT NSString *const kRegexHighlightViewTypeComment;
FOUNDATION_EXPORT NSString *const kRegexHighlightViewTypeDocumentationComment;
FOUNDATION_EXPORT NSString *const kRegexHighlightViewTypeDocumentationCommentKeyword;
FOUNDATION_EXPORT NSString *const kRegexHighlightViewTypeString;
FOUNDATION_EXPORT NSString *const kRegexHighlightViewTypeCharacter;
FOUNDATION_EXPORT NSString *const kRegexHighlightViewTypeNumber;
FOUNDATION_EXPORT NSString *const kRegexHighlightViewTypeKeyword;
FOUNDATION_EXPORT NSString *const kRegexHighlightViewTypePreprocessor;
FOUNDATION_EXPORT NSString *const kRegexHighlightViewTypeURL;
FOUNDATION_EXPORT NSString *const kRegexHighlightViewTypeAttribute;
FOUNDATION_EXPORT NSString *const kRegexHighlightViewTypeProject;
FOUNDATION_EXPORT NSString *const kRegexHighlightViewTypeOther;


typedef NS_ENUM(unsigned int, RegexHighlightViewTheme) {
    kRegexHighlightViewThemeBasic = 0,
    kRegexHighlightViewThemeDefault = 1,
    kRegexHighlightViewThemeDusk = 2,
    kRegexHighlightViewThemeLowKey = 3,
    kRegexHighlightViewThemeMidnight = 4,
    kRegexHighlightViewThemePresentation = 5,
    kRegexHighlightViewThemePrinting = 6,
    kRegexHighlightViewThemeSunset = 7,
    kRegexHighlightViewThemeCustom

};

#define EMPTY @""
static CGFloat MARGIN = 8;
