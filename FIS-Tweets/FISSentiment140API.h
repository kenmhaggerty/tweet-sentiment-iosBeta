//
//  FISSentiment140API.h
//  FIS-Tweets
//
//  Created by Ken M. Haggerty on 2/22/16.
//  Copyright © 2016 James Campagno. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const Sentiment140APIKeyPolarity;

@interface FISSentiment140API : NSObject
+ (void)getSentimentsForText:(NSArray <NSString *> *)text completion:(void (^)(NSArray <NSDictionary *> *sentiments))completionBlock;
@end
