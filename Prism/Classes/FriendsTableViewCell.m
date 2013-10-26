//
//  TableViewCell.m
//  Ghost
//
//  Created by Ashutosh Desai on 12/15/12.
//  Copyright (c) 2012 makegameswithus inc. Free to use for all purposes.
//

#import "FriendsTableViewCell.h"

@implementation FriendsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
		self.backgroundColor = [UIColor clearColor];
		self.selectedBackgroundView.backgroundColor = [UIElements primaryColor];
		self.name = [UIElements friendName:@"friend"];
		self.status = [UIElements friendStatus:@"chat from"];
		[self addSubview:self.name];
		[self addSubview:self.status];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
