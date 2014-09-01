//
//  BBItemDetailViewController.h
//  ArchiveMultiDimArray
//
//  Created by Bryan Boyko on 8/29/14.
//  Copyright (c) 2014 none. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBItem;

@interface BBItemDetailViewController : UIViewController

@property (nonatomic, strong) BBItem *item;

- (instancetype)initForNewItem:(BOOL)isNew;

@property (nonatomic, copy) void (^dismissBlock)(void);

@end
