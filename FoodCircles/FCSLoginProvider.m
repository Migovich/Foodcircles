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
#import <TwitterKit/TwitterKit.h>

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
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends"]
     //fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
             
             [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"email,name"}]
              startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                  if (!error) {
                      NSLog(@"fetched user:%@  and Email : %@", result[@"id"],result[@"email"]);
                      
                      NSDictionary *userData = (NSDictionary *)result;
                      NSString *email = userData[@"email"];
                      NSString *user = userData[@"id"];
                      [self authenticateToServerWithUrl:SIGN_IN_URL uid:user email:email withCompletion:^(id JSON, NSString *error, FacebookErrorCode errorCode) {
                          if (errorCode == FacebookErrorCodeNone) {
                              UIAppDelegate.user_email = email;
                              UIAppDelegate.user_token = [JSON valueForKeyPath:@"auth_token"];
                              UIAppDelegate.user_uid = user;
                              
                              [SSKeychain setPassword:@"Facebook" forService:@"FoodCircles" account:@"FoodCirclesType"];
                              [SSKeychain setPassword:user forService:@"FoodCircles" account:@"FoodCirclesFacebookUID"];
                              [SSKeychain setPassword:email forService:@"FoodCircles" account:@"FoodCirclesEmail"];
                              
                              handler(YES);
                          }
                          else if (errorCode == FacebookErrorCodeNoAccountExists) {
                              [self authenticateToServerWithUrl:SIGN_UP_URL uid:user email:email withCompletion:^(id JSON, NSString *error, FacebookErrorCode errorCode) {
                                  if (error) {
//                                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sign Up Error" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                                      [alert show];
                                      UIAlertController * alert=   [UIAlertController
                                                                    alertControllerWithTitle:@"Sign Up Error"
                                                                    message:error
                                                                    preferredStyle:UIAlertControllerStyleAlert];
                                      
                                      UIAlertAction* ok = [UIAlertAction
                                                           actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action)
                                                           {
                                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                                               
                                                           }];
                                      [alert addAction:ok];
                                      
                                      UINavigationController *navigationController = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                                      
                                      UICollectionViewController *collectionView = (UICollectionViewController *)[navigationController visibleViewController];
                                      
                                      [collectionView presentViewController:alert animated:YES completion:nil];
                                      handler(NO);
                                  }
                                  else {
                                      UIAppDelegate.user_email = email;
                                      UIAppDelegate.user_token = [JSON valueForKeyPath:@"auth_token"];
                                      UIAppDelegate.user_uid = user;
                                      
                                      [SSKeychain setPassword:@"Facebook" forService:@"FoodCircles" account:@"FoodCirclesType"];
                                      [SSKeychain setPassword:user forService:@"FoodCircles" account:@"FoodCirclesFacebookUID"];
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
    
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
            NSLog(@"signed in as %@", [session userName]);
            NSURL *url = [NSURL URLWithString:SIGN_IN_URL];
            AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
            [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    session.userID, @"uid",
                                    nil];
            
            NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"" parameters:params];
            
            AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                                    UIAppDelegate.user_token = [JSON valueForKeyPath:@"auth_token"];
                                                                                                    UIAppDelegate.user_uid = session.userID;
                                                                                                    
                                                                                                    [SSKeychain setPassword:@"Twitter" forService:@"FoodCircles" account:@"FoodCirclesType"];
                                                                                                    [SSKeychain setPassword:session.userID forService:@"FoodCircles" account:@"FoodCirclesTwitterUID"];
                                                                                                    
                                                                                                    _completionHandler(YES);
                                                                                                    
                                                                                                } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                                    
                                                                                                    NSString *errorMessage = [JSON objectForKey:@"description"];
                                                                                                    
                                                                                                    if (errorMessage == nil) {
                                                                                                        errorMessage = @"Can't connect to server.";
                                                                                                        
//                                                                                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sign In Error"
//                                                                                                                                                        message:errorMessage
//                                                                                                                                                       delegate:nil
//                                                                                                                                              cancelButtonTitle:@"OK"
//                                                                                                                                              otherButtonTitles:nil];
//                                                                                                        [alert show];
                                                                                                        
                                                                                                        UIAlertController * alert=   [UIAlertController
                                                                                                                                      alertControllerWithTitle:@"Sign In Error"
                                                                                                                                      message:errorMessage
                                                                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                                                                                                        
                                                                                                        UIAlertAction* ok = [UIAlertAction
                                                                                                                             actionWithTitle:@"OK"
                                                                                                                             style:UIAlertActionStyleDefault
                                                                                                                             handler:^(UIAlertAction * action)
                                                                                                                             {
                                                                                                                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                                                                                                                 
                                                                                                                             }];
                                                                                                        [alert addAction:ok];
                                                                                                        
                                                                                                        UINavigationController *navigationController = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                                                                                                        
                                                                                                        UICollectionViewController *collectionView = (UICollectionViewController *)[navigationController visibleViewController];
                                                                                                        
                                                                                                        [collectionView presentViewController:alert animated:YES completion:nil];                              }
                                                                                        
                                                                                                    _completionHandler(NO);
                                                                                                }];
            
            [operation start];
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
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
            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sign In Error"
//                                                            message:errorMessage
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil];
//            [alert show];
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Sign Up Error"
                                          message:errorMessage
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
            [alert addAction:ok];
            
            UINavigationController *navigationController = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            
            UICollectionViewController *collectionView = (UICollectionViewController *)[navigationController visibleViewController];
            
            [collectionView presentViewController:alert animated:YES completion:nil];
            
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
