//
//  IBQuickScrollbar.h
//  iconsweb
//
//  Created by Ke Xu on 6/18/12.
//  Copyright (c) 2012 Xu Ke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IBQuickScrollbar : UIView
{
    CGFloat scrollPercents;
    UIScrollView *scrollView;
}

@property (nonatomic, readwrite) CGFloat scrollPercents;
@property (nonatomic, strong) UIScrollView *scrollView;

- (void)resetSubviews;
- (void)hide:(BOOL)hidden;
- (void)hide:(BOOL)hidden withDelay:(CGFloat)delay;

@end
