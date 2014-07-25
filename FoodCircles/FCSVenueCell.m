//
//  FCSVenueCell.m
//  FoodCircles
//
//  Created by David Groulx on 5/10/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSVenueCell.h"
#import "UIImageView+AFNetworking.h"

@interface FCSVenueCell ()

@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *detailTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *qtyLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *milesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tagImageView;
@property (weak, nonatomic) IBOutlet UILabel *soldOutLabel;
@property (weak, nonatomic) IBOutlet UIView *contentViewCell;

@end

@implementation FCSVenueCell

- (void)layoutSubviews {
    self.productName.text = [[self.venue objectForKey:@"name"] uppercaseString];
    [self.productImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,[self.venue objectForKey:@"timeline_image"]]] placeholderImage:[UIImage imageNamed:@"transparent_box.png"]];
    [self.productImage setClipsToBounds:YES];
    
    NSArray *tags = [NSArray arrayWithArray:[self.venue objectForKey:@"tags"]];
    if (tags.count > 0) {
        self.detailTextLabel.text = [[tags objectAtIndex:0] objectForKey:@"name"];
    } else {
        self.detailTextLabel.text = @"";
    }
    
    NSString *miles = [self.venue objectForKey:@"distance"];
    [self.milesLabel setText:miles];
    
    int leftTag = [[self.venue objectForKey:@"vouchers_available"] integerValue];
    [self.qtyLeftLabel setText:[NSString stringWithFormat:@"%d",leftTag]];
    
    
    if (leftTag == 0) {
        [self.tagImageView setImage:[UIImage imageNamed:@"tag-grey.png"]];
        [self setUserInteractionEnabled:NO];
        [self.soldOutLabel setHidden:NO];
    } else {
        [self setUserInteractionEnabled:YES];
        [self.soldOutLabel setHidden:YES];
        
        switch (leftTag) {
            case 1:
                [self.tagImageView setImage:[UIImage imageNamed:@"tag-red.png"]];
                break;
                
            case 2:
                [self.tagImageView setImage:[UIImage imageNamed:@"tag-yellow.png"]];
                break;
                
            default:
                [self.tagImageView setImage:[UIImage imageNamed:@"tag-green.png"]];
                break;
        }
    }
    
    self.contentViewCell.layer.shadowOpacity = 0.1f;
    self.contentViewCell.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    self.contentViewCell.layer.masksToBounds = NO;
}

- (void)setVenue:(NSDictionary *)venue {
    _venue = venue;
    [self layoutSubviews];
}

@end
