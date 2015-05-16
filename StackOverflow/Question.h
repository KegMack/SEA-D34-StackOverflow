//
//  Question.h
//  StackOverflow
//
//  Created by User on 5/12/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Question : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *avatarURL;
@property (strong, nonatomic) UIImage *avatarPic;
@property (strong, nonatomic) NSString *ownerName;

@end
