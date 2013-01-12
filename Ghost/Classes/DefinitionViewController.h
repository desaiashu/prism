//
//  DefinitionViewController.h
//  Ghost
//
//  Created by Ashutosh Desai on 12/14/12.
//  Copyright (c) 2012 makegameswithus inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DefinitionViewController : UIViewController <UIGestureRecognizerDelegate>
{
	NSString *definition;
}

@property IBOutlet UITextView *textView;
@property NSString *definition;

@end
