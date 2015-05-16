//
//  LoginViewController.m
//  StackOverflow
//
//  Created by User on 5/12/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//


#import "LoginViewController.h"
#import "OAuthWebViewController.h"


@interface LoginViewController ()

@property (strong,nonatomic) UIDynamicAnimator *animator;

@end


@implementation LoginViewController

- (void)viewDidLoad {
  [super viewDidLoad];


}

- (IBAction)loginButtonPressed:(id)sender {
  
  OAuthWebViewController *webVC = [[OAuthWebViewController alloc] init];
  webVC.view.frame = self.view.frame;
  webVC.view.backgroundColor = [UIColor greenColor];
  [self presentViewController:webVC animated:true completion:^{
    
  }];
  
}


@end
