@interface DTCustomColoredAccessory : UIControl
{
	UIColor *_accessoryColor;
	UIColor *_highlightedColor;
}
 
@property (nonatomic, retain) UIColor *accessoryColor;
@property (nonatomic, retain) UIColor *highlightedColor;
 
+ (DTCustomColoredAccessory *)accessoryWithColor:(UIColor *)color;
 
@end