//
//  AppModel.m
//  FollowMe
//
//  Created by Staff on 9/21/15.
//  Copyright (c) 2015 Ngo Hoang Lien. All rights reserved.
//

#import "AppModel.h"
#import "Helper.h"
#import "PhotoInfo.h"
@import GoogleMaps;
@import GooglePlaces;

@interface AppModel()

//@property (nonatomic, strong) APIHandler *apiHandler;

@end

@implementation AppModel

+ (void)configureGoogleMapsSDK {
    
    // Google Maps
    if ([kAPIKey length] == 0) {
        // Blow up if APIKey has not yet been set.
        NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
        NSString *format = @"Configure APIKey inside SDKDemoAPIKey.h for your "
        @"bundle `%@`, see README.GoogleMapsSDKDemos for more information";
        @throw [NSException exceptionWithName:@"SDKDemoAppDelegate"
                                       reason:[NSString stringWithFormat:format, bundleId]
                                     userInfo:nil];
    }
    [GMSServices provideAPIKey:kAPIKey];
    [GMSPlacesClient provideAPIKey:kAPIKey];
}



+ (NSArray *)getPhotosFromFlickData:(NSArray *)flickData {
    
    NSMutableArray *listOfPhotos = @[].mutableCopy;
    
    [flickData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        PhotoInfo *photo = [[PhotoInfo alloc] initWithFlickData: obj];
        [listOfPhotos addObject: photo];
    }];
    
    return listOfPhotos;
}


+ (void)setRadiusSettingsIfNeeded {
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    NSNumber *radius = [df objectForKey: kRadius];
    if (!IS_NOT_NULL(radius)) {
        radius = @(5.0); // Km
        [df setObject:radius forKey: kRadius];
        [df synchronize];
    }
}

+ (void)resetRadiusSettings {
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    [df setObject: @(5.0) forKey: kRadius];
    [df synchronize];
}

+ (void)setRadiusSettings:(float)value {
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    [df setObject: @(value) forKey: kRadius];
    [df synchronize];
}

+ (float)getRadiusSettings {
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    NSNumber *radius = [df objectForKey: kRadius];
    return radius.floatValue;
}


@end
