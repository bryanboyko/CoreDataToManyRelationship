//
//  BBItemStore.h
//  ArchiveMultiDimArray
//
//  Created by Bryan Boyko on 8/29/14.
//  Copyright (c) 2014 none. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BBItem;

@interface BBItemStore : NSObject


@property (nonatomic, readonly) NSArray *allItems;

+ (instancetype)sharedStore;
- (BBItem *)createItem;


- (void)removeItem:(BBItem *)item;

- (BOOL)saveChanges;



@end
