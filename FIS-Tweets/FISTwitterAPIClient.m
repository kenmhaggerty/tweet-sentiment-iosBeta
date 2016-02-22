//
//  FISTwitterAPIClient.m
//  FIS-Tweets
//
//  Created by Ken M. Haggerty on 2/21/16.
//  Copyright © 2016 James Campagno. All rights reserved.
//

#import "FISTwitterAPIClient.h"
#import "FISPrivateInfo.h"
#include <CommonCrypto/CommonHMAC.h>

NSString *const TwitterSearchAPIKey_Content = @"q";

static NSString *const TwitterSearchAPIURL = @"https://api.twitter.com/1.1/search/tweets.json";
static NSString *const TwitterAPIKey_OAuthConsumerKey = @"oauth_consumer_key";
static NSString *const TwitterAPIKey_OAuthToken = @"oauth_token";

static NSString *const TwitterAPIKey_OAuthVersion = @"oauth_version";
static NSString *const TwitterAPIKey_OAuthVersion_Value = @"1.0";
static NSString *const TwitterAPIKey_OAuthSignatureMethod = @"oauth_signature_method";
static NSString *const TwitterAPIKey_OAuthSignatureMethod_Value = @"HMAC-SHA1";

static NSString *const TwitterAPIKey_OAuthTimestamp = @"oauth_timestamp";
static NSString *const TwitterAPIKey_OAuthNonce = @"oauth_nonce";

static NSString *const TwitterAPIKey_OAuthSignature = @"oauth_signature";

@implementation FISTwitterAPIClient

+ (void)getTweetsWithQuery:(NSArray <NSURLQueryItem *> *)queryItems completion:(void (^)(NSArray <NSDictionary *> *tweets))completionBlock {
    
    NSURLComponents *components = [NSURLComponents componentsWithString:TwitterSearchAPIURL];
    NSArray *parameters = [queryItems arrayByAddingObjectsFromArray:[FISTwitterAPIClient authenticationParameters]];
    
    NSMutableArray *encodedParameters = [NSMutableArray array];
    NSURLQueryItem *parameter;
    NSString *escapedKey, *escapedValue;
    for (NSInteger i = 0; i < parameters.count; i++)
    {
        parameter = parameters[i];
        escapedKey = [parameter.name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
        escapedValue = [parameter.value stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
        [encodedParameters addObject:[NSURLQueryItem queryItemWithName:escapedKey value:escapedValue]];
    }
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(name)) ascending:YES];
    [encodedParameters sortUsingDescriptors:@[sortDescriptor]];
    NSMutableString *parametersString = [NSMutableString string];
    for (NSUInteger i = 0; i < encodedParameters.count; i++)
    {
        parameter = encodedParameters[i];
        [parametersString appendFormat:@"%@=%@&", parameter.name, parameter.value];
    }
    parametersString = [NSMutableString stringWithString:[parametersString substringToIndex:parametersString.length-1]];
    
    NSString *percentEncodedURL = [TwitterSearchAPIURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *signatureBaseString = [NSString stringWithFormat:@"GET&%@&%@", percentEncodedURL, parametersString];
    
    NSString *signingKey = [NSString stringWithFormat:@"%@&%@", [TwitterAPIConsumerSecret stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]], [TwitterAPIAccessTokenSecret stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    const char *cKey  = [signingKey cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [signatureBaseString cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    NSString *hash = [HMAC base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSURLQueryItem *signature = [NSURLQueryItem queryItemWithName:TwitterAPIKey_OAuthSignature value:hash];
    
    [components setQueryItems:[encodedParameters arrayByAddingObject:signature]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:components.URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            completionBlock(nil);
            return;
        }
        
        NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        completionBlock(json);
    }] resume];
}

+ (NSArray <NSURLQueryItem *> *)authenticationParameters
{
    NSURLQueryItem *consumerKey = [NSURLQueryItem queryItemWithName:TwitterAPIKey_OAuthConsumerKey value:TwitterAPIConsumerKey];
    NSURLQueryItem *nonce = [NSURLQueryItem queryItemWithName:TwitterAPIKey_OAuthNonce value:[NSUUID UUID].UUIDString];
    NSURLQueryItem *signatureMethod = [NSURLQueryItem queryItemWithName:TwitterAPIKey_OAuthSignatureMethod value:TwitterAPIKey_OAuthSignatureMethod_Value];
    NSURLQueryItem *timestamp = [NSURLQueryItem queryItemWithName:TwitterAPIKey_OAuthTimestamp value:[NSString stringWithFormat:@"%i", (int)floorf([[NSDate date] timeIntervalSince1970])]];
    NSURLQueryItem *token = [NSURLQueryItem queryItemWithName:TwitterAPIKey_OAuthToken value:TwitterAPIAccessToken];
    NSURLQueryItem *version = [NSURLQueryItem queryItemWithName:TwitterAPIKey_OAuthVersion value:TwitterAPIKey_OAuthVersion_Value];
    return @[consumerKey, nonce, signatureMethod, timestamp, token, version];
}

@end
