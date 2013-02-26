//
//  IBMainVC.h
//  IconsWebBrowser
//
//  Created by 徐 可 on 3/27/12.
//  Copyright (c) 2012 Xu Ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IBURLSuggestionVC.h"

@class IBWebVC;
@interface IBMainVC : UIViewController <UISearchBarDelegate, UIScrollViewDelegate, UIAlertViewDelegate, IBURLSuggestionDelegate>
{
    BOOL iconEditing;
    BOOL iconMovingDone;
    BOOL iconMoving;
    NSMutableArray *siteOuterViews;
    NSMutableArray *siteIcons;
    NSMutableArray *siteIconBorders;
    NSMutableArray *siteLabels;
    NSMutableArray *siteDeleteButtons;
    UISearchBar *_searchBar;
    UIButton *bgView;
    IBWebVC *webVC;
    CGPoint touchLocation;
    UIImageView *movingSiteIcon;
    UIView *movingOuter;
    NSInteger lastMoveInto;
    UIScrollView *desktop;
    UIPageControl *pageControl;
    IBURLSuggestionVC *suggestionVC;
}

- (void)iconTouched:(UIButton *)icon;
- (void)editIcons:(UILongPressGestureRecognizer *)gesture;
- (void)editIconsDone;
- (void)removeIcon:(UIButton *)deleteButton;
- (void)initIcons;
- (void)cancelSearch;
- (void)siteIconAdded:(NSNotification *)siteInfo;
- (void)resetIconsLocationForSites:(NSArray *)sites fromIndex:(NSInteger)idx;
- (NSInteger)checkMovingIndex;
- (void)pageChanged;
- (void)shakeIcons;
- (void)doShakeIcons:(NSNumber *)ancle;
- (void)viewWillLayoutSubviews;

+ (IBMainVC *)sharedMainVC;

@end
