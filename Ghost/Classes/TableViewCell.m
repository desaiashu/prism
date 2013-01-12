//
//  TableViewCell.m
//  Ghost
//
//  Created by Ashutosh Desai on 12/15/12.
//  Copyright (c) 2012 makegameswithus inc. All rights reserved.
//

#import "TableViewCell.h"
#import "DTCustomColoredAccessory.h"
#import <QuartzCore/QuartzCore.h>

@implementation TableViewCell

@synthesize chatIcon;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

//Since this is a view not view controller we don't have a viewDidLoad method, we need to split set up between the initWithCoder method (called by the storyboard) and layoutSubviews
- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
    if (self) {
		//Change the arrow on the cell to be red
		DTCustomColoredAccessory *accessory = [DTCustomColoredAccessory accessoryWithColor:[UIColor colorWithRed:(223.0/256.0) green:(34.0/256.0) blue:(46.0/256.0) alpha:1.0]];
		accessory.highlightedColor = [UIColor whiteColor];
		self.accessoryView = accessory;
		
		//Add corner radius to the image
		CALayer * l = [self.imageView layer];
		[l setMasksToBounds:YES];
		[l setCornerRadius:5.0];
		
		//Create custom fonts/colors for the labels
		font = [UIFont fontWithName:@"Nexa Bold" size:18.0];
		detailFont = [UIFont fontWithName:@"ghosty" size:16.0];
		textColor = [UIColor colorWithRed:(223.0/256.0) green:(228.0/256.0) blue:(227.0/256.0) alpha:1.0];
		altColor = [UIColor colorWithRed:(223.0/256.0) green:(34.0/256.0) blue:(46.0/256.0) alpha:1.0];
	}
	return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
	
	//Set the labels to have the desired fonts / colors
	self.textLabel.font = font;
	self.textLabel.textColor = textColor;
	self.detailTextLabel.font = detailFont;
	self.detailTextLabel.textColor = textColor;
	//Set the detail label to be all uppercase
	self.detailTextLabel.text = [self.detailTextLabel.text uppercaseString];
	
	//Position the image view
    self.imageView.frame = CGRectMake( 10, 10, 40, 40 );
	
	//If chatIcon exists, set the position
	if (chatIcon)
		chatIcon.frame = CGRectMake( 40, 0, 25, 20);
	
	//Adjust the position of the text labels (since the custom fonts are not the same size as the default font), in this case we ensure that the textLabel is never cut off by the detail text label
	CGRect f = self.textLabel.frame;
	self.textLabel.frame = CGRectMake( 70, f.origin.y+2, f.size.width, f.size.height );
	CGRect d = self.detailTextLabel.frame;
	CGFloat endf = 90+f.size.width;
	if (d.origin.x < endf)
		self.detailTextLabel.frame = CGRectMake( endf, d.origin.y+3, d.size.width-(endf-d.origin.x), d.size.height);
	else
		self.detailTextLabel.frame = CGRectMake( d.origin.x, d.origin.y+3, d.size.width, d.size.height);
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//Method to return cell height, this is always constant
+ (CGFloat) cellHeight
{
	return 60.0;
}

//Method to convert full name to name with 
+ (NSString*)shortName:(NSString*)friendname
{
	NSArray *names = [friendname componentsSeparatedByString:@" "];
	NSString * firstLetter = [[names objectAtIndex:([names count]-1)] substringToIndex:1];
	NSString *shortname;
	if ([names count] > 1)
		shortname = [[names objectAtIndex:0] stringByAppendingFormat:@" %@", firstLetter];
	else
		shortname = [names objectAtIndex:0];
	shortname = [shortname stringByAppendingString:@"."];
	return shortname;
}

@end
