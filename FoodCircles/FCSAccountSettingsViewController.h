//
//  FCSAccountSettingsViewController.h
//  FoodCircles
//
//  Created by David Groulx on 5/21/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FCSAccountSettingsViewController : UITableViewController
<UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *facebookConnectionSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *twitterConnectionSwitch;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@end
