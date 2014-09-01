//
//  BBChooseBagContentsTableViewController.h
//  ArchiveMultiDimArray
//
//  Created by Bryan Boyko on 8/29/14.
//  Copyright (c) 2014 none. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBBag;

@interface BBChooseBagContentsTableViewController : UITableViewController


@property (nonatomic, strong) BBBag *bag;
@property (nonatomic, copy) void (^dismissBlock)(void);

@end
