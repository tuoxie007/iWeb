//
//  VMMiniBrowser.m
//  v2exmobile
//
//  Created by 徐 可 on 3/25/12.
//  Copyright (c) 2012 Xu Ke. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <Twitter/Twitter.h>
#import "IBMainVC.h"

#import "IBWebVC.h"
#import "IBFavVC.h"
#import "IBIconHandler.h"
#import "DBController.h"
#import "MD5.h"
#import "IBPageCache.h"
#import "SVProgressHUD.h"
#import "IBDetachLayoutView.h"

#define TOOLBAR_HEIGHT 35
#define TOOLBAR_ICON_WIDTH 35
#define STATUSBAR_HEIGHT 14

#define HEAD_VIEW_TITLE_TAG 101
#define HEAD_VIEW_URL_TAG 102

#define TOOLBAR_HOME_BUTTON_TAG 201
#define TOOLBAR_BACKWARD_BUTTON_TAG 202
#define TOOLBAR_FORWARD_BUTTON_TAG 203
#define TOOLBAR_RELOAD_BUTTON_TAG 204
#define TOOLBAR_ACTIONS_BUTTON_TAG 205
#define TOOLBAR_BG_TAG 206

#define STATUSBAR_TITLE_TAG 301
#define STATUSBAR_URL_TAG 302
#define STATUSBAR_BG_TAG 303

#define HEAD_VIEW_TITLE_HEIGHT 20
#define HEAD_VIEW_URL_HEIGHT 20

#define HOME_BUTTON_INDEX 0
#define BACKWARD_BUTTON_INDEX 2
#define FORWARD_BUTTON_INDEX 4
#define RELOAD_BUTTON_INDEX 8
#define ACTIONS_BUTTON_INDEX 10

UIScrollView *getScrollViewInWebView(UIWebView *webView)
{
    for (UIView *subview in [webView subviews]) {
        if ([subview isKindOfClass:[UIScrollView class]]) {  
            return (UIScrollView *)subview;
        }
    }
    return nil;
}

@interface IBWebVC()
{
    DBController *db;
    
    UIView *headView;
    UIWebView *_webView;
    UIView *statusbar;
    UIView *statusMask;
    UIToolbar *toolbar;
    UIView *toolbarBorderTop;
    UIActivityIndicatorView *waitingView;
    
    NSMutableArray *history;
    NSInteger historyCurrentIndex;
    BOOL passingHistory;
    
    NSURL *currentURL;
    NSURL *loadingURL;
    BOOL failed;
    BOOL toolbarHidden;
    BOOL toolbarHiddenBeforeDraging;
    BOOL toolbarHiddenForced;
    BOOL webViewZooming;
    BOOL webViewDragging;
}

@end

@implementation IBWebVC

