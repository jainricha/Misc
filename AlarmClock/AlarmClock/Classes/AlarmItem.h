//
//  AlarmItem.h
//  AlarmClock
//
//  Created by Richa on 23/04/14.
//  Copyright (c) 2014 Richa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlarmItem : NSObject
@property(nonatomic,retain)NSString *datetime;
@property(nonatomic,retain)NSString *day;
@property BOOL isActive;
@property int recid;
-(NSString*)dayString;
-(NSString*)getDateTime;
@end
