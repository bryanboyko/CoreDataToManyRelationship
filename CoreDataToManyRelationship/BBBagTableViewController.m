//
//  BBBagTableViewController.m
//  ArchiveMultiDimArray
//
//  Created by Bryan Boyko on 8/29/14.
//  Copyright (c) 2014 none. All rights reserved.
//

#import "BBBagTableViewController.h"
#import "BBBagDetailViewController.h"
#import "BBBagContentsTableViewController.h"
#import "BBBagTableViewCell.h"
#import "BBBagTableViewCell.h"

@interface BBBagTableViewController ()

@end

@implementation BBBagTableViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        //add button to create new plan
        UINavigationItem *navItem = self.navigationItem;
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewBag:)];
        navItem.rightBarButtonItem = bbi;
    }
    return self;
}

- (void)viewDidLoad
{
    //SET UP TABLEVIEW
    self.tableView.rowHeight = 60;
    [self.tableView setSeparatorColor:[UIColor darkGrayColor]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //load nib
    UINib *nib = [UINib nibWithNibName:@"BBBagTableViewCell" bundle:nil];
    
    //register nib containing cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"BBBagTableViewCell"];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BBBagStore sharedStore] allBags] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //get new cell
    BBBagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBBagTableViewCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    
    NSArray *bags = [[BBBagStore sharedStore] allBags];
    BBBag *bag = bags[indexPath.row];
    
    //fill custom cell
    cell.textLabel.text = bag.bagName;
    
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.cellStartEditing = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(toggleEditingMode:)];
    
    BBBagContentsTableViewController *tvc = [[BBBagContentsTableViewController alloc] init];
    
    NSArray *bags = [[BBBagStore sharedStore] allBags];
    BBBag *selectedBag = bags[indexPath.row];
    
    tvc.bag = selectedBag;
    
    [self.navigationController pushViewController:tvc animated:YES];
}

- (IBAction)addNewBag:(id)sender
{
    BBBag *newBag = [[BBBagStore sharedStore] createBag];
    
    BBBagDetailViewController *dvc = [[BBBagDetailViewController alloc] initForNewBag:YES];
    
    dvc.bag = newBag;
    
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
        NSArray *bags = [[BBBagStore sharedStore] allBags];
        BBBag *bag = bags[indexPath.row];
        [[BBBagStore sharedStore] removeBag:bag];
        
        //remove row with animation
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    [self.tableView reloadData];
}

@end
