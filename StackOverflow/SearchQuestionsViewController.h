//
//  SearchQuestionsViewController.h
//  StackOverflow
//
//  Created by User on 5/11/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchQuestionsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
