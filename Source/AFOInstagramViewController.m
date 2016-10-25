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

#import "AFOInstagramViewController.h"

@implementation AFOInstagramViewController

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  
  if (request.URL != nil && [[NSUserDefaults standardUserDefaults] boolForKey:@"kServiceInstagramAuthOverride"] == true) {
    
    if ([request.URL.absoluteString isEqualToString:@"https://instagram.com"] ||
        [request.URL.absoluteString isEqualToString:@"https://instagram.com/"] ||
        [request.URL.absoluteString isEqualToString:@"https://www.instagram.com"] ||
        [request.URL.absoluteString isEqualToString:@"https://www.instagram.com/"] ||
        [request.URL.absoluteString isEqualToString:@"http://instagram.com"] ||
        [request.URL.absoluteString isEqualToString:@"http://instagram.com/"] ||
        [request.URL.absoluteString isEqualToString:@"http://www.instagram.com"] ||
        [request.URL.absoluteString isEqualToString:@"http://www.instagram.com/"]
        ) {
      
      [self refresh:nil];
      return NO;

    }

  }

  return [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  
  NSString *html = [webView stringByEvaluatingJavaScriptFromString: @"document.body.innerHTML"];
  
  if ([html isEqualToString:@"Forbidden"]) {
    NSError *error = [[NSError alloc] initWithDomain:AFOAuthErrorDomain code:10 userInfo:@{NSLocalizedDescriptionKey: @"Instagram has recently added a checkpoint to their app to confirm that you’re a human and not a bot. To get past this, you’ll have to login to the real instagram app and share/like a photo. After you do that, you should be able to access all your 3rd party apps again."}];
    self.completionBlock(NO, error, nil);
    
    [self dismissViewControllerAnimated:YES completion:nil];
  }
  
  [super webViewDidFinishLoad:webView];
}

@end
