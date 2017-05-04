//
//  TermConditionViewController.m
//  SydneyTransit
//
//  Created by Bo Wang on 21/06/2015.
//  Copyright (c) 2015 Bo Software. All rights reserved.
//

#import "TermConditionViewController.h"

@interface TermConditionViewController ()

@end

@implementation TermConditionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURL *websiteUrl = [NSURL URLWithString:@"http://users.tpg.com.au/okwbpottery/MobileAppTerms.html"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:websiteUrl];
    [self.myWebView loadRequest:urlRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
