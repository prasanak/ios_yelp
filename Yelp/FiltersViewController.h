//
//  FiltersViewController.h
//  Yelp
//
//  Created by Prasannakumar Jobigenahally on 2/1/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FiltersViewController;

@protocol FiltersViewControllerDelegate <NSObject>

- (void)filtersViewController:(FiltersViewController *)
filtersViewController didChangeFilters:(NSDictionary *)fiters;

@end

@interface FiltersViewController : UIViewController

@property (nonatomic, weak) id<FiltersViewControllerDelegate> delegate;

@end
