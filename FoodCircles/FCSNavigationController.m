#import "FCSNavigationController.h"
#import "FCSStyles.h"

@implementation FCSNavigationController

- (void)viewWillAppear:(BOOL)animated {
  self.navigationBar.tintColor = [FCSStyles darkRed];
  self.navigationBar.titleTextAttributes = @{ UITextAttributeFont : [UIFont fontWithName:@"Neutraface Slab Text" size:22] };
}

@end
