//
//  IBPageCache.m
//  iconsweb
//
//  Created by 徐 可 on 4/16/12.
//  Copyright (c) 2012 Xu Ke. All rights reserved.
//

#import "IBPageCache.h"
#import "MD5.h"

@implementation IBPageCache
@synthesize cacheId, url, rurl, html, curl, chtml, update;

- (id)initWithURL:(NSString *)_url
{
    self = [super init];
    if (self) {
        self.url = _url;
        self.cacheId = [_url md5];
    }
    return self;
}

- (id)initWithCacheId:(NSString *)_cacheId url:(NSString *)_url rurl:(NSString *)_rurl html:(NSString *)_html curl:(NSString *)_curl chtml:(NSString *)_chtml update:(NSDate *)_update
{
    self = [super init];
    if (self) {
        self.cacheId = _cacheId;
        self.url = _url;
        self.rurl = _rurl;
        self.html = _html;
        self.curl = _curl;
        self.chtml = _chtml;
        self.update = _update;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"{\n\tcacheId: %@,\n\turl:%@,\n\trurl:%@,\n\tcurl:%@,\n}", self.cacheId, self.url, self.rurl, self.curl];
}

@end
