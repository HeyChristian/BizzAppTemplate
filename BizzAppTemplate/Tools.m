//
//  Tools.m
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/5/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import "Tools.h"
#import <Parse/Parse.h>

@implementation Tools


+(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
+(NSString *)clearText:(UITextField *)field{
  
    return [field.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
+(id) getSessionObject:(NSString *)key{
   
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];

}
+(void)setSessionObject:(NSString *)key andValue:(id)value{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setValue:value forKey:key];
    
}
+(void)setCurrentUserImageData{
    
    PFFile *imageFile = [[PFUser currentUser] objectForKey:@"Image"];
    NSLog(@"Image Data URL: %@",imageFile.url);
    if(imageFile.url != nil){
        
        NSURL *imageFileUrl = [[NSURL alloc] initWithString:imageFile.url];
        NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
        
        [Tools setSessionObject:@"ProfileImage" andValue:imageData]; //[UIImage imageWithData:imageData]];
        
    }else{
        UIImage *img = [UIImage imageNamed:@"profile2"];
        [Tools setSessionObject:@"ProfileImage" andValue:UIImagePNGRepresentation(img)];

    }
}
+(UIImage *)getProfileImage{
    
    UIImage *img = [UIImage imageWithData:[Tools getSessionObject:@"ProfileImage"]];
    
    return img;
}
+(NSString *) formatDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM d, yyyy"];
    
    return [dateFormatter stringFromDate:date];
    
}
+(NSString *) formatDateTime:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM d, yyyy - hh:mm a"];
    
    return [dateFormatter stringFromDate:date];
    
}

//Constants
#define SECOND 1
#define MINUTE (60 * SECOND)
#define HOUR (60 * MINUTE)
#define DAY (24 * HOUR)
#define MONTH (30 * DAY)

+ (NSString*)timeIntervalWithStartDate:(NSDate*)d1
{
    NSDate *d2 = [NSDate date];
    
    //Calculate the delta in seconds between the two dates
    NSTimeInterval delta = [d2 timeIntervalSinceDate:d1];
    
    if (delta < 1 * MINUTE)
    {
        return delta == 1 ? @"one second ago" : [NSString stringWithFormat:@"%d seconds ago", (int)delta];
    }
    if (delta < 2 * MINUTE)
    {
        return @"a minute ago";
    }
    if (delta < 45 * MINUTE)
    {
        int minutes = floor((double)delta/MINUTE);
        return [NSString stringWithFormat:@"%d minutes ago", minutes];
    }
    if (delta < 90 * MINUTE)
    {
        return @"an hour ago";
    }
    if (delta < 24 * HOUR)
    {
        int hours = floor((double)delta/HOUR);
        return [NSString stringWithFormat:@"%d hours ago", hours];
    }
    if (delta < 48 * HOUR)
    {
        return @"yesterday";
    }
    if (delta < 30 * DAY)
    {
        int days = floor((double)delta/DAY);
        return [NSString stringWithFormat:@"%d days ago", days];
    }
    if (delta < 12 * MONTH)
    {
        int months = floor((double)delta/MONTH);
        return months <= 1 ? @"one month ago" : [NSString stringWithFormat:@"%d months ago", months];
    }
    else
    {
        int years = floor((double)delta/MONTH/12.0);
        return years <= 1 ? @"one year ago" : [NSString stringWithFormat:@"%d years ago", years];
    }
}

+ (NSDate *)addDays:(NSInteger)days toDate:(NSDate *)originalDate {
   // NSDateComponents *components= [[NSDateComponents alloc] init];
   // [components setDay:days];
   // NSCalendar *calendar = [NSCalendar currentCalendar];
   // return [calendar dateByAddingComponents:components toDate:originalDate options:0];
    
    //NSDate *tomorrow =
    return [NSDate dateWithTimeInterval:86400 sinceDate:originalDate];
    
}
+(int)getDatesBetweenDates:(NSDate *)startDate andEnd:(NSDate *)endDate{
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-ddHH:mm:ss ZZZ"];
   /*
    NSDate *startDate = [NSDate date];
    NSLog(@"%@",startDate);
    NSDate *endDate = [f dateFromString:end];
    NSLog(@"%@",endDate);
    */
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    return (int)components.day;
    
}

@end
