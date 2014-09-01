//
//  BBItemStore.m
//  ArchiveMultiDimArray
//
//  Created by Bryan Boyko on 8/29/14.
//  Copyright (c) 2014 none. All rights reserved.
//

#import "BBItemStore.h"
#import "BBItem.h"

@import CoreData;

@interface BBItemStore ()

@property (nonatomic) NSMutableArray *privateItems;
@property (nonatomic) NSManagedObjectContext *context;
@property (nonatomic) NSManagedObjectModel *model;

@end

@implementation BBItemStore

+ (instancetype)sharedStore{
    static BBItemStore *sharedStore = nil;
    
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    return sharedStore;
}


- (instancetype)init
{
    @throw [NSException exceptionWithName:@"singleton" reason:@"use shared store init method" userInfo:nil];
    return nil;
}


- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        
        // read in .xcdatamodeld
        self.model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
        
        // where does the SQLight go?
        NSString *path = self.itemArchivePath;
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        NSError *error = nil;
        
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:storeURL
                                     options:nil
                                       error:&error]) {
            @throw [NSException exceptionWithName:@"OpenFailure"
                                           reason:[error localizedDescription]
                                         userInfo:nil];
        }
        
        // create the managed object context
        self.context = [[NSManagedObjectContext alloc] init];
        self.context.persistentStoreCoordinator = psc;
        
        [self loadAllItems];
    }
    return self;
}


- (void)loadAllItems
{
    if (!self.privateItems) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [NSEntityDescription entityForName:@"BBItem" inManagedObjectContext:self.context];
        
        request.entity = e;
        
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"itemOrderingValue" ascending:YES];
        
        request.sortDescriptors = @[sd];
        
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        self.privateItems = [[NSMutableArray alloc] initWithArray:result];
    }
}


- (NSArray *)allItems
{
    return self.privateItems;
}


- (BBItem *)createItem
{
    double order;
    if ([self.allItems count] == 0) {
        order = 1.0;
    } else {
        order = [[self.privateItems lastObject] itemOrderingValue] + 1.0;
    }
    NSLog(@"adding after %d items, order = %.2f", [self.privateItems count], order);
    
    BBItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"BBItem" inManagedObjectContext:self.context];
    
    item.itemOrderingValue = order;
    
    [self.privateItems addObject:item];
    
    return item;
}


- (void)removeItem:(BBItem *)item
{
    [self.context deleteObject:item];
    [self.privateItems removeObjectIdenticalTo:item];
}

- (NSString *)itemArchivePath
{
    NSArray *documentDictionaries = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // get the document directory from the list
    NSString *documentDirectory = [documentDictionaries firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"items.data"];
}



- (BOOL)saveChanges
{
    // returns YES on success
    NSError *error;
    BOOL successful = [self.context save:&error];
    if (!successful) {
        NSLog(@"error saving: %@", [error localizedDescription]);
    }
    return successful;
}


@end
