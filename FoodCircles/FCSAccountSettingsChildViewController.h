//
//  FCSAccountSettingsChildViewController.h
//  FoodCircles
//
//  Created by Bruno Guidolim on 8/24/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FCSAccountSettingsChildViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end
