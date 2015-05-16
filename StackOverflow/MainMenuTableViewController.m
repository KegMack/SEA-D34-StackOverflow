//
//  MainMenuTableViewController.m
//  StackOverflow
//
//  Created by User on 5/11/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import "MainMenuTableViewController.h"

@interface MainMenuTableViewController ()

@end

@implementation MainMenuTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  [self.delegate userDidSelectOption:indexPath.row];
  
}

@end
