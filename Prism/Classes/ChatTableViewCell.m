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
		self.selectedBackgroundView.backgroundColor = [UIElements primaryColor];
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
	self.message.textAlignment = (self.message.textAlignment == UITextAlignmentLeft)?UITextAlignmentRight:UITextAlignmentLeft;
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

- (void) layoutSubviews
{
    [super layoutSubviews];
	
//	//Set the labels to have the desired fonts / colors
//	self.textLabel.font = font;
//	self.textLabel.textColor = textColor;
//	self.detailTextLabel.font = detailFont;
//	self.detailTextLabel.textColor = textColor;
//	//Set the detail label to be all uppercase
//	self.detailTextLabel.text = [self.detailTextLabel.text uppercaseString];
//	
//	//Position the image view
//    self.imageView.frame = CGRectMake( 10, 10, 40, 40 );
//	
//	accept.frame = CGRectMake(190, 0, 60, 60);
//	reject.frame = CGRectMake(250, 0, 60, 60);
//	
//	//Adjust the position of the text labels (since the custom fonts are not the same size as the default font), in this case we ensure that the textLabel is never cut off by the detail text label
//	CGRect f = self.textLabel.frame;
//	self.textLabel.frame = CGRectMake( 70, f.origin.y+2, f.size.width, f.size.height );
//	CGRect d = self.detailTextLabel.frame;
//	CGFloat endf = 90+f.size.width;
//	if (d.origin.x < endf)
//		self.detailTextLabel.frame = CGRectMake( endf, d.origin.y+3, d.size.width-(endf-d.origin.x), d.size.height);
//	else
//		self.detailTextLabel.frame = CGRectMake( d.origin.x, d.origin.y+3, d.size.width, d.size.height);
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
