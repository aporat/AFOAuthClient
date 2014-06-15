//
//  ViewController.m
//  example
//
//  Created by Adar Porat on 6/15/14.
//  Copyright (c) 2014 Adar Porat. All rights reserved.
//

#import "ViewController.h"
#import "AFOAuthClient.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)loginWithInstagram:(id)sender {
    AFInstagramImplicitLoginViewController *vc = [AFInstagramImplicitLoginViewController controllerWithAuthUri:@"https://instagram.com/oauth/authorize"
                                                                                                   redirectURI:@"redirect"
                                                                                                      clientId:@""
                                                                                                         scope:@"basic"
                                                                                             completionHandler:^(NSDictionary *info, NSError *error) {
                                                                                                 
                                                                                                 
                                                                                                 
                                                                                             }];
    
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:nav animated:YES completion:nil];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
