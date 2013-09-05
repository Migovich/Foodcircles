//
//  FCSLandingPageViewController.m
//  FoodCircles
//
//  Created by David Groulx on 5/12/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSLandingPageViewController.h"
#import "FCSShareProviders.h"
#import "constants.h"


@interface FCSLandingPageViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareThisMissionLabelYConstraint;
@property (weak, nonatomic) IBOutlet UILabel *youCanFeedLabel;

@end


@implementation FCSLandingPageViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareButtonTapped)];
    tap.numberOfTapsRequired = 1;
    tap.enabled = YES;
    _shareButton.userInteractionEnabled = YES;
    [_shareButton addGestureRecognizer:tap];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"You can feed a child but your\nnetwork can feed a classrom" attributes:@{
                                                         NSForegroundColorAttributeName: [UIColor whiteColor]
                                       }];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:1];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [text addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    self.youCanFeedLabel.attributedText = text;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"%@",segue.identifier);
    if ([segue.identifier isEqualToString:@"showVenueList"]) {
        NSLog(@"VenueList");
    } else {
        NSLog(@"Timeline");
    }
}

- (IBAction)swipeRecognized:(id)sender {
    NSLog(@"swipe is a go");
}

#pragma mark - Custom Methods
-(void)shareButtonTapped {
    FCSShareProviders *shareProviders = [[FCSShareProviders alloc] init];
    shareProviders.type = 1;
    NSURL *shareUrl = [NSURL URLWithString:@"http://joinfoodcircles.org/#app"];
    
    NSArray *itemsToShare = @[shareProviders,shareUrl];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeMail, UIActivityTypeMessage, UIActivityTypePostToWeibo];
    
    [self presentViewController:activityVC animated:YES completion:nil];
}

@end
