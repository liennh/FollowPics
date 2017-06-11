//
//  HomeViewController.m
//  FollowPics
//
//  Created by Ngo Hoang Lien on 6/9/17.
//  Copyright © 2017 AlexNgo2412@gmail.com. All rights reserved.
//

#import "HomeViewController.h"
#import "ParallaxCell.h"
#import "GridCell.h"
#import "APIHandler.h"
#import "PhotoInfo.h"
#import "FiltersViewController.h"
#import "LocationTracker.h"
#import "Header.h"
#import "IDMPhotoBrowser.h"
//#import "FollowPics-Swift.h"
//@import GoogleMaps;
@import GooglePlaces;
@import AASquaresLoading;

#define kHeader                 @"Header"
#define kGridCell               @"GridCell"
#define kParallaxCell           @"ParallaxCell"


@interface HomeViewController ()<GMSAutocompleteViewControllerDelegate, UICollectionViewDelegate>

@property (strong, nonatomic) GMSAutocompleteViewController *searchPlacesController;
@property (strong, nonatomic) FiltersViewController *filterController;

@property (strong, nonatomic) NVBnbCollectionView *collectionView;
@property (assign, nonatomic) NSInteger numberOfItems;
@property (strong, nonatomic) NSArray *photos;

@property (strong, nonatomic) CLLocation *location; // used to filter

@property (assign, nonatomic) CGFloat previousScrollViewYOffset;

@property (strong, nonatomic) AASquaresLoading *vLoading;


@end



@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    self.vFilter.layer.cornerRadius = self.vFilter.frame.size.height/2.0;
    self.vFilter.layer.borderWidth = 1.0;
    self.vFilter.layer.borderColor = [[Helper colorWithRed:52 green:196 blue:186] CGColor];
    self.iconFilter.image = [self.iconFilter.image imageTintedWithColor: [Helper colorWithRed:52 green:196 blue:186]];
    
    self.photos = @[];
    
    NVBnbCollectionViewLayout *layout = [[NVBnbCollectionViewLayout alloc] init];
    layout.currentOrientation = UIInterfaceOrientationPortrait;
    layout.headerSize = CGSizeMake(self.view.frame.size.width, 70);
    
    _collectionView = [[NVBnbCollectionView alloc] initWithFrame:CGRectMake(0, 78, self.view.frame.size.width, self.view.frame.size.height-78) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
   
    
    [self.view addSubview: self.collectionView];
    [self.view bringSubviewToFront: self.vFilter];

    
    
    [_collectionView registerNib:[UINib nibWithNibName:kHeader bundle:nil] forSupplementaryViewOfKind:NVBnbCollectionElementKindHeader withReuseIdentifier:kHeader];
    
    [_collectionView registerNib:[UINib nibWithNibName:kGridCell bundle:nil] forCellWithReuseIdentifier: kGridCell];
    
    [_collectionView registerNib:[UINib nibWithNibName:kParallaxCell bundle:nil] forCellWithReuseIdentifier: kParallaxCell];
    
    self.location = [LocationTracker sharedLocationTracker].currentLocation;
    
    if(IS_NOT_NULL(self.location)) {
        [self loadPhotosNearbyLocation: self.location];
    }
    
    [self subscribeToNotifications];
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

- (void)viewWillLayoutSubviews {
    
    CGRect rect;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if(!([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait)) {
            
            // if (self.view.bounds.size.width > self.view.bounds.size.height) {
            // Landscape
            rect = self.collectionView.frame;
            rect.size.width = self.view.bounds.size.width;
            rect.size.height = self.view.bounds.size.height - 78;
            
        } else {
            rect = self.collectionView.frame;
            rect.size.width = self.view.bounds.size.width;
            rect.size.height = self.view.bounds.size.height - 78;
        }
        
        self.collectionView.frame = rect;
    }
}

#pragma mark - IBAction
- (IBAction)ibaSearch:(id)sender {
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self presentSearchPlacesControllerOnPad];
    } else {
        [self presentSearchPlacesControllerOnPhone];
    }
    
    
}

- (IBAction)ibaFilter:(id)sender {
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self presentFiltersOnPad];
    } else {
        [self presentFiltersOnPhone];
    }
}


#pragma mark - GMSAutocompleteViewControllerDelegate

- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    
    self.tfSearch.text = place.name;
    
    [self dismissViewControllerAnimated: NO completion: nil];
    
    [self showSearchResultControllerForPlace: place];
    
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    __typeof (self) __weak weakSelf = self;
    
    [self dismissViewControllerAnimated: NO completion:^{
        __typeof (weakSelf) __strong strongSelf = weakSelf;
        
        strongSelf.searchPlacesController = nil;
    }];
}

- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    __typeof (self) __weak weakSelf = self;
    
    [self dismissViewControllerAnimated: NO completion:^{
        __typeof (weakSelf) __strong strongSelf = weakSelf;
        
        strongSelf.searchPlacesController = nil;
    }];
}

#pragma mark - Private Methods

- (void)showLoading {
    
    if(!IS_NOT_NULL(self.vLoading)) {
        _vLoading = [[AASquaresLoading alloc] initWithTarget: self.view size:40];
        _vLoading.color = [Helper colorWithRed:52 green:196 blue:186];
    }
    
    [self.vLoading start:0];
}

- (void)stopLoading {
    
    [self.vLoading stop:0.5];
}

- (void)showSearchResultControllerForPlace:(GMSPlace *)place {
    
    self.location = [[CLLocation alloc] initWithLatitude: place.coordinate.latitude longitude: place.coordinate.longitude];
    
    [self loadPhotosNearbyLocation: self.location];
}

- (void)loadPhotosNearbyLocation:(CLLocation *)location {
    __typeof (self) __weak weakSelf = self;
    
    [self showLoading];
    
    [[APIHandler sharedHandler] getFlickPhotosNearbyLocation: location withBlock:^(NSArray *object, NSError *error) {
        __typeof (weakSelf) __strong strongSelf = weakSelf;
        strongSelf.photos = object;
        [strongSelf.collectionView reloadData];
        [strongSelf.collectionView setContentOffset:CGPointZero animated: NO];
        
        [strongSelf stopLoading];
        
    }];
}


- (void)presentSearchPlacesControllerOnPhone {
    
    if (!IS_NOT_NULL(_searchPlacesController)) {
        _searchPlacesController = [[GMSAutocompleteViewController alloc] init];
        _searchPlacesController.delegate = self;
    }
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController presentViewController: _searchPlacesController animated: NO completion:nil];
    
    
    // Work around an iOS bug where the main event loop sometimes doesn't wake up to process the
    // presentation of the view controller (http://openradar.appspot.com/19563577).
    dispatch_async(dispatch_get_main_queue(), ^{});
}

- (void)presentSearchPlacesControllerOnPad {
    
    if (!IS_NOT_NULL(_searchPlacesController)) {
        _searchPlacesController = [[GMSAutocompleteViewController alloc] init];
        _searchPlacesController.delegate = self;
    }
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: _searchPlacesController];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:nav animated:YES completion:NULL];
}

- (void)showPhotosBrowserAtIndexPath:(NSIndexPath *)indexPath {
    
    // Create an array to store IDMPhoto objects
    NSMutableArray *photosArray = [NSMutableArray new];
    
    for (PhotoInfo *item in self.photos) {
        NSURL *url = [NSURL URLWithString: item.url];
        IDMPhoto *photo = [IDMPhoto photoWithURL:url];
        photo.caption = item.title;
        [photosArray addObject:photo];
    }
    
    
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photosArray animatedFromView:nil];
    [browser setInitialPageIndex: indexPath.row];
    browser.usePopAnimation = YES;
    browser.displayArrowButton = NO;
    [self presentViewController:browser animated:YES completion:nil];
}

- (void)presentFiltersOnPad {
    FiltersViewController *controller = [[FiltersViewController alloc] initWithNibName:@"FiltersViewController" bundle: nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: controller];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:nav animated:YES completion:NULL];
}


- (void)presentFiltersOnPhone {
    
    if (!IS_NOT_NULL(self.filterController)) {
        
        _filterController = [[FiltersViewController alloc] initWithNibName:@"FiltersViewController" bundle: nil];
    }
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController.view addSubview: _filterController.view];
}

#pragma mark - Notifications

- (void)subscribeToNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(didSaveFilters:) name:kNotificationDidSaveFilters object:nil];
}

- (void)unsubscribeToNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void)didSaveFilters:(NSNotification *)noti {
    
    if(IS_NOT_NULL(self.location)) {
        [self loadPhotosNearbyLocation: self.location];
    }
}


#pragma mark - NVBnbCollectionViewDataSource

- (NSInteger)numberOfItemsInBnbCollectionView:(NVBnbCollectionView *)collectionView {
    _numberOfItems = self.photos.count;
    return _numberOfItems;
}

- (UICollectionViewCell *)bnbCollectionView:(NVBnbCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: kGridCell forIndexPath:indexPath];
    
    PhotoInfo *photo = self.photos[indexPath.row];
    [cell configureCellData: photo];
    
    return cell;
}

