//
//  FCSAccountSettingsChildViewController.m
//  FoodCircles
//
//  Created by Bruno Guidolim on 8/24/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSAccountSettingsChildViewController.h"
#import "FCSStyles.h"
#import "FCSAppDelegate.h"

@interface FCSAccountSettingsChildViewController ()

@end

@implementation FCSAccountSettingsChildViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _emailTextField.text = UIAppDelegate.user_email;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
