//
//  Tools.h
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/5/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject

+(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width;
+(NSString *)clearText:(UITextField *)field;
+(id) getSessionObject:(NSString *)key;
+(void)setSessionObject:(NSString *)key andValue:(id)value;

+(UIImage *)getProfileImage;
+(void)setCurrentUserImageData;


+ (NSString *) formatDate:(NSDate *)date;
+ (NSString *) formatDateTime:(NSDate *)date;
+ (NSString*)timeIntervalWithStartDate:(NSDate*)d1;
@end
