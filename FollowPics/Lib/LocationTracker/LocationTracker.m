//
//  LocationTracker.m
//  TEST
//
//  Created by Ngo Hoang Lien on 3/9/15.
//  Copyright (c) 2015 Ngo Lien. All rights reserved.
//


#import "LocationTracker.h"
#import "Constants.h"


#define LATITUDE @"latitude"
#define LONGITUDE @"longitude"
#define ACCURACY @"theAccuracy"


@interface LocationTracker()
@property(nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation LocationTracker

+ (LocationTracker *)sharedLocationTracker
{
    // Persistent instance.
    static LocationTracker * _sharedLocationTracker = nil;
    
    if (IS_NOT_NULL(_sharedLocationTracker)) {
        
        return _sharedLocationTracker;
    }
    
    static dispatch_once_t safer;
    dispatch_once(&safer, ^(void) {
        
        _sharedLocationTracker = [[LocationTracker alloc] init];
        
        // private initialization goes here.
        [_sharedLocationTracker startLocationTracking];
    });
    
    
    return _sharedLocationTracker;
    
}//end method "sharedLocationTracker"


- (id)init {
    if (self==[super init]) {
        //Get the share model and also initialize myLocationArray
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        
        
      //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

/*-(void)applicationEnterBackground{
    
    //startLocationTracking
    NSLog(@"applicationEnterBackground. startUpdatingLocation");
    if ([CLLocationManager locationServicesEnabled] == NO) {
        NSLog(@"locationServicesEnabled false");
    } else {
        CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
        
        if(authorizationStatus == kCLAuthorizationStatusDenied || authorizationStatus == kCLAuthorizationStatusRestricted){
            NSLog(@"authorizationStatus failed");
            NSLog(@"locationServicesEnabled false");
        } else {
            NSLog(@"authorizationStatus authorized");
            
            if(IS_OS_8_OR_LATER) {
                [self.locationManager requestAlwaysAuthorization];
            }
            [self.locationManager stopUpdatingLocation];//for saving power
            [self.locationManager startMonitoringSignificantLocationChanges];// only apply if requestAlwaysAuthorization
            
        }
    }
    
}//method
*/

- (void) restartLocationUpdates
{
    NSLog(@"restartLocationUpdates");
    
    [self startLocationTracking];
}

- (void)startMonitoring {
    NSLog(@"startLocationTracking");
    
    if ([CLLocationManager locationServicesEnabled] == NO) {
        NSLog(@"locationServicesEnabled false");
        
        [Helper showAlertLocationDisabled];
        
    } else {
        CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
        
        if(authorizationStatus == kCLAuthorizationStatusDenied || authorizationStatus == kCLAuthorizationStatusRestricted){
            NSLog(@"authorizationStatus failed");
            NSLog(@"locationServicesEnabled false");
            
            [Helper showAlertLocationDisabled];
        } else {
            NSLog(@"authorizationStatus authorized");
            
            if(IS_OS_8_OR_LATER) {
                [self.locationManager requestAlwaysAuthorization];
            }
            [self.locationManager startMonitoringSignificantLocationChanges];
        }
    }
}

- (void)startLocationTracking {
    NSLog(@"startLocationTracking");
    
    if ([CLLocationManager locationServicesEnabled] == NO) {
        NSLog(@"locationServicesEnabled false");
        
        [Helper showAlertLocationDisabled];
        
    } else {
        CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
        
        if(authorizationStatus == kCLAuthorizationStatusDenied || authorizationStatus == kCLAuthorizationStatusRestricted){
            NSLog(@"authorizationStatus failed");
            NSLog(@"locationServicesEnabled false");
            
            [Helper showAlertLocationDisabled];
        } else {
            NSLog(@"authorizationStatus authorized");
            
            if(IS_OS_8_OR_LATER) {
                [self.locationManager requestWhenInUseAuthorization];
            }
            [self.locationManager startUpdatingLocation];
        }
    }
}

- (void)stopMonitoring {
    [self.locationManager stopMonitoringSignificantLocationChanges];
}
- (void)stopLocationTracking {
    NSLog(@"stopLocationTracking");
    [self.locationManager stopUpdatingLocation];
}

- (CLLocation *)currentLocation {
    
    return self.locationManager.location;
}

#pragma mark - CLLocationManagerDelegate Methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    // NSLog(@"locationManager didUpdateLocations");
    
}

- (void)locationManager: (CLLocationManager *)manager didFailWithError: (NSError *)error
{
    NSLog(@"location Manager error:%@",error);
    
    switch([error code])
    {
        case kCLErrorNetwork: // general, network-related error
        {
            [Helper showNoInternetConnectionError];
        }
            break;
        case kCLErrorDenied:{
            [Helper showAlertLocationDisabled];
        }
            break;
        default:
        {
            
        }
            break;
    }
}

@end
