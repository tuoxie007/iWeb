//
//  IBURLSuggestionVC.h
//  iconsweb
//
//  Created by Xu Ke on 5/30/12.
//  Copyright (c) 2012 Xu Ke. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IBURLSuggestionDelegate <NSObject>

- (void)suggestionDidSelectedURL:(NSString *)url withTitle:(NSString *)title;
- (void)suggestionViewDidWillBeginDragging;

@end

@interface IBURLSuggestionVC : UITableViewController
{
    NSMutableArray *suggestions;
    id<IBURLSuggestionDelegate> delegate;
}

@property (strong) NSMutableArray *suggestions;
@property (strong) id<IBURLSuggestionDelegate> delegate;

- (void)loadWithQuery:(NSString *)_query;
- (id)initWithFrame:(CGRect)frame;
@end
