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

#import "NSDictionary+AFOAuthClient.h"
#import "NSString+AFOAuthClient.h"

@implementation NSDictionary (AFOAuthClient)

#pragma mark Query String
+ (instancetype)af_dictionaryFromQueryString:(NSString *)queryString {
  NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
  NSArray *pairs = [queryString componentsSeparatedByString:@"&"];
  
  for (NSString *pair in pairs)
  {
    NSArray *elements = [pair componentsSeparatedByString:@"="];
    if (elements.count == 2)
    {
      NSString *key = elements[0];
      NSString *value = elements[1];
      NSString *decodedKey = [key af_URLDecode];
      NSString *decodedValue = [value af_URLDecode];
      
      if (![key isEqualToString:decodedKey])
        key = decodedKey;
      
      if (![value isEqualToString:decodedValue])
        value = decodedValue;
      
      dictionary[key] = value;
    }
  }
  
  return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (NSString *)af_queryStringRepresentation {
    NSMutableArray *paramArray = [NSMutableArray array];

    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *param = [NSString stringWithFormat:@"%@=%@", [key af_URLEncode], [obj af_URLEncode]];
        [paramArray addObject:param];
    }];

    return [paramArray componentsJoinedByString:@"&"];
}

@end