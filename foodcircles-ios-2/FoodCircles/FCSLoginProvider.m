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
#import "SSKeychain.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>

typedef enum {
    FacebookErrorCodeNone,
    FacebookErrorCodeUnknown,
    FacebookErrorCodeNoAccountExists,
} FacebookErrorCode;

@implementation FCSLoginProvider

- (void)authenticateToServerWithUrl: (NSString*)urlString uid:(NSString*)uid email:(NSString*)email withCompletion:(void(^)(id JSON, NSString *error, FacebookErrorCode errorCode))handler {
    
    NSURL *url = [NSURL URLWithString:urlString];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    NSDictionary *params = @{
                             @"user_email": email,
                             @"uid": uid
                             };
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"" parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        handler(JSON, nil, 0);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        //Old logic that I don't understand
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
        if (emailErrorMessage == nil && passwordErrorMessage == nil) {
            errorMessage = @"Can't connect to server.";
        }
        
        //if user account doesn't exist. wrapping in try catch block because I'm not sure this is future proof
        BOOL userAcountExists = YES;
        @try {
            id errorDescription = error.userInfo[@"NSLocalizedRecoverySuggestion"];
            userAcountExists = !([errorDescription rangeOfString:@"Wrong uid."].location != NSNotFound);
        }
        @catch (NSException *exception) {
            
        }
        if (!userAcountExists) {
            handler(nil, errorMessage, FacebookErrorCodeNoAccountExists);
        }
        else {
            handler(nil, errorMessage, FacebookErrorCodeUnknown);
        }
        
    }];
    [operation start];
}

- (void) loginWithFacebook:(void(^)(BOOL))handler {
    _completionHandler = [handler copy];
    
    NSArray *permissionsArray = @[@"user_about_me", @"email"];
    
    [PFFacebookUtils  logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (!user) {
            #warning set messages
            if (error) {
                NSLog(@"An error occurred: %@", error);
            }
            _completionHandler(NO);
        } else {
            
            FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":@"id,name,email"}];
            [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                if (error) {
                    NSLog(@"%@", error.localizedDescription);
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sign Up Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    
                    [alert show];
                    handler(NO);
                }
                else {
                    NSDictionary *userData = (NSDictionary *)result;
                    NSString *email = userData[@"email"];
                    [self authenticateToServerWithUrl:SIGN_IN_URL uid:user.username email:email withCompletion:^(id JSON, NSString *error, FacebookErrorCode errorCode) {
                        if (errorCode == FacebookErrorCodeNone) {
                            UIAppDelegate.user_email = email;
                            UIAppDelegate.user_token = [JSON valueForKeyPath:@"auth_token"];
                            UIAppDelegate.user_uid = user.username;
                            
                            [SSKeychain setPassword:@"Facebook" forService:@"FoodCircles" account:@"FoodCirclesType"];
                            [SSKeychain setPassword:user.username forService:@"FoodCircles" account:@"FoodCirclesFacebookUID"];
                            [SSKeychain setPassword:email forService:@"FoodCircles" account:@"FoodCirclesEmail"];
                            
                            handler(YES);
                        }
                        else if (errorCode == FacebookErrorCodeNoAccountExists) {
                            [self authenticateToServerWithUrl:SIGN_UP_URL uid:user.username email:email withCompletion:^(id JSON, NSString *error, FacebookErrorCode errorCode) {
                                if (error) {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sign Up Error" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                    [alert show];
                                    handler(NO);
                                }
                                else {
                                    UIAppDelegate.user_email = email;
                                    UIAppDelegate.user_token = [JSON valueForKeyPath:@"auth_token"];
                                    UIAppDelegate.user_uid = user.username;
                                    
                                    [SSKeychain setPassword:@"Facebook" forService:@"FoodCircles" account:@"FoodCirclesType"];
                                    [SSKeychain setPassword:user.username forService:@"FoodCircles" account:@"FoodCirclesFacebookUID"];
                                    [SSKeychain setPassword:email forService:@"FoodCircles" account:@"FoodCirclesEmail"];
                                    handler(YES);
                                }
                            }];
                        }
                    }];
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
                                                                                                    UIAppDelegate.user_uid = user.username;
                                                                                                    
                                                                                                    [SSKeychain setPassword:@"Twitter" forService:@"FoodCircles" account:@"FoodCirclesType"];
                                                                                                    [SSKeychain setPassword:user.username forService:@"FoodCircles" account:@"FoodCirclesTwitterUID"];
                                                                                                    
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

-(void)loginWithParams:(NSDictionary *)params :(void (^)(BOOL))handler {
    _completionHandler = [handler copy];
    
    NSURL *url = [NSURL URLWithString:SIGN_IN_URL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"" parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
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

-(void)savedLoginWithView:(UIViewController *)view segue:(NSString *)segue hud:(MBProgressHUD *)hud {
    NSString *typeLogin = [SSKeychain passwordForService:@"FoodCircles" account:@"FoodCirclesType"];
    if (typeLogin != nil) {
        [hud show:YES];
        NSDictionary *params;
        
        if ([typeLogin isEqualToString:@"Email"]) {
            params = [NSDictionary dictionaryWithObjectsAndKeys:
                      [SSKeychain passwordForService:@"FoodCircles" account:@"FoodCirclesEmail"], @"user_email",
                      [SSKeychain passwordForService:@"FoodCircles" account:@"FoodCirclesPassword"], @"user_password",
                      nil];
        } else if ([typeLogin isEqualToString:@"Facebook"]) {
            params = [NSDictionary dictionaryWithObjectsAndKeys:
                      [SSKeychain passwordForService:@"FoodCircles" account:@"FoodCirclesFacebookUID"], @"uid",
                      [SSKeychain passwordForService:@"FoodCircles" account:@"FoodCirclesEmail"], @"user_password",
                      nil];
        } else if ([typeLogin isEqualToString:@"Twitter"]) {
            params = [NSDictionary dictionaryWithObjectsAndKeys:
                      [SSKeychain passwordForService:@"FoodCircles" account:@"FoodCirclesTwitterUID"], @"uid",
                      nil];
        }
        
        //FCSLoginProvider *login = [[FCSLoginProvider alloc] init];
        [self loginWithParams:params :^(BOOL success) {
            [hud hide:YES];
            if (success) {
                if ([typeLogin isEqualToString:@"Facebook"] || [typeLogin isEqualToString:@"Twitter"]) {
                    UIAppDelegate.user_uid = [params objectForKey:@"uid"];
                } else {
                    UIAppDelegate.user_uid = [params objectForKey:@"user_email"];
                }
                [view performSegueWithIdentifier:segue sender:self];
            }
        }];
    }
}

@end
