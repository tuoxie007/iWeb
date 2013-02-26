/*
 
 UIView+FrameUtils.m
 
 This is a category on UIView that adds convenience methods that utilize
 FrameUtils operations to resize, move, center, debug log and more for 
 a given UIView's frame. 
 
 Usage instructions/examples are provided in UIView+FrameUtils.h.
 
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

#import "UIView+FrameUtils.h"

@implementation UIView (FrameUtils)

- (void) frameResizeToSize:(CGSize)size
{
    self.frame = [FrameUtils frame:self.frame resizeToSize:size];
}

- (void) frameResizeToWidth:(CGFloat)width height:(CGFloat)height
{
    self.frame = [FrameUtils frame:self.frame resizeToWidth:width height:height];
}

- (void) frameResizeToWidth:(CGFloat)width
{
    self.frame = [FrameUtils frame:self.frame resizeToWidth:width];
}

- (void) frameResizeToHeight:(CGFloat)height
{
    self.frame = [FrameUtils frame:self.frame resizeToHeight:height];
}

- (void) frameResizeByDelta:(CGSize)delta
{
    self.frame = [FrameUtils frame:self.frame resizeByDelta:delta];
}

- (void) frameResizeByWidthDelta:(CGFloat)widthDelta heightDelta:(CGFloat)heightDelta
{
    self.frame = [FrameUtils frame:self.frame resizeByWidthDelta:widthDelta heightDelta:heightDelta];
}

- (void) frameResizeByWidthDelta:(CGFloat)widthDelta
{
    self.frame = [FrameUtils frame:self.frame resizeByWidthDelta:widthDelta];
}

- (void) frameResizeByHeightDelta:(CGFloat)heightDelta
{
    self.frame = [FrameUtils frame:self.frame resizeByHeightDelta:heightDelta];
}

- (void) frameMoveToPosition:(CGPoint)position
{
    self.frame = [FrameUtils frame:self.frame moveToPosition:position];
}

- (void) frameMoveToX:(CGFloat)x y:(CGFloat)y
{
    self.frame = [FrameUtils frame:self.frame moveToX:x y:y];
}

- (void) frameMoveToX:(CGFloat)x
{
    self.frame = [FrameUtils frame:self.frame moveToX:x];
}
- (void) frameMoveToY:(CGFloat)y
{
    self.frame = [FrameUtils frame:self.frame moveToY:y];
}

- (void) frameMoveByDelta:(CGPoint)delta
{
    self.frame = [FrameUtils frame:self.frame moveByDelta:delta];
}

- (void) frameMoveByXDelta:(CGFloat)xDelta yDelta:(CGFloat)yDelta
{
    self.frame = [FrameUtils frame:self.frame moveByXDelta:xDelta yDelta:yDelta];
}

- (void) frameMoveByXDelta:(CGFloat)xDelta
{
    self.frame = [FrameUtils frame:self.frame moveByXDelta:xDelta];
}

- (void) frameMoveByYDelta:(CGFloat)yDelta
{
    self.frame = [FrameUtils frame:self.frame moveByYDelta:yDelta];
}

- (void) frameCenterInFrame:(CGRect)frame
{
    self.frame = [FrameUtils frame:self.frame centerInFrame:frame];
}

- (void) frameCenterHorizontallyInFrame:(CGRect)frame
{
    self.frame = [FrameUtils frame:self.frame centerHorizontallyInFrame:frame]; 
}

- (void) frameCenterVerticallyInFrame:(CGRect)frame
{
    self.frame = [FrameUtils frame:self.frame centerVerticallyInFrame:frame];
}

- (void) frameCenterInParent
{
    [self frameCenterInFrame:self.superview.frame];
}

- (void) frameCenterHorizontallyInParent
{
    [self frameCenterHorizontallyInFrame:self.superview.frame];
}

- (void) frameCenterVerticallyInParent
{
    [self frameCenterVerticallyInFrame:self.superview.frame];
}

- (void) frameFix
{
    self.frame = [FrameUtils fixFrame:self.frame];
}

- (void) framePrintWithLabel:(NSString *)label
{
    [FrameUtils printFrame:self.frame label:label];
}

- (void) framePrint
{
    [FrameUtils printFrame:self.frame];  
}


@end
