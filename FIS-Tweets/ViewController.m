//
//  ViewController.m
//  FIS-Tweets
//
//  Created by James Campagno on 11/2/15.
//  Copyright © 2015 James Campagno. All rights reserved.
//

#import "ViewController.h"
#import "FISTwitterAPIClient.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSURLQueryItem *query = [NSURLQueryItem queryItemWithName:TwitterSearchAPIKey_Content value:@"FlatironSchool"];
//    [FISTwitterAPIClient getTweetsWithQuery:@[query] completion:^(NSArray <NSDictionary *> *tweets) {
//        //
//    }];
    
    [FISTwitterAPIClient getTweetsWithQuery:@"FlatironSchool" completion:^(NSDictionary *metadata, NSArray *statuses) {
        //
    }];
}


@end
