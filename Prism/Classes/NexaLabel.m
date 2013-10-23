//
//  NexaLabel.m
//  Ghost
//
//  Created by Ashutosh Desai on 1/9/13.
//  Copyright (c) 2013 makegameswithus inc. All rights reserved.
//

#import "NexaLabel.h"

@implementation NexaLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//The storyboard calls this method to create some labels
- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
    if (self) {
		//Set font to Nexa Bold while preserving font size
		int fontsize = self.font.pointSize;
		self.font = [UIFont fontWithName:@"Nexa Bold" size:fontsize];
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
