//
//  StyledLabel.m
//  Prism
//
//  Created by Ashutosh Desai on 10/24/13.
//  Copyright (c) 2013 makegameswithus inc. All rights reserved.
//

#import "StyledLabel.h"

@implementation StyledLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (id)h1WithString:(NSString*)string
{
	StyledLabel *h1 = [[StyledLabel alloc] initWithString:string];
	h1.text = string;
}

- (id)initWithString:(NSString*)string
{
	self = [super init];
    if (self) {
        // Initialization code
		self.text = string;
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
