//
//  UIElements.m
//  Prism
//
//  Created by Ashutosh Desai on 10/24/13.
//  Copyright (c) 2013 makegameswithus inc. All rights reserved.
//

#import "UIElements.h"
#import "EquilateralTriangleView.h"
#import "DTCustomColoredAccessory.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIElements

+(UIColor*)darkColor
{
	return [UIColor colorWithRed:26.f/255.f green:26.f/255.f blue:26.f/255.f alpha:1.f];
}

+(UIColor*)lightColor
{
	return [UIColor colorWithRed:255.f/255.f green:255.f/255.f blue:255.f/255.f alpha:1.f];
}

+(UIColor*)primaryColor
{
	return [UIColor colorWithRed:102.f/255.f green:171.f/255.f blue:197.f/255.f alpha:1.f];
}

+(CGFloat)height
{
	return [[UIScreen mainScreen] bounds].size.height;
}

+(CGFloat)width
{
	return [[UIScreen mainScreen] bounds].size.width;
}

+(UIView*)header:(NSString*)string withBackButton:(BOOL)back
{
	UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 3, 320, 60)];
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 320, 60)];
	label.textAlignment = UITextAlignmentCenter;
	label.text = string;
	label.textColor = [self primaryColor];
	label.font = [UIFont fontWithName:@"AvenirNext-Bold" size:32];
	[header addSubview:label];
	
	if (back)
	{
		UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
		[button setImage:[self backButtonImageWithhighlighted:NO] forState:UIControlStateNormal];
		[button setImage:[self backButtonImageWithhighlighted:YES] forState:UIControlStateHighlighted];
		[button addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
		[header addSubview:button];
	}
	
	return header;
}

+(void)popViewController
{
	UINavigationController *nc = (UINavigationController*)[[[UIApplication sharedApplication] keyWindow] rootViewController];
	[nc popViewControllerAnimated:YES];
}

+(UIImage*)backButtonImageWithhighlighted:(BOOL)highlighted
{
	UIGraphicsBeginImageContextWithOptions(CGSizeMake(60, 60), false, 0);
	
	CGPoint startPoint = CGPointMake(32, 20);
	CGPoint endPoint = CGPointMake(32, 42);
	
	CGFloat angle = M_PI/3; // 60 degrees in radians
	// v1 = vector from startPoint to endPoint:
	CGPoint v1 = CGPointMake(endPoint.x - startPoint.x, endPoint.y - startPoint.y);
	// v2 = v1 rotated by 60 degrees:
	CGPoint v2 = CGPointMake(cosf(angle) * v1.x - sinf(angle) * v1.y,
							 sinf(angle) * v1.x + cosf(angle) * v1.y);
	// thirdPoint = startPoint + v2:
	CGPoint thirdPoint = CGPointMake(startPoint.x + v2.x + 3, startPoint.y + v2.y);
	
	highlighted?(DARK_SCHEME?[[self lightColor] setFill]:[[self darkColor] setFill]):[[self primaryColor] setFill];
	
	UIBezierPath *triangle = [UIBezierPath bezierPath];
	[triangle moveToPoint:startPoint];
	[triangle addLineToPoint:endPoint];
	[triangle addLineToPoint:thirdPoint];
	[triangle closePath];
	[triangle fill];
	
	//now get the image from the context
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return image;
}

+(UILabel*)friendName:(NSString*)string
{
	CGSize size = CGSizeMake(250, 40);
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, 14, size.width, size.height)];
	label.text = string;
	label.textAlignment = UITextAlignmentLeft;
	label.font = [UIFont fontWithName:@"AvenirNext-Medium" size:24];
	label.textColor = DARK_SCHEME?[self lightColor]:[self darkColor];
	return label;
}

