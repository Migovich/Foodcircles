//
//  FCSLoginProvider.m
//  FoodCircles
//
//  Created by Bruno Guidolim on 8/19/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSLoginProvider.h"
#import "constants.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"
#import "FCSAppDelegate.h"

@implementation FCSLoginProvider

- (void) loginWithFacebook:(void(^)(BOOL))handler {
    _completionHandler = [handler copy];
    
    NSArray *permissionsArray = @[@"user_about_me"];
    
    [PFFacebookUtils initializeFacebook];
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (!user) {
            #warning set messages
            if (!error) {
                NSLog(@"The user cancelled the Facebook login.");
            } else {
                NSLog(@"An error occurred: %@", error);
            }
        } else {
            NSLog(@"User with facebook signed up and logged in!");
            
            FBRequest *request = [FBRequest requestForMe];
            
            [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    NSDictionary *userData = (NSDictionary *)result;
                    NSString *email = userData[@"email"];
                    
                    NSURL *url = [NSURL URLWithString:SIGN_IN_URL];
                    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
                    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
                    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                            email, @"user_email",
                                            user.username, @"uid",
                                            nil];
                    
                    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"" parameters:params];
                    
                    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                                            UIAppDelegate.user_email = email;
                                                                                                            UIAppDelegate.user_token = [JSON valueForKeyPath:@"auth_token"];

                                                                                                            _completionHandler(YES);
                                                                                                            
                                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {

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
                                                                                                            
                                                                                                            _completionHandler(NO);
                                                                                                        }];
                    
                    [operation start];
                }
            }];
        }
    }];
}

- (void) loginWithTwitter:(void(^)(BOOL))handler {
    _completionHandler = [handler copy];
    
    [PFTwitterUtils initialize];
    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"The user cancelled the Twitter login.");
            return;
        } else {
            NSLog(@"User logged in with Twitter!");
            NSURL *url = [NSURL URLWithString:SIGN_IN_URL];
            AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
            [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    user.username, @"uid",
                                    nil];
            
            NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"" parameters:params];
            
            AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                                    UIAppDelegate.user_token = [JSON valueForKeyPath:@"auth_token"];
                                                                                                    
                                                                                                    _completionHandler(YES);
                                                                                                    
                                                                                                } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {

                                                                                                    NSString *errorMessage = [JSON objectForKey:@"description"];
                                                                                                    
                                                                                                    if (errorMessage == nil) {
                                                                                                        errorMessage = @"Can't connect to server.";
                                                                                                        
                                                                                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sign In Error"
                                                                                                                                                        message:errorMessage
                                                                                                                                                       delegate:nil
                                                                                                                                              cancelButtonTitle:@"OK"
                                                                                                                                              otherButtonTitles:nil];
                                                                                                        [alert show];
                                                                                                    }

                                                                                                    _completionHandler(NO);
                                                                                                }];
            
            [operation start];

        }
    }];
}

@end
