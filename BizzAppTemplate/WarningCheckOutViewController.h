//
//  WarningCheckOutViewController.h
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/14/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>



@interface WarningCheckOutViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic) NSMutableDictionary  *timeCard;

@property (weak, nonatomic) IBOutlet UILabel *warningLabel;

@end