+(UILabel*)friendStatus:(NSString*)string
{
	CGSize size = CGSizeMake(250, 20);
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, size.width, size.height)];
	label.text = string;
	label.textAlignment = UITextAlignmentLeft;
	label.font = [UIFont fontWithName:@"AvenirNext-Heavy" size:10];
	label.textColor = [self primaryColor];
	return label;
}

+(UIView*)friendUnread:(int)number
{
	CGSize size = CGSizeMake(24, 24);
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(275, 22, size.width, size.height)];
	view.backgroundColor = [self primaryColor];
	view.layer.cornerRadius = 5;
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
	label.text = [NSString stringWithFormat:@"%d", number];
	label.textAlignment = UITextAlignmentCenter;
	label.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:12];
	label.textColor = [self lightColor];
	[view addSubview:label];
	
	return view;
}

+(float)heightForFriendCell
{
	return 75;
}

+(UITableView*)tableView
{
	CGRect rect = CGRectMake(0, 80, self.width, self.height-80-50);
	UITableView *tableView = [[UITableView alloc] initWithFrame:rect];
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	tableView.backgroundColor = [UIColor clearColor];
	return tableView;
}

+(UIButton*)acceptButton
{
	
}

+(UIButton*)rejectButton
{
	
}

+(UIButton*)footerButtonWithTitle:(NSString*)title
{
	CGSize size = CGSizeMake(320, 50);
	int fontsize = ([title length] < 20)?30:24;
	
	UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, self.height-size.height, size.width, size.height)];
	[button setBackgroundImage:[self buttonImageWithSize:size cornerRadius:0 highlighted:NO] forState:UIControlStateNormal];
	[button setBackgroundImage:[self buttonImageWithSize:size cornerRadius:0 highlighted:YES] forState:UIControlStateHighlighted];
	
	[button setTitle:title forState:UIControlStateNormal];
	[[button titleLabel] setFont:[UIFont fontWithName:@"AvenirNext-Bold" size:fontsize]];
	[[button titleLabel] setAdjustsFontSizeToFitWidth:YES];
	[button setTitleColor:[self lightColor] forState:UIControlStateNormal];
	[button setTitleColor:[self primaryColor] forState:UIControlStateHighlighted];
	
	return button;
}

+(UILabel*)chatFrom:(NSString*)string
{
	CGSize size = CGSizeMake((self.width-26)/2.f, 14);
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, size.width, size.height)];
	label.text = string;
	label.textAlignment = UITextAlignmentLeft;
	label.font = [UIFont fontWithName:@"AvenirNext-Heavy" size:14];
	label.textColor = [self primaryColor];
	return label;
}

+(UILabel*)chatTime:(NSString*)string
{
	CGSize size = CGSizeMake((self.width-26)/2.f, 14);
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.width/2.f, 0, size.width, size.height)];
	label.text = string;
	label.textAlignment = UITextAlignmentRight;
	label.font = [UIFont fontWithName:@"AvenirNext-UltraLight" size:11];
	label.textColor = [self primaryColor];
	return label;
}

+(float)heightForChatCell:(NSString*)string
{
	UIFont *font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:12];
	CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(self.width-28, self.height) lineBreakMode:UILineBreakModeWordWrap];
	return size.height+30;
}

+(UILabel*)chatMessage:(NSString*)string
{
	UIFont *font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:12];
	CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(self.width-28, self.height) lineBreakMode:UILineBreakModeWordWrap];
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, 20, self.width-28, size.height)];
	label.text = string;
	label.textAlignment = UITextAlignmentLeft;
	label.lineBreakMode = UILineBreakModeWordWrap;
	label.numberOfLines = 0;
	label.font = font;
	label.textColor = DARK_SCHEME?[self lightColor]:[self darkColor];
	return label;
}

+(UIButton*)deleteButton
{
	
}

+(UIView*)statusBar
{
	CGSize size = CGSizeMake(320, 20);
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
	view.backgroundColor = [self primaryColor];
	return view;
}

