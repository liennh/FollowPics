//
//  Helper.m
//  FollowMe
//
//  Created by Ngo Hoang Lien on 5/25/15.
//  Copyright (c) 2015 JustFollowMe. All rights reserved.
//


#import "Helper.h"
#import <GoogleMaps/GoogleMaps.h>

@implementation Helper

//convert the UTC time to local time
+ (NSDate *)toLocalTime:(NSDate *)aDate
{
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: aDate];
    return [NSDate dateWithTimeInterval: seconds sinceDate: aDate];
}


//convert the local time to UTC time
+ (NSDate *)toGlobalTime:(NSDate *)aDate
{
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = -[tz secondsFromGMTForDate: aDate];
    return [NSDate dateWithTimeInterval: seconds sinceDate: aDate];
}



+ (UIColor *) getColor: (NSString *) hexColor
{
    unsigned int red, green, blue;
    NSRange range;
    range.length = 2;

    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];

    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:1.0f];
}

+ (UIColor *) colorWithRed:(float)red green:(float)green blue:(float)blue {

    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:1.0f];
}

+ (void)showNoInternetConnectionError {

    [Helper showAlertWithTitle: @"JustFollowMe" message: NSLocalizedString(@"The internet connection appears to be offline.", @"") cancelStatus: NSLocalizedString(@"OK", nil)];
}


+ (void)showAlertWithTitle:(NSString *) localizedTitle message:(NSString *) localizdMessage cancelStatus:(NSString *) localizedCancel {

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: localizedTitle
                                                    message: localizdMessage
                                                   delegate: nil
                                          cancelButtonTitle: localizedCancel
                                          otherButtonTitles:  nil ];
    [alert show];
}

+ (void)showAlertLocationDisabled {
    NSString *alertTitle = NSLocalizedString(@"Location Services Disabled", nil);
    NSString *message = NSLocalizedString(@"To turn it on, go to Settings > Privacy > Location Services (ON) > FollowPics (ON)", nil);
    [Helper showAlertWithTitle: alertTitle message: message cancelStatus: @"OK"];
}

+ (BOOL)checkIfString:(NSString *)mainString  containsSubString:(NSString *) subString {

    if (IS_NOT_NULL(mainString) && IS_NOT_NULL(subString)) {

        if ([mainString rangeOfString: subString options:NSCaseInsensitiveSearch].location == NSNotFound) {
            //NSLog(@"string does not contain bla");
            return NO;
        }

        return YES;
    }
    //parameters is Nil or Null
    return NO;
}


// RAND_FROM_TO(0, 74) // 0, 1, 2,..., 73, 74
+ (NSInteger)randomValueBetween:(NSInteger)min and:(NSInteger)max {
    return (NSInteger)(min + arc4random_uniform((u_int32_t)(max - min + 1)));
}

+ (CGFloat)widthWithFont:(UIFont *)font forText:(NSString *)text
{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString: text attributes:attributes] size].width;
}

+ (CGFloat)heigthWithWidth:(CGFloat)width andFont:(UIFont *)font forText:(NSString *)text
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString: text];
    [attrStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [text length])];
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    return rect.size.height;
}


+ (NSString *) stringFromParams:(NSDictionary *)params
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity: 4];
    for (NSString *key in [params allKeys]) {
        [array addObject:[NSString stringWithFormat:@"%@=%@", key, [params objectForKey: key]]];
    }

    return [array componentsJoinedByString:@"&"];
}


+ (NSString*) generateParams:(NSDictionary*)params
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity: 0];
    for (NSString *key in [params allKeys]) {
        [array addObject:[NSString stringWithFormat:@"%@=%@", key, [params objectForKey:key]]];
    }

    return [array componentsJoinedByString:@"&"];
}




#pragma mark  showloading

+ (void)showLoadingForView:(UIView *)view {
    
//    if (![SVProgressHUD isVisible]) {
//        
//        [SVProgressHUD setBackgroundColor: [Helper colorWithRed:83 green:142 blue:13]];
//        [SVProgressHUD setForegroundColor: [UIColor whiteColor]];
//        [SVProgressHUD showWithMaskType: SVProgressHUDMaskTypeBlack];
//    }
    
    [MBProgressHUD showHUDAddedTo: view animated:YES];
}

+ (void)dismissHUDForView:(UIView *)view {
    //[SVProgressHUD dismiss];
    [MBProgressHUD hideAllHUDsForView: view animated: NO];
}

+ (NSString *)getString:(NSString *)input {
    
    if (!IS_NOT_NULL(input)) {
        input = @"";
    } else {
        input = [input stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    return input;
}

+ (NSNumber *)getNumber:(NSNumber *)input {
    
    if (!IS_NOT_NULL(input)) {
        input = @0;
    }
    
    return input;
}


+ (NSArray *)getArray:(NSArray *)input {
    
    if (!IS_NOT_NULL(input)) {
        input = @[];
    }
    
    return input;
}


+ (CABasicAnimation *)getZoomOutAnimation {
    CABasicAnimation *anim = [CABasicAnimation animation];
    anim.keyPath = @"transform.scale";
    anim.fromValue = [NSNumber numberWithFloat:0.0];
    anim.toValue = [NSNumber numberWithFloat:1];
    anim.removedOnCompletion = NO;
    anim.duration = 0.3;
    anim.fillMode = kCAFillModeBoth;
    return anim;
}


+ (void) getAddressFromLatLon:(CLLocation *)bestLocation
{
    NSLog(@"%f %f", bestLocation.coordinate.latitude, bestLocation.coordinate.longitude);
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:bestLocation
                   completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error){
             NSLog(@"Geocode failed with error: %@", error);
             return;
         }
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         NSLog(@"placemark.ISOcountryCode %@",placemark.ISOcountryCode);
         NSLog(@"locality %@",placemark.locality);
         NSLog(@"postalCode %@",placemark.postalCode);
         
     }];
    
}



+ (void)getAddressFromLocation:(CLLocation *)location complationBlock:(IdResultBlock)completionBlock
{
    //__block CLPlacemark* placemark;
    __block NSString *address = @"";
    
   /* CLGeocoder* geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!IS_NOT_NULL(error) && [placemarks count] > 0)
         {
             placemark = [placemarks lastObject];
             
             NSString *city = [Helper getString: placemark.locality];
             NSString *country = [Helper getString: placemark.country];
             
             if (!city.length) {
                 address = country;
             } else {
                 address = [NSString stringWithFormat:@"%@, %@", city, country];
             }
             
             if (completionBlock) {
                 completionBlock(address, nil);
             }
         } else {
             if (completionBlock) {
                 completionBlock(nil, error);
             }
         }
     }];*/
    
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate: location.coordinate completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
       // NSLog(@"reverse geocoding results:");
        
        if (IS_NOT_NULL(response) && IS_NOT_NULL(response.results) && response.results.count) {
            
            GMSAddress* addressObj = [response.results objectAtIndex:0];
            
            NSString *city = [Helper getString: addressObj.locality];
            //NSString *state = [Helper getString: addressObj.administrativeArea];
            NSString *country = [Helper getString: addressObj.country];
            
            if (city.length) {
                address = city;
            }
            
//            if (state.length) {
//                address = [address stringByAppendingFormat: @", %@", state];
//            }
            
            if (country.length) {
                address = [address stringByAppendingFormat: @", %@", country];
            }
            
            address = [address stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@", "]];
            
            if (completionBlock) {
                completionBlock(address, nil);
            }
            
        } else {
            if (completionBlock) {
                completionBlock(nil, error);
            }
        }
        
    }];
}


@end




