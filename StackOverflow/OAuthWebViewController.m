//
//  OAuthWebViewController.m
//  StackOverflow
//
//  Created by User on 5/12/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import "OAuthWebViewController.h"
#import <WebKit/WebKit.h>
#import "Constants.h"

@interface OAuthWebViewController () <WKNavigationDelegate>

@property (strong,nonatomic) WKWebView *webView;

@end

@implementation OAuthWebViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.webView = [[WKWebView alloc] initWithFrame:self.view.frame];
  [self.view addSubview:self.webView];
  self.webView.navigationDelegate = self;
  
  [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://stackexchange.com/oauth/dialog?client_id=4801&scope=no_expiry&redirect_uri=https://stackexchange.com/oauth/login_success"]]];
}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
  NSURLRequest *request = navigationAction.request;
  NSURL *url = request.URL;
  
  if ([url.description containsString:@"access_token"]) {
    NSArray *components = [[url description] componentsSeparatedByString:@"="];
    NSString *token = components.lastObject;
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:kUserDefaultoAuthTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self dismissViewControllerAnimated:true completion:^{
    }];
  }
  decisionHandler(WKNavigationActionPolicyAllow);
}

@end
