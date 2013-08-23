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
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subtitle;

-(id)initWithVenueIndex:(NSInteger)venueIndex;

@end
