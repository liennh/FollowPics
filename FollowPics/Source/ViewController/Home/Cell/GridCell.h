//
//  GridCell.h
//  FollowPics
//
//  Created by Ngo Hoang Lien on 6/10/17.
//  Copyright © 2017 AlexNgo2412@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PhotoInfo;

@interface GridCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (void)configureCellData:(PhotoInfo *)photo;

@end
