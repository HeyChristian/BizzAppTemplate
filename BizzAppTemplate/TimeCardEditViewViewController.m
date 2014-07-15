//
//  TimeCardEditViewViewController.m
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/10/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import "TimeCardEditViewViewController.h"
#import "TaskNotesViewController.h"
#import "Tools.h"
#import <Parse/Parse.h>
#import <CoreLocation/CLGeocoder.h>
#import <CoreLocation/CLPlacemark.h>
#import <CoreLocation/CoreLocation.h>
#import "WarningCheckOutViewController.h"

@interface TimeCardEditViewViewController ()<TaskNoteDelegate,CLLocationManagerDelegate,UIAlertViewDelegate>{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    bool locationAvailable;
    bool locationCheckOutWarning;
    PFGeoPoint *point;
    NSString *line1;
    NSString *line2;
    NSString *line3;
}

@end

@implementation TimeCardEditViewViewController


- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self bindTimeCard];
    locationCheckOutWarning=false;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
     warningView = [[WarningCheckOutViewController alloc] initWithNibName:@"WarningCheckOutViewController" bundle:nil];
   
}
-(void)viewDidAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    self.navigationItem.title  = @"Time Card";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    
    [self bindNotes:[self.timeCard objectForKey:@"objectId"]];
    

    
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
   // NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
    
    locationAvailable=NO;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
   // NSLog(@"didUpdateToLocation: %@", newLocation);
    currentLocation = newLocation;
    locationAvailable=YES;
    [locationManager stopUpdatingLocation];
    [self setGeoName];
}
-(void) setGeoName{
    
    NSArray *defaultLanguages = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
    NSArray *languages = [NSArray arrayWithObject:@"en"];
    [[NSUserDefaults standardUserDefaults] setObject:languages forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = placemarks[0];
        
       /*
        self.currentLocationLabel.text = [NSString stringWithFormat:@"%@ %@\n%@ %@, %@\n%@",
                                          placemark.subThoroughfare, placemark.thoroughfare,
                                          placemark.postalCode, placemark.locality,
                                          placemark.administrativeArea,
                                          placemark.country];*/
        
        line1 = [NSString stringWithFormat:@"%@ %@", placemark.subThoroughfare, placemark.thoroughfare];
        line2 = [NSString stringWithFormat:@"%@ %@, %@", placemark.postalCode, placemark.locality,placemark.administrativeArea];
        line3 = [NSString stringWithFormat:@"%@", placemark.country];
        
        
        double latitude = currentLocation.coordinate.latitude;
        double longitude = currentLocation.coordinate.longitude;
        point = [PFGeoPoint geoPointWithLatitude:latitude longitude:longitude];
        
        [[NSUserDefaults standardUserDefaults] setObject:defaultLanguages forKey:@"AppleLanguages"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
    
}
-(void)bindTimeCard{
    
    
    
    self.clientNameLabel.text = [[self.timeCard objectForKey:@"client"] capitalizedString];
    self.locationLabel.text =[NSString stringWithFormat:@"%@ \n%@ \n%@",[self.timeCard objectForKey:@"line1"],[self.timeCard objectForKey:@"line2"],[self.timeCard objectForKey:@"line3"]];
    
    self.checkinLabel.text =[NSString stringWithFormat:@"%@ - %@",[self.timeCard objectForKey:@"time_in"],[self.timeCard objectForKey:@"date_in"]];
    
    
    if([[self.timeCard objectForKey:@"date_out"] length]>0){
    
        self.checkoutLabel.text =[NSString stringWithFormat:@"%@  %@",[self.timeCard objectForKey:@"time_out"],[self.timeCard objectForKey:@"date_out"]];
        self.checkoutLabel.textColor = [UIColor blackColor];
        self.tableView.scrollsToTop = YES;
        self.tableView.scrollEnabled = NO;
       
    }else{
    
        self.checkoutLabel.text  = @"In Progress";
        self.checkoutLabel.textColor = [UIColor redColor];
        self.tableView.scrollsToTop = YES;
        self.tableView.scrollEnabled = YES;
    }
    
    
    self.taskDescription.text = [[self.timeCard objectForKey:@"description"] capitalizedString];
    [self bindNotes:[self.timeCard objectForKey:@"objectId"]];
    
    
    [self bindWarnings:[self.timeCard objectForKey:@"objectId"]];
    
    
  
}
-(void)bindNotes:(NSString *)objectId{
    
    // __block NSMutableDictionary *row = nil;
    PFQuery *qrynotes = [PFQuery queryWithClassName:@"TaskNote"];
    [qrynotes whereKey:@"TimeCard"
               equalTo:[PFObject objectWithoutDataWithClassName:@"TimeCard" objectId:objectId]];
    self.notes =  [[NSMutableArray alloc] initWithArray:[qrynotes findObjects]];
    
    self.countTaskNoteLabel.text = [NSString stringWithFormat:@" %lu entries",(unsigned long)[self.notes count]];
    
  
    
    
}
-(void)bindWarnings:(NSString *)objectId{
    
    PFQuery *qry = [PFQuery queryWithClassName:@"warningCheckOut"];
    [qry whereKey:@"TimeCard"
               equalTo:[PFObject objectWithoutDataWithClassName:@"TimeCard" objectId:objectId]];
    
    NSArray *warns = [[NSArray alloc] initWithArray:[qry findObjects]];
    if([warns count]>0){
        [self.timeCard setObject:[warns objectAtIndex:0] forKey:@"warnings"];
        [self.warningCell setHidden:NO];
    }else{
        [self.warningCell setHidden:YES];
    }
    
    
}
#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"taskNotes"]){
        
        TaskNotesViewController  *tasks = (TaskNotesViewController *) segue.destinationViewController;
        tasks.delegate =  self;
        tasks.objectId = [self.timeCard objectForKey:@"objectId"];
        if([self.checkoutLabel.text isEqualToString:@"In Progress"]){
            tasks.isClose=false;
        }else{
            tasks.isClose=true;
        }
    }
    
}

