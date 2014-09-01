//
//  BBItem.h
//  CoreDataToManyRelationship
//
//  Created by Bryan Boyko on 8/31/14.
//  Copyright (c) 2014 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BBBag;

@interface BBItem : NSManagedObject

@property (nonatomic, retain) NSString * itemName;
@property (nonatomic) double itemOrderingValue;
@property (nonatomic, retain) BBBag *bag;

@end
