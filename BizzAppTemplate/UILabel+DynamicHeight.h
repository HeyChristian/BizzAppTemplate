//
//  UILabel+DynamicHeight.m
//  For StackOverFlow
//
//  Created by Vijay on 24/02/14.
//  Copyright (c) 2014 http://Vijay-Apple-Dev.blogspot.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define iOS7_0 @"7.0"

@interface UILabel (DynamicHeight)

/*====================================================================*/

/* Calculate the size,bounds,frame of the Multi line Label */

/*====================================================================*/
/**
 *  Returns the size of the Label
 *
 *  @param aLabel To be used to calculte the height
 *
 *  @return size of the Label
 */

-(CGSize)sizeOfMultiLineLabel;

@end