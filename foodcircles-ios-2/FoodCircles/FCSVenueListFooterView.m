//
//  FCSVenueListFooterView.m
//  FoodCircles
//
//  Created by Bruno Guidolim on 9/20/15.
//  Copyright © 2015 FoodCircles. All rights reserved.
//

#import "FCSVenueListFooterView.h"
#import "FCSStyles.h"
#import <MessageUI/MessageUI.h>

@implementation FCSVenueListFooterView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.requestRestaurantButton setTitleColor:[FCSStyles darkRed] forState:UIControlStateNormal];
}

- (IBAction)requestRestaurantTapped:(id)sender {
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
        mailVC.mailComposeDelegate = self.parentVC;
        [mailVC setSubject:@"Another restaurant to consider"];
        [mailVC setToRecipients:@[@"hey@joinfoodcircles.org"]];
        mailVC.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
        
        [self.parentVC.navigationController presentViewController:mailVC animated:YES completion:^{
           [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            
        }];
    }
}

@end