- (id)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        self.view = [[IBDetachLayoutView alloc] initWithViewController:self];
        
        [self setWantsFullScreenLayout:YES];
        db = [[DBController alloc] init];
        [db initDatabase];
        
        statusbar = [[UIView alloc] init];
        [self.view addSubview:statusbar];
        statusbar.clipsToBounds = YES;
        UIView *statusbarBG = [[UIView alloc] init];
        statusbarBG.tag = STATUSBAR_BG_TAG;
        statusbarBG.backgroundColor = [UIColor colorWithWhite:0.9 alpha:.8];
        statusbarBG.layer.cornerRadius = 5;
        statusbarBG.layer.masksToBounds = NO;
        [statusbar addSubview:statusbarBG];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.tag = STATUSBAR_TITLE_TAG;
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textColor = [UIColor colorWithWhite:.3 alpha:1];
        titleLabel.backgroundColor = [UIColor clearColor];
        UILabel *urlLabel = [[UILabel alloc] init];
        urlLabel.tag = STATUSBAR_URL_TAG;
        urlLabel.font = [UIFont systemFontOfSize:12];
        urlLabel.textColor = [UIColor colorWithWhite:.3 alpha:1];
        urlLabel.backgroundColor = [UIColor clearColor];
        [statusbar addSubview:titleLabel];
        [statusbar addSubview:urlLabel];
        
        toolbar = [[UIToolbar alloc] init];
        [self.view addSubview:toolbar];
        toolbar.barStyle = UIBarStyleBlack;
        
        UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon-tool-home-white.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goHome)];
        
        UIBarButtonItem *backwardButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon-tool-backward-white.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
        backwardButton.enabled = NO;
        
        UIBarButtonItem *forwardButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon-tool-forward-white.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goForward)];
        forwardButton.enabled = NO;
        
        UIBarButtonItem *waitingButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        waitingButton.width = TOOLBAR_ICON_WIDTH;
        
        UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon-tool-reload-white.png"] style:UIBarButtonItemStylePlain target:self action:@selector(reload)];
        reloadButton.enabled = NO;
        
        UIBarButtonItem *actionsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon-tool-actions-white.png"] style:UIBarButtonItemStylePlain target:self action:@selector(actions)];
        
        [toolbar setItems:@[homeButton, spacer, backwardButton, spacer, forwardButton, spacer, waitingButton, spacer, reloadButton, spacer,actionsButton]];
        
        waitingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [toolbar addSubview:waitingView];
        
        headView = [[UIView alloc] init];
        headView.backgroundColor = [UIColor colorWithWhite:0 alpha:.3];
        UILabel *titleView = [[UILabel alloc] init];
        titleView.tag = HEAD_VIEW_TITLE_TAG;
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont boldSystemFontOfSize:14];
        titleView.textColor = [UIColor whiteColor];
        titleView.textAlignment = UITextAlignmentCenter;
        [headView addSubview:titleView];
        UILabel *urlView = [[UILabel alloc] init];
        urlView.tag = HEAD_VIEW_URL_TAG;
        urlView.backgroundColor = [UIColor clearColor];
        urlView.font = [UIFont systemFontOfSize:14];
        urlView.textColor = [UIColor whiteColor];
        urlView.textAlignment = UITextAlignmentCenter;
        [headView addSubview:urlView];
        statusMask = [[UIView alloc] init];
        statusMask.backgroundColor = [UIColor whiteColor];
        [headView addSubview:statusMask];
        
        [self renewWithURL:url];
    }
    return self;
}

- (void)renewWithURL:(NSURL *)url
{
    if (history == nil) {
        history = [[NSMutableArray alloc] init];
    } else if (history.count) {
        [history removeAllObjects];
    }
    historyCurrentIndex = 0;
    currentURL = url;
    
    [_webView removeFromSuperview];
    _webView = [[UIWebView alloc] init];
    [self.view addSubview:_webView];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    UIScrollView *scrollView = getScrollViewInWebView(_webView);
    scrollView.delegate = self;
    _webView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:headView];
    _webView.allowsInlineMediaPlayback = YES;
    scrollView.decelerationRate = 1;
    [_webView stopLoading];
    [_webView loadRequest:[NSURLRequest requestWithURL:currentURL]];
    
    [self.view bringSubviewToFront:statusbar];
    [self.view bringSubviewToFront:toolbar];
    
    headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor colorWithWhite:0 alpha:.3];
    UILabel *titleView = [[UILabel alloc] init];
    titleView.tag = HEAD_VIEW_TITLE_TAG;
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont boldSystemFontOfSize:14];
    titleView.textColor = [UIColor whiteColor];
    titleView.textAlignment = UITextAlignmentCenter;
    [headView addSubview:titleView];
    UILabel *urlView = [[UILabel alloc] init];
    urlView.tag = HEAD_VIEW_URL_TAG;
    urlView.backgroundColor = [UIColor clearColor];
    urlView.font = [UIFont systemFontOfSize:14];
    urlView.textColor = [UIColor whiteColor];
    urlView.textAlignment = UITextAlignmentCenter;
    [headView addSubview:urlView];
    statusMask = [[UIView alloc] init];
    statusMask.backgroundColor = [UIColor whiteColor];
    [headView addSubview:statusMask];
    
    for (UIView *subview in scrollView.subviews) {
        if (subview.frame.origin.y < 0) {
            [subview removeFromSuperview];
            [scrollView addSubview:headView];
        }
    }
    [self resetTitle];
    
    UIBarButtonItem *backwardButton = [toolbar.items objectAtIndex:BACKWARD_BUTTON_INDEX];
    UIBarButtonItem *forwardButton = [toolbar.items objectAtIndex:FORWARD_BUTTON_INDEX];
    UIBarButtonItem *reloadButton = [toolbar.items objectAtIndex:RELOAD_BUTTON_INDEX];
    backwardButton.enabled = NO;
    forwardButton.enabled = NO;
    reloadButton.enabled = YES;
}

