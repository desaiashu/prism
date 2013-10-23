//
//  StyledButton.m
//  Ghost
//
//  Created by Ashutosh Desai on 12/13/12.
//  Copyright (c) 2012 makegameswithus inc. Free to use for all purposes.
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

//The storyboard calls this method to create buttons
- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
		
		//Set the background images for buttons, cap insets are used to stretch the buttons from the center (instead of stretching the entire image)
		UIImage* img = [[UIImage imageNamed:@"Button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(16, 16, 16, 16)];
		[self setBackgroundImage:img forState:UIControlStateNormal];
		
		UIImage* img2 = [[UIImage imageNamed:@"Button-pressed.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(16, 16, 16, 16)];
		[self setBackgroundImage:img2 forState:UIControlStateHighlighted];
		
		//Set the font to Nexa Bold while preserving font size
		int fontsize = self.titleLabel.font.pointSize;
		self.titleLabel.font = [UIFont fontWithName:@"Nexa Bold" size:fontsize];

		//Set color of title
		[self setTitleColor:[UIColor colorWithRed:(63.0/256.0) green:(70.0/256.0) blue:(68.0/256.0) alpha:1.0] forState:UIControlStateNormal];
		[self setTitleColor:[UIColor colorWithRed:(63.0/256.0) green:(70.0/256.0) blue:(68.0/256.0) alpha:1.0] forState:UIControlStateHighlighted];
		
		//Adjust position of title
		[self setTitleEdgeInsets:UIEdgeInsetsMake(fontsize/4.0, 0.0, 0.0, 0.0)];
		
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code

}
*/

@end
