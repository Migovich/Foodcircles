//
//  RootViewController.m
//  OWActivityViewControllerExample
//
//  Created by Roman Efimov on 1/24/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "RootViewController.h"
#import "OWActivityViewController.h"

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(20, 20, 280, 44);
    [button setTitle:@"Show OWActivityViewController" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonPressed
{
    // Prepare activities
    //
    OWTwitterActivity *twitterActivity = [[OWTwitterActivity alloc] init];
    OWMailActivity *mailActivity = [[OWMailActivity alloc] init];
    OWSafariActivity *safariActivity = [[OWSafariActivity alloc] init];
    OWSaveToCameraRollActivity *saveToCameraRollActivity = [[OWSaveToCameraRollActivity alloc] init];
    OWMapsActivity *mapsActivity = [[OWMapsActivity alloc] init];
    OWPrintActivity *printActivity = [[OWPrintActivity alloc] init];
    OWCopyActivity *copyActivity = [[OWCopyActivity alloc] init];
    
    // Create some custom activity
    //
    OWActivity *customActivity = [[OWActivity alloc] initWithTitle:@"Custom"
                                                             image:[UIImage imageNamed:@"OWActivityViewController.bundle/Icon_Custom"]
                                                       actionBlock:^(OWActivity *activity, OWActivityViewController *activityViewController) {
                                                           [activityViewController dismissViewControllerAnimated:YES completion:^{
                                                               NSLog(@"Info: %@", activityViewController.userInfo);
                                                           }];
                                                       }];
    
    // Compile activities into an array, we will pass that array to
    // OWActivityViewController on the next step
    //
    
    NSMutableArray *activities = [NSMutableArray arrayWithObject:mailActivity];
    
    // For some device may not support message (ie, Simulator and iPod Touch).
    // There is a bug in the Simulator when you configured iMessage under OS X,
    // for detailed information, refer to: http://stackoverflow.com/questions/9349381/mfmessagecomposeviewcontroller-on-simulator-cansendtext
    if ([MFMessageComposeViewController canSendText]) {
        OWMessageActivity *messageActivity = [[OWMessageActivity alloc] init];
        [activities addObject:messageActivity];
    }
    
    [activities addObjectsFromArray:@[saveToCameraRollActivity, twitterActivity]];
    
    if( NSClassFromString (@"UIActivityViewController") ) {
        // ios 6, add facebook and sina weibo activities
        OWFacebookActivity *facebookActivity = [[OWFacebookActivity alloc] init];
        OWSinaWeiboActivity *sinaWeiboActivity = [[OWSinaWeiboActivity alloc] init];
        [activities addObjectsFromArray:@[
         facebookActivity, sinaWeiboActivity
         ]];
    }
    
    [activities addObjectsFromArray:@[
     safariActivity, mapsActivity, printActivity, copyActivity, customActivity]];
    
    // Create OWActivityViewController controller and assign data source
    //
    OWActivityViewController *activityViewController = [[OWActivityViewController alloc] initWithViewController:self activities:activities];
    activityViewController.userInfo = @{
                                        @"image": [UIImage imageNamed:@"Flower.jpg"],
                                        @"text": @"Hello world!",
                                        @"url": [NSURL URLWithString:@"https://github.com/romaonthego/OWActivityViewController"],
                                        @"coordinate": @{@"latitude": @(37.751586275), @"longitude": @(-122.447721511)}
                                        };
    
    [activityViewController presentFromRootViewController];
}

#pragma mark -
#pragma mark Orientation

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return (orientation == UIInterfaceOrientationPortrait);
}

@end
