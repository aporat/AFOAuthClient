//
// Copyright 2011-2014 Adar Porat (https://github.com/aporat)
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

#import "AFInstagramImplicitLoginViewController.h"

@implementation AFInstagramImplicitLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = [NSString stringWithFormat:NSLocalizedString(@"Sign in to %@", @""), @"Instagram"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [super webViewDidFinishLoad:webView];
    
    NSString *html = [webView stringByEvaluatingJavaScriptFromString: @"document.body.innerHTML"];
    
    if ([html isEqualToString:@"Forbidden"]) {
        NSError *error = [[NSError alloc] initWithDomain:@"OAuth2Domain" code:10 userInfo:@{NSLocalizedDescriptionKey: @"Instagram has recently added a ‘captcha’ to their app to confirm that you’re a human and not a bot. To get past this, you’ll have to share/like a photo on the actual instagram app, and before you share it, it’ll ask you to enter some letters to confirm that you’re human. After you do that, you should be able to access all your 3rd party apps again."}];
        completionBlock_(nil, error);
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
