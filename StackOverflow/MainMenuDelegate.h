//
//  MainMenuDelegate.h
//  StackOverflow
//
//  Created by User on 5/12/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MainMenuDelegate <NSObject>

-(void)userDidSelectOption:(NSInteger)selection;

@end