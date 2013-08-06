#import "UILabel+Boldify.h"
 
@implementation UILabel (Boldify)
- (void) boldRange: (NSRange) range {
    if (![self respondsToSelector:@selector(setAttributedText:)]) {
        return;
    }
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:self.text];
    NSString *fontName = [NSString stringWithFormat:@"%@-Bold", self.font.fontName];
    [attributedText addAttribute:NSFontAttributeName value:[UIFont fontWithName:fontName size:self.font.pointSize] range:range];
    self.attributedText = attributedText;    
}

- (void) boldSubstring: (NSString*) substring {
    NSRange range = [self.text rangeOfString:substring];
    [self boldRange:range];
}
@end