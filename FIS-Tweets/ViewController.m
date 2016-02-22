//
//  ViewController.m
//  FIS-Tweets
//
//  Created by James Campagno on 11/2/15.
//  Copyright © 2015 James Campagno. All rights reserved.
//

#import "ViewController.h"
#import "FISTwitterAPIClient.h"
#import "FISSentiment140APIClient.h"

@interface ViewController ()
@property (nonatomic, strong) IBOutlet UILabel *sentiment;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSURLQueryItem *query = [NSURLQueryItem queryItemWithName:TwitterSearchAPIKey_Content value:@"FlatironSchool"];
//    [FISTwitterAPIClient getTweetsWithQuery:@[query] completion:^(NSArray <NSDictionary *> *tweets) {
//        //
//    }];
    
    [FISTwitterAPIClient getTweetsWithQuery:@"FlatironSchool" completion:^(NSDictionary *metadata, NSArray <NSDictionary *> *statuses) {
        NSMutableArray *text = [NSMutableArray arrayWithCapacity:statuses.count];
        for (NSUInteger i = 0; i < statuses.count; i++)
        {
            [text addObject:statuses[i][TwitterAPIKeyText]];
        }
        [FISSentiment140APIClient getSentimentsForText:text completion:^(NSArray <NSDictionary *> *sentiments) {
            float averageSentiment = 0.0f;
            for (NSUInteger i = 0; i < sentiments.count; i++)
            {
                averageSentiment += [sentiments[i][Sentiment140APIKeyPolarity] integerValue];
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.sentiment setText:[NSString stringWithFormat:@"%f", averageSentiment/sentiments.count]];
            });
        }];
    }];
}


@end
