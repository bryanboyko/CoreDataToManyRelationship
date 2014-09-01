//
//  BBChooseBagContentsTableViewController.m
//  ArchiveMultiDimArray
//
//  Created by Bryan Boyko on 8/29/14.
//  Copyright (c) 2014 none. All rights reserved.
//

#import "BBChooseBagContentsTableViewController.h"
#import "BBBagContentsTableViewController.h"
#import "BBBagDetailViewController.h"
#import "BBBagTableViewController.h"
#import "BBBag.h"
#import "BBItemStore.h"
#import "BBItem.h"
#import "BBItemTableViewCell.h"

@interface BBChooseBagContentsTableViewController ()

@property (nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation BBChooseBagContentsTableViewController

- (instancetype)init{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        UIBarButtonItem *doneExercise = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
        self.navigationItem.rightBarButtonItem = doneExercise;
        
        UIBarButtonItem *cancelExercise = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
        self.navigationItem.leftBarButtonItem = cancelExercise;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set up tableview
    self.tableView.rowHeight = 60;
    //load nib
    UINib *nib = [UINib nibWithNibName:@"BBItemTableViewCell" bundle:nil];
    [self.tableView setSeparatorColor:[UIColor darkGrayColor]];
    
    
    //register nib containing cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"BBItemTableViewCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BBItemStore sharedStore] allItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //get new cell
    BBItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBItemTableViewCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    
    NSArray *items = [[BBItemStore sharedStore] allItems];
    BBItem *item = items[indexPath.row];
    
    //fill custom cell
    cell.textLabel.text = item.itemName;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *items = [[BBItemStore sharedStore] allItems];
    BBItem *tableItem = items[indexPath.row];
    
    NSManagedObjectContext *context = [self.bag managedObjectContext];
    
    BBItem *contextItem = [NSEntityDescription insertNewObjectForEntityForName:@"BBItem" inManagedObjectContext:context];
    
    contextItem.itemName = tableItem.itemName;
    contextItem.itemOrderingValue = tableItem.itemOrderingValue;
    
    [self.bag addItemObject:contextItem];
    
    [self dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (void)save:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (void)cancel:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}



@end
