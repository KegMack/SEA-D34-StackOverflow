//
//  StackOverflowService.m
//  StackOverflow
//
//  Created by User on 5/12/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import "StackOverflowService.h"
#import "Constants.h"
#import "JSONStackoverflowParser.h"
#import <AFNetworking.h>

@interface StackOverflowService ()

@end

@implementation StackOverflowService

+(void)fetchQuestionsForSearchTerm:(NSString *)searchTerm completionHandler:(void (^)(NSArray* items, NSString *error))completionHandler {
  
  NSURL *baseUrl = [NSURL URLWithString: @"https://api.stackexchange.com"];
  NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultoAuthTokenKey];
  NSDictionary *parameters = @{@"order"   : @"desc",    @"sort"   : @"activity",
                               @"token"   : token,      @"site"    : @"stackoverflow",
                               @"intitle" : searchTerm  };
  
  AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseUrl];
  [sessionManager GET:@"2.2/search" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
    NSArray *questions =  [JSONStackoverflowParser searchQuestionsResultsFromJSON:(NSDictionary *)responseObject];
    dispatch_async(dispatch_get_main_queue(), ^{
      completionHandler(questions, nil);
    });
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    completionHandler(nil, error.description);
  }];
}

+(void)fetchProfileInfoForAuthenticatedUser:(void(^)(StackOverflowProfile *profile, NSError *error))completionHandler {
  
  NSURL *baseURL = [[NSURL alloc] initWithString:@"https://api.stackexchange.com"];
  AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
  
  NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultoAuthTokenKey];

  NSDictionary *parameters = @{ @"site"         : @"stackoverflow",
                                @"access_token" : token,
                                @"key"          : kStackExchangeKey };
  
  [sessionManager GET:@"2.2/me" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
    StackOverflowProfile *profile = [JSONStackoverflowParser profileFromJSON:(NSDictionary *)responseObject];
    if(profile) {
      completionHandler(profile, nil);
    } else {
      completionHandler(nil, [NSError errorWithDomain:@"Error: could not parse JSON from request" code:0 userInfo:nil]);
    }
  }
  failure:^(NSURLSessionDataTask *task, NSError *error) {
    completionHandler(nil, error);
  }];
}


+(void)fetchMyQuestions:(void (^)(NSArray* items, NSError *error))completionHandler {
  
  NSURL *baseURL = [[NSURL alloc] initWithString:@"https://api.stackexchange.com"];
  AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
  
  NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultoAuthTokenKey];
  
  NSDictionary *parameters = @{ @"site"         : @"stackoverflow",
                                @"access_token" : token,
                                @"key"          : kStackExchangeKey };
  
  [sessionManager GET:@"2.2/me/questions" parameters:parameters
  
  success:^(NSURLSessionDataTask *task, id responseObject) {
    NSArray *questions = [JSONStackoverflowParser searchQuestionsResultsFromJSON:responseObject];
    completionHandler(questions, nil);
  }
  failure:^(NSURLSessionDataTask *task, NSError *error) {
    completionHandler(nil, error);
  }];
}


+(void)fetchImageFromURL:(NSURL *)url completionHandler:(void(^)(UIImage *image, NSString *error))completionHandler {
  NSData *imageData = [NSData dataWithContentsOfURL:url];
  UIImage *image = [UIImage imageWithData:imageData];
  if(image) {
    completionHandler(image, nil);
  } else {
    completionHandler(nil, @"Error: could not retrieve image from URL");
  }
}

+(void)fetchAndCacheImageFromURL:(NSURL *)url completionHandler:(void(^)(UIImage *image, NSString *error))completionHandler {
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
  NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:30 * 1024 * 1024 diskCapacity:100 * 1024 *1024 diskPath:nil];
  [NSURLCache setSharedURLCache:sharedCache];
  
  [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    if([responseObject isKindOfClass:[responseObject class]]) {
      completionHandler(responseObject, nil);
    }
  }
  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    completionHandler(nil, error.description);
  }];
    
  [requestOperation start];
}

@end