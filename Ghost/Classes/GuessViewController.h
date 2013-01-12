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
	//Labels + challenge button
	IBOutlet UILabel *time;
	IBOutlet UILabel *word;
	IBOutlet UIButton *challenge;
	
	//This text field is hidden (transparent), but required to take keyboard input
	IBOutlet UITextField *letter;
	
	//Delegate to pass back user input to
	id <GuessDelegate> delegate;
	
	//String to keep track of word
	NSString *w;
	
	//Timer + counter to decrement label
	NSTimer *timer;
	int counter;
}

@property id<GuessDelegate> delegate;
@property NSString *w;

- (IBAction)challenge:(id)sender;

@end
