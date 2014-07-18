//
//  MapViewController.h
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/1/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController

@property (retain, nonatomic) IBOutlet MKMapView *MapView;

- (IBAction)sharedLocation:(id)sender;
- (IBAction)changeMapViewType:(UISegmentedControl *)sender;
- (IBAction)closeAction:(id)sender;

@end
