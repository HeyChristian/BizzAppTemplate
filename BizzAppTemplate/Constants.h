//
//  Constants.h
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 6/29/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import <Foundation/Foundation.h>




#pragma mark -

#pragma mark - Global

#define BZAMaxBgImages    3
#define BZGood  @"green"
#define BZBad   @"red"



#pragma mark - View  - prefix: KY

// Button Size
#define kKYButtonInMiniSize   16.f
#define kKYButtonInSmallSize  32.f
#define kKYButtonInNormalSize 64.f

#pragma mark - KYCircleMenu Configuration

// Number of buttons around the circle menu
#define kKYCCircleMenuButtonsCount 5
// Circle Menu
// Basic constants
#define kKYCircleMenuSize             280.f
#define kKYCircleMenuButtonSize       kKYButtonInNormalSize
#define kKYCircleMenuCenterButtonSize kKYButtonInNormalSize
// Image
#define kKYICircleMenuCenterButton           @"KYICircleMenuCenterButton.png"
#define kKYICircleMenuCenterButtonBackground @"KYICircleMenuCenterButtonBackground.png"
#define kKYICircleMenuButtonImageNameFormat  @"KYICircleMenuButton%.2d.png" // %.2d: 1 - 6

@interface Constants : NSObject

@end
