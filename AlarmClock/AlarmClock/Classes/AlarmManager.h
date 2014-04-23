//
//  AlarmManager.h
//  AlarmClock
//
//  Created by Richa on 23/04/14.
//  Copyright (c) 2014 Richa. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AlarmItem;
@interface AlarmManager : NSObject
{
    
}
-(BOOL)addAlarm:(AlarmItem*)alarm;
-(NSMutableArray*)getAlarmList;
-(BOOL)deleteAlarm:(AlarmItem*)alarm;
-(BOOL)updateAlarm:(AlarmItem*)alarm;

-(void)scheduleAlarm:(AlarmItem*)alarm;
- (void)cancelAlarm:(AlarmItem*)alarm;
- (void)snoozeAlarm:(AlarmItem*)alarm;
@end
