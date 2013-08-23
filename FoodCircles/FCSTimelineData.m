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
    
    FCSTimelineData *data = [[FCSTimelineData alloc] init];
    data.type = 0;
    
    [array addObject:data];
    
    int monthDif = [[[[[JSON objectForKey:@"reservations"] objectAtIndex:0] objectForKey:@"date_purchased"] substringWithRange:NSMakeRange(5, 2)] integerValue];;
    int month = 0;
    
    for (int i = 0; i < [[JSON objectForKey:@"reservations"] count]; i++) {
        month = [[[[[JSON objectForKey:@"reservations"] objectAtIndex:i] objectForKey:@"date_purchased"] substringWithRange:NSMakeRange(5, 2)] integerValue];
        if (monthDif != month) {
            
            FCSTimelineData *data = [[FCSTimelineData alloc] init];
            data.type = 1;
            data.year = [[[[JSON objectForKey:@"reservations"] objectAtIndex:i] objectForKey:@"date_purchased"] substringWithRange:NSMakeRange(0, 4)];
            
            NSString *dateStr = [[[[JSON objectForKey:@"reservations"] objectAtIndex:i] objectForKey:@"date_purchased"] substringToIndex:10];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *date = [formatter dateFromString:dateStr];
            [formatter setDateFormat:@"MMMM"];
            
            data.month = [formatter stringFromDate:date];
            
            [array addObject:data];
            
            monthDif = month;
        }
        
        FCSTimelineData *data = [[FCSTimelineData alloc] init];
        data.type = 2;
        data.data = [[JSON objectForKey:@"reservations"] objectAtIndex:i];
        
        [array addObject:data];
    }

    return array;
}

@end
