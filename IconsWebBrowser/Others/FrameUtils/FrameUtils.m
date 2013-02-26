/*
 
 FrameUtils.m
 
 A collection of utilities that simplify common Objective C CGRect/Frame 
 operations such as resizing, moving, centering, debug logging, and more.
 
 Usage instructions/examples are provided in FrameUtils.h.
 
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

#import "FrameUtils.h"

@implementation FrameUtils

+ (CGRect) frame:(CGRect)frame resizeToSize:(CGSize)newSize
{
    return CGRectMake(frame.origin.x, frame.origin.y, newSize.width, newSize.height);
}

+ (CGRect) frame:(CGRect)frame resizeToWidth:(CGFloat)width height:(CGFloat)height
{
    return CGRectMake(frame.origin.x, frame.origin.y, width, height);
}

+ (CGRect) frame:(CGRect)frame resizeToWidth:(CGFloat)width
{
    return CGRectMake(frame.origin.x, frame.origin.y, width, frame.size.height);
}

+ (CGRect) frame:(CGRect)frame resizeToHeight:(CGFloat)height
{
    return CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height);
}

+ (CGRect) frame:(CGRect)frame resizeByDelta:(CGSize)delta
{
    return CGRectMake(frame.origin.x, frame.origin.y, frame.size.width + delta.width, frame.size.height + delta.height);
}

+ (CGRect) frame:(CGRect)frame resizeByWidthDelta:(CGFloat)widthDelta heightDelta:(CGFloat)heightDelta
{
    return CGRectMake(frame.origin.x, frame.origin.y, frame.size.width + widthDelta, frame.size.height + heightDelta);
}

+ (CGRect) frame:(CGRect)frame resizeByWidthDelta:(CGFloat)widthDelta
{
    return CGRectMake(frame.origin.x, frame.origin.y, frame.size.width + widthDelta, frame.size.height);
}

+ (CGRect) frame:(CGRect)frame resizeByHeightDelta:(CGFloat)heightDelta
{
    return CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height + heightDelta);
}

+ (CGRect) frame:(CGRect)frame moveToPosition:(CGPoint)position
{
    return CGRectMake(position.x, position.y, frame.size.width, frame.size.height);
}

+ (CGRect) frame:(CGRect)frame moveToX:(CGFloat)x y:(CGFloat)y
{
    return CGRectMake(x, y, frame.size.width, frame.size.height);
}

+ (CGRect) frame:(CGRect)frame moveToX:(CGFloat)x
{
    return CGRectMake(x, frame.origin.y, frame.size.width, frame.size.height);
}

+ (CGRect) frame:(CGRect)frame moveToY:(CGFloat)y
{
    return CGRectMake(frame.origin.x, y, frame.size.width, frame.size.height);
}


+ (CGRect) frame:(CGRect)frame moveByDelta:(CGPoint)delta
{
    return CGRectMake(frame.origin.x + delta.x, frame.origin.y + delta.y, frame.size.width, frame.size.height);
}

+ (CGRect) frame:(CGRect)frame moveByXDelta:(CGFloat)xDelta yDelta:(CGFloat)yDelta
{
    return CGRectMake(frame.origin.x + xDelta, frame.origin.y + yDelta, frame.size.width, frame.size.height);
}

+ (CGRect) frame:(CGRect)frame moveByXDelta:(CGFloat)xDelta
{
    return CGRectMake(frame.origin.x + xDelta, frame.origin.y, frame.size.width, frame.size.height);
}

+ (CGRect) frame:(CGRect)frame moveByYDelta:(CGFloat)yDelta
{
    return CGRectMake(frame.origin.x, frame.origin.y + yDelta, frame.size.width, frame.size.height);
}

+ (CGRect) frame:(CGRect)frame centerInFrame:(CGRect)parentFrame
{
    CGFloat x = parentFrame.origin.x + ((parentFrame.size.width - frame.size.width) / 2);
    CGFloat y = parentFrame.origin.y + ((parentFrame.size.height - frame.size.height) / 2);
    return [FrameUtils frame:frame moveToX:x y:y];
}

+ (CGRect) frame:(CGRect)frame centerHorizontallyInFrame:(CGRect)parentFrame
{
    CGFloat x = parentFrame.origin.x + ((parentFrame.size.width - frame.size.width) / 2);
    return [FrameUtils frame:frame moveToX:x];
}

+ (CGRect) frame:(CGRect)frame centerVerticallyInFrame:(CGRect)parentFrame
{
    CGFloat y = parentFrame.origin.y + ((parentFrame.size.height - frame.size.height) / 2);
    return [FrameUtils frame:frame moveToY:y];
}

+ (CGFloat)fixFrameDim:(CGFloat)dim
{
    if (isnan(dim))
    {
        return 0.0f;
    }
    return round(dim);
}

+ (CGRect) fixFrame:(CGRect)frame
{
    return CGRectMake([FrameUtils fixFrameDim:frame.origin.x], 
                      [FrameUtils fixFrameDim:frame.origin.y], 
                      [FrameUtils fixFrameDim:frame.size.width],
                      [FrameUtils fixFrameDim:frame.size.height]);
}

+ (CGRect) frameIpadLandscape
{
    return CGRectMake(0.0f, 0.0f, 1024.0f, 768.0f);
}

+ (CGRect) frameIpadPortrait
{
    return CGRectMake(0.0f, 0.0f, 768.0f, 1024.0f);
}

+ (CGRect) frameIPhoneLandscape
{
    return CGRectMake(0.0f, 0.0f, 480.0f, 320.0f);
}

+ (CGRect) frameIPhonePortrait
{
    return CGRectMake(0.0f, 0.0f, 320.0f, 480.0f);
}

+ (void) printFrame:(CGRect)frame label:(NSString *)label
{
    CGFloat ratio = frame.size.width / frame.size.height;
    NSLog(@"Frame: %@, origin: %dx%d, size: %dx%d, ratio (w/h): %2.2f", ((label == nil) ? @"" : label), 
          (int) frame.origin.x, (int) frame.origin.y, (int) frame.size.width, (int) frame.size.height, ratio);
}

+ (void) printFrame:(CGRect)frame
{
    [FrameUtils printFrame:frame label:nil];
}




@end
