//
//  DTCustomColoredAccessory.h
//  Ghost
//
//  Created by Ashutosh Desai on 12/13/12.
//  Copyright (c) 2012 makegameswithus inc. Free to use for all purposes.
//
//  Found on Cocoanetics.com

#import <UIKit/UIKit.h>

@interface DTCustomColoredAccessory : UIControl
{
	UIColor *_accessoryColor;
	UIColor *_highlightedColor;
}
 
@property (nonatomic, retain) UIColor *accessoryColor;
@property (nonatomic, retain) UIColor *highlightedColor;
 
+ (DTCustomColoredAccessory *)accessoryWithColor:(UIColor *)color;
 
@end