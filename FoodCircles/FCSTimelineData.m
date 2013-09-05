//
//  FCSTimelineData.m
//  FoodCircles
//
//  Created by Bruno Guidolim on 8/22/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSTimelineData.h"

@implementation FCSTimelineData

-(NSArray *)processJSON:(id)JSON {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    int total = 0;
    
    for (int i = 0; i < [[JSON objectForKey:@"reservations"] count]; i++) {
        FCSTimelineData *data = [[FCSTimelineData alloc] init];
        data.type = 2;
        NSDictionary *row = [[JSON objectForKey:@"reservations"] objectAtIndex:i];
        
        NSString *dateStr = [[row objectForKey:@"date_purchased"] substringToIndex:10];
        NSDate *date = [formatter dateFromString:dateStr];
        
        data.date = date;
        data.restaurantName = [[row objectForKey:@"venue"] objectForKey:@"name"];
        data.offerName = [[row objectForKey:@"offer"] objectForKey:@"title"];
        data.code = @"";
        
        int qty = [[[row objectForKey:@"offer"] objectForKey:@"minimum_diners"] integerValue];
        qty = qty/2;
        
        data.qtyFed = qty;
        total += qty;
        
        [array addObject:data];
    }
    
    for (int i = 0; i < [[JSON objectForKey:@"payments"] count]; i++) {
        FCSTimelineData *data = [[FCSTimelineData alloc] init];
        data.type = 2;
        NSDictionary *row = [[JSON objectForKey:@"payments"] objectAtIndex:i];
        
        NSString *dateStr = [[row objectForKey:@"date_purchased"] substringToIndex:10];
        NSDate *date = [formatter dateFromString:dateStr];
        
        data.date = date;
        data.restaurantName = [[[[[row objectForKey:@"offer"] objectAtIndex:0] objectForKey:@"venue"] objectAtIndex:0] objectForKey:@"name"];
        data.offerName = [[[row objectForKey:@"offer"] objectAtIndex:0] objectForKey:@"name"];
        data.code = [row objectForKey:@"code"];
        
        int qty = [[row objectForKey:@"amount"] integerValue];
        data.qtyFed = qty;
        total += qty;
        
        [array addObject:data];
    }
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    [array sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    FCSTimelineData *data = [[FCSTimelineData alloc] init];
    data.type = 0;
    data.total = total;
    [returnArray addObject:data];
    
    data = [array objectAtIndex:1];

    NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:data.date];
   
    [formatter setDateFormat:@"yyyy"];
    
    int monthDif = [comps month];
    int month = 0;
    
    for (int i = 0; i < [array count]; i++) {
        data = [array objectAtIndex:i];
        
        comps = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:data.date];
        month = [comps month];

        if (monthDif != month) {
            
            FCSTimelineData *newData = [[FCSTimelineData alloc] init];
            newData.type = 1;
            newData.year = [NSString stringWithFormat:@"%d", [comps year]];
            
            [formatter setDateFormat:@"MMMM"];
            newData.month = [[formatter stringFromDate:data.date] uppercaseString];
            
            [returnArray addObject:newData];
            
            monthDif = month;
        }
        
        [returnArray addObject:data];
    }
    
    return returnArray;
}

@end
