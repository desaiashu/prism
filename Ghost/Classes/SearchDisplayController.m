//
//  SearchDisplayController.m
//  Ghost
//
//  Created by Ashutosh Desai on 12/16/12.
//  Copyright (c) 2012 makegameswithus inc. Free to use for all purposes.
//

#import "SearchDisplayController.h"

@implementation SearchDisplayController

//Pretty obscure bug, basically when you're searching using a searchbar/searchdisplaycontroller it does weird things to the nav bar. In this case when you hit the back button it makes the nav bar appear on the menu even when we hide it in the viewWillAppear of the menu. This hack basically fools the search bar into thinking the nav bar is hidden, so it doesn't do any of it's weird stuff in setActive:animated:.
- (void)setActive:(BOOL)visible animated:(BOOL)animated;
{
    [self.searchContentsController.navigationController setNavigationBarHidden:YES animated:NO];
    [super setActive:visible animated:animated];
    [self.searchContentsController.navigationController setNavigationBarHidden:NO animated:NO];
}

@end
