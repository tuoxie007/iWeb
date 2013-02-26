//
//  DataController.m
//  iconsweb
//
//  Created by 徐 可 on 4/16/12.
//  Copyright (c) 2012 Xu Ke. All rights reserved.
//

#import "DBController.h"
#import "Helper.h"
#import "IBPageCache.h"

@implementation DBController

- (void)initDatabase
{
    NSString *databasePath = [Helper getFilePathWithFilename:@"sqlite.db"];
    
    bool databaseAlreadyExists = [[NSFileManager defaultManager] fileExistsAtPath:databasePath];
    
    if (sqlite3_open([databasePath UTF8String], &databaseHandle) == SQLITE_OK) {
        if (!databaseAlreadyExists) {
            const char *sqlStatement = "CREATE TABLE IF NOT EXISTS PageCache (id text NOT NULL PRIMARY KEY, url TEXT, rurl TEXT, html TEXT, curl TEXT, chtml TEXT, update_time DATE)";
            char *error;
            if (sqlite3_exec(databaseHandle, sqlStatement, NULL, NULL, &error) == SQLITE_OK) {
//                NSLog(@"Database and tables created.");
            } else {
                NSLog(@"Error: %s", error);
            }
            sqlStatement = "CREATE TABLE IF NOT EXISTS History (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, title TEXT, url TEXT)";
            if (sqlite3_exec(databaseHandle, sqlStatement, NULL, NULL, &error) == SQLITE_OK) {
//                NSLog(@"Database and tables created.");
            } else {
                NSLog(@"Error: %s", error);
            }
        }
    }
}

- (void)insertPageCache:(IBPageCache *)pageCache
{
    NSString *insertStatement = @"INSERT INTO PageCache (id, url, rurl, html, curl, chtml, update_time) VALUES (?, ?, ?, ?, ?, ?, ?)";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(databaseHandle, [insertStatement UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [pageCache.cacheId UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 2, [pageCache.url UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 3, [pageCache.rurl UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 4, [pageCache.html UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 5, [pageCache.curl UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 6, [pageCache.chtml UTF8String], -1, nil);
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
        NSString *updateTimeString = [dateFormat stringFromDate:pageCache.update];
        sqlite3_bind_text(stmt, 7, [updateTimeString UTF8String], -1, nil);
    }
    if (sqlite3_step(stmt) == SQLITE_DONE) {
//        NSLog(@"PageCache inserted.");
    } else {
        NSLog(@"Error: insert pageCache failed");
    }
}

- (IBPageCache *)getPageCacheById:(NSString *)pageCacheId
{
    NSString *databasePath = [Helper getFilePathWithFilename:@"sqlite.db"];
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:databasePath error:nil];
    id filesize = [attributes valueForKey:NSFileSize];
    if ([filesize intValue] > 50 * 1024 * 1024) {
        [self deletePageCacheOldest:100];
    }
    
    IBPageCache *pageCache;
    NSString *queryStatement = [NSString stringWithFormat:@"SELECT * FROM PageCache WHERE id = \"%@\"", pageCacheId];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(databaseHandle, [queryStatement UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSString *cacheId = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 0)];
            NSString *url = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 1)];
            NSString *rurl = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 2)];
            NSString *html = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 3)];
            NSString *curl = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 4)];
            NSString *chtml = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 5)];
            NSString *updateTimeStr = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 6)];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";
            NSDate *update = [dateFormatter dateFromString: updateTimeStr];
            
            pageCache = [[IBPageCache alloc] initWithCacheId:cacheId url:url rurl:rurl html:html curl:curl chtml:chtml update:update];
        }
        sqlite3_finalize(statement);
    }
    return pageCache;
}

- (void)updatePageCache:(IBPageCache *)pageCache
{
    NSString *replaceStatement = @"UPDATE PageCache SET url = ?, rurl = ?, html = ?, curl = ?, chtml = ?, update_time = ? WHERE id = ?";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(databaseHandle, [replaceStatement UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [pageCache.url UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 2, [pageCache.rurl UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 3, [pageCache.html UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 4, [pageCache.curl UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 5, [pageCache.chtml UTF8String], -1, nil);
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
        NSString *updateTimeString = [dateFormat stringFromDate:pageCache.update];
        sqlite3_bind_text(stmt, 6, [updateTimeString UTF8String], -1, nil);
        
        sqlite3_bind_text(stmt, 7, [pageCache.cacheId UTF8String], -1, nil);
    }
    if (sqlite3_step(stmt) == SQLITE_DONE) {
//        NSLog(@"PageCache replaced.");
    } else {
        NSLog(@"Error: replace pageCache failed");
    }
}

- (void)deletePageCacheOldest:(NSInteger)count
{
    NSString *queryStatement = [NSString stringWithFormat:@"SELECT update_time FROM PageCache ORDER BY update_time limit %d, 1", count];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(databaseHandle, [queryStatement UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSString *updateTimeStr = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 0)];
            NSString *deleteStatement = [NSString stringWithFormat:@"DELETE FROM PageCache WHERE update_time < \"%@\"", updateTimeStr];
            char *error;
            if (sqlite3_exec(databaseHandle, [deleteStatement UTF8String], nil, nil, &error) == SQLITE_OK) {
//                NSLog(@"PageCache deleted");
            } else {
                NSLog(@"Delete pageCache failed %s", error);
            }
        }
        sqlite3_finalize(statement);
    }
}

- (void)insertHistory:(NSString *)title url:(NSString *)url
{
    if ([self historyExistedWithURL:url]) {
        return;
    }
    NSString *insertStatement = @"INSERT INTO History (title, url) VALUES (?, ?)";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(databaseHandle, [insertStatement UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [title UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 2, [url UTF8String], -1, nil);
    }
    if (sqlite3_step(stmt) == SQLITE_DONE) {
//        NSLog(@"History inserted. %@", url);
    } else {
        NSLog(@"Error: insert history failed");
    }
}

- (NSArray *)searchHistory:(NSString *)query limit:(NSInteger)limit
{
    NSMutableArray *histories;
    NSString *queryStatement = [NSString stringWithFormat:@"SELECT * FROM History WHERE url like '%%%@%%' LIMIT %d", query, limit];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(databaseHandle, [queryStatement UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSString *title = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 1)];
            NSString *url = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 2)];
            NSDictionary *history = [NSDictionary dictionaryWithObjectsAndKeys:title, @"title", url, @"url", nil];
            if (histories == nil) {
                histories = [[NSMutableArray alloc] init];
            }
            [histories addObject:history];
        }
        sqlite3_finalize(statement);
    }
    return histories;
}

- (BOOL)historyExistedWithURL:(NSString *)url
{
    BOOL existed = NO;
    NSString *queryStatement = [NSString stringWithFormat:@"SELECT * FROM History WHERE url = '%@'", url];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(databaseHandle, [queryStatement UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            existed = YES;
        }
        sqlite3_finalize(statement);
    }
    return existed;
}

@end
