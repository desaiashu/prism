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
		self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
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
	
	for (UIView *subview in [[self.subviews objectAtIndex:0] subviews])
	{
		if ([[subview subviews] count] > 0)
		{
			UIView *subview1 = [[subview subviews] objectAtIndex:0];
			if ([NSStringFromClass([subview1 class]) isEqualToString:@"UITableViewCellDeleteConfirmationButton"]) {
				//					subview1.frame = CGRectMake(subview1.frame.origin.x-20, subview1.frame.origin.y, subview1.frame.size.width, subview1.frame.size.height);
				//					NSLog(@"yay");
				//					subview1.backgroundColor = [UIElements primaryColor];
				//					UILabel *label = [[subview1 subviews] objectAtIndex:0];
				//					label.font = [UIFont fontWithName:@"AvenirNext-Bold" size:14];
				//					label.text = @"delete";
				//					label.textColor = [UIElements lightColor];
				UIButton *b = [UIElements deleteButtonWithHeight:self.frame.size.height];
				[b addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
				[subview addSubview:b];
			}
		}
	}
}

-(void)delete:(id)sender
{
	if (self.deleteBlock)
		self.deleteBlock();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
