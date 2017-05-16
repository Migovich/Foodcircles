//
//  FCSSignUpViewController.h
//  FoodCircles
//
//  Created by David Groulx on 5/1/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FCSStyledViewController.h" 
#import "MBProgressHUD.h"

@class MBProgressHUD;

@interface FCSSignInViewController : FCSStyledViewController{
    MBProgressHUD *HUD;
}

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)clickSignIn:(id)sender;
- (IBAction)clickFacebookSignIn:(id)sender;
- (IBAction)clickTwitterSignIn:(id)sender;

@end