- (void)goHome
{
    [_webView stopLoading];
    [self dismissModalViewControllerAnimated:NO];
    [[IBMainVC sharedMainVC] cancelSearch];
}

- (void)goBack
{
    passingHistory = YES;
    [_webView goBack];
    historyCurrentIndex -= 1;
    [self resetTitle];
}

- (void)goForward
{
    passingHistory = YES;
    [_webView goForward];
    historyCurrentIndex += 1;
    [self resetTitle];
}

- (void)reload
{
    [_webView reload];
}

- (void)actions
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add to start page", @"Mail this page", @"Share via Twitter", @"Open in Safari", @"Read as Text", @"Copy URL", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
	if ([title isEqualToString:@"Open in Safari"]) {
        [[UIApplication sharedApplication] openURL:currentURL];
    } else if ([title isEqualToString:@"Read as Text"]) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.instapaper.com/text?u=%@", [[currentURL absoluteString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        NSURLRequest *req = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:req];
    } else if ([title isEqualToString:@"Add to start page"]) {
        NSString *title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        NSURL *iconURL;
        NSString *iconURLStr = [_webView stringByEvaluatingJavaScriptFromString:@"(function() {var links = document.querySelectorAll('link'); for (var i=0; i<links.length; i++) {if (links[i].rel.substr(0, 16) == 'apple-touch-icon') return links[i].href;} return "";})();"];
        IBFavVC *favVc;
        NSURL *url = currentURL;
        if (iconURLStr && iconURLStr.length) {
            iconURL = [NSURL URLWithString:iconURLStr];
            favVc = [[IBFavVC alloc] initWithTitle:title forURL:url withIconURL:iconURL withScreenshot:nil];
        } else {
            UIGraphicsBeginImageContext(_webView.bounds.size);
            [_webView.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
            favVc = [[IBFavVC alloc] initWithTitle:title forURL:url withIconURL:nil withScreenshot:viewImage];
        }
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:favVc];
        [self presentModalViewController:nav animated:YES];
    } else if ([title isEqualToString:@"Copy URL"]) {
        [SVProgressHUD showWithStatus:nil];
        [self performSelector:@selector(copyURL) withObject:nil afterDelay:0.1];
    } else if ([title isEqualToString:@"Mail this page"]) {
        NSString *mailto = [NSString stringWithFormat:@"mailto:?&subject=%@&body=%@", [@"Share a page for you" stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding], [currentURL absoluteString]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailto]];
    } else if ([title isEqualToString:@"Share via Twitter"]) {
        [SVProgressHUD showWithStatus:nil];
        [self performSelector:@selector(shareViaTwitter) withObject:nil afterDelay:0.1];
    }
}

- (void)copyURL
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [currentURL absoluteString];
    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"Copied!.\n%@", pasteboard.string]];
}

