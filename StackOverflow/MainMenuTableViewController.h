//
//  MainMenuTableViewController.h
//  StackOverflow
//
//  Created by User on 5/11/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainMenuDelegate.h"

@interface MainMenuTableViewController : UITableViewController

@property (weak,nonatomic) id<MainMenuDelegate> delegate;

@end
