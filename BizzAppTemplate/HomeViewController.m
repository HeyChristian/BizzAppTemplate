//
//  HomeViewController.m
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 6/29/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import "HomeViewController.h"
#import "AwesomeMenuItem.h"
#import "AwesomeMenu.h"
#import <QuartzCore/QuartzCore.h>
#import "UIViewController+KNSemiModal.h"
#import "VCardViewController.h"
#import "CompanyViewController.h"
//for testing only
//#import "TestViewController.h"

@interface HomeViewController (){
     int imageCount;
     
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic,strong) NSDateFormatter *dateFormatter;
@property (nonatomic,strong) NSCalendar *calendar;
@property (nonatomic,strong) NSDate *date;

@end

@implementation HomeViewController

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //NSLog(@"view did appear");
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    imageCount = 1;
    
    [self.navigationController.navigationBar setHidden:YES];
    //[self initMenu];
    
    // Take note that you need to take ownership of the ViewController that is being presented
    
    vcardView = [[VCardViewController alloc] initWithNibName:@"VCardViewController" bundle:nil];
    vcardView.parentVC = self;
    
    companyView = [[CompanyViewController alloc] initWithNibName:@"CompanyViewController" bundle:nil];
    
    
    [self initClock];
    
    
    [NSTimer scheduledTimerWithTimeInterval:10
                                     target:self
                                   selector:@selector(animateFunction)
                                   userInfo:nil
                                    repeats:YES];
    imageCount = 1;
}

-(void)animateFunction
{
    //NSLog(@"Timer heartbeat %i",imageCount);
    
    NSString *imageName = [NSString stringWithFormat:@"bg%i.png",imageCount];
    [self.bgImage setImage:[UIImage imageNamed:imageName]];
    
    
    CATransition *transition = [CATransition animation];
    transition.duration = 4.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    
    [self.bgImage.layer addAnimation:transition forKey:nil];
    
    if(imageCount == BZAMaxBgImages){
        imageCount = 1;
    }else{
        imageCount = imageCount + 1;
    }
    
}



- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (IBAction)displayGridMenu:(id)sender {
    [self showGrid];
}

- (IBAction)displayForDownloadVCard:(id)sender {

    // You can also present a UIViewController with complex views in it
    // and optionally containing an explicit dismiss button for semi modal
    
    [self presentSemiViewController:vcardView withOptions:@{
                                                         KNSemiModalOptionKeys.pushParentBack    : @(YES),
                                                         KNSemiModalOptionKeys.animationDuration : @(0.5),
                                                         KNSemiModalOptionKeys.shadowOpacity     : @(0.9),
                                                         }];

}

- (IBAction)viewCompanyInfo:(id)sender {
    
    [self presentSemiViewController:companyView withOptions:@{
                                                            KNSemiModalOptionKeys.pushParentBack    : @(YES),
                                                            KNSemiModalOptionKeys.animationDuration : @(0.5),
                                                            KNSemiModalOptionKeys.shadowOpacity     : @(0.9),
                                                            }];
    
}


#pragma mark - RNGridMenu
- (void)showGrid {
    NSInteger numberOfOptions = 9;
    NSArray *items = @[
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"arrow"] title:@"Next"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"attachment"] title:@"Attach"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"block"] title:@"Cancel"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"bluetooth"] title:@"Bluetooth"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"cube"] title:@"Deliver"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"download"] title:@"Download"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"enter"] title:@"Enter"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"file"] title:@"Source Code"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"github"] title:@"Github"]
                       ];
    
    RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    //    av.bounces = NO;
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}

- (void)showGridWithHeaderFromPoint:(CGPoint)point {
    NSInteger numberOfOptions = 9;
    NSArray *items = @[
                       [RNGridMenuItem emptyItem],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"attachment"] title:@"Attach"],
                       [RNGridMenuItem emptyItem],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"bluetooth"] title:@"Bluetooth"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"cube"] title:@"Deliver"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"download"] title:@"Download"],
                       [RNGridMenuItem emptyItem],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"file"] title:@"Source Code"],
                       [RNGridMenuItem emptyItem]
                       ];
    
    RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    av.bounces = NO;
    av.animationDuration = 0.2;
    av.blurExclusionPath = [UIBezierPath bezierPathWithOvalInRect:self.imageView.frame];
    av.backgroundPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0.f, 0.f, av.itemSize.width*3, av.itemSize.height*3)];
    
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
    header.text = @"Example Header";
    header.font = [UIFont boldSystemFontOfSize:18];
    header.backgroundColor = [UIColor clearColor];
    header.textColor = [UIColor whiteColor];
    header.textAlignment = NSTextAlignmentCenter;
    // av.headerView = header;
    
    [av showInViewController:self center:point];
}

- (void)showGridWithPath {
    NSInteger numberOfOptions = 9;
    NSArray *items = @[
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"arrow"] title:@"Next"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"attachment"] title:@"Attach"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"block"] title:@"Cancel"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"bluetooth"] title:@"Bluetooth"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"cube"] title:@"Deliver"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"download"] title:@"Download"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"enter"] title:@"Enter"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"file"] title:@"Source Code"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"github"] title:@"Github"]
                       ];
    
    RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    //    av.bounces = NO;
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}

