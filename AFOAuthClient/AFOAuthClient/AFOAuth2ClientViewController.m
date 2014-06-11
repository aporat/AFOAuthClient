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

#import "AFOAuth2ClientViewController.h"

@implementation AFOAuth2ClientViewController

+ (instancetype)controllerWithAuthUri:(NSString *)authUri
                          redirectURI:(NSString *)redirectUri
                             clientId:(NSString *)clientId
                                scope:(NSString *)scope
                    completionHandler:(void (^)(NSDictionary *info, NSError *error))handler {
    return [[self alloc] initWithAuthUri:authUri redirectURI:redirectUri clientId:clientId scope:scope completionHandler:handler];
}

- (instancetype)initWithAuthUri:(NSString *)authUri
                    redirectURI:(NSString *)redirectUri
                       clientId:(NSString *)clientId
                          scope:(NSString *)scope
              completionHandler:(void (^)(NSDictionary * info, NSError *error))handler {
    
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.authUri = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@", authUri, clientId, redirectUri, scope];
        self.redirectURI = [NSURL URLWithString:redirectUri];
        completionBlock_ = [handler copy];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSHTTPCookieStorage *cookieStorage;
    
    cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies =  [cookieStorage cookies];
    
    for (NSHTTPCookie *cookie in cookies) {
        [cookieStorage deleteCookie:cookie];
    }
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.authUri]];
    
    [self.webView loadRequest:request];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if (request.URL!=nil) {

        if ([request.URL.absoluteString hasPrefix:self.redirectURI.absoluteString]) {
            
            if ([request.URL.absoluteString rangeOfString:@"error"].location != NSNotFound) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSError *error = [[NSError alloc] initWithDomain:@"OAuth2Domain" code:11 userInfo:@{NSLocalizedDescriptionKey: @"Unable to login to service. try again later."}];
                    completionBlock_(nil, error);
                    [self dismissViewControllerAnimated:YES completion:nil];

                });
            } else {
                NSDictionary *result = [self URLQueryParametersWithURL:request.URL];
            
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock_(result, nil);
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            }
            
            return NO;
        }
    }
    
    return YES;
}

- (NSDictionary *)URLQueryParametersWithURL:(NSURL *)url {
    NSString *queryString = @"";
    
    NSRange fragmentStart = [url.absoluteString rangeOfString:@"#"];
    if (fragmentStart.location != NSNotFound) {
        queryString = [url.absoluteString substringFromIndex:fragmentStart.location + 1];
    }
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    NSArray *parameters = [queryString componentsSeparatedByString:@"&"];
    for (NSString *parameter in parameters) {
        NSArray *parts = [parameter componentsSeparatedByString:@"="];
        NSString *key = parts[0];
        if ([parts count] > 1) {
            id value = parts[1];
            BOOL arrayValue = [key hasSuffix:@"[]"];
            if (arrayValue) {
                key = [key substringToIndex:[key length] - 2];
            }
            
            id existingValue = result[key];
            if ([existingValue isKindOfClass:[NSArray class]]) {
                value = [existingValue arrayByAddingObject:value];
            } else if (existingValue) {
                value = existingValue;
            }
            
            result[key] = value;
        }
    }
    return result;
}

@end

