//
//  FCSAccountSettingsChildViewController.m
//  FoodCircles
//
//  Created by Bruno Guidolim on 8/24/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSAccountSettingsChildViewController.h"
#import "FCSStyles.h"
#import "FCSAppDelegate.h"
#import "SSKeychain.h"

@interface FCSAccountSettingsChildViewController ()

@end

@implementation FCSAccountSettingsChildViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _emailTextField.text = UIAppDelegate.user_email;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)changePassword:(id)sender {

//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Change password" message:@"Please input your previous password" preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//        textField.placeholder = @"please input your previous password";
//        textField.secureTextEntry = YES;
//    }];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil];
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Confirm the modification" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *alertAction) {
//        UITextField *password = alertController.textFields.firstObject;
//            if (![password.text isEqualToString:@""]) {
//                
//                
//            //change password
//            
//            }
//            else {
//                [self presentViewController:alertController animated:YES completion:nil];
//        }
//    }];
//    [alertController addAction:cancelAction];
//    [alertController addAction:okAction];
//    [self presentViewController:alertController animated:YES completion:nil];
//    
}

@end