+(UIView*)footer
{
	CGSize size = CGSizeMake(320, 50);
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-size.height, size.width, size.height)];
	view.backgroundColor = [self primaryColor];
	return view;
}

+(UIButton*)sendButton
{
	CGSize size = CGSizeMake(50, 28);
	UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.width-size.width-7, 14, size.width, size.height)];
	[button setBackgroundImage:[self altButtonImageWithSize:size cornerRadius:5 highlighted:NO] forState:UIControlStateNormal];
	[button setBackgroundImage:[self altButtonImageWithSize:size cornerRadius:5 highlighted:YES] forState:UIControlStateHighlighted];
	
	[button setTitle:@"send" forState:UIControlStateNormal];
	[[button titleLabel] setFont:[UIFont fontWithName:@"AvenirNext-Bold" size:12]];
	[button setTitleColor:[self primaryColor] forState:UIControlStateNormal];
	
	return button;
}

+(UITextField*)textInputField
{
	UITextField *textField = [[UITextField alloc] init];
	textField.backgroundColor = [self lightColor];
	textField.textColor = [self primaryColor];
	[[UITextField appearance] setTintColor:[self primaryColor]];
	textField.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:18];
	textField.borderStyle = UITextBorderStyleRoundedRect;
	if (!DARK_SCHEME)
	{
		textField.layer.cornerRadius = 8.0f;
		textField.layer.borderColor = [self primaryColor].CGColor;
		textField.layer.borderWidth = 2;
	}
	return textField;
}

+(UITextField*)centerTextInputField
{
	CGSize size = CGSizeMake(225, 36);
	UITextField *textField = [self textInputField];
	textField.frame = CGRectMake((self.width-size.width)/2.f, (self.height-size.height-50)/2.f, size.width, size.height);
	return textField;
}

+(UITextField*)footerTextInputField
{
	CGSize size = CGSizeMake(250, 36);
	UITextField *textField = [self textInputField];
	textField.frame = CGRectMake(7, 7, size.width, size.height);
	return textField;
}

+(UILabel*)enterUsername
{
	CGSize size = CGSizeMake(320, 36);
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((self.width-size.width)/2.f, (self.height-size.height-50)*3.f/8.f, size.width, size.height)];
	label.text = @"enter username";
	label.textAlignment = UITextAlignmentCenter;
	label.font = [UIFont fontWithName:@"AvenirNext-Medium" size:24];
	label.textColor = DARK_SCHEME?[self lightColor]:[self darkColor];
	return label;
}

+(UIButton*)floatingButtonWithTitle:(NSString*)title
{
	CGSize size = CGSizeMake(145, 36);
	UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((self.width-size.width)/2.f, (self.height-size.height-50)*5.f/8.f, size.width, size.height)];
	[button setBackgroundImage:[self buttonImageWithSize:size cornerRadius:5 highlighted:NO] forState:UIControlStateNormal];
	[button setBackgroundImage:[self buttonImageWithSize:size cornerRadius:5 highlighted:YES] forState:UIControlStateHighlighted];
	
	[button setTitle:title forState:UIControlStateNormal];
	[[button titleLabel] setFont:[UIFont fontWithName:@"AvenirNext-Bold" size:16]];
	[button setTitleColor:[self lightColor] forState:UIControlStateNormal];
	[button setTitleColor:[self primaryColor] forState:UIControlStateHighlighted];
	
	return button;
}

+(UILabel*)passcode
{
	CGSize size = CGSizeMake(320, 60);
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((self.width-size.width)/2.f, self.height*1.f/6.f, size.width, size.height)];
	label.text = @"5     5     5     5";
	label.textAlignment = UITextAlignmentCenter;
	label.font = [UIFont fontWithName:@"AvenirNext-Bold" size:31];
	label.textColor = DARK_SCHEME?[self lightColor]:[self darkColor];
	return label;
}

