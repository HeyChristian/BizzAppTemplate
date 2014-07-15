//
//  WarningCheckOutViewController.m
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/14/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import "WarningCheckOutViewController.h"
#import "UIViewController+KNSemiModal.h"
#import <Parse/Parse.h>


@interface WarningCheckOutViewController ()<MKMapViewDelegate>

@end

@implementation WarningCheckOutViewController



- (void)viewDidLoad
{
    [super viewDidLoad];

    self.mapView.delegate = self;
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = YES;
    
    
    [self showChecksLocations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) showChecksLocations{
    
    PFGeoPoint *checkIn = [self.timeCard objectForKey:@"geoPoint"];
    NSMutableDictionary *warning = [self.timeCard objectForKey:@"warnings"];
   
    
    NSLog(@"%@  ",warning);
    
    PFGeoPoint *checkOut  = [warning objectForKey:@"geoPoint"];
    
    if(checkOut != nil){
       
        /*
        CLLocationCoordinate2D coord;
        coord.latitude = checkIn.latitude;
        coord.longitude =  checkIn.longitude;
        
        CLLocation *pointALocation = [[CLLocation alloc] initWithLatitude:checkIn.latitude longitude:checkIn.longitude];
        CLLocation *pointBLocation = [[CLLocation alloc] initWithLatitude:checkOut.latitude longitude:checkOut.longitude];
        CLLocationDistance d = [pointALocation distanceFromLocation:pointBLocation];
        
        
        MKCoordinateRegion r = MKCoordinateRegionMakeWithDistance(coord, 2*d, 2*d);
        [self.mapView setRegion:r animated:YES];
   */
    
    

    MKPlacemark *source = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake(checkIn.latitude,checkIn.longitude) addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    
    MKMapItem *srcMapItem = [[MKMapItem alloc]initWithPlacemark:source];
    [srcMapItem setName:@"Check-IN"];
    
    MKPlacemark *destination = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake(checkOut.latitude, checkOut.longitude) addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    
    MKMapItem *distMapItem = [[MKMapItem alloc]initWithPlacemark:destination];
    [distMapItem setName:@"Check-Out"];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
    [request setSource:srcMapItem];
    [request setDestination:distMapItem];
    [request setTransportType:MKDirectionsTransportTypeAutomobile];
    
    MKDirections *direction = [[MKDirections alloc]initWithRequest:request];
    
    [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        
        NSLog(@"response = %@",response);
        NSArray *arrRoutes = [response routes];
        [arrRoutes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            MKRoute *rout = obj;
            
            MKPolyline *line = [rout polyline];
            [self.mapView addOverlay:line];
            NSLog(@"Rout Name : %@",rout.name);
            NSLog(@"Total Distance (in Meters) :%f",rout.distance);
            
            NSArray *steps = [rout steps];
            
          //  NSLog(@"Total Steps : %d",[steps count]);
            
            [steps enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSLog(@"Rout Instruction : %@",[obj instructions]);
                NSLog(@"Rout Distance : %f",[obj distance]);
            }];
        }];
    }];
    }
    
}
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer =
    [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 3.0;
    return renderer;
}
@end
