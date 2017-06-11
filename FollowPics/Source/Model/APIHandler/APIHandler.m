//
//  APIHandler.m
//  FollowPics
//
//  Created by Ngo Hoang Lien on 6/10/17.
//  Copyright © 2017 AlexNgo2412@gmail.com. All rights reserved.
//

#import "APIHandler.h"
#import <AFNetworking/AFNetworking.h>
#import "LocationTracker.h"

@interface APIHandler()

@property (strong, nonatomic) AFURLSessionManager *manager;

@end

@implementation APIHandler

+ (instancetype)sharedHandler {
    
    // Persistent instance.
    static APIHandler *sharedHandler = nil;
    
    if (IS_NOT_NULL(sharedHandler)) {
        return sharedHandler;
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHandler = [[self alloc] init];
    });
    
    return sharedHandler;
}

- (instancetype)init {
    
    self = [super init];
    if (IS_NOT_NULL(self)) {
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    }
    
    return self;
}


- (void)getFlickPhotosNearbyLocation:(CLLocation *)location  withBlock:(IdResultBlock)block {
    
    double latitude = location.coordinate.latitude;
    double longitude = location.coordinate.longitude;
    float radius = [AppModel getRadiusSettings];
    
    NSString *urlString = [NSString stringWithFormat: @"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&lat=%f&lon=%f&radius=%f&format=json&nojsoncallback=1", kFlickAPIKey, latitude, longitude, radius];
    NSURL *URL = [NSURL URLWithString: urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [self.manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        NSArray *photos = @[];
        
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSDictionary *data = [Utils getDictionary: [responseObject objectForKey: @"photos"]];
            NSArray *flickPhotos = [Utils getArray: [data objectForKey: @"photo"]];
            photos = [AppModel getPhotosFromFlickData: flickPhotos];
        }
        
        if(block) {
            block(photos, error);
        }
    }];
    [dataTask resume];
    
}

@end
