//
//  FCSSignUpViewController.m
//  FoodCircles
//
//  Created by David Groulx on 5/1/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//
#import "constants.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"
#import "FCSAppDelegate.h"

#import "FCSSignUpViewController.h"

#import "UILabel+Boldify.h"
#import "FCSOverImageHeader.h"
#import "FCSOverImageSecondary.h"
#import "MBProgressHUD.h"
#import <Parse/Parse.h>
#import "FCSLoginProvider.h"
#import "SSKeychain.h"

@interface FCSSignUpViewController ()
@property (weak, nonatomic) IBOutlet FCSOverImageHeader *overImageHeader;
@property (weak, nonatomic) IBOutlet FCSOverImageSecondary *overImageHeaderScondary;

@end

@implementation FCSSignUpViewController

@synthesize emailTextField;
@synthesize passwordTextField;

- (void)viewDidLoad
{
    [super viewDidLoad];

    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *qtyPeople = [userDefaults stringForKey:@"qtyPeople"];
    if (qtyPeople == nil) {
        qtyPeople = @"0";
    }
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"Grab a local restaurant dish for $1.\nYour $1 feeds one child in need."];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,text.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:1];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [text addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    self.overImageHeaderScondary.attributedText = text;
    
    self.countLabel.text = [NSString stringWithFormat:@"%@%@", qtyPeople, @" people repurpose their everyday dining."];
    self.countCopyLabel.text = @"Today, it's your turn.";
    
    NSURL *url = [NSURL URLWithString:USER_COUNT_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        self.countLabel.text = [NSString stringWithFormat:@"%@%@", [JSON valueForKeyPath:@"content"], @" people repurpose their everyday dining."];
        NSString *quantity = [JSON valueForKeyPath:@"content"];
        if (!quantity) quantity = @"0";
        
        [userDefaults setValue:[NSString stringWithFormat:@"%@",quantity] forKey:@"qtyPeople"];
        [userDefaults synchronize];
        [self.countLabel boldSubstring: [NSString stringWithFormat:@"%@", quantity]];
    } failure:nil];
    [operation start];
    
    FCSLoginProvider *login = [[FCSLoginProvider alloc] init];
    [login savedLoginWithView:self segue:@"SignUpSegue" hud:HUD];
}

-(void)viewWillAppear:(BOOL)animated {
    [self activateTwitterSignUp:NO];
}

-(void)activateTwitterSignUp:(BOOL)activate {
    _twitterTextView.hidden = !activate;
    _facebookButton.hidden = activate;
    _twitterButton.hidden = activate;
    self.passwordTextField.hidden = activate;
    _passwordTextView.hidden = !activate;
    
    _twitterLogin = activate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickSignUp:(id)sender {
    [HUD show:YES];
    NSURL *url = [NSURL URLWithString:SIGN_UP_URL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    NSDictionary *params;
    
    if (!_twitterLogin) {
        params = [NSDictionary dictionaryWithObjectsAndKeys:
                  self.emailTextField.text, @"user_email",
                  self.passwordTextField.text, @"user_password",
                  nil];
    } else {
        params = [NSDictionary dictionaryWithObjectsAndKeys:
                  self.emailTextField.text, @"user_email",
                  _twitterUID, @"uid",
                  nil];
    }
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"" parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [HUD hide:YES];
        UIAppDelegate.user_email = self.emailTextField.text;
        UIAppDelegate.user_token = [JSON valueForKeyPath:@"auth_token"];
        
        if (!_twitterLogin) {
            [SSKeychain setPassword:@"Email" forService:@"FoodCircles" account:@"FoodCirclesType"];
            [SSKeychain setPassword: self.emailTextField.text forService:@"FoodCircles" account:@"FoodCirclesEmail"];
            [SSKeychain setPassword: self.passwordTextField.text forService:@"FoodCircles" account:@"FoodCirclesPassword"];
            UIAppDelegate.user_uid = self.emailTextField.text;
        } else {
            [SSKeychain setPassword:@"Twitter" forService:@"FoodCircles" account:@"FoodCirclesType"];
            [SSKeychain setPassword:_twitterUID forService:@"FoodCircles" account:@"FoodCirclesTwitterUID"];
            UIAppDelegate.user_uid = _twitterUID;
        }
        
        [self performSegueWithIdentifier:@"SignUpSegue" sender:self];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [HUD hide:YES];
        
        NSString *emailErrorMessage = [JSON valueForKeyPath:@"errors.email"][0];
        NSString *passwordErrorMessage = [JSON valueForKeyPath:@"errors.password"][0];
        
        NSString *errorMessage = @"";
        
        if (emailErrorMessage != nil) {
            errorMessage = [NSString stringWithFormat:@"%@%@%@%@", errorMessage, @"Email ", emailErrorMessage, @"."];
        }
        
        if (emailErrorMessage != nil && passwordErrorMessage != nil) {
            errorMessage = [errorMessage stringByAppendingString:@"\n"];
        }
        
        if (passwordErrorMessage != nil) {
            errorMessage = [NSString stringWithFormat:@"%@%@%@%@", errorMessage, @"Password ", passwordErrorMessage, @"."];
        }
        
        if(emailErrorMessage == nil && passwordErrorMessage == nil) {
            errorMessage = @"Can't connect to server.";
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sign Up Error"
                                                        message:errorMessage
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        NSLog(@"%@", errorMessage);
        [alert show];
        
    }];
    
    [operation start];
    
}

- (IBAction)clickFacebookSignUp:(id)sender {
    [HUD show:YES];
    FCSLoginProvider *login = [[FCSLoginProvider alloc] init];
    [login loginWithFacebook:^(BOOL success) {
        [HUD hide:YES];
        if (success) {
            [self performSegueWithIdentifier:@"SignUpSegue" sender:self];
        }
    }];
}

- (IBAction)clickTwitterSignUp:(id)sender {
    [HUD show:YES];
//    [PFTwitterUtils initialize];
//    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
//        if (!user) {
//            NSLog(@"The user cancelled the Twitter login.");
//            return;
//        } else {
//            _twitterUID = user.username;
//            FCSLoginProvider *login = [[FCSLoginProvider alloc] init];
//            [login loginWithTwitter:^(BOOL success) {
//                [HUD hide:YES];
//                if (!success) {
//                    [self activateTwitterSignUp:YES];
//                } else {
//                    [self performSegueWithIdentifier:@"SignUpSegue" sender:self];
//                }
//            }];
//        }
//    }];
}

- (void)goToRestuarantList {
    [self performSegueWithIdentifier:@"SignUpSegue" sender:nil];
}

@end
