//
//  Tools.m
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/5/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import "Tools.h"

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
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}
+(void)setSessionObject:(NSString *)key andValue:(id)value{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
