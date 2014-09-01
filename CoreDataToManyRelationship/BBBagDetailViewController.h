//
//  BBBagDetailViewController.h
//  ArchiveMultiDimArray
//
//  Created by Bryan Boyko on 8/29/14.
//  Copyright (c) 2014 none. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBBag;

@interface BBBagDetailViewController : UIViewController

@property (nonatomic, strong) BBBag *bag;

- (instancetype)initForNewBag:(BOOL)isNew;

@property (nonatomic, copy) void (^dismissBlock)(void);

@end
