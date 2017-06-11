//
//  LocationTracker.h
//  TEST
//
//  Created by Ngo Hoang Lien on 3/9/15.
//  Copyright (c) 2015 Ngo Lien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationTracker : NSObject <CLLocationManagerDelegate>

+ (LocationTracker *)sharedLocationTracker;

- (void)startLocationTracking;
- (void)stopLocationTracking;

- (void)startMonitoring;
- (void)stopMonitoring;
- (CLLocation *)currentLocation;

@end
