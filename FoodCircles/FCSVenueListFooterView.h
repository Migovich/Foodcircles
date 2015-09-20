//
//  FCSVenueListFooterView.h
//  FoodCircles
//
//  Created by Bruno Guidolim on 9/20/15.
//  Copyright © 2015 FoodCircles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCSVenueListViewController.h"

@interface FCSVenueListFooterView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIButton *requestRestaurantButton;
@property (strong, nonatomic) FCSVenueListViewController *parentVC;

@end
