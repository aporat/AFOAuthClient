//
//  ViewController.m
//  example
//
//  Created by Adar Porat on 6/15/14.
//  Copyright (c) 2014 Adar Porat. All rights reserved.
//

#import "ViewController.h"
#import <AFOAuthClient/AFOAuthClient.h>

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)loginWithInstagram:(id)sender {
  
  AFOInstagramImplicitLoginViewController *vc = [AFOInstagramImplicitLoginViewController controllerWithAuthURL:[NSURL URLWithString:@"https://instagram.com/oauth/authorize"] redirectURL:[NSURL URLWithString:@"login://redirect"] clientId:@"" scope:@"basic" completionHandler:^(BOOL success, NSError * _Nullable error, NSDictionary<NSString *,id> * _Nullable info) {
    
  }];
  
  
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:nav animated:YES completion:nil];
}

@end