- (NVBnbCollectionViewParallaxCell *)bnbCollectionView:(NVBnbCollectionView *)collectionView parallaxCellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ParallaxCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: kParallaxCell forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    PhotoInfo *photo = self.photos[indexPath.row];
    [cell configureCellData: photo];
    
    return cell;
}

- (UICollectionReusableView *)bnbCollectionView:(NVBnbCollectionView *)collectionView headerAtIndexPath:(NSIndexPath *)indexPath {
    Header *header = [_collectionView dequeueReusableSupplementaryViewOfKind: NVBnbCollectionElementKindHeader withReuseIdentifier:kHeader forIndexPath:indexPath];
    
    if(_numberOfItems > 1) {
        header.lbTitle.text = [NSString stringWithFormat:@"%ld Photos", _numberOfItems];
    } else if(_numberOfItems == 1) {
        header.lbTitle.text = [NSString stringWithFormat:@"%ld Photo", _numberOfItems];
    } else {
        header.lbTitle.text = @"";// @"No Photos";
    }
    //header.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    
    return header;
}

- (UIView *)bnbCollectionView:(NVBnbCollectionView *)collectionView moreLoaderAtIndexPath:(NSIndexPath *)indexPath {
    UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    view.color = [UIColor darkGrayColor];
    [view startAnimating];
    
    return view;
}

#pragma mark - NVBnbCollectionViewDelegate

- (void)loadMoreInBnbCollectionView:(NVBnbCollectionView *)collectionView {
    NSLog(@"loadMoreInBnbCollectionView:");
//    if (_numberOfItems > _numberOfItems) {
//        collectionView.enableLoadMore = false;
//        
//        return;
//    }
//    _numberOfItems += 10;
//    collectionView.loadingMore = false;
//    [collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self showPhotosBrowserAtIndexPath: indexPath];
}

#pragma mark - Hide Navigation Bar when scrolling
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect frame = self.navBar.frame;
    CGFloat size = frame.size.height - 21;
    CGFloat framePercentageHidden = ((20 - frame.origin.y) / (frame.size.height - 1));
    CGFloat scrollOffset = scrollView.contentOffset.y;
    CGFloat scrollDiff = scrollOffset - self.previousScrollViewYOffset;
    CGFloat scrollHeight = scrollView.frame.size.height;
    CGFloat scrollContentSizeHeight = scrollView.contentSize.height + scrollView.contentInset.bottom;
    
    if (scrollOffset <= -scrollView.contentInset.top) {
        frame.origin.y = 20;
    } else if ((scrollOffset + scrollHeight) >= scrollContentSizeHeight) {
        frame.origin.y = -size;
    } else {
        //frame.origin.y = MIN(20, MAX(-size, frame.origin.y - scrollDiff));
        frame.origin.y = MIN(20,
                             MAX(-size, frame.origin.y -
                                 (frame.size.height * (scrollDiff / scrollHeight))));
    }
    
    if(frame.origin.y > 0) {
        frame.origin.y = 0;
    }
    
    [self.navBar setFrame:frame];
    [self updateBarButtonItems:(1 - framePercentageHidden)];
    self.previousScrollViewYOffset = scrollOffset;
    
    frame = self.collectionView.frame;
    frame.origin.y = self.navBar.frame.origin.y + self.navBar.frame.size.height;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        frame.size.height = [[UIScreen mainScreen] bounds].size.height - frame.origin.y;
    } else {
        frame.size.height = [[UIScreen mainScreen] bounds].size.height - frame.origin.y;
    }
    
    self.collectionView.frame = frame;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self stoppedScrolling];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self stoppedScrolling];
    }
}

- (void)stoppedScrolling {
}

- (void)updateBarButtonItems:(CGFloat)alpha {
    
    self.vSearch.alpha = alpha;
    self.tfSearch.alpha = alpha;
}

- (void)animateNavBarTo:(CGFloat)y
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.navBar.frame;
        CGFloat alpha = (frame.origin.y >= y ? 0 : 1);
        frame.origin.y = y;
        
        if(frame.origin.y > 0) {
            frame.origin.y = 0;
        }
        
        [self.navBar setFrame:frame];
        [self updateBarButtonItems:alpha];
        
        frame = self.collectionView.frame;
        frame.origin.y = self.navBar.frame.origin.y + self.navBar.frame.size.height;
        frame.size.height = [[UIScreen mainScreen] bounds].size.height - frame.origin.y;
        self.collectionView.frame = frame;
        
    }];
}

- (void)dealloc {
    [self unsubscribeToNotifications];
}
@end
