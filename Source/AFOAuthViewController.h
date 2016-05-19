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

#import <UIKit/UIKit.h>

@interface AFOAuthViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) void (^ __nullable completionBlock)(BOOL success, NSError * __nullable error, NSDictionary<NSString *, id> *__nullable info);
@property (nonatomic, strong) UIActivityIndicatorView * __nullable activityIndicator;
@property (nonatomic, strong, nullable) UIWebView * webView;
@property (nonatomic, strong, nonnull) NSURL * authUrl;
@property (nonatomic, strong, nonnull) NSURL *redirectURL;
@property (nonatomic, assign) BOOL isBarStyleLight;

@property (nonatomic, strong, nullable) NSString * initialHTMLString;

+ (instancetype _Nonnull)controllerWithCompletionClosure:(void (^ __nullable)(BOOL success, NSError * __nullable error, NSDictionary<NSString *, id> *__nullable info))handler;
- (void)dismissAnimated:(__nullable id)sender;

@end