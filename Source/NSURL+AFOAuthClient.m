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

@implementation NSURL (AFOAuthClient)

- (NSDictionary <NSString *, NSString *> *)af_parameters {
  NSMutableDictionary<NSString *, NSString *>* queryParams = [NSMutableDictionary<NSString *, NSString *> new];
  
  NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:self resolvingAgainstBaseURL:NO];
  
  NSString *queryString = nil;
  if (urlComponents.query == nil) {
    queryString = urlComponents.fragment;
  } else {
    queryString = self.query;
  }
  
  NSArray *parameters = [queryString componentsSeparatedByString:@"&"];
  for (NSString *parameter in parameters) {
    NSArray *parts = [parameter componentsSeparatedByString:@"="];
    NSString *key = parts[0];
    if (parts.count > 1) {
      id value = parts[1];
      BOOL arrayValue = [key hasSuffix:@"[]"];
      if (arrayValue) {
        key = [key substringToIndex:key.length - 2];
      }
      
      id existingValue = queryParams[key];
      if ([existingValue isKindOfClass:[NSArray class]]) {
        value = [existingValue arrayByAddingObject:value];
      } else if (existingValue) {
        value = existingValue;
      }
      
      queryParams[key] = value;
    }
  }
  
  return queryParams;
}

@end