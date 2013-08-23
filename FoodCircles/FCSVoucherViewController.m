//
//  FCSVoucherViewController.m
//  FoodCircles
//
//  Created by David Groulx on 5/10/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSVoucherViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface FCSVoucherViewController ()

@end

@implementation FCSVoucherViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
  
    self.receiptView.layer.shadowOpacity = 0.5f;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)accountButtonClicked:(id)sender {
    //[self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
    [self performSegueWithIdentifier:@"TimelineSegue" sender:self];
}
@end
