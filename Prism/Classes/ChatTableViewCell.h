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
@interface ChatTableViewCell : UITableViewCell

@property UILabel *from, *time, *message;
@property BOOL right;
@property (nonatomic, copy) DeleteBlock deleteBlock;

-(void)flip;

@end
