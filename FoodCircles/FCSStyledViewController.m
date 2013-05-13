//
//  FCSStyledViewController.m
//  FoodCircles
//
//  Created by David Groulx on 5/6/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSStyledViewController.h"
#import "FCSStyles.h"

@interface FCSStyledViewController ()

@end

@implementation FCSStyledViewController


- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [FCSStyles backgroundColor];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
