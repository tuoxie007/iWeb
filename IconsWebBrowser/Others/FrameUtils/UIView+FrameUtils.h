/*
 
 UIView+FrameUtils.h
 
 This is a category on UIView that adds convenience methods that utilize
 FrameUtils operations to resize, move, center, debug log and more for 
 a given UIView's frame. 
 
 USAGE INSTRUCTIONS
 
 Using this category is simple. Simply include the source code from the
 FrameUtils.zip file in your Objective C project, then import this file in
 any file where you would like to use the methods provided by this category.
 
 USAGE EXAMPLES
 
 #move a UIView's frame to position 0,0
 [view frameMoveToX:0 y:0];
 
 #move a UIView's frame left by 50 pixels
 [view frameMoveByXDelta:-50];
 
 #resize a UIView's frame to 50x100
 [view frameResizeToWidth:50 height:100];
 
 #resize a UIView's frame to be 75 pixels wider
 [view frameResizeByWidthDelta:75];
 
 #center a UIView's frame inside another view's frame
 [view frameCenterInFrame:otherView.frame];
 
 #print a UIView's frame to NSLog
 [view framePrint];
 
 #"fix" a UIView's frame (set NAN dimensions to 0, and round all dimensions)
 [view frameFix];
 
 Additional utility methods are provided in FrameUtils.  
 
 For more information about Objective-C Categories, visit these resources:
 
 - http://en.wikipedia.org/wiki/Objective-C#Categories
 
 - http://developer.apple.com/library/ios/#documentation/cocoa/conceptual/objectivec/chapters/occategories.html
 
 Created by Jason Baker (jason@onejasonforsale.com) 
 & Adam Zacharski (zacharski@gmail.com) for TumbleOn, March 2012.
 
 The latest version of this code is available at www.codercowboy.com.
 
 This code is licensed under the BSD license, a non-viral open source license
 that lets you use this code freely within your own projects without requiring 
 your project itself to also be open source. More information about the BSD 
 license is here:
 
 - http://en.wikipedia.org/wiki/Bsd_license
 
 Copyright (c) 2012, Pocket Sized Giraffe, LLC
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met: 
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer. 
 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution. 
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 The views and conclusions contained in the software and documentation are those
 of the authors and should not be interpreted as representing official policies, 
 either expressed or implied.
 
 */

#import <Foundation/Foundation.h>
#import "FrameUtils.h"

@interface UIView (FrameUtils)

- (void) frameResizeToSize:(CGSize)size;
- (void) frameResizeToWidth:(CGFloat)width height:(CGFloat)height;
- (void) frameResizeToWidth:(CGFloat)width;
- (void) frameResizeToHeight:(CGFloat)height;

- (void) frameResizeByDelta:(CGSize)delta;
- (void) frameResizeByWidthDelta:(CGFloat)widthDelta heightDelta:(CGFloat)heightDelta;
- (void) frameResizeByWidthDelta:(CGFloat)widthDelta;
- (void) frameResizeByHeightDelta:(CGFloat)heightDelta;

- (void) frameMoveToPosition:(CGPoint)position;
- (void) frameMoveToX:(CGFloat)x y:(CGFloat)y;
- (void) frameMoveToX:(CGFloat)x;
- (void) frameMoveToY:(CGFloat)y;

- (void) frameMoveByDelta:(CGPoint)delta;
- (void) frameMoveByXDelta:(CGFloat)xDelta yDelta:(CGFloat)yDelta;
- (void) frameMoveByXDelta:(CGFloat)xDelta;
- (void) frameMoveByYDelta:(CGFloat)yDelta;

- (void) frameCenterInFrame:(CGRect)frame;
- (void) frameCenterHorizontallyInFrame:(CGRect)frame;
- (void) frameCenterVerticallyInFrame:(CGRect)frame;

- (void) frameCenterInParent;
- (void) frameCenterHorizontallyInParent;
- (void) frameCenterVerticallyInParent;

- (void) frameFix;

- (void) framePrintWithLabel:(NSString *)label;
- (void) framePrint;

@end
