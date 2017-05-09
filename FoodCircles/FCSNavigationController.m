#import "FCSNavigationController.h"
#import "FCSStyles.h"

@implementation FCSNavigationController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.navigationBar.tintColor = [FCSStyles darkRed];
    self.navigationBar.titleTextAttributes = @{ NSFontAttributeName: [UIFont fontWithName:@"NeutrafaceSlabText-Bold" size:22],
                                                NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationBar.translucent = NO;
}

@end
