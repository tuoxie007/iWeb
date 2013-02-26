//
//  Commen.h
//  v2exmobile
//
//  Created by 徐 可 on 3/18/12.
//  Copyright (c) 2012 Xu Ke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Helper : NSObject

+ (NSString *)getFilePathWithFilename:(NSString *)filename;
+ (BOOL)hasRetinaDisplay;
+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(CGFloat)radius;
+ (void)printRect:(CGRect)frame;

@end
