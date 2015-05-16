//
//  SearchQuestionsViewController.m
//  StackOverflow
//
//  Created by User on 5/11/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import "SearchQuestionsViewController.h"
#import "StackOverflowService.h"
#import "Question.h"
#import "QuestionTableViewCell.h"
#import "ImageResizer.h"

@interface SearchQuestionsViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (strong, nonatomic) NSArray *questions;

@end


@implementation SearchQuestionsViewController

@synthesize questions = _questions;


- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.tableView registerNib:[UINib nibWithNibName:@"QuestionCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier: @"QuestionCell"];
  self.tableView.estimatedRowHeight = 100;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  QuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionCell"];
  Question *question = self.questions[indexPath.row];

  cell.titleLabel.text = question.title;
  cell.nameLabel.text = question.ownerName;
  
  if(question.avatarPic) {
    UIImage *resizedImage = [ImageResizer resizeImage:question.avatarPic toSize:cell.profileImageView.frame.size];
    [cell.spinner stopAnimating];
    cell.profileImageView.image = resizedImage;
  } else {
    cell.profileImageView.image = nil;
    [cell.spinner startAnimating];
  }
  
  return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.questions.count;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  
  [searchBar resignFirstResponder];
  self.questions = nil;
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [StackOverflowService fetchQuestionsForSearchTerm:searchBar.text completionHandler:^(NSArray *items, NSString *error) {
      if(error) {
        NSLog(@"Error from search request: %@", error);
      } else {
        dispatch_async(dispatch_get_main_queue(), ^{
          self.questions = items;
          [self fetchImagesForCells];
        });
      }
    }];
  });
}


/// done in one big batch to demonstrate dispatch groups for assigment.  Refactor if I ever want to do anything with this app
- (void)fetchImagesForCells {
  __block int count = 0;
  dispatch_group_t bgImageFetchGroup = dispatch_group_create();

  dispatch_group_async(bgImageFetchGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    for(Question *question in self.questions) {
      NSURL *imageURL = [NSURL URLWithString: question.avatarURL];
      [StackOverflowService fetchImageFromURL:imageURL completionHandler:^(UIImage *image, NSString *error) {
        dispatch_group_async(bgImageFetchGroup, dispatch_get_main_queue(), ^{
          count++;
          if(error) {
            NSLog(@"Error fetching cell Image: %@",error);
            question.avatarPic = nil;
          }
          else {
            question.avatarPic = image;
          }
          NSLog(@"%d/%lu completed", count, (unsigned long)self.questions.count);
          
        });
      }];
    }
    
  });

    dispatch_group_notify(bgImageFetchGroup, dispatch_get_main_queue(), ^{
      [self.tableView reloadData];
    });
  
}

- (void)setQuestions:(NSArray *)questions {
  _questions = questions;
  [self.tableView reloadData];
}

@end
