//
//  StackOverflowService.h
//  StackOverflow
//
//  Created by User on 5/12/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StackOverflowProfile.h"

@interface StackOverflowService : NSObject

+(void)fetchQuestionsForSearchTerm:(NSString *)searchTerm completionHandler:(void (^)(NSArray* items, NSString *error))completionHandler;

+(void)fetchImageFromURL:(NSURL *)url completionHandler:(void(^)(UIImage *image, NSString *error))completionHandler;

+(void)fetchProfileInfoForAuthenticatedUser:(void(^)(StackOverflowProfile *profile, NSError *error))completionHandler;

+(void)fetchMyQuestions:(void (^)(NSArray* items, NSError *error))completionHandler;


@end
