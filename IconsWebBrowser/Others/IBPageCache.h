//
//  IBPageCache.h
//  iconsweb
//
//  Created by 徐 可 on 4/16/12.
//  Copyright (c) 2012 Xu Ke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IBPageCache : NSObject
{
    NSString *cacheId;
    NSString *url;
    NSString *rurl;
    NSString *html;
    NSString *curl;
    NSString *chtml;
    NSDate *update;
}

@property (strong) NSString *cacheId;
@property (strong) NSString *url;
@property (strong) NSString *rurl;
@property (strong) NSString *html;
@property (strong) NSString *curl;
@property (strong) NSString *chtml;
@property (strong) NSDate *update;

- (id)initWithURL:(NSString *)url;
- (id)initWithCacheId:(NSString *)cacheId url:(NSString *)url rurl:(NSString *)rurl html:(NSString *)html curl:(NSString *)curl chtml:(NSString *)chtml update:(NSDate *)update;

@end
