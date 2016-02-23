//
//  FISTwitterAPIClientSpec.m
//  FISTweetSentiment
//
//  Created by James Campagno on 9/10/15.
//  Copyright 2015 James Campagno. All rights reserved.
//

#import "Specta.h"
#import "AppDelegate.h"
#import "FISTwitterAPIClient.h"
#import "FISSentiment140API.h"
//#import "FISConstants.h"
#import "OHHTTPStubs.h"
#define EXP_SHORTHAND
#import "Expecta.h"

SpecBegin(FISTwitterAPIClient)

static NSString *const kTwitterRequestURL = @"api.twitter.com";
static NSString *const kTwitterOauthURL = @"https://api.twitter.com/oauth2/token";
static NSString *const kSentimentRequestURL = @"sentiment140";
static NSString *const kPolarityOfEveryTweet = @"20";
static NSString *const kTwitterQuery = @"FlatironSchool";

describe(@"FISTwitterAPIClient", ^{
    
    __block id<OHHTTPStubsDescriptor> httpTwitterStub;
    __block id<OHHTTPStubsDescriptor> httpTwitterLoginStub;
    __block id<OHHTTPStubsDescriptor> httpSentimentStub;
    __block NSString *filePath;
    __block NSArray *tweets;
    __block NSDictionary *responseObject;
    __block NSDictionary *loginResponse;
    __block NSData *sentimentStubData;
    
    beforeAll(^{
        filePath = [[NSBundle mainBundle] pathForResource:@"fakeJSON" ofType:@"json"];
        tweets = [NSArray arrayWithContentsOfFile:filePath];
        
        responseObject = @{@"search_metadata": @{@"Data": @"<3"},
                           @"statuses": tweets};
        
        loginResponse = @{@"access_token": @"DONALD TRUMP",
                          @"token_type": @"bearer"};
        
        NSString *jsonString = [NSString stringWithFormat:@"{\"data\": [{\"polarity\": \"%@\"}]}", kPolarityOfEveryTweet];
        
        sentimentStubData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    });
    
    describe(@"getAveragePolarityOfTweetsFromQuery:withCompletion::", ^{
        
        beforeEach(^{
            [OHHTTPStubs removeAllStubs];
            
            httpTwitterStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return [[request.URL absoluteString] containsString:kTwitterRequestURL];
            }
                                                  withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
//                                                      return [OHHTTPStubsResponse responseWithJSONObject:responseObject
//                                                                                              statusCode:200
//                                                                                                 headers:@{@"Content-type": @"application/json"}];
                                                      NSError *error;
                                                      NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject
                                                                                                         options:0
                                                                                                           error:&error];
                                                      return [OHHTTPStubsResponse responseWithData:jsonData
                                                                                        statusCode:200
                                                                                           headers:@{@"Content-type": @"application/json"}];
                                                  }];
            
            httpTwitterLoginStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return [[request.URL absoluteString] isEqualToString:kTwitterOauthURL];
            }
                                                       withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
//                                                           return [OHHTTPStubsResponse responseWithJSONObject:loginResponse
//                                                                                                   statusCode:200
//                                                                                                      headers:@{@"Content-type": @"application/json"}];
                                                           NSError *error;
                                                           NSData *jsonData = [NSJSONSerialization dataWithJSONObject:loginResponse
                                                                                                              options:0
                                                                                                                error:&error];
                                                           return [OHHTTPStubsResponse responseWithData:jsonData
                                                                                             statusCode:200
                                                                                                headers:@{@"Content-type": @"application/json"}];
                                                       }];
        
            httpSentimentStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return [[request.URL absoluteString] containsString:kSentimentRequestURL];
            }
                                                    withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                                                        return [OHHTTPStubsResponse responseWithData:sentimentStubData
                                                                                          statusCode:200
                                                                                             headers:nil];
                                                    }];
            
        });
        
        it(@"should get the average polarity of tweets from the provided query.", ^{
            
            waitUntil(^(DoneCallback done) {
                
                [FISTwitterAPIClient getAveragePolarityOfTweetsFromQuery:kTwitterQuery
                                                          withCompletion:^(NSNumber *polarity) {
                                                              
                                                              expect(polarity).to.beAKindOf([NSNumber class]);
                                                              expect(polarity).notTo.equal(nil);
                                                              expect(polarity).to.equal(20);
                                                              
                                                              done();
                                                          }];
            });
        });
    });
});

SpecEnd
