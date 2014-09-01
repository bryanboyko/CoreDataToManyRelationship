//
//  BBBagTableViewController.h
//  ArchiveMultiDimArray
//
//  Created by Bryan Boyko on 8/29/14.
//  Copyright (c) 2014 none. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBBag.h"
#import "BBBagStore.h"

@interface BBBagTableViewController : UITableViewController

@property (nonatomic) UISwipeGestureRecognizer *cellStartEditing, *cellStopEditing;

@end
