//
//  VMMiniBrowser.h
//  v2exmobile
//
//  Created by 徐 可 on 3/25/12.
//  Copyright (c) 2012 Xu Ke. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBController;
@interface IBWebVC : UIViewController <UIWebViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate>

- (id)initWithURL:(NSURL *)url;
- (void)renewWithURL:(NSURL *)url;

@end
