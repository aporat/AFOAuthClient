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

#import "AFOWebViewController.h"
#import "NSURL+AFOAuthClient.h"

@implementation AFOWebViewController

+ (instancetype)controllerWithAuthURL:(NSURL *)authUrl
                          redirectURL:(NSURL *)redirectUrl
                    completionHandler:(void (^ __nullable)(BOOL success, NSError *__nullable error, NSDictionary<NSString *, id> *__nullable info))handler {
  return [[self alloc] initWithAuthURL:authUrl redirectURL:redirectUrl completionHandler:handler];
}

- (instancetype)initWithAuthURL:(NSURL *)authUrl
                    redirectURL:(NSURL *)redirectUrl
              completionHandler:(void (^ __nullable)(BOOL success, NSError *__nullable error, NSDictionary<NSString *, id> *__nullable info))handler {
  
  self = [self initWithNibName:nil bundle:nil];
  if (self) {
    self.authUrl = authUrl;
    
   //  DDLogDebug(@"loading %@", self.authUrl);
    
    self.redirectURL = redirectUrl;
    self.completionBlock = [handler copy];
  }
  
  return self;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  
  //DDLogDebug(@"loading %@", request.URL.absoluteString);

  if (request.URL!=nil) {
    
    if ([request.URL.absoluteString hasPrefix:self.redirectURL.absoluteString] || [request.URL.absoluteString hasPrefix:@"followers://callback"]) {
      
      if ([request.URL.absoluteString rangeOfString:@"error"].location != NSNotFound) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
          
          NSDictionary *result = [request.URL af_parameters];
          
          NSString *errorMessage = @"Unable to login. try again later.";
          if (result[@"error"]!=nil) {
            errorMessage = result[@"error"];
          }
          
          NSError *error = [[NSError alloc] initWithDomain:AFOAuthErrorDomain code:AFOAuthCodeLoginFailed userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
          self.completionBlock(NO, error, nil);
          [self dismissViewControllerAnimated:YES completion:nil];
          
        });
      } else {
        NSDictionary *result = [request.URL af_parameters];
        
        dispatch_async(dispatch_get_main_queue(), ^{
          self.completionBlock(YES, nil, result);
          [self dismissViewControllerAnimated:YES completion:nil];
        });
      }
      
      return NO;
    }
  }
  
  return YES;
}

@end
