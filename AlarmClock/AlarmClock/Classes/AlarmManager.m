//
//  AlarmManager.m
//  AlarmClock
//
//  Created by Richa on 23/04/14.
//  Copyright (c) 2014 Richa. All rights reserved.
//

#import "AlarmManager.h"
#import "AlarmItem.h"
#import "DBManager.h"
@implementation AlarmManager
-(BOOL)addAlarm:(AlarmItem*)alarm
{
    int recid=[[DBManager sharedManager]execQuery:[NSString stringWithFormat:@"INSERT INTO alarms (day, datetime) VALUES ('%@', '%@')",[alarm dayString],alarm.datetime]];
    if(recid!=0)
    {
        alarm.recid=recid;
        [self scheduleAlarm:alarm];
        return YES;
    }
    return NO;
    
}
-(NSMutableArray*)getAlarmList
{
    return [[DBManager sharedManager]fetchRecords];
}
-(BOOL)deleteAlarm:(AlarmItem*)alarm{
    [[DBManager sharedManager]execQuery:[NSString stringWithFormat:@"DELETE FROM alarms where recid=%d",alarm.recid]];
    [self cancelAlarm:alarm];
    return YES;
}
-(BOOL)updateAlarm:(AlarmItem*)alarm
{
    [[DBManager sharedManager]execQuery:[NSString stringWithFormat:@"UPDATE alarms set isActive = %d where recid=%d",alarm.isActive ,alarm.recid]];
    if(alarm.isActive)
    {
        [self scheduleAlarm:alarm];
    }
    else{
        [self cancelAlarm:alarm];
    }
    return YES;

}
-(void)scheduleAlarm:(AlarmItem *)alarm
{
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm:00 dd/MM/yyyy"];
    localNotif.fireDate=[formatter dateFromString:alarm.datetime];
    // Notification details
    localNotif.alertBody = @"Alert!!";// this shows the notification with message.
    // Set the action button
    
    localNotif.alertAction = @"View";
    localNotif.soundName = @"siren.wav";
    
    // Specify custom data for the notification
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:alarm.recid] forKey:@"alarmid"];

    localNotif.userInfo = infoDict;
    localNotif.repeatCalendar = [NSCalendar currentCalendar];
    localNotif.repeatInterval = kCFCalendarUnitSecond;
    // Schedule the notification
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}
- (void)cancelAlarm:(AlarmItem*)alarm
{
    //cancel alarm
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    for (int i=0; i<[eventArray count]; i++)
    {
        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
        NSDictionary *userInfoCurrent = oneEvent.userInfo;
        NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"alarmid"]];
        if ([uid isEqualToString:[NSString stringWithFormat:@"%d",alarm.recid]])
        {
            //Cancelling local notification
            
            [app cancelLocalNotification:oneEvent];
            break;
        }
    }
}
- (void)snoozeAlarm:(AlarmItem*)alarm
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm:00 dd/MM/yyyy"];
    NSDate *snoozedDate=[[formatter dateFromString:alarm.datetime]dateByAddingTimeInterval:120];
    NSString *dateString=[formatter stringFromDate:snoozedDate];
    [self cancelAlarm:alarm];
    alarm.datetime =dateString;
    [self scheduleAlarm:alarm];
}
@end
