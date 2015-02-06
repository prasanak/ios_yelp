//
//  FiltersViewController.m
//  Yelp
//
//  Created by Prasannakumar Jobigenahally on 2/1/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "FiltersViewController.h"
#import "SwitchCell.h"
#import "Filters.h"

@interface FiltersViewController () <UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate>

@property (nonatomic, readonly) NSDictionary *filters;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSMutableSet *selectedCategories;
@property (nonatomic, strong) Filters *businessFilters;
@property (nonatomic, strong) NSMutableDictionary *activeFilters;
@property (strong, nonatomic) NSArray* availableFilters;



- (void)initCategories;
- (void) initAvailableFilters;

@end

@implementation FiltersViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        self.selectedCategories = [NSMutableSet set];
        self.businessFilters = [[Filters alloc] init];
        [self initCategories];
        [self initAvailableFilters];

    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:@selector(onApplyButton)];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SwitchCell" bundle:nil] forCellReuseIdentifier:@"SwitchCell"];
    
}

- (void) viewWillAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.activeFilters = [defaults objectForKey:@"activeFilters"] ? [defaults objectForKey:@"activeFilters"]: [NSMutableDictionary dictionary];
    self.selectedCategories = [NSMutableSet setWithArray:[defaults objectForKey:@"selectedCategories"]];
    
    CGFloat distanceMeters = [[self.activeFilters valueForKey:@"radius_filter"] floatValue];
    if (distanceMeters > 0) {
        CGFloat distanceMiles = distanceMeters/1600;
        [self.activeFilters setObject:[NSString stringWithFormat:@"%li", (long)[@(distanceMiles) integerValue]] forKey:@"radius_filter"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.availableFilters.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id value = self.availableFilters[section][@"value"];
    if ([value isKindOfClass:[NSString class]]) {
        return 1;
    } else {
        return [value count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSLog(@"section : %ld", section);
    return self.availableFilters[section][@"name"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
    cell.delegate = self;
    
    NSInteger section = indexPath.section;
    NSString *distanceMile;
    id dealsFilter = [self.activeFilters objectForKey:@"deals_filter"];
    id sortFilter = [self.activeFilters valueForKey:@"sort"];
    id radiusFilter = [self.activeFilters valueForKey:@"radius_filter"];
    
    switch (section) {
        case 0: // Deals
            cell.delegate = self;
            cell.on = dealsFilter;
            cell.titleLabel.text = self.availableFilters[section][@"value"];
            break;
        case 1: // Sort By
            cell.delegate = self;
            cell.on = sortFilter ? ([sortFilter integerValue] == indexPath.row) : false;
            cell.titleLabel.text = [self.availableFilters[section][@"value"] objectAtIndex:indexPath.row];
            break;
        case 2: // Distance
            cell.delegate = self;
            distanceMile = [self.availableFilters[section][@"value"] objectAtIndex:indexPath.row];
            cell.on = [radiusFilter integerValue] > 0 ? [radiusFilter isEqualToString:distanceMile] : false;
            cell.titleLabel.text = distanceMile;
            break;
        case 3: //Categories
            cell.delegate = self;
            cell.on = [self.selectedCategories containsObject:self.categories[indexPath.row]];
            cell.titleLabel.text = self.categories[indexPath.row][@"name"];
            break;
    }
    
    
    return cell;
}

# pragma switch cell delegate

- (void)switchCell:(SwitchCell *)cell didUpdateValue:(BOOL)value {
    
    NSLog(@"switch cell update");
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (indexPath.section == 0) { // Deals
        if (value) {
            [self.activeFilters setObject:@true forKey:@"deals_filter"];
        } else {
            [self.activeFilters removeObjectForKey:@"deals_filter"];
        }
    } else if (indexPath.section == 1) { // Sort
        if (value) {
            [self.activeFilters setObject:@(indexPath.row) forKey:@"sort"];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        } else {
            [self.activeFilters removeObjectForKey:@"sort"];
        }
    } else if (indexPath.section == 2) { // Radius
        if (value) {
            NSArray *distances = [[self.availableFilters objectAtIndex:indexPath.section] valueForKey:@"value"];
            NSString *selectedDistance = [distances objectAtIndex:indexPath.row];
            [self.activeFilters setObject:selectedDistance forKey:@"radius_filter"];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        } else {
            [self.activeFilters removeObjectForKey:@"radius_filter"];
        }
    } else if (indexPath.section == 3) { // Categories
        if (value) {
            [self.selectedCategories addObject:self.categories[indexPath.row]];
        } else {
            [self.selectedCategories removeObject:self.categories[indexPath.row]];
        }
    }
    
}


# pragma mark - on cancel button and on apply button

- (NSDictionary *) filters {
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];
    
    if (self.selectedCategories.count > 0) {
        NSMutableArray *names = [NSMutableArray array];
        for (NSDictionary *category in self.selectedCategories) {
            [names addObject:category[@"code"]];
        }
        NSString *categoryFilter = [names componentsJoinedByString:@","];
        [filters setObject:categoryFilter forKey:@"category_filter"];
    }
    
    // Massage the radius data
    NSString *distanceMiles = [self.activeFilters valueForKey:@"radius_filter"];
    if (distanceMiles.length > 0) {
        CGFloat distanceMeters = [distanceMiles floatValue]*1600;
        [self.activeFilters setObject:@(distanceMeters) forKey:@"radius_filter"];
    }
    
    // Add all filters
    [filters addEntriesFromDictionary:self.activeFilters];
    
    return filters;
}

- (void)onCancelButton {
    NSLog(@"On cancel button");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) onApplyButton {
    NSLog(@"On apply button");
    [self.delegate filtersViewController:self didChangeFilters:self.filters];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.activeFilters forKey:@"activeFilters"];
    [defaults setObject:[self.selectedCategories allObjects] forKey:@"selectedCategories"];
    [defaults synchronize];
    
}

- (void) initAvailableFilters {
    self.availableFilters = @[
                              
                              [NSDictionary dictionaryWithObjectsAndKeys:@"Deals", @"name",
                               @"Show me deals only", @"value", nil],
                              [NSDictionary dictionaryWithObjectsAndKeys:@"Sort By", @"name",
                               @[@"Best Matched", @"Distance", @"Highest Rated"], @"value", nil ],
                              [NSDictionary dictionaryWithObjectsAndKeys:@"Distance", @"name",
                               @[@"1", @"5", @"10", @"20"], @"value", nil ],
                              [NSDictionary dictionaryWithObjectsAndKeys:@"Categories", @"name",
                               self.categories, @"value", nil ]
                              ];
}


- (void)initCategories {
    self.categories = self.businessFilters.filterHierachy[@"categories"];
}

@end
