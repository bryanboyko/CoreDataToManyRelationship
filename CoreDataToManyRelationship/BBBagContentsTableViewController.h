//
//  BBBagContentsTableViewController.h
//  ArchiveMultiDimArray
//
//  Created by Bryan Boyko on 8/29/14.
//  Copyright (c) 2014 none. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBBag.h"

@interface BBBagContentsTableViewController : UITableViewController


@property (nonatomic) UISwipeGestureRecognizer *cellStartEditing, *cellStopEditing;

@property (nonatomic) BBBag *bag;


@end
