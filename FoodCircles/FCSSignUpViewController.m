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
#import "MBProgressHUD.h"
#import <Parse/Parse.h>
#import "FCSLoginProvider.h"

@interface FCSSignUpViewController ()

@end

@implementation FCSSignUpViewController

@synthesize emailTextField;
@synthesize passwordTextField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    NSURL *url = [NSURL URLWithString:USER_COUNT_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                            self.countLabel.text = [NSString stringWithFormat:@"%@%@", [JSON valueForKeyPath:@"content"], @" people repurpose their everyday dining."];
                                            [self.countLabel boldSubstring: [NSString stringWithFormat:@"%@",[JSON valueForKeyPath:@"content"]]];
                                            self.countCopyLabel.text = @"Today, it's your turn.";
                                        } failure:nil];
    [operation start];
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
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                            [HUD hide:YES];
                                            UIAppDelegate.user_email = self.emailTextField.text;
                                            UIAppDelegate.user_token = [JSON valueForKeyPath:@"auth_token"];
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
    [PFTwitterUtils initialize];
    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
        #warning set messages
        if (!user) {
            NSLog(@"The user cancelled the Twitter login.");
            return;
        } else {
            NSLog(@"User logged in with Twitter!");
            _twitterUID = user.username;
            [self activateTwitterSignUp:YES];
        }
    }];
}

@end