- (void)shareViaTwitter
{
    if ([TWTweetComposeViewController canSendTweet]) {
        NSString *shortURLStr = [[NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api-ssl.bitly.com/v3/shorten?access_token=d9aef5c6872daafd382d30a3cfe8d889b8363a80&longUrl=%@&format=txt", [currentURL absoluteString]]] encoding:NSASCIIStringEncoding error:nil] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (shortURLStr == nil || shortURLStr.length == 0) {
            shortURLStr = [currentURL absoluteString];
        }
        [SVProgressHUD dismiss];
        TWTweetComposeViewController *twVC = [[TWTweetComposeViewController alloc] init];
        [twVC addURL:[NSURL URLWithString:shortURLStr]];
        twVC.completionHandler = ^(TWTweetComposeViewControllerResult result) {
            switch (result) {
                case TWTweetComposeViewControllerResultCancelled:
                    break;
                case TWTweetComposeViewControllerResultDone:
                    [SVProgressHUD showSuccessWithStatus:@"Twitter Sent"];
                    break;
                default:
                    [SVProgressHUD showErrorWithStatus:@"Twitter send faild"];
                    break;
            }
            [self dismissModalViewControllerAnimated:YES];
        };
        [self presentViewController:twVC animated:YES completion:nil];
    } else {
        [SVProgressHUD showErrorWithStatus:@"Failed to access twitter" duration:1];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self goHome];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    loadingURL = nil;
    
    UIBarButtonItem *backwardButton = [toolbar.items objectAtIndex:BACKWARD_BUTTON_INDEX];
    UIBarButtonItem *forwardButton = [toolbar.items objectAtIndex:FORWARD_BUTTON_INDEX];
    UIBarButtonItem *reloadButton = [toolbar.items objectAtIndex:RELOAD_BUTTON_INDEX];
    backwardButton.enabled = [webView canGoBack];
    forwardButton.enabled = [webView canGoForward];
    reloadButton.enabled = YES;
    [waitingView stopAnimating];
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (failed) {
        failed = NO;
        return;
    }
    failed = NO;
    currentURL = [NSURL URLWithString:[webView stringByEvaluatingJavaScriptFromString:@"window.location.href"]];
    
    if (passingHistory) {
        passingHistory = NO;
    } else {
        if (history.count && historyCurrentIndex < history.count - 1) {
            [history removeObjectsInRange:NSMakeRange(historyCurrentIndex+1, history.count-historyCurrentIndex-1)];
        }
        [history addObject:currentURL];
    }
    historyCurrentIndex += 1;
    
    [self resetTitle];
    if (![db historyExistedWithURL:[currentURL absoluteString]]) {
        [db insertHistory:self.title url:[currentURL absoluteString]];
    }
    [self performSelector:@selector(hideStatusbar) withObject:nil afterDelay:2];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [waitingView startAnimating];
    statusbar.hidden = NO;
    loadingURL = request.URL;
    [self resetTitle];
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (error.code == -999) {
        return;
    }
    [_webView loadHTMLString:[NSString stringWithFormat:@"<html><head><meta id=\"viewport\" name=\"viewport\" content=\"width=device-width; initial-scale=1.0; maximum-scale=1.0;\"/></head><body style=\"padding-top:50px;font-size:20px;text-align:center;\">%@</body></html>", [error localizedDescription]] baseURL:[[webView request] URL]];
    [waitingView stopAnimating];
    [SVProgressHUD showErrorWithStatus:@"Failed loading page"];
    statusbar.hidden = YES;
    failed = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)resetTitle
{
    UILabel *titleView = (UILabel *)[headView viewWithTag:HEAD_VIEW_TITLE_TAG];
    UILabel *urlView = (UILabel *)[headView viewWithTag:HEAD_VIEW_URL_TAG];
    NSString *urlString = [(loadingURL ? loadingURL : currentURL) absoluteString];
    UILabel *titleLabel = (UILabel *)[self.view viewWithTag:STATUSBAR_TITLE_TAG];
    UILabel *urlLabel = (UILabel *)[self.view viewWithTag:STATUSBAR_URL_TAG];
    if (self.title && self.title.length && loadingURL == nil) {
        titleLabel.text = self.title;
        urlLabel.text = [NSString stringWithFormat:@" - %@", urlString];
        titleView.text = self.title;
        urlView.text = urlString;
    } else {
        titleLabel.text = @"Loading";
        urlLabel.text = [NSString stringWithFormat:@" %@", urlString];
        titleView.text = @"";
        urlView.text = urlString;
    }
    
    [titleLabel sizeToFit];
    [urlLabel sizeToFit];
    [titleView sizeToFit];
    [urlView sizeToFit];
    
    [self resetTitleLayout];
}

- (void)viewWillLayoutSubviews
{
    CGFloat ww = self.view.bounds.size.width;
    CGFloat wh = self.view.bounds.size.height;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone &&
        [UIApplication sharedApplication].statusBarOrientation >= UIDeviceOrientationLandscapeRight) {
        
        [self doHideToolbar:YES];
    } else {
        
        wh -= TOOLBAR_HEIGHT;
    }
    
    CGRect frame = CGRectMake(0, 0, ww, wh);
    _webView.frame = frame;
    
    [toolbar frameResizeToWidth:ww height:TOOLBAR_HEIGHT];
    [toolbar frameMoveToY:toolbarHidden ? wh : wh];
    
    [waitingView frameMoveToX:ww/6*3+(ww/6-waitingView.bounds.size.width)/2 y:(toolbar.bounds.size.height-waitingView.bounds.size.height)/2];
    
    [self resetTitleLayout];
    
    [headView frameMoveToY:-wh/2];
    
    UIScrollView *scrollView = getScrollViewInWebView(_webView);
    [headView frameResizeToWidth:scrollView.contentSize.width];
    [headView frameResizeToHeight:wh/2];
    UIView *urlView = [headView viewWithTag:HEAD_VIEW_URL_TAG];
    UIView *titleView = [headView viewWithTag:HEAD_VIEW_TITLE_TAG];
    [titleView frameMoveToY:headView.bounds.size.height-HEAD_VIEW_URL_HEIGHT];
    [titleView frameResizeToWidth:headView.bounds.size.width];
    [urlView frameMoveToY:headView.bounds.size.height-HEAD_VIEW_URL_HEIGHT-HEAD_VIEW_TITLE_HEIGHT];
    [urlView frameResizeToWidth:headView.bounds.size.width];
    
}

