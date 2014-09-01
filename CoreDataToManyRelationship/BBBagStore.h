//
//  BBBagStore.h
//  ArchiveMultiDimArray
//
//  Created by Bryan Boyko on 8/29/14.
//  Copyright (c) 2014 none. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BBBag;

@interface BBBagStore : NSObject


@property (nonatomic, readonly) NSArray *allBags;


+ (instancetype)sharedStore;
- (BBBag *)createBag;

- (void)removeBag:(BBBag *)bag;

- (BOOL)saveChanges;


@end
