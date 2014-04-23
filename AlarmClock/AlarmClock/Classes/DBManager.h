//
//  DBManager.h
//  AlarmClock
//
//  Created by Richa on 23/04/14.
//  Copyright (c) 2014 Richa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject
{
    
}
+ (id)sharedManager;
-(NSMutableArray*)fetchRecords;
-(int)execQuery:(NSString*)query;
-(void)createDatabaseIfNeeded;
-(NSString*)databasePath;
-(NSString*)fetchAlarmTime:(int)recid;
@end
