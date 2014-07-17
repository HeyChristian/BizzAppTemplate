//
//  Pin.m
//  Locations
//
//  Created by Jay Versluis on 20/03/2014.
//  Copyright (c) 2014 Pinkstone Pictures LLC. All rights reserved.
//

#import "Pin.h"

@implementation Pin

- (id)initWithCoordinate:(CLLocationCoordinate2D)newCoordinate {
    
    self = [super init];
    if (self) {
        _coordinate = newCoordinate;
        //_title = @"Hello";
        //_subtitle = @"Are you still there?";
    }
    return self;
}
- (id)initWithCoordinate:(CLLocationCoordinate2D)newCoordinate andTitle:(NSString *)title andSubtitle:(NSString *)subTitle {
    
    self = [super init];
    if (self) {
        _coordinate = newCoordinate;
        _title = title;
        _subtitle = subTitle;
      
    }
    return self;
}

@end
