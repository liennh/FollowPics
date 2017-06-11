//
//  ParallaxCell.h
//  FollowPics
//
//  Created by Ngo Hoang Lien on 6/10/17.
//  Copyright © 2017 AlexNgo2412@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NVBnbCollectionViewParallaxCell.h"

@class PhotoInfo;

@interface ParallaxCell : NVBnbCollectionViewParallaxCell

- (void)configureCellData:(PhotoInfo *)photo;

@end
