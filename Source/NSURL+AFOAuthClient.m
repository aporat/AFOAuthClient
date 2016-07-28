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

#import "NSURL+AFOAuthClient.h"
#import "NSString+AFOAuthClient.h"

@implementation NSURL (AFOAuthClient)

- (NSDictionary <NSString *, NSString *> *)af_parameters {
  NSMutableDictionary<NSString *, NSString *>* queryParams = [NSMutableDictionary<NSString *, NSString *> new];
  
  // If we are here it's was native iOS authorization and we have redirect URL like this:
  // testapp123://foursquare?access_token=ACCESS_TOKEN
  if (self.query != nil) {
    NSArray *parameters = [self.query componentsSeparatedByString:@"&"];
    for (NSString *parameter in parameters) {
      NSArray *parts = [parameter componentsSeparatedByString:@"="];
      if (parts.count == 2) {
        if ([parts[1] isKindOfClass:[NSString class]]) {
          queryParams[parts[0]] = [parts[1] af_URLDecode];
        } else {
          queryParams[parts[0]] = parts[1];
        }
      }
    }
  }
  
  // If we are here it's was web authorization and we have redirect URL like this:
  // testapp123://foursquare#access_token=ACCESS_TOKEN
  if (self.fragment != nil) {
    NSArray *parameters = [self.fragment componentsSeparatedByString:@"&"];
    for (NSString *parameter in parameters) {
      NSArray *parts = [parameter componentsSeparatedByString:@"="];
      if (parts.count == 2) {
        if ([parts[1] isKindOfClass:[NSString class]]) {
          queryParams[parts[0]] = [parts[1] af_URLDecode];
        } else {
          queryParams[parts[0]] = parts[1];
        }
      }
    }
  }
  
  return queryParams;
}

@end