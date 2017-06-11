//
//  PhotoInfo.m
//  FollowPics
//
//  Created by Ngo Hoang Lien on 6/10/17.
//  Copyright © 2017 AlexNgo2412@gmail.com. All rights reserved.
//

#import "PhotoInfo.h"

@implementation PhotoInfo

- (instancetype)initWithFlickData:(NSDictionary *)data {
    
    self = [super init];
    
    if (self) {
        
        NSInteger farm = [data[@"farm"] integerValue];
        NSInteger server = [data[@"server"] integerValue];
        NSString *photoId = data[@"id"];
        NSString *secret = data[@"secret"];
        
        self.title = [Utils getString: [data objectForKey:@"title"]];
        self.thumbnail = [NSString stringWithFormat: @"http://farm%ld.static.flickr.com/%ld/%@_%@_m.jpg", farm, server, photoId, secret];
        
        self.url = [NSString stringWithFormat: @"http://farm%ld.static.flickr.com/%ld/%@_%@.jpg", farm, server, photoId, secret];
        
    }
    
    return self;
                       
}

@end
