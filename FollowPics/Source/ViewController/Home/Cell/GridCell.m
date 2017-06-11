//
//  GridCell.m
//  FollowPics
//
//  Created by Ngo Hoang Lien on 6/10/17.
//  Copyright © 2017 AlexNgo2412@gmail.com. All rights reserved.
//

#import "GridCell.h"
#import "UIImageView+AFNetworking.h"
#import "PhotoInfo.h"

@implementation GridCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configureCellData:(PhotoInfo *)photo {
    
    [self.imageView setImageWithURL: [NSURL URLWithString: photo.thumbnail] placeholderImage: nil];
}


@end
