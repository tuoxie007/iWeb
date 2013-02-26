//
//  ImagLoader.m
//  v2exmobile
//
//  Created by 徐 可 on 3/16/12.
//  Copyright (c) 2012 Xu Ke. All rights reserved.
//
#import "ImageLoader.h"
#import "MD5.h"
#import "Helper.h"

@implementation ImageLoader

- (void)loadImageWithURL:(NSURL *)url forImageView:(UIImageView *)imgView
{
    NSString *encodedUrl = [[url description] md5];
    cacheFilePath = [Helper getFilePathWithFilename:[NSString stringWithFormat:@"%@.png", encodedUrl]];
    
    NSData *imgData = [[NSData alloc] initWithContentsOfFile:cacheFilePath];
    if ([imgData length]) {
//        imgView.image = [[UIImage alloc] initWithData:imgData];
//        return;
    }
    
    imageView = imgView;
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
    NSLog(@"%@", url);
    connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    webdata = [[NSMutableData alloc] init];
}

- (void)loadImageForImageView:(UIImageView *)imgView inURLs:(NSArray *)urls
{
    urlChoices = urls;
    currentURLIdx = 0;
    [self loadImageWithURL:[urlChoices objectAtIndex:currentURLIdx] forImageView:imgView];
}

- (void)loadImageWithURL:(NSURL *)url forImageButton:(UIButton *)imgButton
{
    NSString *encodedUrl = [[url description] md5];
    cacheFilePath = [Helper getFilePathWithFilename:[NSString stringWithFormat:@"%@.png", encodedUrl]];
    
    NSData *imgData = [[NSData alloc] initWithContentsOfFile:cacheFilePath];
    if ([imgData length]) {
        UIImage *img = [[UIImage alloc] initWithData:imgData];
        CGSize imgSize = [img size];
        if (imgSize.width < imgSize.height) {
            imgButton.frame = CGRectMake(imgButton.frame.origin.x, imgButton.frame.origin.y, imgButton.frame.size.width*imgSize.width/imgSize.height, imgButton.frame.size.height);
        }
        [imgButton setImage:img forState:UIControlStateNormal];
        return;
    }
    
    imageButton = imgButton;
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
    connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    webdata = [[NSMutableData alloc] init];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    imageView.image = [[UIImage alloc] initWithData:webdata];
    [webdata writeToFile:cacheFilePath atomically:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"IconLoaded" object:cacheFilePath];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webdata appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (urlChoices) {
        if (currentURLIdx >= [urlChoices count]) {
            [self loadImageWithURL:[urlChoices objectAtIndex:++currentURLIdx] forImageView:imageView];
        } else {
            NSLog(@"Image Load Failed");
        }
    } else {
        NSLog(@"Image Load Failed");
    }
}

@end