//
//  BBBagContentsTableViewController.m
//  ArchiveMultiDimArray
//
//  Created by Bryan Boyko on 8/29/14.
//  Copyright (c) 2014 none. All rights reserved.
//

#import "BBBagContentsTableViewController.h"
#import "BBBagStore.h"
#import "BBItem.h"
#import "BBItemStore.h"
#import "BBChooseBagContentsTableViewController.h"
#import "BBItemTableViewCell.h"

@interface BBBagContentsTableViewController ()

@property (nonatomic) NSMutableArray *privateBagItems;

@end

@implementation BBBagContentsTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //add existing exercise button to nav bar
        UINavigationItem *navItem = self.navigationItem;
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addExistingItem:)];
        navItem.rightBarButtonItem = bbi;
        
    }
    
    return self;
}

//method for custom nav bar
- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set up tableview
    self.tableView.rowHeight = 60;

    
    [self.tableView setSeparatorColor:[UIColor darkGrayColor]];
    //load nib
    UINib *nib = [UINib nibWithNibName:@"BBItemTableViewCell" bundle:nil];
    
    //register nib containing cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"BBItemTableViewCell"];
    
    //self.privateBagItems = self.bag.itemsInBag;
}

- (void)viewWillAppear:(BOOL)animated
{
    // navigation bar appearance
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor blackColor],NSForegroundColorAttributeName,
                                    [UIColor blackColor],NSBackgroundColorAttributeName,nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    self.title = self.bag.bagName;
    
    //tableview
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma tableview code


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [self.bag.itemsInBag count];
    
    
    // to-many code
    return [self.bag.item.allObjects count];
    
    NSLog(@"there are %lu items in bag", (unsigned long)[self.bag.item.allObjects count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //get new cell
    BBItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBItemTableViewCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    
    // to-many code
    BBItem *item = [self.bag.item.allObjects objectAtIndex:indexPath.row];
    
    
    cell.textLabel.text = item.itemName;
    
    return cell;
    
}

- (IBAction)addExistingItem:(id)sender
{
    BBChooseBagContentsTableViewController *tvc = [[BBChooseBagContentsTableViewController alloc] init];
    
    tvc.bag = self.bag;
    
    tvc.dismissBlock = ^{
        [self.tableView reloadData];
    };
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:tvc];
    
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:navController animated:YES completion:nil];
}

- (IBAction)toggleEditingMode:(id)sender
{
    if (self.isEditing) {
        [self setEditing:NO animated:YES];
    } else {
        [self setEditing:YES animated:YES];
    }
}




@end
