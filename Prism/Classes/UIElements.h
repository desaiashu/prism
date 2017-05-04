//
//  UIElements.h
//  Prism
//
//  Created by Ashutosh Desai on 10/24/13.
//  Copyright (c) 2013 makegameswithus inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatTableViewCell.h"
#import "FriendsTableViewCell.h"

#define DARK_SCHEME false

@interface UIElements : NSObject

+(UIColor*)darkColor;
+(UIColor*)lightColor;
+(UIColor*)primaryColor;
+(UIColor*)backgroundColor;

+(UIView*)statusBar;

+(UIView*)header:(NSString*)string withBackButton:(BOOL)back;

+(UILabel*)friendName:(NSString*)string;
+(UILabel*)friendStatus:(NSString*)string;
+(UIView*)friendUnread:(int)number;
+(float)heightForFriendCell;

+(UIButton*)acceptButton;
+(UIButton*)rejectButton;

+(UIButton*)footerButtonWithTitle:(NSString*)title;

+(UILabel*)chatFrom:(NSString*)string;
+(UILabel*)chatTime:(NSString*)string;
+(UILabel*)chatMessage:(NSString*)string;
+(float)heightForChatCell:(NSString*)string;

+(UIButton*)deleteButtonWithHeight:(float)height;

+(UIView*)footer;
+(UITextView*)footerTextInputField;
+(UIButton*)sendButton;

+(UITextField*)textInputField;

+(UILabel*)enterUsername;
+(UITextField*)centerTextInputField;
+(UIButton*)floatingButtonWithTitle:(NSString*)title;

+(UILabel*)passcode;
+(UIButton*)passcodeButtonWithNumber:(int)number;

+(UITextView*)about;

+(UIButton*)button;
+(UITableView*)tableView;

@end
