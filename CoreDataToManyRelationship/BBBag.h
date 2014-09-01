//
//  BBBag.h
//  CoreDataToManyRelationship
//
//  Created by Bryan Boyko on 8/31/14.
//  Copyright (c) 2014 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BBItem;

@interface BBBag : NSManagedObject

@property (nonatomic, retain) NSString * bagName;
@property (nonatomic) double bagOrderingValue;
@property (nonatomic, retain) NSSet *item;



//@property (nonatomic) NSMutableArray *itemsInBag;


@end

@interface BBBag (CoreDataGeneratedAccessors)

- (void)addItemObject:(BBItem *)value;
- (void)removeItemObject:(BBItem *)value;
- (void)addItem:(NSSet *)values;
- (void)removeItem:(NSSet *)values;

@end
