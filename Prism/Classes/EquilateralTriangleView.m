//
//  EquilateralTriangleView.m
//  Prism
//
//  Created by Ashutosh Desai on 10/24/13.
//  Copyright (c) 2013 makegameswithus inc. All rights reserved.
//

#import "EquilateralTriangleView.h"

@implementation EquilateralTriangleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(void)drawRect:(CGRect)rect
{
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	CGContextBeginPath(ctx);
	CGContextMoveToPoint   (ctx, CGRectGetMinX(rect), CGRectGetMinY(rect));  // top left
	CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMidY(rect));  // mid right
	CGContextAddLineToPoint(ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect));  // bottom left
	CGContextClosePath(ctx);
	
//	CGContextSetRGBFillColor(ctx, 1, 1, 0, 1);
	CGContextFillPath(ctx);
}


@end
