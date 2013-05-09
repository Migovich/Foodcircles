//
//  FCSStyledViewController.m
//  FoodCircles
//
//  Created by David Groulx on 5/6/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSStyledViewController.h"

@interface FCSStyledViewController ()

@end

@implementation FCSStyledViewController

@synthesize buttonImage;


- (id)initWithCoder:(NSCoder *)aDecoder {
  
  self = [super initWithCoder:aDecoder];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.buttonImage = [[UIImage imageNamed:@"orangeButton.png"]
                      resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
