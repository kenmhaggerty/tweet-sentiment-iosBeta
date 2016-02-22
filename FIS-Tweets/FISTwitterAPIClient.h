//
//  FISTwitterAPIClient.h
//  FIS-Tweets
//
//  Created by Ken M. Haggerty on 2/22/16.
//  Copyright © 2016 James Campagno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FISTwitterAPIClient : NSObject
+ (void)getTweetsWithQuery:(NSString *)query completion:(void (^)(NSDictionary *metadata, NSArray *statuses))completionBlock;
@end
