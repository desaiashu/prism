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
		DTCustomColoredAccessory *accessory = [DTCustomColoredAccessory accessoryWithColor:[UIColor colorWithRed:(223.0/256.0) green:(34.0/256.0) blue:(46.0/256.0) alpha:1.0]];
		accessory.highlightedColor = [UIColor whiteColor];
		self.accessoryView = accessory;
		
		font = [UIFont fontWithName:@"Nexa Bold" size:18.0];
		detailFont = [UIFont fontWithName:@"ghosty" size:16.0];
		textColor = [UIColor colorWithRed:(63.0/256.0) green:(70.0/256.0) blue:(68.0/256.0) alpha:1.0];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
    if (self) {
		DTCustomColoredAccessory *accessory = [DTCustomColoredAccessory accessoryWithColor:[UIColor colorWithRed:(223.0/256.0) green:(34.0/256.0) blue:(46.0/256.0) alpha:1.0]];
		accessory.highlightedColor = [UIColor whiteColor];
		self.accessoryView = accessory;
		
		CALayer * l = [self.imageView layer];
		[l setMasksToBounds:YES];
		[l setCornerRadius:5.0];
		
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
	
	self.textLabel.font = font;
	self.textLabel.textColor = textColor;
	
	self.detailTextLabel.font = detailFont;
//	if ([self.detailTextLabel.text isEqualToString:@"GHOST"] || [self.detailTextLabel.text isEqualToString:@"VIEW"])
//		self.detailTextLabel.textColor = altColor;
//	else
	self.detailTextLabel.textColor = textColor;
	self.detailTextLabel.text = [self.detailTextLabel.text uppercaseString];
	
    self.imageView.frame = CGRectMake( 10, 10, 40, 40 ); // your positioning here
	if (chatIcon)
		chatIcon.frame = CGRectMake( 40, 0, 25, 20);
	
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

+ (CGFloat) cellHeight
{
	return 60.0;
}

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