-(void)updateTaskNoteList:(NSDate *)date andNote:(NSString *)note{
    
    NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
    [row setObject:date forKey:@"date"];
    [row setObject:note forKey:@"note"];
    [self.notes addObject:row];
    
    NSString *parentId =[self.timeCard objectForKey:@"objectId"];
    
    PFQuery *timec = [PFQuery queryWithClassName:@"TimeCard"];
    [timec whereKey:@"objectId" equalTo:parentId];
    
    
    PFObject *tnote = [PFObject objectWithClassName:@"TaskNote"];
    tnote[@"TimeCard"] = [[timec findObjects] objectAtIndex:0];
    tnote[@"note"] = note;
    tnote[@"date"] = date;
    [tnote save];
    
    [self bindNotes:parentId];
    
    self.countTaskNoteLabel.text = [NSString stringWithFormat:@" %lu entries",(unsigned long)[self.notes count]];
    
}
- (NSInteger) numberOfSectionsInTableView:(UITableView*)tableView
{
   if([self.checkoutLabel.text isEqualToString:@"In Progress"])
    {
        return 2;
    }
   else
    {
        return 1;
    }
}
- (IBAction)checkOutAction:(id)sender {
    
    PFGeoPoint *firstPoint = [self.timeCard objectForKey:@"geoPoint"];
  
    if(firstPoint != nil){
        
        CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:firstPoint.latitude longitude:firstPoint.longitude];
        double distance = [loc1 distanceFromLocation:currentLocation];
        if(distance <= 100){
            
            locationCheckOutWarning=false;
            [self saveCheckOut];
        }else{
            
            locationCheckOutWarning=true;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                                message:@"The location where the checkout is being perfomed is different from the location where the check in was recorded. Are you aware of this?"
                                                               delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save Anyway",nil];
            [alertView show];
        }
        
    }else{
        
        locationCheckOutWarning=false;
        [self saveCheckOut];
    }
    
}

- (IBAction)viewWarningGeoLocationAction:(id)sender {
    
    warningView.timeCard = self.timeCard;
    [self presentSemiViewController:warningView withOptions:@{ KNSemiModalOptionKeys.pushParentBack    : @(YES),
                                                              KNSemiModalOptionKeys.animationDuration : @(0.5),
                                                              KNSemiModalOptionKeys.shadowOpacity     : @(0.9),
                                                              }];
    
    
}
-(void)showMessage:(NSString *)title andMessage:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}
-(void)saveCheckOut{
    if([self.notes count]>0){
        
        
        NSString *parentId =[self.timeCard objectForKey:@"objectId"];
        
        
        
        PFQuery *query = [PFQuery queryWithClassName:@"TimeCard"];
        [query getObjectInBackgroundWithId:parentId block:^(PFObject *timecard, NSError *error) {
            
            NSLog(@"%@", timecard);
            
            NSDate *localDate = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            dateFormatter.dateFormat = @"MM/dd/yy";
            timecard[@"date_out"] = [dateFormatter stringFromDate: localDate];
            
            NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
            timeFormatter.dateFormat = @"hh:mm a";
            timecard[@"time_out"] = [timeFormatter stringFromDate: localDate];
            
            timecard[@"checkout"] = [NSDate date];
            
            if(locationCheckOutWarning){
                timecard[@"locationCheckOutWarning"]= @YES;
            }
            
            [timecard saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(succeeded){
                    
                    if(locationCheckOutWarning){
                        PFObject *warn = [PFObject objectWithClassName:@"warningCheckOut"];
                        warn[@"TimeCard"]=timecard;
                        warn[@"geoPoint"]=[PFGeoPoint geoPointWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
                        warn[@"line1"]=line1;
                        warn[@"line2"]=line2;
                        warn[@"line3"]=line3;
                        [warn saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if(succeeded){
                                [self showMessage:@"Check Out Complete" andMessage:nil];
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                        }];
                        
                    }else{
                        [self showMessage:@"Check Out Complete" andMessage:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
            }];
            
            
        }];
    }else{
        [self showMessage:@"Oops!" andMessage:@"You need, at least, one task note before you check out."];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            //NSLog(@">>>>0");
            break;
        case 1:
            locationCheckOutWarning=true;
            [self saveCheckOut];
            break;
        case 2:
           // NSLog(@">>>>2");
            break;
        default:
            break;
    }
}
@end
