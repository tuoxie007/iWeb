//
//  IBDetachLayoutView.h
//  iconsweb
//
//  Created by Xu Ke on 6/24/12.
//  Copyright (c) 2012 Xu Ke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IBDetachLayoutView : UIView
{
    id mainVC;
}

- (id)initWithViewController:(id)_mainVC;
@end