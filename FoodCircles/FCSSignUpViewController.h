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
#import "FCSFacebookButton.h"
#import "FCSTwitterButton.h"

@class MBProgressHUD;

@interface FCSSignUpViewController : FCSStyledViewController{
    MBProgressHUD *HUD;
}

@property (assign, nonatomic) BOOL twitterLogin;
@property (strong, nonatomic) NSString *twitterUID;

@property (weak, nonatomic) IBOutlet FCSFacebookButton *facebookButton;
@property (weak, nonatomic) IBOutlet FCSTwitterButton *twitterButton;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *countCopyLabel;
@property (weak, nonatomic) IBOutlet UIView *twitterTextView;
@property (weak, nonatomic) IBOutlet UIView *passwordTextView;
- (IBAction)clickSignUp:(id)sender;
- (IBAction)clickFacebookSignUp:(id)sender;
- (IBAction)clickTwitterSignUp:(id)sender;

@end
