//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "Business.h"
#import "BusinessCell.h"
#import "FiltersViewController.h"

NSString * const kYelpConsumerKey = @"U-Esd3cYBQDJ9n_69LlPfw";
NSString * const kYelpConsumerSecret = @"DlMPGkbPARYWmbi7qWWx6ZD4KqM";
NSString * const kYelpToken = @"jMRKOdbHaFTxQ6jSx8XGv-6Xr4nB_JGr";
NSString * const kYelpTokenSecret = @"uE_Y_nq2P833QUzV-btnblqC2Q0";

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchBarDelegate>

@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSArray *businesses;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) BusinessCell *prototypeBusinessCell;

- (void)fetchBusinessesWithQuery:(NSString *)query params:(NSDictionary *)params;

@property (strong, nonatomic) UISearchBar *searchBar;


@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        
        [self fetchBusinessesWithQuery:@"Restaurants" params:nil];
        
    }
    return self;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchText = [searchBar text];
    NSString *searchTerm = [NSString stringWithFormat:@"%@ Restaurants", searchText];
    [self fetchBusinessesWithQuery:searchTerm params:nil];
    
    [self.searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Cancel button clicked");
    [self fetchBusinessesWithQuery:@"Restaurants" params:nil];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSString *searchText = [searchBar text];
    NSString *searchTerm = [NSString stringWithFormat:@"%@ Restaurants", searchText];
    [self fetchBusinessesWithQuery:searchTerm params:nil];
    
    [self.searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText length] == 0) {
        [self fetchBusinessesWithQuery:@"Restaurants" params:nil];
        [self.searchBar resignFirstResponder];
    }
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.searchBar resignFirstResponder];
}

- (void)fetchBusinessesWithQuery:(NSString *)query params:(NSDictionary *)params {
    [self.client searchWithTerm:query params:params success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"response: %@", response);
        NSArray *businessDictionaries = response[@"businesses"];
        NSLog(@"business: %@", businessDictionaries[0]);
        
        self.businesses = [Business businessesWithDictionaries:businessDictionaries];
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessCell" bundle:nil] forCellReuseIdentifier:@"BusinessCell"];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.title = @"Yelp";
    //[self.navigationController setNavigationBarHidden:YES animated:YES];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filters" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterButton)];
    
    // setup UI search bar
    self.searchBar = [[UISearchBar alloc] init];
    self.navigationItem.titleView = self.searchBar;
    
    // todo: setup the autolayout properties of the search bar
    
    self.searchBar.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.businesses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessCell"];
    
    cell.business = self.businesses[indexPath.row];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // hack to compute the height of the cell.
    
    self.prototypeBusinessCell.business = self.businesses[indexPath.row];
    
    CGSize size = [self.prototypeBusinessCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return size.height + 1;
}

# pragma mark - on filter button

- (void)onFilterButton {
    NSLog(@"selected filter button");
    
    FiltersViewController *vc = [[FiltersViewController alloc] init];
    
    vc.delegate = self;
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:nvc animated:YES completion:nil];
}

# pragma mark - filter delegate

- (void) filtersViewController:(FiltersViewController *)filtersViewController didChangeFilters:(NSDictionary *)filters {
    NSLog(@"fire new network event: %@", filters);
    
    [self fetchBusinessesWithQuery:@"Restaurants" params:filters];

}

# pragma - prototype business cell

- (BusinessCell *) prototypeBusinessCell {
    if (!_prototypeBusinessCell) {
        _prototypeBusinessCell = [self.tableView dequeueReusableCellWithIdentifier:@"BusinessCell"];
    }
    return _prototypeBusinessCell;
}

@end
