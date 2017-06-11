//
//  Utils.m
//  FollowPics
//
//  Created by Ngo Hoang Lien on 6/10/17.
//  Copyright © 2017 AlexNgo2412@gmail.com. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (NSDictionary *)getDictionary:(NSDictionary *)input {
    
    if(IS_NOT_NULL(input)) {
    
        return input;
    } else {
        return @{};
    }
}


+ (NSArray *)getArray:(NSArray *)input {
    
    if(IS_NOT_NULL(input)) {
        
        return input;
    } else {
        return @[];
    }
}


+ (NSString *)getString:(NSString *)input {
    
    if(IS_NOT_NULL(input)) {
        
        return [input stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    } else {
        return @"";
    }
}


@end
