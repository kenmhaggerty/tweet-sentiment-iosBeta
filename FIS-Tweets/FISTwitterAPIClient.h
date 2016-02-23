//
//  FISTwitterAPIClient.h
//  FIS-Tweets
//
//  Created by Ken M. Haggerty on 2/22/16.
//  Copyright © 2016 James Campagno. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const TwitterAPIKeyText;

@interface FISTwitterAPIClient : NSObject
+ (void)getTweetsWithQuery:(NSString *)query completion:(void (^)(NSDictionary *metadata, NSArray <NSDictionary *> *statuses))completionBlock;
+ (void)getAveragePolarityOfTweetsFromQuery:(NSString *)query withCompletion:(void (^)(NSNumber *polarity))completionBlock;
@end
