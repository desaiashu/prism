//
//  NewChatViewController.h
//  Prism
//
//  Created by Ashutosh Desai on 9/4/13.
//  Copyright (c) 2013 makegameswithus inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewChatViewController : UIViewController <UITextFieldDelegate>
{
	IBOutlet UITextField *username;
}

- (IBAction)go:(id)sender;
- (IBAction)back:(id)sender;

@end
