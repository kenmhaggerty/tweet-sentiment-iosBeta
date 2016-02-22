//
//  FISSentiment140APIClient.m
//  FIS-Tweets
//
//  Created by Ken M. Haggerty on 2/22/16.
//  Copyright © 2016 James Campagno. All rights reserved.
//

#import "FISSentiment140APIClient.h"
#import "FISPrivateInfo.h"

NSString *const Sentiment140APIKeyPolarity = @"polarity";

static NSString *const Sentiment140APIBulkClassificationURL = @"http://www.sentiment140.com/api/bulkClassifyJson";
static NSString *const Sentiment140APIKeyAppID = @"appid";
static NSString *const Sentiment140APIKeyText = @"text";
static NSString *const Sentiment140APIKeyData = @"data";

@implementation FISSentiment140APIClient

+ (void)getSentimentsForText:(NSArray <NSString *> *)text completion:(void (^)(NSArray <NSDictionary *> *sentiments))completionBlock
{
    NSMutableArray *textArray = [NSMutableArray arrayWithCapacity:text.count];
    for (NSUInteger i = 0; i < text.count; i++)
    {
        [textArray addObject:@{Sentiment140APIKeyText : text[i]}];
    }
    NSDictionary *json = @{Sentiment140APIKeyData : textArray};
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:json options:0 error:&error];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:Sentiment140APIBulkClassificationURL];
    NSURLQueryItem *appId = [NSURLQueryItem queryItemWithName:Sentiment140APIKeyAppID value:Sentiment140APIAppID];
    [components setQueryItems:@[appId]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            NSLog(@"%@", error);
            completionBlock(nil);
            return;
        }
        
//        NSArray *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
        if (error) {
            NSLog(@"%@", error);
            completionBlock(nil);
            return;
        }
        
        completionBlock(result[Sentiment140APIKeyData]);
        
    }] resume];
}

@end
