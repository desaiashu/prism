//
//  SearchDisplayController.m
//  Ghost
//
//  Created by Ashutosh Desai on 12/16/12.
//  Copyright (c) 2012 makegameswithus inc. All rights reserved.
//

#import "SearchDisplayController.h"

@implementation SearchDisplayController

- (void)setActive:(BOOL)visible animated:(BOOL)animated;
{
    [self.searchContentsController.navigationController setNavigationBarHidden:YES animated:NO];
    [super setActive:visible animated:animated];
    [self.searchContentsController.navigationController setNavigationBarHidden:NO animated:NO];
}

@end
