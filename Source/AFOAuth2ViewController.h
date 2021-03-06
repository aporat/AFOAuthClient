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

@interface AFOAuth2ViewController : AFOAuthViewController

+ (instancetype _Nonnull)controllerWithAuthURL:(NSURL *__nullable)authURL
                                   redirectURL:(NSURL *__nullable)redirectURL
                             completionHandler:(void (^ __nullable)(BOOL success, NSError * __nullable error, NSDictionary <NSString *, id> *__nullable info))handler;

@end