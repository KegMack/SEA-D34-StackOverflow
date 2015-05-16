//
//  JSONStackoverflowParser.m
//  StackOverflow
//
//  Created by User on 5/12/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import "JSONStackoverflowParser.h"
#import "Question.h"

@implementation JSONStackoverflowParser

+(NSArray *)searchQuestionsResultsFromJSON:(NSDictionary *)jsonInfo {
  
  NSMutableArray *questions = [[NSMutableArray alloc] init];
  
  NSArray *items = jsonInfo[@"items"];
  for(NSDictionary *item in items) {
    Question *question = [[Question alloc] init];
    question.title = item[@"title"];
    NSDictionary *owner = item[@"owner"];
    question.ownerName = owner[@"display_name"];
    question.avatarURL = owner[@"profile_image"];
    [questions addObject:question];
    
  }
  return questions;
}

+(StackOverflowProfile *)profileFromJSON:(NSDictionary *)jsonInfo {
  
  StackOverflowProfile *profile = [[StackOverflowProfile alloc] init];
  NSArray *items = jsonInfo[@"items"];
  NSDictionary *item = items.firstObject;
  profile.displayName = item[@"display_name"];
  profile.avatarURL = item[@"profile_image"];
  profile.reputation = [item[@"reputation"] intValue];
  return profile;
  
}


@end
