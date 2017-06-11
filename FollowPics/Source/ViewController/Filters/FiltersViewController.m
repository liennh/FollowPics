//
//  FiltersViewController.m
//  FollowPics
//
//  Created by Ngo Hoang Lien on 6/10/17.
//  Copyright © 2017 AlexNgo2412@gmail.com. All rights reserved.
//

#import "FiltersViewController.h"

@interface FiltersViewController ()

@end

@implementation FiltersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    
    [AppModel setRadiusSettingsIfNeeded];
    
     [self updateGUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView {
    
    [super loadView];
    self.view.frame = [[UIScreen mainScreen] bounds];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - IBAction

- (IBAction)ibaCancel:(id)sender {
    
    if(INTERFACE_IS_PAD) {
        [self dismissViewControllerAnimated: YES completion: nil];
    } else {
        CATransition* transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
        //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self.view removeFromSuperview];
        [self updateGUI];
    }
}

- (IBAction)ibaReset:(id)sender {
    
    [AppModel resetRadiusSettings];
    self.lbRadius.text = @"5 km";
    self.slider.value = [AppModel getRadiusSettings];
}

- (IBAction)ibaSaveFilters:(id)sender {
    
    [AppModel setRadiusSettings: self.slider.value];
    
    // Reload photos
    [[NSNotificationCenter defaultCenter] postNotificationName: kNotificationDidSaveFilters object:nil];
    
    [self ibaCancel: nil];
    
    
}

- (IBAction)ibaSliderChanged:(UISlider *)sender {
    
    self.lbRadius.text = [NSString stringWithFormat: @"%ld km", (NSInteger)sender.value];
}


#pragma mark - Private methods
- (void)updateGUI {
    
    float radius = [AppModel getRadiusSettings];
    self.lbRadius.text = [NSString stringWithFormat: @"%ld km", (NSInteger)radius];
    self.slider.value = radius;
}


@end
