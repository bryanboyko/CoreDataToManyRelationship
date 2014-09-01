//
//  BBMenuViewController.m
//  ArchiveMultiDimArray
//
//  Created by Bryan Boyko on 8/29/14.
//  Copyright (c) 2014 none. All rights reserved.
//

#import "BBMenuViewController.h"
#import "BBItemTableViewController.h"
#import "BBBagTableViewController.h"

@interface BBMenuViewController ()

@end

@implementation BBMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    UIButton *itemsButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 120, 40)];
    [itemsButton setTitle:@"ITEMS" forState:UIControlStateNormal];
    [itemsButton addTarget:self action:@selector(pushItemsTableView) forControlEvents:UIControlEventTouchUpInside];
    itemsButton.backgroundColor = [UIColor redColor];
    
    UIButton *bagsButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 120, 40)];
    [bagsButton setTitle:@"BAGS" forState:UIControlStateNormal];
    [bagsButton addTarget:self action:@selector(pushBagsTableView) forControlEvents:UIControlEventTouchUpInside];
    bagsButton.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:itemsButton];
    [self.view addSubview:bagsButton];
}

- (void)pushItemsTableView
{
    BBItemTableViewController *tvc = [[BBItemTableViewController alloc] init];
    [self.navigationController pushViewController:tvc animated:YES];
}

- (void)pushBagsTableView
{
    BBBagTableViewController *tvc = [[BBBagTableViewController alloc] init];
    [self.navigationController pushViewController:tvc animated:YES];
}

@end
