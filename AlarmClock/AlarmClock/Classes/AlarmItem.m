//
//  AlarmItem.m
//  AlarmClock
//
//  Created by Richa on 23/04/14.
//  Copyright (c) 2014 Richa. All rights reserved.
//

#import "AlarmItem.h"
#import "DBManager.h"

@implementation AlarmItem
@synthesize datetime;
@synthesize day;
@synthesize isActive;
@synthesize recid;
-(NSString*)dayString
{
    NSString *dString=[day lowercaseString];
    if([dString isEqualToString:@"mon"])
    {
        return  @"Monday";
    }
    else if([dString isEqualToString:@"tue"])
    {
        return  @"Tuesday";
    }
    else if([dString isEqualToString:@"wed"])
    {
        return  @"Wednesday";
    }
    else if([dString isEqualToString:@"thu"])
    {
        return  @"Thursday";
    }
    else if([dString isEqualToString:@"fri"])
    {
        return  @"Friday";
    }
    else if([dString isEqualToString:@"sat"])
    {
        return  @"Saturday";
    }
    else if([dString isEqualToString:@"sun"])
    {
        return  @"Sunday";
    }
    return dString;
}
-(NSString*)getDateTime
{
    return [[DBManager sharedManager]fetchAlarmTime:recid];
    
}
@end
