//
//  Helper.h
//  FollowMe
//
//  Created by Ngo Hoang Lien on 5/25/15.
//  Copyright (c) 2015 JustFollowMe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class DTTimePeriod;

typedef void (^IdResultBlock)(id object, NSError *error);


@interface Helper : NSObject

#pragma mark - Common methods
//convert the UTC time to local time
+ (NSDate *)toLocalTime:(NSDate *)aDate;

//convert the local time to UTC time
+ (NSDate *)toGlobalTime:(NSDate *)aDate;

+ (UIColor *) getColor: (NSString *) hexColor;
+ (UIColor *) colorWithRed:(float)red green:(float)green blue:(float)blue;

+ (void)showNoInternetConnectionError;
+ (void)showAlertWithTitle:(NSString *) localizedTitle message:(NSString *) localizdMessage cancelStatus:(NSString *) localizedCancel;
+ (void)showAlertLocationDisabled;

+ (BOOL)checkIfString:(NSString *)mainString  containsSubString:(NSString *) subString;
+ (CGFloat)widthWithFont:(UIFont *)font forText:(NSString *)text;
+ (CGFloat)heigthWithWidth:(CGFloat)width andFont:(UIFont *)font forText:(NSString *)text;

+ (NSString *) stringFromParams:(NSDictionary *)params;

+ (NSString*) generateParams:(NSDictionary*)params;

+ (BOOL)checkIfString:(NSString *)str inArray:(NSArray *)array;
+ (BOOL)checkIfString:(NSString *)mainString  containsSubString:(NSString *)subString;

// RAND_FROM_TO(0, 74) // 0, 1, 2,..., 73, 74
+ (NSInteger)randomValueBetween:(NSInteger)min and:(NSInteger)max;


#pragma mark  showLoading
+ (void)showLoadingWithStatus:(NSString *)status;
+ (void)showLoadingForView:(UIView *)view;
+ (void)dismissHUDForView:(UIView *)view;
+ (NSNumber *)getNumber:(NSNumber *)input;
+ (NSString *)getString:(NSString *)input;
+ (NSArray *)getArray:(NSArray *)input;

+ (CABasicAnimation *)getZoomOutAnimation;

+ (void) getAddressFromLatLon:(CLLocation *)bestLocation;
+ (void)getAddressFromLocation:(CLLocation *)location complationBlock:(IdResultBlock)completionBlock;

@end
