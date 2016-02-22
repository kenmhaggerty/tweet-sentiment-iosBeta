//
//  FISTwitterAPIClient.h
//  FIS-Tweets
//
//  Created by Ken M. Haggerty on 2/21/16.
//  Copyright © 2016 James Campagno. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const TwitterSearchAPIKey_Content;

@interface FISTwitterAPIClient : NSObject
+ (void)getTweetsWithQuery:(NSArray <NSURLQueryItem *> *)queryItems completion:(void (^)(NSArray <NSDictionary *> *tweets))completionBlock;
@end
