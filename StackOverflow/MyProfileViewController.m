//
//  MyProfileViewController.m
//  StackOverflow
//
//  Created by User on 5/13/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import "MyProfileViewController.h"
#import "StackOverflowService.h"

@interface MyProfileViewController ()

@property (assign, nonatomic) IBOutlet UIImageView *imageView;
@property (assign, nonatomic) IBOutlet UILabel *nameLabel;
@property (assign, nonatomic) IBOutlet UILabel *repLabel;

@end

@implementation MyProfileViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor yellowColor];
  [StackOverflowService fetchProfileInfoForAuthenticatedUser:^(StackOverflowProfile *profile, NSError *error) {
    if (error) {
      NSLog(@"error: %@", error);
    }
    else {
      self.nameLabel.text = profile.displayName;
      self.repLabel.text = [NSString stringWithFormat:@"%ld Reputation", (long)profile.reputation];
      [StackOverflowService fetchImageFromURL:[NSURL URLWithString:profile.avatarURL] completionHandler:^(UIImage *image, NSString *error) {
        self.imageView.image = image;
      }];
    }
  }];
}


@end
