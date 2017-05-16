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
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:@"mailto:hey@joinfoodcircles.org"];
    [application openURL:URL options:@{} completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Opened url");
        }
    }];
}

@end
