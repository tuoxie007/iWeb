//
//  IBQuickScrollbar.m
//  iconsweb
//
//  Created by Ke Xu on 6/18/12.
//  Copyright (c) 2012 Xu Ke. All rights reserved.
//

#import "IBQuickScrollbar.h"

@interface IBQuickScrollbar()
{
    UIView *barView;
    UIView *ballView;
    BOOL draging;
}

- (void)didTouchedAtY:(CGFloat)y;
- (void)hideWithObject:(NSNumber *)hidden;
@end

@implementation IBQuickScrollbar

@synthesize scrollPercents, scrollView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self resetSubviews];
    }
    return self;
}

- (void)resetSubviews
{
    CGFloat width = self.frame.size.width;
    [self frameResizeToWidth:width];
    
    if (barView == nil) {
        barView = [[UIView alloc] init];
    }
    barView.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.7];
    [barView frameResizeToWidth:2 height:self.frame.size.height];
    [barView frameMoveToX:width/2-1];
    [self addSubview:barView];
    
    if (ballView == nil) {
        ballView = [[UIView alloc] init];
    }
    [ballView frameResizeToWidth:width height:width];
    ballView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:1];
    ballView.layer.cornerRadius = width/2;
#en
    [self addSubview:ballView];
}

- (void)setScrollPercents:(CGFloat)_scrollPercents
{
    scrollPercents = MAX(0, MIN(1, _scrollPercents));
    [ballView frameMoveToY:scrollPercents*(self.frame.size.height-ballView.bounds.size.height)];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGFloat y = [touch locationInView:self].y;
    [self didTouchedAtY:y];
    [self hide:NO];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGFloat y = [touch locationInView:self].y;
    [self didTouchedAtY:y];
    [self hide:NO];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hide:YES withDelay:1];
}

- (void)didTouchedAtY:(CGFloat)y
{
    if (y < ballView.bounds.size.height/2) {
        y = ballView.bounds.size.height/2;
    } else if (y > self.bounds.size.height - ballView.bounds.size.height/2) {
        y = self.bounds.size.height - ballView.bounds.size.height/2;
    }
    [ballView frameMoveToY:y-ballView.bounds.size.height/2];
    scrollPercents = (y-ballView.bounds.size.height/2) / (self.bounds.size.height-ballView.bounds.size.height);
    [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, scrollPercents*(scrollView.contentSize.height-scrollView.bounds.size.height))];
}

- (void)hide:(BOOL)hidden
{
    if (barView.hidden != hidden) {
        [UIView animateWithDuration:0.5 animations:^{
            barView.hidden = hidden;
            ballView.hidden = hidden;
        }];
    }
}

- (void)hide:(BOOL)hidden withDelay:(CGFloat)delay
{
    [self performSelector:@selector(hideWithObject:) withObject:[NSNumber numberWithBool:hidden] afterDelay:delay];
}

- (void)hideWithObject:(NSNumber *)hidden
{
    [self hide:hidden.boolValue];
}

@end
