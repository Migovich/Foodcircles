//
//  FCSAccountSettingsViewController.h
//  FoodCircles
//
//  Created by David Groulx on 5/21/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface FCSAccountSettingsViewController : UIViewController <UITableViewDelegate> {
    MBProgressHUD *HUD;
}

- (IBAction)logoutButtonClicked:(id)sender;
- (IBAction)saveUserData:(id)sender;

@end
