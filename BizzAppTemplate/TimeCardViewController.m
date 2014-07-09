//
//  TimeCardViewController.m
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/8/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import "TimeCardViewController.h"
#import "MenuNavigationController.h"
#import <CoreLocation/CLGeocoder.h>
#import <CoreLocation/CLPlacemark.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import "Tools.h"

@interface TimeCardViewController ()<CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    bool locationAvailable;
    NSString *line1;
    NSString *line2;
    NSString *line3;
}
@end

@implementation TimeCardViewController

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
    [super viewDidLoad];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    self.navigationItem.title  = @"Time Card";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    /*
    
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu48"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:(MenuNavigationController *)self.navigationController
                                                                            action:@selector(showMenu)];
    
 
    
    self.navigationItem.leftBarButtonItem = nil;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(cancel)];
    
       */
}
-(void)cancel{
    
    [self.navigationController popViewControllerAnimated:YES];
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
        
        
        self.currentLocationLabel.text = [NSString stringWithFormat:@"%@ %@\n%@ %@, %@\n%@",
                                          placemark.subThoroughfare, placemark.thoroughfare,
                                          placemark.postalCode, placemark.locality,
                                          placemark.administrativeArea,
                                          placemark.country];

        line1 = [NSString stringWithFormat:@"%@ %@", placemark.subThoroughfare, placemark.thoroughfare];
        line2 = [NSString stringWithFormat:@"%@ %@, %@", placemark.postalCode, placemark.locality,placemark.administrativeArea];
        line3 = [NSString stringWithFormat:@"%@", placemark.country];
        
        
        
        [[NSUserDefaults standardUserDefaults] setObject:defaultLanguages forKey:@"AppleLanguages"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
    
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
    
    locationAvailable=NO;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    currentLocation = newLocation;
    locationAvailable=YES;
    [locationManager stopUpdatingLocation];
    [self setGeoName];
}

- (IBAction)checkInAction:(id)sender {
    
    PFObject *tc = [PFObject objectWithClassName:@"TimeCard"];
    tc[@"user"] = [PFUser currentUser];
    tc[@"client"] = [Tools clearText:self.clientField];
    tc[@"tasks"]= self.taskDescriptionsField.text;
   
    if(locationAvailable){
        double latitude = currentLocation.coordinate.latitude;
        tc[@"latitude"] = [NSNumber numberWithDouble:latitude];
        double longitude = currentLocation.coordinate.longitude;
        tc[@"latitude"] = [NSNumber numberWithDouble:longitude];
        tc[@"line1"]=line1;
        tc[@"line2"]=line2;
        tc[@"line3"]=line3;
    }
  
    tc[@"checkin"]= [NSDate date];
    
    NSDate *localDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"MM/dd/yy";
    tc[@"date_in"] = [dateFormatter stringFromDate: localDate];

    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    timeFormatter.dateFormat = @"HH:mm:ss";
    tc[@"time_in"] = [timeFormatter stringFromDate: localDate];
    
   // tc[@"date_out"]=@"";
    //tc[@"time_out"]=@"";
    //tc[@"check_out"]=@"";
    
    
    [tc saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded){
            [self showMessage:@"Check In Complete" andMessage:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showMessage:@"An Error Occur!" andMessage:[error description]];
        }
    }];
    
    
}
-(void)showMessage:(NSString *)title andMessage:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}
@end
