//
//  MapViewController.m
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/1/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import "MapViewController.h"



@interface MapViewController ()<MKMapViewDelegate>

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // self.MapView = [[MKMapView alloc] init];
     self.MapView.delegate = self;
     self.MapView.zoomEnabled = NO;
     self.MapView.mapType = MKMapTypeStandard;
     self.MapView.showsUserLocation = YES;
    
    
 
    // Do any additional setup after loading the view from its nib.
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self setMyCurrentLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sharedLocation:(id)sender {
     [self setMyCurrentLocation];
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    [self.MapView setCenterCoordinate:userLocation.coordinate animated:YES];
}

- (IBAction)changeMapViewType:(UISegmentedControl*)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.MapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.MapView.mapType = MKMapTypeSatellite;
            break;
        case 2:
            self.MapView.mapType = MKMapTypeHybrid;
            break;
        default:
            break;
    }
    
    
}

-(void) setMyCurrentLocation{
    float spanX = 0.00725;
    float spanY = 0.00725;
    MKCoordinateRegion region;
    region.center.latitude = self.MapView.userLocation.coordinate.latitude;
    region.center.longitude = self.MapView.userLocation.coordinate.longitude;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    
    [self.MapView setRegion:region animated:YES];
}
@end
