//
//  MyQuestionsViewController.m
//  StackOverflow
//
//  Created by User on 5/11/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import "MyQuestionsViewController.h"
#import "Question.h"
#import "StackOverflowService.h"

@interface MyQuestionsViewController ()  <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *(questions);

@end

@implementation MyQuestionsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor greenColor];
  [StackOverflowService fetchMyQuestions:^(NSArray *items, NSError *error) {
    
  }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.questions.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myQuestionCell" forIndexPath:indexPath];
  
  return cell;
}




@end
