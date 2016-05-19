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

#pragma mark -
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

+ (instancetype)af_dictionaryFromURL:(NSURL *)url {
  NSString *queryString = @"";
  
  NSRange fragmentStart = [url.absoluteString rangeOfString:@"#"];
  if (fragmentStart.location != NSNotFound) {
    queryString = [url.absoluteString substringFromIndex:fragmentStart.location + 1];
  }
  
  NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
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
      
      id existingValue = dictionary[key];
      if ([existingValue isKindOfClass:[NSArray class]]) {
        value = [existingValue arrayByAddingObject:value];
      } else if (existingValue) {
        value = existingValue;
      }
      
      dictionary[key] = value;
    }
  }
  
  return [[[self class] alloc] initWithDictionary:dictionary];
}

@end
