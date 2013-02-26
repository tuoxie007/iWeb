//
//  IBFavVC.m
//  Icons
//
//  Created by 徐 可 on 3/28/12.
//  Copyright (c) 2012 Xu Ke. All rights reserved.
//

#import "IBFavVC.h"
#import "ImageLoader.h"
#import "Helper.h"
#import "MD5.h"

#define WINDOW_WIDTH 320
#define NAV_HEIGHT 44

#define ICON_TAG 1
#define SITE_NAME_TAG 2

@implementation IBFavVC

- (id)initWithTitle:(NSString *)title forURL:(NSURL *)url withIconURL:(NSURL *)iconURL withScreenshot:(UIImage *)screenshot
{
    self = [super init];
    if (self) {
        _url = url;
        self.view.backgroundColor = [UIColor whiteColor];
        self.title = @"Add to Start Page";
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"Canel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
        UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleDone target:self action:@selector(add)];
        self.navigationItem.leftBarButtonItem = cancelItem;
        cancelItem.action = @selector(cancel);
        self.navigationItem.rightBarButtonItem = addItem;
        addItem.action = @selector(add);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(iconLoaded:) name:@"IconLoaded" object:nil];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 80, 57, 57)];
        icon.tag = ICON_TAG;
        [self.view addSubview:icon];
        
        if (screenshot) {
            icon.image = screenshot;
        } else {
            ImageLoader *imgLoader = [[ImageLoader alloc] init];
            if (iconURL) {
                [imgLoader loadImageWithURL:iconURL forImageView:icon];
            } else {
                NSInteger iconWidth;
                CGFloat width = [UIScreen mainScreen].bounds.size.width;
                if (width == 640) {
                    iconWidth = 114;
                } else {
                    iconWidth = 57;
                }
                NSString *iconURL1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/apple-touch-icon-%dx%d-precomposed.png", [url scheme], [url host], iconWidth, iconWidth]];
                NSString *iconURL2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/apple-touch-icon-%dx%d.png", [url scheme], [url host], iconWidth, iconWidth]];
                NSString *iconURL3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/apple-touch-icon-precomposed.png", [url scheme], [url host]]];
                NSString *iconURL4 = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/apple-touch-icon.png", [url scheme], [url host]]];
                NSArray *iconURLs = [NSArray arrayWithObjects:iconURL1, iconURL2, iconURL3, iconURL4, nil];
                [imgLoader loadImageForImageView:icon inURLs:iconURLs];
            }
        }
        UIImageView *borderImageView = [[UIImageView alloc] initWithFrame:icon.frame];
        borderImageView.image = [UIImage imageNamed:@"desktop-icon-bg.png"];
        [self.view addSubview:borderImageView];
        
        UITextField *siteName = [[UITextField alloc] initWithFrame:CGRectMake(icon.frame.origin.x+icon.frame.size.width+icon.frame.origin.x, icon.frame.origin.y+10, WINDOW_WIDTH-icon.frame.origin.x*3-icon.frame.size.width, icon.frame.size.height-10*2)];
        siteName.font = [UIFont systemFontOfSize:20];
        siteName.text = title;
        siteName.tag = SITE_NAME_TAG;
        [self.view addSubview:siteName];
        siteName.borderStyle = UITextBorderStyleRoundedRect;
    }
    return self;
}

- (void)cancel
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)add
{
    UIImageView * iconImageView = (UIImageView *)[self.view viewWithTag:ICON_TAG];
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSString *filePath = [Helper getFilePathWithFilename:[NSString stringWithFormat:@"%@.png", [[date description] md5]]];
    [UIImagePNGRepresentation(iconImageView.image) writeToFile:filePath atomically:YES];
    NSString *siteName = ((UITextField *)[self.view viewWithTag:SITE_NAME_TAG]).text;
    NSDictionary *siteInfo = [NSDictionary dictionaryWithObjectsAndKeys:filePath, @"icon", siteName, @"name", [_url description], @"url", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SiteIconAdded" object:siteInfo];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)iconLoaded:(NSString *)iconFilePath
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
