//
//  JSONStackoverflowParser.h
//  StackOverflow
//
//  Created by User on 5/12/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StackOverflowProfile.h"

@interface JSONStackoverflowParser : NSObject

+(NSArray *)searchQuestionsResultsFromJSON:(NSDictionary *)jsonInfo;
+(StackOverflowProfile *)profileFromJSON:(NSDictionary *)jsonInfo;

@end
