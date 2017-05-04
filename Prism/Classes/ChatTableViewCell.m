//
//  TableViewCell.m
//  Ghost
//
//  Created by Ashutosh Desai on 12/15/12.
//  Copyright (c) 2012 makegameswithus inc. Free to use for all purposes.
//

#import "ChatTableViewCell.h"

@implementation ChatTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
		self.backgroundColor = [UIColor clearColor];
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		self.from = [UIElements chatFrom:@"friend"];
		self.time = [UIElements chatTime:@"yesterday, 11:57pm"];
		[self addSubview:self.from];
		[self addSubview:self.time];
		self.right = FALSE;
    }
    return self;
}

- (void)flip
{
	CGRect fromFrame = self.from.frame;
	CGRect timeFrame = self.time.frame;
	self.time.frame = fromFrame;
	self.from.frame = timeFrame;
	self.from.textAlignment = (self.from.textAlignment == UITextAlignmentLeft)?UITextAlignmentRight:UITextAlignmentLeft;
	self.time.textAlignment = (self.time.textAlignment == UITextAlignmentRight)?UITextAlignmentLeft:UITextAlignmentRight;
	self.right = !self.right;
}
////Since this is a view not view controller we don't have a viewDidLoad method, we need to split set up between the initWithCoder method (called by the storyboard) and layoutSubviews
//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//	self = [super initWithCoder:aDecoder];
//    if (self) {
//
//		
////		accept = [UIButton buttonWithType:UIButtonTypeCustom];
////		[accept setBackgroundColor:[UIColor clearColor]];
////		[accept setBackgroundImage:[UIImage imageNamed:@"Check.png"] forState:UIControlStateNormal];
////		[self addSubview:accept];
////		
////		reject = [UIButton buttonWithType:UIButtonTypeCustom];
////		[reject setBackgroundColor:[UIColor clearColor]];
////		[reject setBackgroundImage:[UIImage imageNamed:@"X.png"] forState:UIControlStateNormal];
////		[self addSubview:reject];
//		
//	}
//	return self;
//}

- (void)willTransitionToState:(UITableViewCellStateMask)state{
    [super willTransitionToState:state];
	

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
