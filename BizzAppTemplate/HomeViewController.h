//
//  HomeViewController.h
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 6/29/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNGridMenu.h"
#import "BEMAnalogClockView.h"
#import "BEMMinuteHand.h"
#import "MapViewController.h"

@class VCardViewController;
@class CompanyViewController;
@class MapViewController;

@interface HomeViewController : UIViewController <RNGridMenuDelegate,BEMAnalogClockDelegate,UIGestureRecognizerDelegate>{
    
    VCardViewController *vcardView;
    CompanyViewController *companyView;
    MapViewController *mapView;
    
}
- (IBAction)displayGridMenu:(id)sender;
- (IBAction)displayForDownloadVCard:(id)sender;
- (IBAction)viewCompanyInfo:(id)sender;
- (IBAction)displayMap:(id)sender;
- (IBAction)displaySideMenu:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *bgImage;



@property (weak, nonatomic) IBOutlet BEMAnalogClockView *myClock1; // The big, main clock.
@property (weak, nonatomic) IBOutlet BEMAnalogClockView *myClock2; // The smaller clock.
@property (strong, nonatomic) IBOutlet UILabel *myLabel;
@property (weak, nonatomic) IBOutlet UIView *panView;


@end
