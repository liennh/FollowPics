//
//  PhotoInfo.h
//  FollowPics
//
//  Created by Ngo Hoang Lien on 6/10/17.
//  Copyright © 2017 AlexNgo2412@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoInfo : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *thumbnail;
@property (strong, nonatomic) NSString *url;

- (instancetype)initWithFlickData:(NSDictionary *)data;

@end
