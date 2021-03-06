//
//  TableViewCell.h
//  Ghost
//
//  Created by Ashutosh Desai on 12/15/12.
//  Copyright (c) 2012 makegameswithus inc. Free to use for all purposes.
//

#import <UIKit/UIKit.h>

typedef void(^DeleteBlock)(void);

//Our custom tableViewCell
@interface FriendsTableViewCell : UITableViewCell

@property UILabel *name, *status;
@property UIView *unread;
@property UIButton *accept, *reject;
@property (nonatomic, copy) DeleteBlock deleteBlock;

@end
