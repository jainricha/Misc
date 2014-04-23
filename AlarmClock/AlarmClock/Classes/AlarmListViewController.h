//
//  AlarmListViewController.h
//  AlarmClock
//
//  Created by Richa on 23/04/14.
//  Copyright (c) 2014 Richa. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ACTIVE_ALARM_IMAGE @"alarm_active.png"
#define DEACTIVE_ALARM_IMAGE @"alarm_deactive.png"
@interface AlarmListViewController : UITableViewController<UIActionSheetDelegate,UIAlertViewDelegate>
{
    
}
-(void)updateAlarmList;
@property(nonatomic,strong)NSMutableArray *alarmList;
@property(nonatomic,strong)NSString *selectedDay;
@property(nonatomic,strong)NSString *selectedDate;
@property BOOL shouldStopAlarm;
@property int alarmRecID;
@end
