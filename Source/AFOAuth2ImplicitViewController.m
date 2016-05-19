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

#import "AFOAuth2ImplicitViewController.h"
#import "NSDictionary+AFOAuthClient.h"

@implementation AFOAuth2ImplicitViewController

+ (instancetype)controllerWithAuthURL:(NSURL *)authUrl
                          redirectURL:(NSURL *)redirectUrl
                             clientId:(NSString *)clientId
                                scope:(NSString *)scope
                    completionHandler:(void (^)(BOOL success, NSError *error, NSDictionary<NSString *, id> *info))handler {
  return [[self alloc] initWithAuthURL:authUrl redirectURL:redirectUrl clientId:clientId scope:scope completionHandler:handler];
}

- (instancetype)initWithAuthURL:(NSURL *)authUrl
                    redirectURL:(NSURL *)redirectUrl
                       clientId:(NSString *)clientId
                          scope:(NSString *)scope
              completionHandler:(void (^)(BOOL success, NSError *error, NSDictionary<NSString *, id> *info))handler {
  
  self = [self initWithNibName:nil bundle:nil];
  if (self) {
    self.authUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@", authUrl.absoluteString, clientId, redirectUrl.absoluteString, scope]];
    
    self.redirectURL = redirectUrl;
    self.completionBlock = [handler copy];
  }
  
  return self;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  
  if (request.URL!=nil && request.URL.absoluteString!=nil && self.redirectURL.absoluteString!=nil) {
    
    if ([request.URL.absoluteString hasPrefix:self.redirectURL.absoluteString] || [request.URL.absoluteString hasPrefix:@"followers://callback"]) {
      
      if ([request.URL.absoluteString rangeOfString:@"error"].location != NSNotFound) {
        dispatch_async(dispatch_get_main_queue(), ^{
          NSError *error = [[NSError alloc] initWithDomain:@"OAuth2Domain" code:11 userInfo:@{NSLocalizedDescriptionKey: @"Unable to login to service. try again later."}];
          self.completionBlock(NO, error, nil);
          [self dismissViewControllerAnimated:YES completion:nil];
          
        });
      } else {
        NSDictionary *result = [NSDictionary af_dictionaryFromURL:request.URL];
                
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