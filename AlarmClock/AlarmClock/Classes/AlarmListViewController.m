//
//  AlarmListViewController.m
//  AlarmClock
//
//  Created by Richa on 23/04/14.
//  Copyright (c) 2014 Richa. All rights reserved.
//

#import "AlarmListViewController.h"
#import "AlarmItem.h"
#import "AlarmManager.h"
#import "AppDelegate.h"
@interface AlarmListViewController ()

@end

@implementation AlarmListViewController
@synthesize alarmList;
@synthesize selectedDate;
@synthesize selectedDay;
@synthesize shouldStopAlarm;
@synthesize alarmRecID;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAlarm:)];
    self.title=@"Alarm List";
    if(self.shouldStopAlarm)
    {
        UIAlertView *alarmAlert=[[UIAlertView alloc]initWithTitle:@"Alarm Alert" message:@"" delegate:self cancelButtonTitle:@"Stop" otherButtonTitles:@"Snooze", nil];
        [alarmAlert show];
    }
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (BOOL)canBecomeFirstResponder
{
    return YES;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}
-(void)viewWillAppear:(BOOL)animated
{

    [self updateAlarmList];
    

    [super viewWillAppear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma Detect Shake
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if(event.type == UIEventSubtypeMotionShake)
    {
        AlarmItem *alarm=[[AlarmItem alloc]init];
        AlarmManager *aManager=[[AlarmManager alloc]init];
        alarm.recid=alarmRecID;
        alarm.datetime=[alarm getDateTime];
        [aManager snoozeAlarm:alarm];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] player] stop];
        
    }
}
#pragma mark Alert View Delegates
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //stop ringing alarm
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] player] stop];
        AlarmItem *alarm=[[AlarmItem alloc]init];
        AlarmManager *aManager=[[AlarmManager alloc]init];
        alarm.recid=alarmRecID;

        alarm.isActive=NO;
        
        if([aManager updateAlarm:alarm])
            [self updateAlarmList];
        
    }
    else{
     //Snooze ringing alarm
        AlarmItem *alarm=[[AlarmItem alloc]init];
        AlarmManager *aManager=[[AlarmManager alloc]init];
        alarm.recid=alarmRecID;
        alarm.datetime=[alarm getDateTime];
        [aManager snoozeAlarm:alarm];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] player] stop];
        

        
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [self.alarmList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    AlarmItem *item=(AlarmItem*)[self.alarmList objectAtIndex:indexPath.row];
    cell.textLabel.text=item.datetime;
    cell.detailTextLabel.text =item.day;
    if(item.isActive)
    {
        cell.imageView.image=[UIImage imageNamed:ACTIVE_ALARM_IMAGE];
    }
    else{
        cell.imageView.image=[UIImage imageNamed:DEACTIVE_ALARM_IMAGE];
    }
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
#pragma mark Alarm methods
-(void)addAlarm:(id)sender
{
    UIDatePicker *datePickerView = [[UIDatePicker alloc] init];
    datePickerView.datePickerMode = UIDatePickerModeDateAndTime;


    UIActionSheet *dateActionSheet = [[UIActionSheet alloc] initWithTitle:@"Set Alarm"
                                                       delegate:self cancelButtonTitle:nil
                                         destructiveButtonTitle:nil otherButtonTitles:@"Cancel",@"Done", nil];
    
    [dateActionSheet showInView:self.view];
    [dateActionSheet addSubview:datePickerView];
    [dateActionSheet setBounds:CGRectMake(0,0,320, 500)];
    [dateActionSheet setTag:100];
    CGRect pickerRect = datePickerView.bounds;
    pickerRect.origin.y = -125;
    datePickerView.bounds=pickerRect;
    
    
    
    [datePickerView addTarget:self
                          action:@selector(datePickerDateChanged:)
                forControlEvents:UIControlEventValueChanged];
    


    
}

-(void)updateAlarmList
{
    AlarmManager *aManager=[[AlarmManager alloc]init];
    if(self.alarmList==nil)
    {
        self.alarmList=[[NSMutableArray alloc]init];
    }
    else
    {
        [self.alarmList removeAllObjects];
    }
    self.alarmList=[aManager getAlarmList];
    [self.tableView reloadData];
    
}
#pragma mark Action Sheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex==1 && actionSheet.tag==100)
    {
        //Add alarm
        AlarmManager *aManager=[[AlarmManager alloc]init];
        AlarmItem *alarm=[[AlarmItem alloc]init];
        alarm.day=self.selectedDay;
        alarm.datetime=self.selectedDate;
        alarm.isActive=YES;
        if([aManager addAlarm:alarm])
            [self updateAlarmList];
        
        
    }
    else if (buttonIndex==0 && actionSheet.tag==101)
    {
        //Deactivate or activate alarm
        AlarmManager *aManager=[[AlarmManager alloc]init];
        AlarmItem *alarm=[self.alarmList objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        alarm.isActive=!alarm.isActive;
        
        if([aManager updateAlarm:alarm])
        {
            
            [self updateAlarmList];
            
        }
    }
}

#pragma Date Picker Delegate
//listen to changes in the date picker and just log them
- (void) datePickerDateChanged:(UIDatePicker *)paramDatePicker{

        NSLog(@"Selected date = %@", paramDatePicker.date);
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"EEE,HH:mm:00 dd/MM/yyyy"];
    NSString *myDate = [df stringFromDate:paramDatePicker.date];
            NSLog(@"Selected date formatted= %@", myDate);
    self.selectedDay=[[myDate componentsSeparatedByString:@","]objectAtIndex:0];
    self.selectedDate=[[myDate componentsSeparatedByString:@","]objectAtIndex:1];
    

}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    NSString *stateString=((AlarmItem*)[self.alarmList objectAtIndex:indexPath.row]).isActive?@"Deactivate":@"Activate" ;
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:nil destructiveButtonTitle:stateString otherButtonTitles:@"Cancel", nil];
    [sheet setTag:101];
    [sheet showInView:self.view];
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Delete Alarm
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        AlarmManager *aManager=[[AlarmManager alloc]init];
        if([aManager deleteAlarm:[self.alarmList objectAtIndex:indexPath.row]])
        {
            [self updateAlarmList];
        }
    }
    
}
@end
