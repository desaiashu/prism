//
//  TableViewCell.h
//  Ghost
//
//  Created by Ashutosh Desai on 12/15/12.
//  Copyright (c) 2012 makegameswithus inc. Free to use for all purposes.
//

#import <UIKit/UIKit.h>

//Our custom tableViewCell
@interface TableViewCell : UITableViewCell
{
	UIFont *font;
	UIFont *detailFont;
	UIColor *textColor;
	UIColor *altColor;
	UIImageView *chatIcon;
}

@property UIImageView *chatIcon;

+ (CGFloat) cellHeight;
+ (NSString*)shortName:(NSString*)friendname;

@end
