//
//  Filters.h
//  Yelp
//
//  Created by Prasannakumar Jobigenahally on 2/2/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Filters : NSObject

@property (nonatomic, strong) NSArray *filterNames;
@property (nonatomic, strong) NSArray *filterTypes;
@property (nonatomic, strong) NSArray *isExpanded;
@property (nonatomic, strong) NSDictionary *filterHierachy;

@end
