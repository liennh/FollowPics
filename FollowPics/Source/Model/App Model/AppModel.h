//
//  AppModel.h
//  FollowMe
//
//  Created by Staff on 9/21/15.
//  Copyright (c) 2015 Ngo Hoang Lien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppModel : NSObject

+ (void)configureGoogleMapsSDK;
+ (NSArray *)getPhotosFromFlickData:(NSArray *)flickData;

+ (void)setRadiusSettingsIfNeeded;
+ (void)resetRadiusSettings;

+ (void)setRadiusSettings:(float)value;
+ (float)getRadiusSettings;


@end
