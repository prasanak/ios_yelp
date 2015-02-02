//
//  FiltersViewController.m
//  Yelp
//
//  Created by Prasannakumar Jobigenahally on 2/1/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "FiltersViewController.h"

@interface FiltersViewController ()

@property (nonatomic, readonly) NSDictionary *filters;

@end

@implementation FiltersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(onApplyButton)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark - on cancel button and on apply button

- (void)onCancelButton {
    NSLog(@"On cancel button");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) onApplyButton {
    NSLog(@"On apply button");
    [self.delegate filtersViewController:self didChangeFilters:self.filters];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
