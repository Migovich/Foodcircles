//
//  FCSCharity.m
//  FoodCircles
//
//  Created by Bruno Guidolim on 8/20/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSCharity.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "constants.h"
#import "FCSAppDelegate.h"
#import "JSONKit.h"

@implementation FCSCharity

-(void)getCharities {
    NSURL *url = [NSURL URLWithString:CHARITIES_URL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:@"" parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                                NSLog(@"%@",[JSON JSONString]);
                                                                                            UIAppDelegate.charities = [JSON objectForKey:@"content"];

                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
    
                                                                                            //NSLog(@"Error: %@", error.localizedDescription);
                                                                                            NSString *errorMessage = [error localizedDescription];
                                                                                            
//                                                                                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                                                                                                            message:errorMessage
//                                                                                                                                           delegate:nil
//                                                                                                                                  cancelButtonTitle:@"OK"
//                                                                                                                                  otherButtonTitles:nil];
//                                                                                           
//                                                                                            [alert show];
                                                                                
                                                                                
                                                                                            UIAlertController *alertController = [UIAlertController
                                                                                                                                  alertControllerWithTitle:@"Error"
                                                                                                                                  message:errorMessage
                                                                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                                                                                            
                                                                                            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                                                                                            
                                                                                            UINavigationController *navigationController = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                                                                                            
                                                                                            UICollectionViewController *collectionView = (UICollectionViewController *)[navigationController visibleViewController];
                                                                                            
                                                                                            [collectionView presentViewController:alertController animated:YES completion:nil];
            
                                                                                        }];
    
    [operation start];
}

@end
