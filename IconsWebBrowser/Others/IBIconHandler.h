//
//  IBIconHandler.h
//  IconsWebBrowser
//
//  Created by 徐 可 on 3/27/12.
//  Copyright (c) 2012 Xu Ke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IBIconHandler : NSObject
{
    NSArray *sites;
}

@property (strong) NSArray *sites;


+ (IBIconHandler *)getInstance;
+ (NSArray *)sites;
+ (void)saveNewSites:(NSArray *)newSites;
+ (void)addNewSite:(NSDictionary *)newSite;

@end
