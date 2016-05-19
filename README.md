AFOAuthClient
=============

[![Build Status](https://travis-ci.org/aporat/AFOAuthClient.svg?branch=master)](https://travis-ci.org/aporat/AFOAuthClient) &nbsp;
![](http://cocoapod-badges.herokuapp.com/v/AFOAuthClient/badge.png) &nbsp; ![](http://cocoapod-badges.herokuapp.com/p/AFOAuthClient/badge.png)

AFNetworking Extension for OAuth 1.0a, OAuth 2 explict (server side) and oAuth 2 Implicit Authentication

Sample usage is available in the `example` project.

## Requirements

`AFOAuthClient` reiles on `AFNetworking 2.0`

## Installation

### CocoaPods

Add the following line to your Podfile:

```ruby
pod 'AFOAuthClient'
```

Then run the following in the same directory as your Podfile:
```ruby
pod install
```


## Usage


```objective-c
    AFInstagramImplicitLoginViewController *vc = [AFInstagramImplicitLoginViewController controllerWithAuthUri:@"https://instagram.com/oauth/authorize"
                                                                                                   redirectURI:@"redirect"
                                                                                                      clientId:@""
                                                                                                         scope:@"basic"
                                                                                             completionHandler:^(NSDictionary *info, NSError *error) {
                                                                                                 
                                                                                                 
                                                                                                 
                                                                                             }];
    
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:nav animated:YES completion:nil];


}

@end
```

