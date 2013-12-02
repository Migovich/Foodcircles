#import "UILabel+Boldify.h"

@implementation UILabel (Boldify)
- (void) boldRange: (NSRange) range {
    if (![self respondsToSelector:@selector(setAttributedText:)]) {
        return;
    }
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:self.text];
    NSString *fontName = [NSString stringWithFormat:@"%@-Bold", self.font.fontName];
    UIFont *font = [UIFont fontWithName:fontName size:self.font.pointSize];
    if (font) {
        [attributedText addAttribute:NSFontAttributeName value:font range:range];
        self.attributedText = attributedText;
    }
}

- (void) boldSubstring: (NSString*) substring {
    NSRange range = [self.text rangeOfString:substring];
    [self boldRange:range];
}
@end