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
#import "Pin.h"

@interface WarningCheckOutViewController ()<MKMapViewDelegate>

@property (nonatomic, strong) NSMutableArray *allPins;
@property (nonatomic, strong) MKPolylineView *lineView;
@property (nonatomic, strong) MKPolyline *polyline;

@end

@implementation WarningCheckOutViewController



- (void)viewDidLoad
{
    [super viewDidLoad];

    self.mapView.delegate = self;
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = YES;
    
    
    self.mapView.zoomEnabled=YES;

    /*
    self.mapView.scrollEnabled = YES;
    self.mapView.showsPointsOfInterest = YES;
    self.mapView.showsBuildings = YES;
    self.mapView.rotateEnabled = NO;
    self.mapView.pitchEnabled = YES;
*/
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
        double miles = [self getMilesBetweenPoints:checkIn andPointB:checkOut];
       // NSLog(@"%f",miles);
        
        self.warningLabel.text = [NSString stringWithFormat:@"The first location does not match the last location, it is located %.1fmi away.",miles];
        
        
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
    
        NSString *checkInAddress = [NSString stringWithFormat:@"%@ %@ %@",[self.timeCard objectForKey:@"line1"],[self.timeCard objectForKey:@"line2"],[self.timeCard objectForKey:@"line3"]];
        
        NSString *checkOutAddress = [NSString stringWithFormat:@"%@ %@ %@",[warning objectForKey:@"line1"],[warning objectForKey:@"line2"],[warning objectForKey:@"line3"]];
        
        
        
        [self addPin:checkIn.latitude andLongitude:checkIn.longitude andStrAddress:checkInAddress];
        [self addPin:checkOut.latitude andLongitude:checkOut.longitude andStrAddress:checkOutAddress];
        

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
        
        //NSLog(@"response = %@",response);
        NSArray *arrRoutes = [response routes];
        [arrRoutes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            MKRoute *rout = obj;
            
            MKPolyline *line = [rout polyline];
            [self.mapView addOverlay:line];
            //NSLog(@"Rout Name : %@",rout.name);
            //NSLog(@"Total Distance (in Meters) :%f",rout.distance);
            
            NSArray *steps = [rout steps];
            
          //  NSLog(@"Total Steps : %d",[steps count]);
            
            [steps enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
              //  NSLog(@"Rout Instruction : %@",[obj instructions]);
               // NSLog(@"Rout Distance : %f",[obj distance]);
            }];
        }];
    }];
    }
    
}

- (void)addPin:(double)latitude andLongitude:(double)longitude andStrAddress:(NSString *)addressStr {
    
  
    
    // convert touched position to map coordinate
   // CGPoint userTouch = [recognizer locationInView:self.mapView];
    CLLocationCoordinate2D mapPoint = CLLocationCoordinate2DMake(latitude,longitude);
    //[self.mapView convertPoint:userTouch toCoordinateFromView:self.mapView];
    
    // and add it to our view and our array
    Pin *newPin = [[Pin alloc]initWithCoordinate:mapPoint andTitle:@"" andSubtitle:addressStr];
    [self.mapView addAnnotation:newPin];
    [self.allPins addObject:newPin];
    
    //[self drawLines:self];
    
}
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer =
    [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 3.0;
    return renderer;
}


-(double)getMilesBetweenPoints:(PFGeoPoint *)pointA andPointB:(PFGeoPoint *)pointB{
    double latA = pointA.latitude;
    double logA = pointA.longitude;
    
    double latB = pointB.latitude;
    double logB = pointB.longitude;
    
    CLLocation *locA = [[CLLocation alloc] initWithLatitude:latA
                                                  longitude:logA];
    
    CLLocation *locB = [[CLLocation alloc] initWithLatitude:latB longitude:logB];
    CLLocationDistance distance = [locA distanceFromLocation:locB];
    NSLog(@"Calculated Miles %@", [NSString stringWithFormat:@"%.1fmi",(distance/1609.344)]);
    return distance/1609.344;

}
@end
