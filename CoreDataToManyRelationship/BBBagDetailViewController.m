//
//  BBBagDetailViewController.m
//  ArchiveMultiDimArray
//
//  Created by Bryan Boyko on 8/29/14.
//  Copyright (c) 2014 none. All rights reserved.
//

#import "BBBagDetailViewController.h"
#import "BBBag.h"
#import "BBBagStore.h"


@interface BBBagDetailViewController ()

@property (weak, nonatomic) IBOutlet UITextField *bagNameTextField;

@end

@implementation BBBagDetailViewController

- (instancetype)initForNewBag:(BOOL)isNew
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        if (isNew) {
            UIBarButtonItem *doneBag = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
            self.navigationItem.rightBarButtonItem = doneBag;
            
            UIBarButtonItem *cancelBag = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
            self.navigationItem.leftBarButtonItem = cancelBag;
            
            self.navigationItem.title = self.bag.bagName;
        }
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"Wrong init" reason:@"Use initForNewPlan" userInfo:nil];
    return nil;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    BBBag *bag = self.bag;
    
    self.bagNameTextField.text = bag.bagName;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
    
    BBBag *bag = self.bag;
    bag.bagName = self.bagNameTextField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)save:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (void)cancel:(id)sender
{
    //if user cancels, remove exercise from store
    [[BBBagStore sharedStore] removeBag:self.bag];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}
- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}

@end
