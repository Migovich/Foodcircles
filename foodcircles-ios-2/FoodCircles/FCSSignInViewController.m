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
#import "FCSLoginProvider.h"
#import "SSKeychain.h"

#import <Parse/Parse.h>

#import "FCSSignInViewController.h"

@interface FCSSignInViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *forgotPasswordButtonConstraintY;
@property (weak, nonatomic) IBOutlet UILabel *buyOneFeedOneLabel;
@end

@implementation FCSSignInViewController

@synthesize emailTextField;
@synthesize passwordTextField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    UIFont *font = [UIFont fontWithName:@"NeutrafaceSlabText-Bold" size:17];
    self.buyOneFeedOneLabel.font = font;
}
- (IBAction)forgotYourPasswordPressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.joinfoodcircles.org/users/password/new"]];
}

- (IBAction)clickSignIn:(id)sender {
    [HUD show:YES];
    NSURL *url = [NSURL URLWithString:SIGN_IN_URL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.emailTextField.text, @"user_email",
                            self.passwordTextField.text, @"user_password",
                            nil];
    
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"" parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [HUD hide:YES];
        UIAppDelegate.user_email = self.emailTextField.text;
        UIAppDelegate.user_token = [JSON valueForKeyPath:@"auth_token"];
        UIAppDelegate.user_uid = self.emailTextField.text;
        
        [SSKeychain setPassword:@"Email" forService:@"FoodCircles" account:@"FoodCirclesType"];
        [SSKeychain setPassword: self.emailTextField.text forService:@"FoodCircles" account:@"FoodCirclesEmail"];
        [SSKeychain setPassword: self.passwordTextField.text forService:@"FoodCircles" account:@"FoodCirclesPassword"];
        
        [self performSegueWithIdentifier:@"SignInSegue" sender:self];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [HUD hide:YES];
        NSString *errorMessage = [JSON valueForKeyPath:@"description"];
        
        if(errorMessage == nil)
        {
            errorMessage = @"Can't connect to server.";
            errorMessage = error.localizedDescription;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sign In Error"
                                                        message:errorMessage
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        NSLog(@"%@", errorMessage);
        [alert show];
        
    }];
    
    [operation start];
    
}

- (IBAction)clickFacebookSignIn:(id)sender {
    [HUD show:YES];
    FCSLoginProvider *login = [[FCSLoginProvider alloc] init];
    [login loginWithFacebook:^(BOOL success) {
        [HUD hide:YES];
        if (success) {
            [self performSegueWithIdentifier:@"SignInSegue" sender:self];
        }
    }];
}

- (IBAction)clickTwitterSignIn:(id)sender {
    [HUD show:YES];
    FCSLoginProvider *login = [[FCSLoginProvider alloc] init];
    [login loginWithTwitter:^(BOOL success) {
        [HUD hide:YES];
        if (success) {
            [self performSegueWithIdentifier:@"SignInSegue" sender:self];
        }
    }];
}


- (void)updateViewConstraints {
    [super updateViewConstraints];
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if (!(screenSize.height > 480.0f)) {
        self.forgotPasswordButtonConstraintY.constant = 392;
    }
}

@end
