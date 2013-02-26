//
//  IBFavVC.h
//  Icons
//
//  Created by 徐 可 on 3/28/12.
//  Copyright (c) 2012 Xu Ke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IBFavVC : UIViewController
{
    NSURL *_url;
}

- (id)initWithTitle:(NSString *)title forURL:(NSURL *)url withIconURL:(NSURL *)iconURL withScreenshot:(UIImage *)screenshot;

- (void)cancel;
- (void)add;
- (void)iconLoaded:(NSString *)iconFilePath;

@end
