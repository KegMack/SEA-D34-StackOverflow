//
//  MenuContainerViewController.m
//  StackOverflow
//
//  Created by User on 5/11/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import "MenuContainerViewController.h"
#import "MainMenuTableViewController.h"
#import "SearchQuestionsViewController.h"
#import "MyQuestionsViewController.h"
#import "MyProfileViewController.h"

@interface MenuContainerViewController () <MainMenuDelegate>

@property (strong, nonatomic) SearchQuestionsViewController *searchQuestionsVC;
@property (strong, nonatomic) MyQuestionsViewController *myQuestionsVC;
@property (strong, nonatomic) MyProfileViewController *myProfileVC;
@property (strong, nonatomic) UIViewController *topViewController;
@property (strong, nonatomic) UIPanGestureRecognizer *slideGesture;
@property (strong,nonatomic) UITapGestureRecognizer *tapGesture;
@property (strong, nonatomic) UIButton *burgerButton;

@end

@implementation MenuContainerViewController

@synthesize searchQuestionsVC = _searchQuestionsVC;
@synthesize myQuestionsVC = _myQuestionsVC;
@synthesize myProfileVC = _myProfileVC;

double const sliderMaxXRatio = 0.8;

- (void)viewDidLoad {
  [super viewDidLoad];
  MainMenuTableViewController *mainMenuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenuVC"];
  [self addChildViewController:mainMenuVC];
  mainMenuVC.view.frame = self.view.frame;
  [self.view addSubview:mainMenuVC.view];
  [mainMenuVC didMoveToParentViewController:self];
  mainMenuVC.delegate = self;
  
  self.slideGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slidePanel:)];
  [self.topViewController.view addGestureRecognizer:self.slideGesture];
  self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
  [self initBurgerButton];
}

- (void)initBurgerButton {
  
  self.burgerButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 50, 50)];
  [self.burgerButton setBackgroundImage:[UIImage imageNamed:@"burgerButton"] forState:UIControlStateNormal];
  [self.burgerButton addTarget:self action:@selector(burgerButtonPressed) forControlEvents:UIControlEventTouchUpInside];
  
 }

- (void)userDidSelectOption:(NSInteger)selection {
  switch (selection) {
    case 0:
      if (self.topViewController != self.searchQuestionsVC) {
        [self switchToViewController:self.searchQuestionsVC];
        return;
      }
      break;
    case 1:
      if (self.topViewController != self.myQuestionsVC) {
        [self switchToViewController:self.myQuestionsVC];
        return;
      }
      break;
    case 2:
      if (self.topViewController != self.myProfileVC) {
        [self switchToViewController:self.myProfileVC];
        return;
      }
      break;
    default:
      break;
  }
  [UIView animateWithDuration:0.3 animations:^{
    self.topViewController.view.center = self.view.center;
  } completion:^(BOOL finished) {
    self.burgerButton.userInteractionEnabled = true;
  }];
  
}

-(void)burgerButtonPressed {
  self.burgerButton.userInteractionEnabled = false;
  [UIView animateWithDuration:0.3 animations:^{
    self.topViewController.view.frame = CGRectMake(self.view.frame.size.width * sliderMaxXRatio, 0, self.topViewController.view.frame.size.width, self.topViewController.view.frame.size.height);
  } completion:^(BOOL finished) {
    [self.topViewController.view addGestureRecognizer:self.tapGesture];
  }];
}

-(void)switchToViewController:(UIViewController *)destinationVC {
  
  [UIView animateWithDuration:0.2 animations:^{
    destinationVC.view.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.topViewController.view.frame = destinationVC.view.frame;
  }
    completion:^(BOOL finished) {
    if(self.topViewController) {
      [self.topViewController.view removeGestureRecognizer:self.slideGesture];
      [self.burgerButton removeFromSuperview];
      [self.topViewController willMoveToParentViewController:nil];
      [self.topViewController.view removeFromSuperview];
      [self.topViewController removeFromParentViewController];
    }
    self.topViewController = destinationVC;
    [self addChildViewController:self.topViewController];
    [self.view addSubview:self.topViewController.view];
    [self.topViewController didMoveToParentViewController:self];
    [self.topViewController.view addSubview:self.burgerButton];
    [self.topViewController.view addGestureRecognizer:self.slideGesture];
    
    [UIView animateWithDuration:0.3 animations:^{
      self.topViewController.view.center = self.view.center;
    } completion:^(BOOL finished) {
      self.burgerButton.userInteractionEnabled = true;
    }];
  }];
}



-(void)tapped {
  [self.topViewController.view removeGestureRecognizer:self.tapGesture];
  [UIView animateWithDuration:0.3 animations:^{
    self.topViewController.view.center = self.view.center;
  } completion:^(BOOL finished) {
    self.burgerButton.userInteractionEnabled = true;
  }];
}

-(void)slidePanel:(UIPanGestureRecognizer *)pan {
  CGPoint translatedPoint = [pan translationInView:self.view];
  CGPoint velocity = [pan velocityInView:self.view];
  
  if (pan.state == UIGestureRecognizerStateChanged) {
    if (velocity.x > 0 || self.topViewController.view.frame.origin.x > 0) {
      self.topViewController.view.center = CGPointMake(self.topViewController.view.center.x + translatedPoint.x, self.topViewController.view.center.y);
      [pan setTranslation:CGPointZero inView:self.view];
    }
  }
  
  if (pan.state == UIGestureRecognizerStateEnded) {
    if (self.topViewController.view.frame.origin.x > self.view.frame.size.width / 3) {
      self.burgerButton.userInteractionEnabled = false;
      [UIView animateWithDuration:0.3 animations:^{
        self.topViewController.view.frame = CGRectMake(self.view.frame.size.width * sliderMaxXRatio, 0, self.topViewController.view.frame.size.width, self.topViewController.view.frame.size.height);
      } completion:^(BOOL finished) {
        [self.topViewController.view addGestureRecognizer:self.tapGesture];
      }];
      
    } else {
      
      [UIView animateWithDuration:0.2 animations:^{
        self.topViewController.view.center = self.view.center;
      } completion:^(BOOL finished) {
        self.burgerButton.userInteractionEnabled = true;
      }];
    }
  }
  
}

- (MyQuestionsViewController *)myQuestionsVC {
  if (!_myQuestionsVC) {
    _myQuestionsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"myQuestionsVC"];
    self.myQuestionsVC = _myQuestionsVC;
  }
  return _myQuestionsVC;
}

- (SearchQuestionsViewController *)searchQuestionsVC {
  if (!_searchQuestionsVC) {
    _searchQuestionsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"searchVC"];
    self.searchQuestionsVC = _searchQuestionsVC;
  }
  return _searchQuestionsVC;
}

- (MyProfileViewController *)myProfileVC {
  if (!_myProfileVC) {
    _myProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"myProfileVC"];
    self.myProfileVC = _myProfileVC;
  }
  return _myProfileVC;
}


@end
