//
// Copyright 2011-2015 Adar Porat (https://github.com/aporat)
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "AFOAuthViewController.h"

NSString *const AFOAuthErrorDomain = @"com.afoauthclient";

NSInteger const AFOAuthCodeLoginFailed = 200;
NSInteger const AFOAuthErrorCodeLoginCanceled = -999;

@implementation AFOAuthViewController

+ (instancetype)controllerWithCompletionClosure:(void (^)(BOOL success, NSError *error, NSDictionary<NSString *, id> *info))handler {
  return [[self alloc] initWithCompletionClosure:handler];
}

- (instancetype)initWithCompletionClosure:(void (^)(BOOL success, NSError *error, NSDictionary<NSString *, id> *info))handler {
  
  self = [self initWithNibName:nil bundle:nil];
  if (self) {
    _completionBlock = [handler copy];
  }
  
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissAnimated:)];
  
  self.activityIndicator.frame = CGRectMake(0.0, 0.0, 25.0, 25.0);
  [self.activityIndicator sizeToFit];
  self.activityIndicator.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);

  if (self.isBarStyleLight) {
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
  } else {
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
  }
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
  
  self.webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
  self.webView.frame = self.view.bounds;
  [self.view addSubview:self.webView];
  self.webView.delegate = self;
  self.webView.scalesPageToFit = YES;
  
  // the app may prefer some html other than blank white to be displayed
  // before the sign-in web page loads
  NSString *html = @"<html><body bgcolor=white><div align=center style='font-family:Arial'>Loading sign-in page...</div></body></html>";
  if (html.length > 0) {
    [self.webView loadHTMLString:html baseURL:nil];
  }
  
  if (self.authURL != nil) {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.authURL];
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
  
    [self.webView loadRequest:request];
  }
  
  [self.webView setScalesPageToFit:YES];
}

- (void)dismissAnimated:(id)sender {
  NSError *error = [NSError errorWithDomain:AFOAuthErrorDomain code:AFOAuthErrorCodeLoginCanceled userInfo:nil];
  if (_completionBlock != nil) { _completionBlock(NO, error, nil); }
  
  dispatch_async(dispatch_get_main_queue(), ^{
    [self dismissViewControllerAnimated:YES completion:nil];
  });
}

- (UIActivityIndicatorView *)activityIndicator {
  if (_activityIndicator == nil) {
    _activityIndicator = [[UIActivityIndicatorView alloc] init];
  }
  
  return _activityIndicator;
}

- (UIWebView *)webView {
  if (_webView == nil) {
    _webView = [[UIWebView alloc] init];
  }
  
  return _webView;
}

- (void)dealloc {
  self.webView.delegate = nil;
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
  [self.activityIndicator startAnimating];
  
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  [self.activityIndicator stopAnimating];

  NSString *response = [webView stringByEvaluatingJavaScriptFromString: @"document.body.innerText"];
  NSData *responseObject = [response dataUsingEncoding:NSUTF8StringEncoding];
  
  NSError *jsonError;
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&jsonError];
  if (json != nil && jsonError == nil) {
    NSString *errorMessage = nil;
    
    if (json[@"meta"]!=nil && json[@"meta"][@"error_message"] != nil) {
      errorMessage = json[@"meta"][@"error_message"];
    }
    
    if (json[@"error_message"] != nil) {
      errorMessage = json[@"error_message"];
    }
    
    if (errorMessage != nil) {
      NSError *error = [[NSError alloc] initWithDomain:AFOAuthErrorDomain code:AFOAuthCodeLoginFailed userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
      self.completionBlock(NO, error, nil);
      [self dismissViewControllerAnimated:YES completion:nil];
      
    }
  }
}

@end