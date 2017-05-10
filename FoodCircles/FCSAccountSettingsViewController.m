//
//  FCSAccountSettingsViewController.m
//  FoodCircles
//
//  Created by David Groulx on 5/21/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSAccountSettingsViewController.h"
#import "FCSAccountSettingsChildViewController.h"

#import "FCSStyles.h"
#import "FCSAppDelegate.h"
#import "constants.h"

#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"
#import "JSONKit.h"
#import "SSKeychain.h"

#import "FCSServerHelper.h"

@interface FCSAccountSettingsViewController ()
@end

@implementation FCSAccountSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.view setBackgroundColor:[FCSStyles backgroundColor]];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    if (IS_OS_7_OR_LATER) self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)logoutButtonClicked:(id)sender {
    
    HUD.mode = MBProgressHUDModeIndeterminate;
    [HUD show:YES];
    [[FCSServerHelper sharedHelper] logoutWithCompletion:^{
        UIAppDelegate.user_token = @"";
        UIAppDelegate.user_email = @"";
        [SSKeychain deletePasswordForService:@"FoodCircles" account:@"FoodCirclesType"];
        [self.navigationController popToRootViewControllerAnimated:YES];
        [HUD hide:YES];
    }];
}

- (IBAction)saveUserData:(id)sender {
    NSURL *url = [NSURL URLWithString:UPDATE_URL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    FCSAccountSettingsChildViewController *child = [self.childViewControllers lastObject];
    
    NSDictionary *session = [NSDictionary dictionaryWithObjectsAndKeys:
                             child.emailTextField.text, @"email",
                             child.passwordTextField.text, @"password",
                             child.nameTextField.text, @"name",
                             nil];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            session, @"session",
                            UIAppDelegate.user_token, @"auth_token",
                            nil];
    
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"PUT" path:@"" parameters:params];

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"%@",JSON);
        
        [HUD setLabelText:@"User saved"];
        [HUD setMode:MBProgressHUDModeText];
        [HUD show:YES];
        [HUD hide:YES afterDelay:2];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSString *errorMessage = [JSON objectForKey:@"description"];
        
        if (errorMessage == nil) {
            errorMessage = @"Can't connect to server.";
        }
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Sign Up Error"
                                              message:errorMessage
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }];
    
    [operation start];
}

#pragma mark - Contact us buttons

- (IBAction)facebookPressed:(id)sender {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:@"http://facebook.com/foodcircles"];
    [application openURL:URL options:@{} completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Opened url");
        }
    }];
}
- (IBAction)twitterPressed:(id)sender {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:@"http://twitter.com/foodcircles"];
    [application openURL:URL options:@{} completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Opened url");
        }
    }];
}

- (IBAction)emailPressed:(id)sender {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:@"mailto:support@foodcircles.net"];
    [application openURL:URL options:@{} completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Opened url");
        }
    }];
}

@end
