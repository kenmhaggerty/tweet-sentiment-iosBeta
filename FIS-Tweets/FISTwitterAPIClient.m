//
//  FISTwitterAPIClient.m
//  FIS-Tweets
//
//  Created by Ken M. Haggerty on 2/22/16.
//  Copyright © 2016 James Campagno. All rights reserved.
//

#import "FISTwitterAPIClient.h"
#import "STTwitter.h"
#import "FISPrivateInfo.h"

@interface FISTwitterAPIClient ()
@property (nonatomic, strong) STTwitterAPI *twitter;
@end

@implementation FISTwitterAPIClient

+ (instancetype)sharedClient
{
    static FISTwitterAPIClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[FISTwitterAPIClient alloc] init];
    });
    return sharedClient;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setTwitter:[STTwitterAPI twitterAPIAppOnlyWithConsumerKey:TwitterAPIConsumerKey consumerSecret:TwitterAPIConsumerSecret]];
    }
    return self;
}

+ (void)getTweetsWithQuery:(NSString *)query completion:(void (^)(NSDictionary *metadata, NSArray *statuses))completionBlock
{
    STTwitterAPI *twitter = [[FISTwitterAPIClient sharedClient] twitter];
    [twitter verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
        [twitter getSearchTweetsWithQuery:[query stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]] successBlock:^(NSDictionary *metadata, NSArray *statuses) {
            completionBlock(metadata, statuses);
        } errorBlock:^(NSError *error) {
            NSLog(@"%@", error);
        }];
    } errorBlock:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

@end
