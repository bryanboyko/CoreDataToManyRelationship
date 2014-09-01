//
//  BBItemTableViewController.m
//  ArchiveMultiDimArray
//
//  Created by Bryan Boyko on 8/29/14.
//  Copyright (c) 2014 none. All rights reserved.
//

#import "BBItemTableViewController.h"
#import "BBItemDetailViewController.h"
#import "BBItemStore.h"
#import "BBItem.h"
#import "BBItemTableViewCell.h"

@interface BBItemTableViewController ()

@end

@implementation BBItemTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        //add new exercise button
        UINavigationItem *navItem = self.navigationItem;
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        navItem.rightBarButtonItem = bbi;
    }
    return self;
}

- (void)viewDidLoad
{
    //SET UP TABLEVIEW
    self.tableView.rowHeight = 60;
    [self.tableView setSeparatorColor:[UIColor darkGrayColor]];
    
    //load nib
    UINib *nib = [UINib nibWithNibName:@"BBItemTableViewCell" bundle:nil];
    
    //register nib containing cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"BBItemTableViewCell"];
    
}

- (void)viewWillAppear:(BOOL)animated{
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
    self.cellStartEditing = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(toggleEditingMode:)];
    
    BBItemDetailViewController *dvc = [[BBItemDetailViewController alloc] initForNewItem:NO];
    
    NSArray *items = [[BBItemStore sharedStore] allItems];
    BBItem *selectedItem = items[indexPath.row];
    
    dvc.item = selectedItem;
    
    [self.navigationController pushViewController:dvc animated:YES];
}

- (IBAction)addNewItem:(id)sender
{
    BBItem *newItem = [[BBItemStore sharedStore] createItem];
    
    BBItemDetailViewController *dvc = [[BBItemDetailViewController alloc] initForNewItem:YES];
    
    dvc.item = newItem;
    
    dvc.dismissBlock = ^{
        [self.tableView reloadData];
    };
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:dvc];
    
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:navController animated:YES completion:nil];
}

- (IBAction)toggleEditingMode:(id)sender
{
    if (self.isEditing) {
        [self setEditing:NO animated:YES];
    } else {
        [self.tableView reloadData];
        [self setEditing:YES animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if tableview is asking to commit a delete command
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *items = [[BBItemStore sharedStore] allItems];
        BBItem *item = items[indexPath.row];
        [[BBItemStore sharedStore] removeItem:item];
        
        //remove row with animation
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    [self.tableView reloadData];
}

@end