-(void)initClock{
    
    self.myClock1.userInteractionEnabled = NO;
    self.myClock1.enableShadows = YES;
    self.myClock1.realTime = YES;
    self.myClock1.currentTime = YES;
    self.myClock1.setTimeViaTouch = YES;
    self.myClock1.borderColor = [UIColor whiteColor];
    self.myClock1.borderWidth = 3;
    self.myClock1.faceBackgroundColor = [UIColor whiteColor];
    self.myClock1.faceBackgroundAlpha = 0.0;
    self.myClock1.delegate = self;
    self.myClock1.digitFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:17];
    self.myClock1.digitColor = [UIColor whiteColor];
    self.myClock1.enableDigit = YES;
    
    
    
    self.myClock2.setTimeViaTouch = NO;
    self.myClock2.enableGraduations = NO;
    self.myClock2.realTime = YES;
    self.myClock2.currentTime = YES;
    self.myClock2.faceBackgroundAlpha = 0;
    self.myClock2.enableShadows = NO;
    self.myClock2.borderColor = [UIColor whiteColor];; // [UIColor colorWithRed:0 green:122.0/255.0 blue:255/255 alpha:1];
    self.myClock2.hourHandColor =  [UIColor whiteColor];//[UIColor colorWithRed:0 green:122.0/255.0 blue:255/255 alpha:1];
    self.myClock2.minuteHandColor = [UIColor whiteColor];  //[UIColor colorWithRed:0 green:122.0/255.0 blue:255/255 alpha:1];
    self.myClock2.borderWidth = 1;
    self.myClock2.hourHandWidth = 1.0;
    self.myClock2.hourHandLength = 10;
    self.myClock2.minuteHandWidth = 1.0;
    self.myClock2.minuteHandLength = 15;
    self.myClock2.minuteHandOffsideLength = 0;
    self.myClock2.hourHandOffsideLength = 0;
    self.myClock2.secondHandAlpha = 0;
    self.myClock2.delegate = self;
    self.myClock2.userInteractionEnabled = NO;
   
    //[self.myClock2 startRealTime];
    //[self.myClock1 startRealTime];
    
    //[self currentTimeOnClock:self.myClock2 Hours:self.myClock2.hours  Minutes:self.myClock2.minutes Seconds:self.myClock2.seconds];
  //  [self currentTimeOnClock:self.myClock1];
    
   // UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
   // panGesture.delegate = self;
   // [panGesture setMaximumNumberOfTouches:0];
   // [self.panView addGestureRecognizer:panGesture];
   
    /*
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(currentTimeOnClock:)
                                   userInfo:nil
                                    repeats:YES];
    */
}

- (void)currentTimeOnClock  {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle: NSDateFormatterShortStyle];

    NSString *currentTime = [dateFormatter stringFromDate: [NSDate date]];
    self.myLabel.text = currentTime;
    
    
}
- (void)currentTimeOnClock:(BEMAnalogClockView *)clock  {
   
    NSNumber *nHour = [[NSNumber alloc] initWithInteger:clock.hours];
    NSNumber *nMin = [[NSNumber alloc] initWithInteger:clock.minutes];
     NSNumber *nSeg = [[NSNumber alloc] initWithInteger:clock.seconds];
    
        int hoursInt =  [nHour intValue];
        int minutesInt = [nMin intValue];
        int secondsInt = [nSeg intValue];
        self.myLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hoursInt, minutesInt, secondsInt];
    
}
- (void)currentTimeOnClock:(BEMAnalogClockView *)clock Hours:(NSString *)hours Minutes:(NSString *)minutes Seconds:(NSString *)seconds {
    if (clock.tag == 1) {
        int hoursInt = [hours intValue];
        int minutesInt = [minutes intValue];
        int secondsInt = [seconds intValue];
        self.myLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hoursInt, minutesInt, secondsInt];
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer locationInView:self.view];
    //    self.myClock1.minutes = translation.x / 5.33333;
    
    float minutes = translation.x/2.666667;  // 320 width / 2.666667 = 120 minutes [2 hours]
    
    if (!_dateFormatter){
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"HH:mm:ss"];
        _calendar = [NSCalendar currentCalendar];
        _date = [_dateFormatter dateFromString:self.myLabel.text];
    }
    NSDate           *datePlusMinutes = [_date dateByAddingTimeInterval:minutes*60];
    NSDateComponents *components      = [_calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:datePlusMinutes];
    NSInteger hour   = [components hour];
    NSInteger minute = [components minute];
    
    self.myClock1.minutes = minute;
    self.myClock1.hours   = hour;
    
    [self matchHoursClock1ToClock2];
    [self.myClock1 updateTimeAnimated:NO];
    [self.myClock2 updateTimeAnimated:NO];
}

- (void)matchHoursClock1ToClock2 {
    self.myClock2.hours = self.myClock1.hours;
    self.myClock2.minutes = self.myClock1.minutes;
    self.myClock2.seconds = self.myClock1.seconds;
}
@end