- (void)resetTitleLayout
{
    CGRect bounds = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    CGFloat radius = 5, paddingLeft = 5, paddingRight = 5, paddingTop = 0;
    
    statusbar.frame = CGRectMake(-radius, bounds.size.height-STATUSBAR_HEIGHT-(toolbarHidden ? 0 : TOOLBAR_HEIGHT), 0, STATUSBAR_HEIGHT);
    
    UILabel *titleLabel = (UILabel *)[self.view viewWithTag:STATUSBAR_TITLE_TAG];
    UILabel *urlLabel = (UILabel *)[self.view viewWithTag:STATUSBAR_URL_TAG];
    UILabel *statusbarBG = (UILabel *)[self.view viewWithTag:STATUSBAR_BG_TAG];
    [titleLabel frameMoveToY:paddingTop];
    [titleLabel frameMoveToX:radius + paddingLeft];
    [titleLabel frameResizeToWidth:MIN(bounds.size.width/2-10, titleLabel.bounds.size.width)];
    
    [urlLabel frameMoveToY:paddingTop];
    [urlLabel frameMoveToX:titleLabel.frame.origin.x + titleLabel.bounds.size.width];
    
    [statusbar frameResizeToWidth:urlLabel.frame.origin.x + urlLabel.bounds.size.width + paddingRight];
    statusbarBG.frame = CGRectMake(0, 0, statusbar.frame.size.width, statusbar.frame.size.height+radius);
}

- (void)hideStatusbar
{
    if (loadingURL == nil) {
        statusbar.hidden = YES;
    }
}

- (void)doHideToolbar:(BOOL)hidden
{
    if (toolbarHidden != hidden) {
        toolbarHidden = hidden;
        [UIView animateWithDuration:0.3 animations:^{
            CGFloat wh = self.view.bounds.size.height;
            [toolbar frameMoveToY:toolbarHidden ? wh : wh-TOOLBAR_HEIGHT];
            NSLog(@"%f", toolbar.frame.origin.y);
            [statusbar frameMoveToY:toolbarHidden ? wh+TOOLBAR_HEIGHT : wh-STATUSBAR_HEIGHT+STATUSBAR_HEIGHT];
            [_webView frameResizeByHeightDelta:toolbarHidden ? TOOLBAR_HEIGHT : -TOOLBAR_HEIGHT];
        }];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (webViewZooming) {
        return;
    }
    webViewDragging = YES;
    toolbarHiddenBeforeDraging = toolbarHidden;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (webViewZooming) {
        return;
    }
    webViewDragging = NO;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    if (webViewDragging) {
        return;
    }
    webViewZooming = YES;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    if (webViewDragging) {
        return;
    }
    webViewZooming = NO;
    
    [headView frameResizeToWidth:scrollView.contentSize.width];
    UIView *urlView = [headView viewWithTag:HEAD_VIEW_URL_TAG];
    UIView *titleView = [headView viewWithTag:HEAD_VIEW_TITLE_TAG];
    [titleView frameMoveToY:headView.bounds.size.height-HEAD_VIEW_URL_HEIGHT];
    [titleView frameResizeToWidth:headView.bounds.size.width];
    [urlView frameMoveToY:headView.bounds.size.height-HEAD_VIEW_URL_HEIGHT-HEAD_VIEW_TITLE_HEIGHT];
    [urlView frameResizeToWidth:headView.bounds.size.width];
}

@end
