//
//  NewChatViewController.h
//  Prism
//
//  Created by Ashutosh Desai on 9/4/13.
//  Copyright (c) 2013 makegameswithus inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface NewChatViewController : UIViewController <UITextFieldDelegate, MFMessageComposeViewControllerDelegate>
{
	IBOutlet UITextField *username;
}

- (IBAction)go:(id)sender;
- (IBAction)back:(id)sender;

@end
