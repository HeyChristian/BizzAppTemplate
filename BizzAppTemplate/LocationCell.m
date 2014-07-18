//
//  LocationCell.m
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/17/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import "LocationCell.h"
#import <CoreLocation/CLGeocoder.h>
#import <CoreLocation/CLPlacemark.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>

@implementation LocationCell

-(void)configureCellForEntry:(NSDictionary *)row{
   
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    PFObject *user = [row objectForKey:@"sendUser"];
    
    NSString *name = [[PFUser currentUser] objectForKey:@"Firstname"];
    NSString *last = [[PFUser currentUser] objectForKey:@"LastName"];
    
    NSString *displayName;
    
    if([name length]>0)
        displayName = [NSString stringWithFormat:@"%@ %@",name,last];
    else
        displayName = user[@"email"];

    
    self.ClientNameLabel.text = displayName;
    
    PFGeoPoint *point = [row objectForKey:@"geoPoint"];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:point.latitude longitude:point.longitude];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = placemarks[0];
        
        
        self.AddressLabel.text = [NSString stringWithFormat:@"%@ %@\n%@ %@, %@\n%@",
                                          placemark.subThoroughfare, placemark.thoroughfare,
                                          placemark.postalCode, placemark.locality,
                                          placemark.administrativeArea,
                                          placemark.country];
        
     
        
       
    }];
    
}

@end
