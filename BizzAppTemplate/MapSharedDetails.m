//
//  MapSharedDetails.m
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/18/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import "MapSharedDetails.h"
#import "UIViewController+KNSemiModal.h"
#import <Parse/Parse.h>
#import "Pin.h"

@interface MapSharedDetails ()<MKMapViewDelegate>

@property (nonatomic, strong) NSMutableArray *allPins;
@property (nonatomic, strong) MKPolylineView *lineView;
@property (nonatomic, strong) MKPolyline *polyline;

@end

@implementation MapSharedDetails



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.MapView.delegate = self;
    self.MapView.mapType = MKMapTypeStandard;
    self.MapView.showsUserLocation = YES;
    
    
    self.MapView.zoomEnabled=YES;
  
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    self.allPins = [[NSMutableArray alloc] init];
    self.lineView = nil;
    self.polyline =  nil;
    self.milesLabel.text =@"";
    [self showRoute];
    [self setLocationAsRead];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)OpenDirection:(id)sender {
    PFGeoPoint *destinationPoint = [self.sharedLocation objectForKey:@"geoPoint"];
    
    
    CLLocationCoordinate2D endingCoord = CLLocationCoordinate2DMake(destinationPoint.latitude,destinationPoint.longitude);
    MKPlacemark *endLocation = [[MKPlacemark alloc] initWithCoordinate:endingCoord addressDictionary:nil];
    MKMapItem *endingItem = [[MKMapItem alloc] initWithPlacemark:endLocation];
    
    NSMutableDictionary *launchOptions = [[NSMutableDictionary alloc] init];
    [launchOptions setObject:MKLaunchOptionsDirectionsModeDriving forKey:MKLaunchOptionsDirectionsModeKey];
    
    [endingItem openInMapsWithLaunchOptions:launchOptions];
    
}



- (void)addPin:(double)latitude andLongitude:(double)longitude andPointTitle:(NSString *)pointTitle andSubTitle:(NSString *)subTitle {
    
    
    
    CLLocationCoordinate2D mapPoint = CLLocationCoordinate2DMake(latitude,longitude);
    // and add it to our view and our array
    Pin *newPin = [[Pin alloc]initWithCoordinate:mapPoint andTitle:pointTitle andSubtitle:subTitle];
    [self.MapView addAnnotation:newPin];
    [self.allPins addObject:newPin];
    
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

-(void) showRoute{
    PFGeoPoint *destinationPoint = [self.sharedLocation objectForKey:@"geoPoint"];
    
    
    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        
    
        double miles = [self getMilesBetweenPoints:geoPoint andPointB:destinationPoint];
       
        
        self.milesLabel.text = [NSString stringWithFormat:@"This location is approximately %.1f miles away.",miles];
        
        
        PFObject *user = [self.sharedLocation objectForKey:@"user"];
        
        
        
        
        NSString *name = [user objectForKey:@"Firstname"];
        NSString *last = [user objectForKey:@"LastName"];
        
        NSString *destinationName;
        NSString *companyName;
        if([name length]>0)
            destinationName = [[NSString stringWithFormat:@"%@ %@",name,last] capitalizedString];
        else
            destinationName = [user[@"email"] capitalizedString];
        
        
        
        
        companyName = [[[NSString alloc] initWithString:[user objectForKey:@"Company"]] capitalizedString];
        
        
        
        NSString *technicianName = [NSString stringWithFormat:@"%@",@"Current Location"];
        
        
        
        [self addPin:geoPoint.latitude andLongitude:geoPoint.longitude andPointTitle:technicianName andSubTitle:@""];
        [self addPin:destinationPoint.latitude andLongitude:destinationPoint.longitude andPointTitle:destinationName andSubTitle:companyName];
        
        
        MKPlacemark *source = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake(geoPoint.latitude,geoPoint.longitude) addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
        
        MKMapItem *srcMapItem = [[MKMapItem alloc]initWithPlacemark:source];
        [srcMapItem setName:@"Technician"];
        
        MKPlacemark *destination = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake(destinationPoint.latitude, destinationPoint.longitude) addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
        
        MKMapItem *distMapItem = [[MKMapItem alloc]initWithPlacemark:destination];
        [distMapItem setName:@"Check-Out"];
        
        MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
        [request setSource:srcMapItem];
        [request setDestination:distMapItem];
        [request setTransportType:MKDirectionsTransportTypeAutomobile];
        
        MKDirections *direction = [[MKDirections alloc]initWithRequest:request];
        
        
        [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
            
         
            NSArray *arrRoutes = [response routes];
            [arrRoutes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                MKRoute *rout = obj;
                
                MKPolyline *line = [rout polyline];
                [self.MapView addOverlay:line];
                
                NSArray *steps = [rout steps];
                
                
                [steps enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                }];
            }];
        }];
  }];
}
-(void)setLocationAsRead{
 
    PFQuery *qry = [PFQuery queryWithClassName:@"SharedLocation"];
    [qry whereKey:@"objectId" equalTo:self.sharedLocation.objectId];
    [qry findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       
        PFObject *loc = [objects objectAtIndex:0];
        loc[@"isOpen"]=@YES;
        [loc saveInBackground];
    }];
    
}


@end
