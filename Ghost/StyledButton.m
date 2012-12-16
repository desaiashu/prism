//
//  StyledButton.m
//  Ghost
//
//  Created by Ashutosh Desai on 12/13/12.
//  Copyright (c) 2012 makegameswithus inc. All rights reserved.
//

#import "StyledButton.h"

@implementation StyledButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
		UIImage* img = [UIImage imageNamed:@"button.png"];
		img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(16, 16, 16, 16)];
		[self setBackgroundImage:img forState:UIControlStateNormal];
		
		UIImage* img2 = [UIImage imageNamed:@"button-pressed.png"];
		img2 = [img2 resizableImageWithCapInsets:UIEdgeInsetsMake(16, 16, 16, 16)];
		[self setBackgroundImage:img2 forState:UIControlStateHighlighted];
		
		int fontsize = self.titleLabel.font.pointSize;

		self.titleLabel.font = [UIFont fontWithName:@"Nexa Bold" size:fontsize];

		[self setTitleColor:[UIColor colorWithRed:(63.0/256.0) green:(70.0/256.0) blue:(68.0/256.0) alpha:1.0] forState:UIControlStateNormal];
		[self setTitleColor:[UIColor colorWithRed:(63.0/256.0) green:(70.0/256.0) blue:(68.0/256.0) alpha:1.0] forState:UIControlStateHighlighted];
		
		[self setTitleEdgeInsets:UIEdgeInsetsMake(fontsize/4.0, 0.0, 0.0, 0.0)];
		
    }
    return self;
}

//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//
//}


@end
