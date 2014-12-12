//
//  MapSharedDetails.h
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/18/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>


@interface MapSharedDetails : UIViewController

@property (nonatomic)PFObject *sharedLocation;
@property (weak, nonatomic) IBOutlet MKMapView *MapView;
@property (weak, nonatomic) IBOutlet UILabel *milesLabel;

- (IBAction)OpenDirection:(id)sender;
@end
