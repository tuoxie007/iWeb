/*
 
 FrameUtils.h
 
 A collection of utilities that simplify common Objective C CGRect/Frame 
 operations such as resizing, moving, centering, debug logging, and more.
 
 USAGE INSTRUCTIONS
 
 Using this class is simple. Simply include the source code from the
 FrameUtils.zip file in your Objective C project, then import this file in
 any file where you would like to use the methods provided by class.
 
 USAGE EXAMPLES
 
 #move a frame to position 0,0
 CGRect movedFrame = [FrameUtils frame:oldFrame moveToX:0 y:0];
 
 #move a frame left by 50 pixels
 CGRect movedFrame = [FrameUtils frame:oldFrame moveByXDelta:-50];
 
 #resize a frame to 50x100
 CGRect resizedFrame = [FrameUtils frame:oldFrame resizeToWidth:50 height:100];
 
 #resize a frame to be 75 pixels wider
 CGRect resizedFrame = [FrameUtils frame:oldFrame resizeByWidthDelta:75];
 
 #center a frame inside another frame
 CGRect centeredFrame = [FrameUtils frame:oldFrame centerInFrame:parentFrame];
 
 #print a frame to NSLog
 [FrameUtils printFrame:oldFrame];
 
 #"fix" a frame (set NAN dimensions to 0, and round all dimensions)
 CGRect fixedFrame = [FrameUtils fixFrame:oldFrame];
 
 If you're using these utilities often on UIView frame objects, consider using
 the UIVIew+FrameUtils category, more info is in UIView+FrameUtils.h. 
 
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

@interface FrameUtils : NSObject

+ (CGRect) frame:(CGRect)frame resizeToSize:(CGSize)newSize;
+ (CGRect) frame:(CGRect)frame resizeToWidth:(CGFloat)width height:(CGFloat)height;
+ (CGRect) frame:(CGRect)frame resizeToWidth:(CGFloat)width;
+ (CGRect) frame:(CGRect)frame resizeToHeight:(CGFloat)height;

+ (CGRect) frame:(CGRect)frame resizeByDelta:(CGSize)delta;
+ (CGRect) frame:(CGRect)frame resizeByWidthDelta:(CGFloat)widthDelta heightDelta:(CGFloat)heightDelta;
+ (CGRect) frame:(CGRect)frame resizeByWidthDelta:(CGFloat)widthDelta;
+ (CGRect) frame:(CGRect)frame resizeByHeightDelta:(CGFloat)heightDelta;

+ (CGRect) frame:(CGRect)frame moveToPosition:(CGPoint)position;
+ (CGRect) frame:(CGRect)frame moveToX:(CGFloat)x y:(CGFloat)y;
+ (CGRect) frame:(CGRect)frame moveToX:(CGFloat)x;
+ (CGRect) frame:(CGRect)frame moveToY:(CGFloat)y;

+ (CGRect) frame:(CGRect)frame moveByDelta:(CGPoint)delta;
+ (CGRect) frame:(CGRect)frame moveByXDelta:(CGFloat)xDelta yDelta:(CGFloat)yDelta;
+ (CGRect) frame:(CGRect)frame moveByXDelta:(CGFloat)xDelta;
+ (CGRect) frame:(CGRect)frame moveByYDelta:(CGFloat)yDelta;

+ (CGRect) frame:(CGRect)frame centerInFrame:(CGRect)parentFrame;
+ (CGRect) frame:(CGRect)frame centerHorizontallyInFrame:(CGRect)parentFrame;
+ (CGRect) frame:(CGRect)frame centerVerticallyInFrame:(CGRect)parentFrame;

+ (CGFloat)fixFrameDim:(CGFloat)dim;
+ (CGRect) fixFrame:(CGRect)frame;

+ (CGRect) frameIpadLandscape;
+ (CGRect) frameIpadPortrait;
+ (CGRect) frameIPhoneLandscape;
+ (CGRect) frameIPhonePortrait;

+ (void) printFrame:(CGRect)frame label:(NSString *)label;
+ (void) printFrame:(CGRect)frame;

@end