+(UIButton*)passcodeButtonWithNumber:(int)number
{
	CGSize size = CGSizeMake(60, 60);
	int x = 0;
	int y = 0;//38 130 222 // self.height*2.f/6.f self.height/2.f self.height*3.f/6.f self.height*4.f/6.f
	switch (number) {
		case 1:
		case 2:
		case 3:
			y = self.height*2.f/6.f;
			break;
		case 4:
		case 5:
		case 6:
			y = self.height*3.f/6.f;
			break;
		case 7:
		case 8:
		case 9:
			y = self.height*4.f/6.f;
			break;
		case 10:
		case 0:
		case 11:
			y = self.height*5.f/6.f;
			break;
		default:
			break;
	}
	switch (number) {
		case 1:
		case 4:
		case 7:
		case 10:
			x = 38;
			break;
		case 2:
		case 5:
		case 8:
		case 0:
			x = 130;
			break;
		case 3:
		case 6:
		case 9:
		case 11:
			x = 222;
			break;
		default:
			break;
	}
	UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, y, size.width, size.height)];
	[button setBackgroundImage:[self buttonImageWithSize:size cornerRadius:10 highlighted:NO] forState:UIControlStateNormal];
	[button setBackgroundImage:[self buttonImageWithSize:size cornerRadius:10 highlighted:YES] forState:UIControlStateHighlighted];
	
	if (number < 10)
	{
		[button setTitle:[NSString stringWithFormat:@"%d", number] forState:UIControlStateNormal];
		[[button titleLabel] setFont:[UIFont fontWithName:@"AvenirNext-Medium" size:36]];
	}
	else
	{
		if (number == 10)
			[button setTitle:@"about" forState:UIControlStateNormal];
		else
			[button setTitle:@"delete" forState:UIControlStateNormal];
		[[button titleLabel] setFont:[UIFont fontWithName:@"AvenirNext-Medium" size:12]];
	}
	[button setTitleColor:[self lightColor] forState:UIControlStateNormal];
	[button setTitleColor:[self primaryColor] forState:UIControlStateHighlighted];
	
	return button;
}

+(UITextView*)about
{
	UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(7, 65, self.width-14, self.height-65)];
	textView.backgroundColor = [UIColor clearColor];
	textView.textColor = DARK_SCHEME?[self lightColor]:[self darkColor];
	textView.font = [UIFont fontWithName:@"AvenirNext-Medium" size:18];
	textView.text = @"whisper was built by ashu desai to enable convenient secure communication. there are a two core factors that make your chats secure: 1. chats are encrypted using public key / private key encryption, the private key lives on your device and is never saved to the cloud or backed up 2. chats are not stored locally on the phone, only encrypted on our servers. essentially, to read your chats, an intruder would have to have physical control over your device and either a. hack into our servers b. hack the app itself, altogether a fairly implausible scenario. of course, you also have to trust that i in fact built the app correctly. usernames cannot be transferred between devices. photo and video functionality is in the works. chat me at desaiashu if you have any questions or suggestions";
	return textView;
}

+(UIImage*)altButtonImageWithSize:(CGSize)size cornerRadius:(CGFloat)cornerRadius highlighted:(BOOL)highlighted
{
	UIGraphicsBeginImageContextWithOptions(size, false, 0);
	
	highlighted?([[self darkColor] setFill]):[[self lightColor] setFill];
	
	UIBezierPath *rect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:cornerRadius];
	[rect fill];
	
	//now get the image from the context
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return image;
}

+(UIImage*)buttonImageWithSize:(CGSize)size cornerRadius:(CGFloat)cornerRadius highlighted:(BOOL)highlighted
{
	UIGraphicsBeginImageContextWithOptions(size, false, 0);
	
	highlighted?(DARK_SCHEME?[[self lightColor] setFill]:[[self darkColor] setFill]):[[self primaryColor] setFill];
	
	UIBezierPath *rect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:cornerRadius];
	[rect fill];
	
	//now get the image from the context
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return image;
}

@end
