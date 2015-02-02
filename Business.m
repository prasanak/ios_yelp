//
//  Business.m
//  Yelp
//
//  Created by Prasannakumar Jobigenahally on 1/31/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "Business.h"

@implementation Business

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self)  {
        NSArray *categories = dictionary[@"categories"];
        NSMutableArray *categoryNames = [NSMutableArray array];
        [categories enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [categoryNames addObject:obj[0]];
        }];
        
        self.name = dictionary[@"name"];
        self.imageUrl = dictionary[@"image_url"];
        
        // address
        NSString *street = @"";
        if([[dictionary valueForKeyPath:@"location.address"] count] > 0) {
            street = [dictionary valueForKeyPath:@"location.address"][0];
        }
        
        // todo: fix this. yelp api returns city or neighbourhood based on the location. not both. 
        NSString *neighborhood = [dictionary valueForKeyPath:@"location.city"];
        self.address = [NSString stringWithFormat:@"%@, %@", street, neighborhood];
        
        self.numReviews = [dictionary[@"review_count"] integerValue];
        self.ratingImageUrl = dictionary[@"rating_img_url"];
        float milesPerMeter = 0.000621371;
        self.distance = [dictionary[@"distance"] floatValue] * milesPerMeter;
        
    }
    
    return self;
}

+ (NSArray *)businessesWithDictionaries:(NSArray *)dictionaries {
    NSMutableArray *businesses = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        Business *business = [[Business alloc] initWithDictionary:dictionary];
        
        [businesses addObject:business];
    }
    return businesses;
}

@end
