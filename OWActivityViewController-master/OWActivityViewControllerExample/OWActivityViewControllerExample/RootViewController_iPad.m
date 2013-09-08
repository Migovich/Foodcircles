//
//  RootViewController_iPad.m
//  OWActivityViewControllerExample
//
//  Created by Roman Efimov on 1/24/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "RootViewController_iPad.h"
#import "OWActivityViewController.h"

@implementation RootViewController_iPad

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(buttonPressed)];
	self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)buttonPressed
{    
    if (_activityPopoverController && _activityPopoverController.isPopoverVisible) {
        [_activityPopoverController dismissPopoverAnimated:YES];
        _activityPopoverController =  nil;
        return;
    }
    
    // Prepare activities
    //
    OWFacebookActivity *facebookActivity = [[OWFacebookActivity alloc] init];
    OWTwitterActivity *twitterActivity = [[OWTwitterActivity alloc] init];
    OWSinaWeiboActivity *sinaWeiboActivity = [[OWSinaWeiboActivity alloc] init];
    OWMessageActivity *messageActivity = [[OWMessageActivity alloc] init];
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
    NSArray *activities = nil;
    if( NSClassFromString (@"UIActivityViewController") ) {
        // ios 6
        activities = @[facebookActivity, twitterActivity, sinaWeiboActivity,
                       messageActivity, mailActivity, safariActivity,
                       saveToCameraRollActivity, mapsActivity, printActivity,
                       copyActivity, customActivity];
    } else {
        // ios 5
        activities = @[twitterActivity,
                       messageActivity, mailActivity, safariActivity,
                       saveToCameraRollActivity, mapsActivity, printActivity,
                       copyActivity, customActivity];
    }
    // Create OWActivityViewController controller and assign data source
    //
    OWActivityViewController *activityViewController = [[OWActivityViewController alloc] initWithViewController:self activities:activities];
    activityViewController.userInfo = @{
                                        @"image": [UIImage imageNamed:@"Flower.jpg"],
                                        @"text": @"Hello world!",
                                        @"url": [NSURL URLWithString:@"https://github.com/romaonthego/OWActivityViewController"],
                                        @"coordinate": @{@"latitude": @(37.751586275), @"longitude": @(-122.447721511)}
                                        };
    
    // Present it from UIPopoverController
    //
    _activityPopoverController = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
    activityViewController.presentingPopoverController = _activityPopoverController;
    [_activityPopoverController presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem
                                       permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark -
#pragma mark Orientation

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

@end
