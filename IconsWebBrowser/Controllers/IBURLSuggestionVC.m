//
//  IBURLSuggestionVC.m
//  iconsweb
//
//  Created by Xu Ke on 5/30/12.
//  Copyright (c) 2012 Xu Ke. All rights reserved.
//

#import "IBURLSuggestionVC.h"
#import "DBController.h"

#define SUGGESTIONS_COUNT 100

@interface IBURLSuggestionVC ()
{
    NSString *query;
    DBController *db;
}
@end

@implementation IBURLSuggestionVC

@synthesize suggestions, delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.view.frame = frame;
    }
    return self;
}

- (void)viewDidLoad
{
    self.tableView.frame = self.view.bounds;
    self.tableView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    self.tableView.separatorColor = [UIColor colorWithWhite:0.3 alpha:1];
}

- (void)loadWithQuery:(NSString *)_query
{
    // Custom initialization
    suggestions = [[NSMutableArray alloc] initWithCapacity:10];
    if (_query.length) {
        if ([_query hasPrefix:@"http://www."]) {
            _query = [_query substringFromIndex:11];
        } else if ([_query hasPrefix:@"http://"]) {
            _query = [_query substringFromIndex:7];
        }
        query = _query;
        if (db == nil) {
            db = [[DBController alloc] init];
            [db initDatabase];
        }
        NSArray *histories = [db searchHistory:query limit:SUGGESTIONS_COUNT];
        if (histories && histories.count) {
            for (NSInteger i=0; i<MIN(histories.count, SUGGESTIONS_COUNT); i++) {
                NSDictionary *history = [histories objectAtIndex:i];
                [suggestions addObject:[NSDictionary dictionaryWithObjectsAndKeys:[history objectForKey:@"title"], @"title", [history objectForKey:@"url"], @"url", nil]];
            }
        }
        if (histories.count < SUGGESTIONS_COUNT) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"top-1k" 
                                                             ofType:@"txt"];
            NSString *content = [NSString stringWithContentsOfFile:path
                                                          encoding:NSUTF8StringEncoding
                                                             error:nil];
            NSArray *lines = [content componentsSeparatedByString:@"\n"];
            for (NSString *line in lines) {
                if (line) {
                    NSArray *components = [line componentsSeparatedByString:@"\t"];
                    if (components.count == 2) {
                        NSString *title = [components objectAtIndex:0];
                        NSString *url = [components objectAtIndex:1];
                        if ([url rangeOfString:query].location != NSNotFound) {
                            if (suggestions.count < SUGGESTIONS_COUNT) {
                                BOOL existed = NO;
                                for (NSDictionary *history in histories) {
                                    if ([[history objectForKey:@"url"] isEqualToString:url]) {
                                        existed = YES;
                                        break;
                                    }
                                }
                                if (existed) {
                                    continue;
                                }
                                [suggestions addObject:[NSDictionary dictionaryWithObjectsAndKeys:title, @"title", url, @"url", nil]];
                            } else {
                                break;
                            }
                        }
                    }
                }
            }
        }
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return suggestions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
    NSDictionary *suggestion = [suggestions objectAtIndex:indexPath.row];
//    836329936
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", [suggestion objectForKey:@"url"], [suggestion objectForKey:@"title"]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *suggestion = [suggestions objectAtIndex:indexPath.row];
    [delegate suggestionDidSelectedURL:[suggestion objectForKey:@"url"] withTitle:[suggestion objectForKey:@"title"]];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [delegate suggestionViewDidWillBeginDragging];
}

@end
