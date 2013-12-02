//
//  FCSVenueAnnotation.h
//  FoodCircles
//
//  Created by David Groulx on 5/22/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface FCSVenueAnnotation : NSObject
<MKAnnotation>

@property (readonly, nonatomic) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;

-(id)initWithVenueIndex:(NSInteger)venueIndex;

@end
