//
//  TableViewCell.h
//  Ghost
//
//  Created by Ashutosh Desai on 12/15/12.
//  Copyright (c) 2012 makegameswithus inc. Free to use for all purposes.
//

#import <UIKit/UIKit.h>

//Our custom tableViewCell
@interface RequestTableViewCell : UITableViewCell
{
	UIFont *font;
	UIFont *detailFont;
	UIColor *textColor;
	UIColor *altColor;
	
	UIButton *accept;
	UIButton *reject;
}

@property UIButton *accept, *reject;

+ (CGFloat) cellHeight;
+ (NSString*)shortName:(NSString*)friendname;

@end
