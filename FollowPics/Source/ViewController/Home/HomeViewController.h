//
//  HomeViewController.h
//  FollowPics
//
//  Created by Ngo Hoang Lien on 6/9/17.
//  Copyright © 2017 AlexNgo2412@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NVBnbCollectionView.h"

@interface HomeViewController : UIViewController <NVBnbCollectionViewDataSource, NVBnbCollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tfSearch;
@property (weak, nonatomic) IBOutlet UIView *vFilter;
@property (weak, nonatomic) IBOutlet UIView *navBar;
@property (weak, nonatomic) IBOutlet UIView *vSearch;

@property (weak, nonatomic) IBOutlet UIImageView *iconFilter;


@end
