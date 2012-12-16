//
//  GuessViewController.h
//  Ghost
//
//  Created by Ashutosh Desai on 12/12/12.
//  Copyright (c) 2012 makegameswithus inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GuessDelegate <NSObject>

-(void)guessed:(NSString*)letter;

@end

@interface GuessViewController : UIViewController <UITextFieldDelegate>
{
	IBOutlet UILabel *time;
	IBOutlet UILabel *word;
	IBOutlet UILabel *underline;
	IBOutlet UIButton *challenge;
	IBOutlet UITextField *letter;
	id <GuessDelegate> delegate;
	NSString *w;
	
	NSTimer *timer;
	int counter;
}

@property id<GuessDelegate> delegate;
@property NSString *w;

- (IBAction)challenge:(id)sender;

@end
