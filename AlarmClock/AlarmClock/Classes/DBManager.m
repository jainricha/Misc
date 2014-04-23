//
//  DBManager.m
//  AlarmClock
//
//  Created by Richa on 23/04/14.
//  Copyright (c) 2014 Richa. All rights reserved.
//

#import "DBManager.h"
#import <sqlite3.h>
#import "AlarmItem.h"
@implementation DBManager
+ (id)sharedManager{
    static DBManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}
-(NSMutableArray*)fetchRecords
{
    static sqlite3 *database = nil;
    NSMutableArray *alarms=[[NSMutableArray alloc]init];
    
    if (sqlite3_open([[self databasePath] UTF8String], &database) == SQLITE_OK)
    {
        const char *sql;
        
        sql= [[NSString stringWithFormat:@"select * from alarms"] UTF8String];        // (SELECT max(ROWID) FROM call)
        
        sqlite3_stmt *selectstmt;
        
        
        if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK)
        {
           
            while(sqlite3_step(selectstmt) == SQLITE_ROW)
            {
                AlarmItem *alarm=[[AlarmItem alloc]init];
                
                alarm.recid=sqlite3_column_int(selectstmt, 0);
                if((char*)sqlite3_column_text(selectstmt, 1)!=NULL)
                {
                    alarm.day = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
                
                if((char*)sqlite3_column_text(selectstmt, 2)!=NULL)
                {
                    alarm.datetime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 2)];
                }
                if((char*)sqlite3_column_text(selectstmt, 3)!=NULL)
                {
                    alarm.isActive = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 3)]boolValue];
                }
                [alarms addObject:alarm];
                
                    NSLog(@"%@",alarms);
            }
        }
        sqlite3_finalize(selectstmt);
        }
        
    }
    sqlite3_close(database);
    if([alarms count]>0)
    {
        return alarms;
    }
    else{
        return  nil;
    }

    
}
-(int)execQuery:(NSString*)query
{
    int recid=0;
    static sqlite3 *database = nil;
    sqlite3_stmt    *statement;
    if (sqlite3_open([[self databasePath] UTF8String], &database) == SQLITE_OK)
    {
        
        NSLog(@"execution query=%@",query);
        
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if(sqlite3_exec(database, [query UTF8String], NULL,NULL, NULL) == SQLITE_OK)
            {
                // SQLITE_OK
                recid=(int)sqlite3_last_insert_rowid(database);
            }
            else
            {
                
                NSLog(@"Error: failed to exec statement with message '%s'.", sqlite3_errmsg(database));
            }
        }
        else
        {
            NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
            
        }
        sqlite3_finalize(statement);
        
        sqlite3_close(database);
    }
    return recid;


}
-(NSString*)databasePath
{
    
    NSString *databaseName=@"alarms.sqlite";
    
    NSArray * documentsPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString * documentDir=[documentsPaths objectAtIndex:0];
    
    return [documentDir stringByAppendingPathComponent:databaseName];
}
-(void)createDatabaseIfNeeded
{
    BOOL success;
    
    
    NSFileManager * fileManager=[NSFileManager defaultManager];
    
    success=[fileManager fileExistsAtPath:[self databasePath]];
    
    if(success) return;
    
    NSString * databasepathfromapp=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[[self databasePath]lastPathComponent]];
    NSLog(@"%@",databasepathfromapp);
    
    [fileManager copyItemAtPath:databasepathfromapp toPath:[self databasePath] error:nil];
    
    NSLog(@"**Database created at : %@",[self databasePath]);
    
    
}
-(NSString*)fetchAlarmTime:(int)recid
{
    static sqlite3 *database = nil;
    NSString *datetime=nil;
    
    if (sqlite3_open([[self databasePath] UTF8String], &database) == SQLITE_OK)
    {
        const char *sql;
        
        sql= [[NSString stringWithFormat:@"select datetime from alarms where recid=%d",recid] UTF8String];        // (SELECT max(ROWID) FROM call)
        
        sqlite3_stmt *selectstmt;
        
        
        if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK)
        {
            
            while(sqlite3_step(selectstmt) == SQLITE_ROW)
            {
                datetime=[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 0)];
                NSLog(@"%@",datetime);
            }
        }
        sqlite3_finalize(selectstmt);
    }
    
    sqlite3_close(database);
    return datetime;
}
@end
