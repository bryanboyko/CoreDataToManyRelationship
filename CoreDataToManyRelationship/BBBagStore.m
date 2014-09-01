//
//  BBBagStore.m
//  ArchiveMultiDimArray
//
//  Created by Bryan Boyko on 8/29/14.
//  Copyright (c) 2014 none. All rights reserved.
//

#import "BBBagStore.h"
#import "BBBag.h"
#import "BBItem.h"
#import "BBItemStore.h"

@import CoreData;

@interface BBBagStore ()

@property (nonatomic) NSMutableArray *privateBags;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;

@end

@implementation BBBagStore

+ (instancetype)sharedStore{
    static BBBagStore *sharedStore = nil;
    
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
        NSString *path = self.bagArchivePath;
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
        
        [self loadAllBags];
    }
    return self;
}

- (void)loadAllBags
{
    if (!self.privateBags) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [NSEntityDescription entityForName:@"BBBag" inManagedObjectContext:self.context];
        
        request.entity = e;
        
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"bagOrderingValue" ascending:YES];
        
        request.sortDescriptors = @[sd];
        
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"reason: %@", [error localizedDescription]];
        }
        
        self.privateBags = [[NSMutableArray alloc] initWithArray:result];
    }
}


- (NSArray *)allBags
{
    return self.privateBags;
}


- (BBBag *)createBag
{
    double order;
    if ([self.allBags count] == 0 ) {
        order = 1.0;
    } else {
        order = [[self.privateBags lastObject] bagOrderingValue] + 1.0;
    }
    
    NSLog(@"adding after %d bags, order = %.2f", [self.privateBags count], order);
    
    BBBag *bag = [NSEntityDescription insertNewObjectForEntityForName:@"BBBag" inManagedObjectContext:self.context];
    
    bag.bagOrderingValue = order;
    
    [self.privateBags addObject:bag];
    
    return bag;
}


- (void)removeBag:(BBBag *)bag
{
    [self.context deleteObject:bag];
    [self.privateBags removeObjectIdenticalTo:bag];
}

- (NSString *)bagArchivePath
{
    NSArray *documentDictionaries = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // get the document directory from the list
    NSString *documentDirectory = [documentDictionaries firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"bags.data"];
}



- (BOOL)saveChanges
{
    NSError *error;
    BOOL successful = [self.context save:&error];
    if (!successful) {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    return successful;
}




@end
