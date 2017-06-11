//
//  APIHandler.h
//  FollowPics
//
//  Created by Ngo Hoang Lien on 6/10/17.
//  Copyright © 2017 AlexNgo2412@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIHandler : NSObject

+ (instancetype)sharedHandler;

- (void)getFlickPhotosNearbyLocation:(CLLocation *)location  withBlock:(IdResultBlock)block;

@end
